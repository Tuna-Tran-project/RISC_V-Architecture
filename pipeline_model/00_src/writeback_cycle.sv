module writeback_cycle(
    // Data inputs from MEM/WB pipeline register
    input logic [31:0] ReadData_W,
    input logic [31:0] ALUResult_W,
    input logic [31:0] PCPlus4_W,
    input logic [4:0] RD_W,
    // Control signals from MEM/WB pipeline register
    input logic rd_wren_W,
    input logic [1:0] wb_sel_W,
    input logic insn_vld_W,
    
    // Outputs to register file and debug
    output logic [31:0] Result_W,    // Writeback result
    output logic [4:0] RD_W_out,     // Destination register
    output logic RegWrite_W,         // Write enable
    output logic insn_vld_out        // Instruction valid
);

//==============================================================================
// Writeback Stage Logic
//==============================================================================

//------------------------------------------------------------------------------
// Writeback Multiplexer - Select data to write to register file
//------------------------------------------------------------------------------
// wb_sel encoding:
// 00 = ALU result
// 01 = Memory/IO load data
// 10 = PC+4 (for JAL/JALR)
always_comb begin
    case (wb_sel_W)
        2'b00: Result_W = ALUResult_W;    // ALU result
        2'b01: Result_W = ReadData_W;     // Memory/IO load data
        2'b10: Result_W = PCPlus4_W;      // PC+4 for JAL/JALR
        default: Result_W = 32'd0;
    endcase
end

// Pass through control signals
assign RD_W_out = RD_W;
assign RegWrite_W = rd_wren_W & insn_vld_W;
assign insn_vld_out = insn_vld_W;

endmodule
