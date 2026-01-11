//==============================================================================
// Module: control_unit
//==============================================================================
// Description:
//   Top-level control unit for the RISC-V RV32I single-cycle processor.
//   Decodes instruction fields (opcode, funct3, funct7) and generates all
//   control signals for the datapath. Instantiates two sub-decoders:
//     1. MainDecoder - Generates control signals for datapath muxes and enables
//     2. ALUDecoder  - Generates the 4-bit ALU operation code
//
// Inputs:
//   i_instr[31:0]  - Current instruction from instruction memory
//   i_br_less      - Branch comparator output (less-than result)
//   i_br_equal     - Branch comparator output (equality result)
//
// Outputs:
//   o_br_un        - Branch unsigned mode (0=signed, 1=unsigned comparison)
//   o_rd_wren      - Register file write enable
//   o_mem_wren     - Data memory/IO write enable
//   o_wb_sel[1:0]  - Writeback mux select (00=ALU, 01=MEM, 10=PC+4)
//   o_pc_sel       - PC mux select (0=PC+4, 1=branch/jump target)
//   o_opa_sel[1:0] - ALU operand A mux (00=rs1, 01=PC, 10=zero)
//   o_opb_sel      - ALU operand B mux (0=rs2, 1=immediate)
//   o_insn_vld     - Instruction valid flag (0 if instruction is all zeros)
//   o_alu_op[3:0]  - ALU operation code
//==============================================================================

module control_unit (
    input  logic [31:0] i_instr,
    output logic 		o_br_un,
    output logic        o_rd_wren,
    output logic        o_mem_wren,
    output logic [1:0]  o_wb_sel,
    output logic        o_is_branch,
    output logic        o_is_jal,
    output logic        o_is_jalr,
	output logic [1:0]  o_opa_sel,
    output logic        o_insn_vld,
    output logic        o_opb_sel,
    output logic [3:0]  o_alu_op
);    // Extract instruction fields for decoders
    logic [6:0] opcode;
    logic [2:0] funct3;
    logic [6:0] funct7;

    assign opcode = i_instr[6:0];   // Instruction opcode field
    assign funct3 = i_instr[14:12]; // Function field 3 (for ALU/branch type)
    assign funct7 = i_instr[31:25]; // Function field 7 (for ALU sub-operations)

    // Main Decoder - Generates datapath control signals based on instruction type
    MainDecoder main_dec (
        .opcode(opcode),
        .funct3(funct3),
	    .br_un(o_br_un),
        .rd_wren(o_rd_wren),
        .mem_wren(o_mem_wren),
        .wb_sel(o_wb_sel),
        .is_branch(o_is_branch),
        .is_jal(o_is_jal),
        .is_jalr(o_is_jalr),
        .opa_sel(o_opa_sel),
        .opb_sel(o_opb_sel)
    );

    // ALU Decoder - Generates ALU operation code based on instruction type
    ALUDecoder alu_dec (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .alu_op(o_alu_op)
    );

    // Instruction valid flag - Detect NOP (all zeros)
	assign o_insn_vld = (i_instr != 32'b0);
endmodule

//==============================================================================
// Module: MainDecoder
//==============================================================================
// Description:
//   Main control decoder for RV32I instruction set using ONE-HOT decoding
//   for reduced logic depth and faster decode. Generates all datapath
//   control signals based on the instruction opcode and funct3 field.
//
// Optimization: One-hot opcode decode eliminates wide case trees, replacing
//   them with simple AND/OR gates. This reduces critical path delay.
//
// Instruction Types Supported:
//   - R-type (0110011): Register-register ALU operations
//   - I-type (0010011): Immediate ALU operations
//   - Load   (0000011): Memory load instructions
//   - Store  (0100011): Memory store instructions
//   - Branch (1100011): Conditional branches (BEQ, BNE, BLT, BGE, BLTU, BGEU)
//   - JAL    (1101111): Jump and link
//   - JALR   (1100111): Jump and link register
//   - LUI    (0110111): Load upper immediate
//   - AUIPC  (0010111): Add upper immediate to PC
//
// Control Signal Encodings:
//   wb_sel:   00=ALU result, 01=Memory data, 10=PC+4
//   opa_sel:  00=rs1, 01=PC, 10=zero (for LUI)
//   opb_sel:  0=rs2, 1=immediate
//   br_un:    0=unsigned comparison (BLTU/BGEU), 1=signed (BEQ/BNE/BLT/BGE)
//   pc_sel:   0=PC+4 (sequential), 1=branch/jump target
//==============================================================================

module MainDecoder (
    input  logic [6:0] opcode,
	 input  logic [2:0] funct3,
    output logic       br_un,
    output logic       rd_wren,
    output logic       mem_wren,
    output logic [1:0] wb_sel,
    output logic       is_branch,
    output logic       is_jal,
    output logic       is_jalr,
	output logic [1:0] opa_sel,
    output logic       opb_sel
);	//==========================================================================
	// One-hot opcode decode - faster than case statement
	//==========================================================================
	logic is_rtype;   // 0110011
	logic is_itype;   // 0010011
	logic is_load;    // 0000011
	logic is_store;   // 0100011
	logic is_lui;     // 0110111
	logic is_auipc;   // 0010111

	assign is_rtype  = (opcode == 7'b0110011);
	assign is_itype  = (opcode == 7'b0010011);
	assign is_load   = (opcode == 7'b0000011);
	assign is_store  = (opcode == 7'b0100011);
	assign is_branch = (opcode == 7'b1100011);
	assign is_jal    = (opcode == 7'b1101111);
	assign is_jalr   = (opcode == 7'b1100111);
	assign is_lui    = (opcode == 7'b0110111);
	assign is_auipc  = (opcode == 7'b0010111);

	//==========================================================================
	// Control signal generation using simple OR logic
	//==========================================================================
	
	// rd_wren: All except STORE and BRANCH write to register
	assign rd_wren = is_rtype | is_itype | is_load | is_jal | is_jalr | is_lui | is_auipc;
	
	// mem_wren: Only STORE writes to memory
	assign mem_wren = is_store;
	
	// opb_sel: Use immediate for all except R-type
	assign opb_sel = is_itype | is_load | is_store | is_branch | is_jal | is_jalr | is_lui | is_auipc;
	
	// wb_sel: 00=ALU, 01=MEM, 10=PC+4
	assign wb_sel[0] = is_load;                    // bit 0: load uses memory
	assign wb_sel[1] = is_jal | is_jalr;           // bit 1: jumps use PC+4
	
	// opa_sel: 00=rs1, 01=PC, 10=zero
	assign opa_sel[0] = is_branch | is_jal | is_auipc;  // bit 0: branch/jal/auipc use PC
	assign opa_sel[1] = is_lui;                                 // bit 1: LUI uses zero
	
	// Branch/Jump flags for pipeline
    // is_branch: True for all branch instructions   

	
	// Branch unsigned mode: BLTU(110) and BGEU(111) are unsigned (br_un=0)
	//                       BEQ/BNE/BLT/BGE are signed (br_un=1)
	assign br_un = (is_branch && (funct3[2:1] == 2'b11)) ? 1'b0 : 1'b1;

endmodule

//==============================================================================
// Module: ALUDecoder
//==============================================================================
// Description:
//   ALU operation decoder for RV32I instruction set. Generates the 4-bit
//   ALU operation code based on instruction opcode, funct3, and funct7 fields.
//   
// ALU Operation Encoding:
//   4'b0000: ADD  - Addition
//   4'b0001: SUB  - Subtraction
//   4'b0010: SLL  - Shift left logical
//   4'b0011: SLT  - Set less than (signed)
//   4'b0100: SLTU - Set less than unsigned
//   4'b0101: XOR  - Bitwise XOR
//   4'b0110: SRL  - Shift right logical
//   4'b0111: SRA  - Shift right arithmetic
//   4'b1000: OR   - Bitwise OR
//   4'b1001: AND  - Bitwise AND
//   4'b1111: NOP  - No operation (invalid)
//
// Notes:
//   - For memory operations (LOAD/STORE), ALU performs address calculation (ADD)
//   - For branches, ALU computes branch target address (ADD)
//   - For JAL/JALR, ALU computes jump target address (ADD)
//   - funct7 distinguishes SUB from ADD, and SRA from SRL in R-type
//==============================================================================

module ALUDecoder (
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic [6:0] funct7,
    output logic [3:0] alu_op
);

always_comb begin
    case (opcode)
        // R-type: Register-register ALU operations
        7'b0110011: begin
            case (funct3)
                3'b000: alu_op = (funct7 == 7'b0100000) ? 4'b0001 : 4'b0000; // SUB if funct7[5]=1, else ADD
                3'b001: alu_op = 4'b0010; // SLL  - Shift left logical
                3'b010: alu_op = 4'b0011; // SLT  - Set less than (signed)
                3'b011: alu_op = 4'b0100; // SLTU - Set less than unsigned
                3'b100: alu_op = 4'b0101; // XOR  - Bitwise XOR
                3'b101: alu_op = (funct7 == 7'b0100000) ? 4'b0111 : 4'b0110; // SRA if funct7[5]=1, else SRL
                3'b110: alu_op = 4'b1000; // OR   - Bitwise OR
                3'b111: alu_op = 4'b1001; // AND  - Bitwise AND
                default: alu_op = 4'b1111; // Invalid
            endcase
        end

        // I-type: Immediate ALU operations
        7'b0010011: begin
            case (funct3)
                3'b000: alu_op = 4'b0000; // ADDI  - Add immediate
                3'b010: alu_op = 4'b0011; // SLTI  - Set less than immediate (signed)
                3'b011: alu_op = 4'b0100; // SLTIU - Set less than immediate unsigned
                3'b100: alu_op = 4'b0101; // XORI  - XOR immediate
                3'b110: alu_op = 4'b1000; // ORI   - OR immediate
                3'b111: alu_op = 4'b1001; // ANDI  - AND immediate
                3'b001: alu_op = 4'b0010; // SLLI  - Shift left logical immediate
                3'b101: alu_op = (funct7 == 7'b0100000) ? 4'b0111 : 4'b0110; // SRAI if funct7[5]=1, else SRLI
                default: alu_op = 4'b1111; // Invalid
            endcase
        end

        // Memory operations: Use ALU to compute address (rs1 + immediate)
        7'b0000011: alu_op = 4'b0000; // LOAD:  address = rs1 + imm
        7'b0100011: alu_op = 4'b0000; // STORE: address = rs1 + imm

        // Control flow: Use ALU to compute target address
        7'b1100011: alu_op = 4'b0000; // BRANCH: target = PC + imm (comparison done in BRC)
        7'b1101111: alu_op = 4'b0000; // JAL:    target = PC + imm
        7'b1100111: alu_op = 4'b0000; // JALR:   target = rs1 + imm

        // Upper immediate operations: Use ALU for addition
        7'b0110111: alu_op = 4'b0000; // LUI:   result = 0 + imm (imm already shifted)
        7'b0010111: alu_op = 4'b0000; // AUIPC: result = PC + imm

        default: alu_op = 4'b1111; // NOP/invalid instruction
    endcase
end
endmodule
