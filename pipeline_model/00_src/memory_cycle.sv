module memory_cycle(
    input logic i_clk,
    input logic i_reset, // ACTIVE-LOW reset
    // Data inputs from EX/MEM pipeline register
    input logic [31:0] ALUResult_M,
    input logic [31:0] WriteData_M,
    input logic [31:0] PCPlus4_M,
    input logic [4:0] RD_M,
    input logic [2:0] funct3_M,
    // Control signals from EX/MEM pipeline register
    input logic rd_wren_M,
    input logic mem_wren_M,
    input logic [1:0] wb_sel_M,
    input logic insn_vld_M,
    // IO inputs
    input logic [31:0] i_io_sw,
    
    // Outputs to MEM/WB pipeline register
    // Data outputs
    output logic [31:0] ReadData_W,
    output logic [31:0] ALUResult_W,
    output logic [31:0] PCPlus4_W,
    output logic [4:0] RD_W,
    // Control signal outputs
    output logic rd_wren_W,
    output logic [1:0] wb_sel_W,
    output logic insn_vld_W,
    
    // IO outputs to FPGA peripherals
    output logic [31:0] o_io_ledr,   // Red LEDs
    output logic [31:0] o_io_ledg,   // Green LEDs
    output logic [6:0]  o_io_hex0,   // 7-segment digit 0
    output logic [6:0]  o_io_hex1,   // 7-segment digit 1
    output logic [6:0]  o_io_hex2,   // 7-segment digit 2
    output logic [6:0]  o_io_hex3,   // 7-segment digit 3
    output logic [6:0]  o_io_hex4,   // 7-segment digit 4
    output logic [6:0]  o_io_hex5,   // 7-segment digit 5
    output logic [6:0]  o_io_hex6,   // 7-segment digit 6
    output logic [6:0]  o_io_hex7,   // 7-segment digit 7
    output logic [31:0] o_io_lcd,    // LCD display data
    
    // Outputs to hazard unit
    output logic [4:0] RD_M_out      // Destination register (for forwarding)
);

//==============================================================================
// Internal Signals - Memory Stage
//==============================================================================
logic [31:0] ld_data;

//------------------------------------------------------------------------------
// Load-Store Unit (LSU) - Memory and I/O Access
//------------------------------------------------------------------------------
lsu lsu_inst (
    .i_clk(i_clk),
    .i_reset(i_reset),
    .i_funct3(funct3_M),           // Load/store type from EX/MEM register
    .i_lsu_addr(ALUResult_M),      // Address from EX/MEM register
    .i_st_data(WriteData_M),       // Store data from EX/MEM register
    .i_lsu_wren(mem_wren_M),       // Write enable from EX/MEM register
    .o_ld_data(ld_data),           // Load data to writeback stage
    .o_io_ledr(o_io_ledr),         // Red LEDs output
    .o_io_ledg(o_io_ledg),         // Green LEDs output
    .o_io_hex0(o_io_hex0),         // 7-segment digit 0
    .o_io_hex1(o_io_hex1),         // 7-segment digit 1
    .o_io_hex2(o_io_hex2),         // 7-segment digit 2
    .o_io_hex3(o_io_hex3),         // 7-segment digit 3
    .o_io_hex4(o_io_hex4),         // 7-segment digit 4
    .o_io_hex5(o_io_hex5),         // 7-segment digit 5
    .o_io_hex6(o_io_hex6),         // 7-segment digit 6
    .o_io_hex7(o_io_hex7),         // 7-segment digit 7
    .o_io_lcd(o_io_lcd),           // LCD display output
    .i_io_sw(i_io_sw)              // Switch inputs
);

// Output RD_M for hazard detection
assign RD_M_out = RD_M;

//==============================================================================
// MEM/WB Pipeline Register
//==============================================================================
always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
        // Reset all pipeline registers to zero
        ReadData_W   <= 32'd0;
        ALUResult_W  <= 32'd0;
        PCPlus4_W    <= 32'd0;
        RD_W         <= 5'd0;
        rd_wren_W    <= 1'b0;
        wb_sel_W     <= 2'd0;
        insn_vld_W   <= 1'b0;
    end else begin
        // Normal operation: Pass signals from MEM to WB
        ReadData_W   <= ld_data;
        ALUResult_W  <= ALUResult_M;
        PCPlus4_W    <= PCPlus4_M;
        RD_W         <= RD_M;
        rd_wren_W    <= rd_wren_M;
        wb_sel_W     <= wb_sel_M;
        insn_vld_W   <= insn_vld_M;
    end
end

endmodule
