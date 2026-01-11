//==============================================================================
// Module: single_cycle
//==============================================================================
// Description:
//   Top-level RISC-V RV32I single-cycle processor implementing the full
//   unprivileged integer instruction set. This is a Harvard architecture
//   design with separate instruction and data memories, executing one
//   instruction per clock cycle.
//
// Architecture Overview:
//   1. Fetch:    PC → IMEM → Instruction
//   2. Decode:   Instruction → Control signals, register addresses, immediate
//   3. Execute:  ALU operation or branch comparison
//   4. Memory:   Load/store through LSU, memory-mapped I/O
//   5. Writeback: Result written to register file
//
// Key Features:
//   - Single-cycle execution (CPI = 1)
//   - Harvard architecture (separate IMEM/DMEM)
//   - Full RV32I ISA support (37 instructions)
//   - Memory-mapped I/O (LEDs, 7-segment, LCD, switches)
//   - Misalignment detection for loads/stores
//   - Branch prediction: predict not-taken
//   - JALR LSB clearing per specification
//
// Supported Instructions:
//   - R-type: ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
//   - I-type: ADDI, SLTI, SLTIU, XORI, ORI, ANDI, SLLI, SRLI, SRAI
//   - Load:   LB, LH, LW, LBU, LHU
//   - Store:  SB, SH, SW
//   - Branch: BEQ, BNE, BLT, BGE, BLTU, BGEU
//   - Jump:   JAL, JALR
//   - Upper:  LUI, AUIPC
//
// Inputs:
//   i_clk       - System clock
//   i_reset     - Active-low asynchronous reset
//   i_io_sw     - Switch inputs (32-bit) from FPGA
//
// Outputs:
//   o_pc_debug  - Current PC value (for debugging/testbench)
//   o_insn_vld  - Instruction valid flag (0 if instruction is NOP)
//   o_io_ledr   - Red LED outputs (32-bit)
//   o_io_ledg   - Green LED outputs (32-bit)
//   o_io_hex0-7 - 7-segment display outputs (8 digits × 7 segments)
//   o_io_lcd    - LCD display data (32-bit)
//==============================================================================

module single_cycle(
	input logic i_clk, i_reset,
	// IO input
	input  logic [31:0] i_io_sw,
	// debug
	output logic [31:0] o_pc_debug,
    output logic        o_insn_vld,	
	
	// Debug signals (commented out but available for waveform analysis)
	// Uncomment to expose internal signals for debugging
	/*
	output logic [31:0] pc_next, pc_four, pc,
	output logic [31:0] instr,
	output logic		pc_sel,
	output logic [4:0] 	rs1_addr, rs2_addr, rd_addr,
	output logic [31:0] rs1_data , rs2_data,
	output logic rd_wren,
	output logic [31:0] imm_data,
	output logic 		br_un,br_less,br_equal,
	output logic [31:0] operand_a, operand_b, alu_data,
	output logic [3:0] alu_op,
	output logic opa_sel, opb_sel,
	output logic mem_wren,
	output logic [1:0] wb_sel,
	output logic [31:0] ld_data, reg_mem,
	output logic [31:0] wb_data,
	*/

	// IO outputs to FPGA peripherals
	output logic [31:0] o_io_ledr,   // Red LEDs
	output logic [31:0] o_io_ledg,   // Green LEDs
	output logic [6:0]  o_io_hex0,   // 7-segment digit 0 (rightmost)
	output logic [6:0]  o_io_hex1,   // 7-segment digit 1
	output logic [6:0]  o_io_hex2,   // 7-segment digit 2
	output logic [6:0]  o_io_hex3,   // 7-segment digit 3
	output logic [6:0]  o_io_hex4,   // 7-segment digit 4
	output logic [6:0]  o_io_hex5,   // 7-segment digit 5
	output logic [6:0]  o_io_hex6,   // 7-segment digit 6
	output logic [6:0]  o_io_hex7,   // 7-segment digit 7 (leftmost)
	output logic [31:0] o_io_lcd     // LCD display data
	);

//==============================================================================
// Internal Signal Declarations
//==============================================================================

// Program Counter signals
	logic [31:0] 	pc_next;      // Next PC value (from mux)
	logic [31:0]    pc_four;      // PC + 4 (sequential)
	logic [31:0]    pc;           // Current PC value
	logic [31:0] 	instr;        // Current instruction from IMEM
	logic		  	pc_sel;       // PC mux select (0=PC+4, 1=branch/jump target)

// Register file signals
	logic [4:0]		rs1_addr;     // Source register 1 address
	logic [4:0]     rs2_addr;     // Source register 2 address
	logic [4:0]     rd_addr;      // Destination register address
	logic	[31:0] 	rs1_data;     // Source register 1 data
	logic	[31:0] 	rs2_data;     // Source register 2 data
	logic			rd_wren;      // Register write enable

// Immediate generator signal
	logic [31:0] 	imm_data;     // Immediate value extracted from instruction

// Branch comparator signals
	logic 			br_un;        // Branch unsigned mode (0=unsigned, 1=signed)
	logic 			br_less;      // Branch less-than result
	logic 			br_equal;     // Branch equality result

// ALU signals
	logic [31:0] operand_a;       // ALU operand A (rs1, PC, or 0)
	logic [31:0] operand_b;       // ALU operand B (rs2 or immediate)
	logic [31:0] alu_data;        // ALU result

// Control signals from control unit
	logic [1:0] opa_sel;          // Operand A mux (00=rs1, 01=PC, 10=zero)
	logic       opb_sel;          // Operand B mux (0=rs2, 1=immediate)
	logic [3:0] alu_op;           // ALU operation code
	logic       jalr_mode;        // JALR mode flag (enables LSB clearing in ALU)
	logic mem_wren;               // Memory/IO write enable
	logic [1:0] wb_sel;           // Writeback mux (00=ALU, 01=MEM, 10=PC+4)

// Load-Store Unit signals
	logic [31:0] ld_data;         // Load data from LSU
	logic [31:0] reg_mem;         // Unused signal (legacy)

// Writeback signal
	logic [31:0] wb_data;         // Writeback data to register file
	
//==============================================================================
// Datapath Implementation
//==============================================================================

//------------------------------------------------------------------------------
// Program Counter (PC) Logic
//------------------------------------------------------------------------------
// PC next value mux: sequential (PC+4) or branch/jump target
// Note: JALR LSB clearing is handled inside the ALU when jalr_mode is asserted
assign pc_next = (pc_sel == 1'b0) ? pc_four : alu_data;

PC program_counter(
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_pc_next(pc_next),
		.o_pc(pc)
	);

// PC+4 computation using full adder (complies with milestone-2 - no + operator)
logic pc_four_cout;  // Carry out (unused)
FA_32bit pc_adder(
	.A(pc),
	.B(32'd4),
	.Cin(1'b0),
	.Sum(pc_four),
	.Cout(pc_four_cout)
);

//------------------------------------------------------------------------------
// Instruction Fetch
//------------------------------------------------------------------------------
i_mem instruction_mem (
	.i_addr(pc),          // PC as instruction address
	.o_data(instr)        // Fetched instruction
);

//------------------------------------------------------------------------------
// Instruction Decode - Extract register addresses
//------------------------------------------------------------------------------
assign rs1_addr = instr[19:15];  // Source register 1 (bits 19-15)
assign rs2_addr = instr[24:20];  // Source register 2 (bits 24-20)
assign rd_addr	= instr[11:7];   // Destination register (bits 11-7)

//------------------------------------------------------------------------------
// Register File
//------------------------------------------------------------------------------
regfile register (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_rs1_addr(rs1_addr),
	.i_rs2_addr(rs2_addr),
	.i_rd_addr(rd_addr),
	.i_rd_wren(rd_wren),
	.i_rd_data(wb_data),
	.o_rs1_data(rs1_data),
	.o_rs2_data(rs2_data)
);

//------------------------------------------------------------------------------
// Immediate Generator
//------------------------------------------------------------------------------
imm_gen immediate(
	.i_instr(instr),         // Input instruction
	.o_imm_out(imm_data)     // Extracted and sign-extended immediate
);

//------------------------------------------------------------------------------
// Branch Comparator (for branch condition evaluation)
//------------------------------------------------------------------------------
brc br(
	.i_rs1_data(rs1_data),   // Source register 1 data
	.i_rs2_data(rs2_data),   // Source register 2 data
	.i_br_un(br_un),         // Unsigned mode flag from control unit
	.o_br_less(br_less),     // Less-than comparison result
	.o_br_equal(br_equal)    // Equality comparison result
);

//------------------------------------------------------------------------------
// ALU Operand Multiplexers
//------------------------------------------------------------------------------
// Operand A mux: rs1, PC, or zero (for LUI)
always_comb begin
	case (opa_sel)
		2'b00: operand_a = rs1_data;  // Normal ALU operation: use rs1
		2'b01: operand_a = pc;        // Branch/jump target or AUIPC: use PC
		2'b10: operand_a = 32'd0;     // LUI: use zero (imm becomes result)
		default: operand_a = rs1_data;
	endcase
end

// Operand B mux: rs2 or immediate
assign operand_b = (opb_sel) ? imm_data : rs2_data;

//------------------------------------------------------------------------------
// Arithmetic Logic Unit (ALU)
//------------------------------------------------------------------------------
alu ALU(
	.i_op_a(operand_a),      // Operand A (rs1, PC, or 0)
	.i_op_b(operand_b),      // Operand B (rs2 or immediate)
	.i_alu_op(alu_op),       // ALU operation code from control unit
	.i_jalr_mode(jalr_mode), // JALR mode: clears LSB of result per RISC-V spec
	.o_alu_data(alu_data)    // ALU result (address, data, or branch target)
);

//------------------------------------------------------------------------------
// Load-Store Unit (LSU) - Memory and I/O Access
//------------------------------------------------------------------------------
lsu lsu_inst (
	.i_clk(i_clk),
	.i_reset(i_reset),
	.i_funct3(instr[14:12]),    // Load/store type from instruction funct3
	.i_lsu_addr(alu_data),      // Address from ALU (rs1 + immediate)
	.i_st_data(rs2_data),       // Store data from rs2
	.i_lsu_wren(mem_wren),      // Write enable from control unit
	.o_ld_data(ld_data),        // Load data to writeback stage
	.o_io_ledr(o_io_ledr),      // Red LEDs output
	.o_io_ledg(o_io_ledg),      // Green LEDs output
	.o_io_hex0(o_io_hex0),      // 7-segment digit 0
	.o_io_hex1(o_io_hex1),      // 7-segment digit 1
	.o_io_hex2(o_io_hex2),      // 7-segment digit 2
	.o_io_hex3(o_io_hex3),      // 7-segment digit 3
	.o_io_hex4(o_io_hex4),      // 7-segment digit 4
	.o_io_hex5(o_io_hex5),      // 7-segment digit 5
	.o_io_hex6(o_io_hex6),      // 7-segment digit 6
	.o_io_hex7(o_io_hex7),      // 7-segment digit 7
	.o_io_lcd(o_io_lcd),        // LCD display output
	.i_io_sw(i_io_sw)           // Switch inputs
);

//------------------------------------------------------------------------------
// Writeback Stage - Select data to write to register file
//------------------------------------------------------------------------------
// Writeback mux: ALU result, memory/IO data, or PC+4 (for JAL/JALR)
assign wb_data = (wb_sel == 2'b00) ? alu_data :   // ALU result (R-type, I-type, LUI, AUIPC)
		         (wb_sel == 2'b01) ? ld_data :     // Memory/IO load data
		         (wb_sel == 2'b10) ? pc_four :     // PC+4 (return address for JAL/JALR)
                 32'd0;                            // Default (should not occur)

//------------------------------------------------------------------------------
// Control Unit - Generate all control signals
//------------------------------------------------------------------------------
control_unit control(
	.i_instr(instr),          // Current instruction
	.i_br_less(br_less),      // Branch comparator less-than result
	.i_br_equal(br_equal),    // Branch comparator equality result
	.o_br_un(br_un),          // Branch unsigned mode
	.o_rd_wren(rd_wren),      // Register write enable
	.o_mem_wren(mem_wren),    // Memory/IO write enable
	.o_wb_sel(wb_sel),        // Writeback mux select
	.o_pc_sel(pc_sel),        // PC mux select (sequential vs branch/jump)
	.o_opa_sel(opa_sel),      // ALU operand A mux select
	.o_opb_sel(opb_sel),      // ALU operand B mux select
	.o_jalr_mode(jalr_mode),  // JALR mode flag for ALU
	.o_insn_vld(o_insn_vld),  // Instruction valid flag
	.o_alu_op(alu_op)         // ALU operation code
);

//------------------------------------------------------------------------------
// Debug Output - Register current PC for testbench/waveform analysis
//------------------------------------------------------------------------------
always @(posedge i_clk or negedge i_reset) begin
	if(~i_reset) 
		o_pc_debug <= 32'd0;  // Reset PC debug to 0
	else
		o_pc_debug <= pc;     // Capture current PC value
end

endmodule
