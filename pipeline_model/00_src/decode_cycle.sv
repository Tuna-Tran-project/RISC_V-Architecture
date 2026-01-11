module decode_cycle(
    input logic i_clk,
    input logic i_reset, // ACTIVE-LOW reset
    input logic [31:0] InstrD,
    input logic [31:0] PCPlus4D,
    input logic [31:0] PCD,
    // Inputs from WB stage for register writeback
    input logic RegWriteW,
    input logic [31:0] ResultW, // Write data from WB stage
    input logic [4:0] RD_W,      // Write destination address
    // Inputs from hazard unit
    input logic StallD,         // Stall ID/EX register (load-use hazard)
    input logic FlushE,         // Flush ID/EX register (control hazard or load-use)
    
    // Outputs to ID/EX pipeline register
    // Data outputs
    output logic [31:0] RD1_E,
    output logic [31:0] RD2_E,
    output logic [31:0] imm_E, 
    output logic [31:0] PC_E,
    output logic [4:0] RD_E,
    output logic [31:0] PCPlus4_E,
    output logic [4:0] RS1_E,
    output logic [4:0] RS2_E,
    // Control signal outputs
    output logic rd_wren_E,
    output logic mem_wren_E,
    output logic [1:0] wb_sel_E,
    output logic [1:0] opa_sel_E,
    output logic opb_sel_E,
    output logic [3:0] alu_op_E,
    output logic [2:0] funct3_E,

    // Branch control signals
    output logic br_un_E,
    output logic is_branch_E,
    output logic is_jal_E,
    output logic is_jalr_E,
    // Instruction valid
    output logic insn_vld_E,
    
    // [NEW] Output tín hiệu MemRead (Load) sang Execute
    output logic mem_read_E, 

    // Outputs to hazard unit for load-use detection
    output logic [4:0] RS1_D,      // Source register 1 address (ID stage)
    output logic [4:0] RS2_D       // Source register 2 address (ID stage)
);

//==============================================================================
// Internal Signals - Decode Stage
//==============================================================================
logic [4:0] rs1_addrD;
logic [4:0] rs2_addrD;
logic [4:0] rd_addrD;
logic [31:0] rs1_dataD_raw; // Dữ liệu thô từ RegFile
logic [31:0] rs2_dataD_raw; // Dữ liệu thô từ RegFile
logic [31:0] rs1_dataD;     // Dữ liệu đã qua Forwarding
logic [31:0] rs2_dataD;     // Dữ liệu đã qua Forwarding
logic [31:0] imm_dataD;

// Control signals from control unit
logic rd_wrenD;
logic mem_wrenD;
logic [1:0] wb_selD;
logic [1:0] opa_selD;
logic opb_selD;
logic [3:0] alu_opD;
logic br_unD;
logic is_branchD;
logic is_jalD;
logic is_jalrD;
logic insn_vldD; 

// [NEW] Tín hiệu phát hiện lệnh Load tại Decode
logic is_load_D; 

//------------------------------------------------------------------------------
// Instruction Decode
//------------------------------------------------------------------------------
assign rs1_addrD = InstrD[19:15];
assign rs2_addrD = InstrD[24:20];
assign rd_addrD  = InstrD[11:7];

// Output register addresses for hazard unit
assign RS1_D = rs1_addrD;
assign RS2_D = rs2_addrD;

// [NEW] Logic phát hiện lệnh Load (Opcode = 0000011)
assign is_load_D = (InstrD[6:0] == 7'b0000011);

//------------------------------------------------------------------------------
// Register File
//------------------------------------------------------------------------------
regfile register (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_rs1_addr(rs1_addrD),
    .i_rs2_addr(rs2_addrD),
    .i_rd_addr(RD_W),
    .i_rd_wren(RegWriteW),
    .i_rd_data(ResultW),
    .o_rs1_data(rs1_dataD_raw), 
    .o_rs2_data(rs2_dataD_raw)  
);

//==============================================================================
// INTERNAL FORWARDING LOGIC (ID Stage)
//==============================================================================
always_comb begin
    // Forwarding cho RS1
    if (RegWriteW && (RD_W != 0) && (RD_W == rs1_addrD))
        rs1_dataD = ResultW;
    else
        rs1_dataD = rs1_dataD_raw;

    // Forwarding cho RS2
    if (RegWriteW && (RD_W != 0) && (RD_W == rs2_addrD))
        rs2_dataD = ResultW;
    else
        rs2_dataD = rs2_dataD_raw;
end

//------------------------------------------------------------------------------
// Immediate Generator
//------------------------------------------------------------------------------
imm_gen immediate(
    .i_instr(InstrD),
    .o_imm_out(imm_dataD)
);

//------------------------------------------------------------------------------
// Control Unit
//------------------------------------------------------------------------------
control_unit control(
    .i_instr(InstrD),
    .o_br_un(br_unD),
    .o_rd_wren(rd_wrenD),
    .o_mem_wren(mem_wrenD),
    .o_wb_sel(wb_selD),
    .o_is_branch(is_branchD),
    .o_is_jal(is_jalD),
    .o_is_jalr(is_jalrD),
    .o_opa_sel(opa_selD),
    .o_opb_sel(opb_selD),
    .o_insn_vld(insn_vldD),
    .o_alu_op(alu_opD)
);

//==============================================================================
// ID/EX Pipeline Register
//==============================================================================
always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
        // Reset logic...
        RD1_E       <= 32'd0;
        RD2_E       <= 32'd0;
        imm_E       <= 32'd0;
        PC_E        <= 32'd0;
        RD_E        <= 5'd0;
        PCPlus4_E   <= 32'd0;
        RS1_E       <= 5'd0;
        RS2_E       <= 5'd0;
        rd_wren_E   <= 1'b0;
        mem_wren_E  <= 1'b0;
        wb_sel_E    <= 2'd0;
        opa_sel_E   <= 2'd0;
        opb_sel_E   <= 1'b0;
        alu_op_E    <= 4'd0;
        funct3_E    <= 3'd0;
        br_un_E     <= 1'b0;
        is_branch_E <= 1'b0;
        is_jal_E    <= 1'b0;
        is_jalr_E   <= 1'b0;
        insn_vld_E  <= 1'b0;
        
        mem_read_E  <= 1'b0; // [NEW] Reset signal
    end else if (FlushE) begin
        // Flush logic...
        RD1_E       <= 32'd0;
        RD2_E       <= 32'd0;
        imm_E       <= 32'd0;
        PC_E        <= 32'd0;
        RD_E        <= 5'd0;
        PCPlus4_E   <= 32'd0;
        RS1_E       <= 5'd0;
        RS2_E       <= 5'd0;
        rd_wren_E   <= 1'b0;
        mem_wren_E  <= 1'b0;
        wb_sel_E    <= 2'd0;
        opa_sel_E   <= 2'd0;
        opb_sel_E   <= 1'b0;
        alu_op_E    <= 4'd0;
        funct3_E    <= 3'd0;
        br_un_E     <= 1'b0;
        is_branch_E <= 1'b0;
        is_jal_E    <= 1'b0;
        is_jalr_E   <= 1'b0;
        insn_vld_E  <= 1'b0;
        
        mem_read_E  <= 1'b0; // [NEW] Flush signal
    end else if (StallD) begin
        // Stall logic: Keep ALL old values
        RD1_E       <= RD1_E;
        RD2_E       <= RD2_E;
        imm_E       <= imm_E;
        PC_E        <= PC_E;
        RD_E        <= RD_E;
        PCPlus4_E   <= PCPlus4_E;
        RS1_E       <= RS1_E;
        RS2_E       <= RS2_E;
        rd_wren_E   <= rd_wren_E;
        mem_wren_E  <= mem_wren_E;
        wb_sel_E    <= wb_sel_E;
        opa_sel_E   <= opa_sel_E;
        opb_sel_E   <= opb_sel_E;
        alu_op_E    <= alu_op_E;
        funct3_E    <= funct3_E;
        br_un_E     <= br_un_E;
        is_branch_E <= is_branch_E;
        is_jal_E    <= is_jal_E;
        is_jalr_E   <= is_jalr_E;
        insn_vld_E  <= insn_vld_E;
        
        mem_read_E  <= mem_read_E; // [NEW] Keep signal
    end else begin
        // Normal operation
        RD1_E       <= rs1_dataD; 
        RD2_E       <= rs2_dataD; 
        imm_E       <= imm_dataD;
        PC_E        <= PCD;
        RD_E        <= rd_addrD;
        PCPlus4_E   <= PCPlus4D;
        RS1_E       <= rs1_addrD;
        RS2_E       <= rs2_addrD;
        rd_wren_E   <= rd_wrenD;
        mem_wren_E  <= mem_wrenD;
        wb_sel_E    <= wb_selD;  // No override needed - control unit handles it
        opa_sel_E   <= opa_selD;
        opb_sel_E   <= opb_selD;
        alu_op_E    <= alu_opD;
        funct3_E    <= InstrD[14:12];
        br_un_E     <= br_unD;
        is_branch_E <= is_branchD;
        is_jal_E    <= is_jalD;
        is_jalr_E   <= is_jalrD;
        insn_vld_E  <= insn_vldD;
        
        mem_read_E  <= is_load_D; // [NEW] Update signal từ logic giải mã
    end
end

endmodule