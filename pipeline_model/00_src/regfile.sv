// ============================================================================
// Module: regfile
// Description: 32×32-bit Register File for RV32I
//              Dual read ports, single write port
//              x0 is hardwired to zero (read always returns 0, writes ignored)
// ============================================================================
module regfile(
  input               i_clk,         // Clock
  input               i_reset,       // Active-low reset
  input  [4:0]        i_rs1_addr,    // Read port 1 address
  input  [4:0]        i_rs2_addr,    // Read port 2 address
  input  [4:0]        i_rd_addr,     // Write port address
  input               i_rd_wren,     // Write enable
  input  [31:0]       i_rd_data,     // Write data
  output [31:0]       o_rs1_data,    // Read port 1 data
  output [31:0]       o_rs2_data     // Read port 2 data
);

  logic [31:0] registers [31:0];     // 32 registers

  // Asynchronous read with x0 hardwired to zero and internal bypassing
  // Internal bypassing: if writing and reading same register in same cycle, forward write data
  assign o_rs1_data = (i_rs1_addr == 5'd0) ? 32'd0 : 
                      (i_rd_wren && (i_rd_addr == i_rs1_addr) && (i_rd_addr != 5'd0)) ? i_rd_data :
                      registers[i_rs1_addr];
  assign o_rs2_data = (i_rs2_addr == 5'd0) ? 32'd0 :
                      (i_rd_wren && (i_rd_addr == i_rs2_addr) && (i_rd_addr != 5'd0)) ? i_rd_data :
                      registers[i_rs2_addr];

  // Synchronous write with reset and x0 protection
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      // Initialize all registers to 0 on reset
      // Using blocking assignments for initialization
      registers[0]  <= 32'd0; registers[1]  <= 32'd0; registers[2]  <= 32'd0; registers[3]  <= 32'd0;
      registers[4]  <= 32'd0; registers[5]  <= 32'd0; registers[6]  <= 32'd0; registers[7]  <= 32'd0;
      registers[8]  <= 32'd0; registers[9]  <= 32'd0; registers[10] <= 32'd0; registers[11] <= 32'd0;
      registers[12] <= 32'd0; registers[13] <= 32'd0; registers[14] <= 32'd0; registers[15] <= 32'd0;
      registers[16] <= 32'd0; registers[17] <= 32'd0; registers[18] <= 32'd0; registers[19] <= 32'd0;
      registers[20] <= 32'd0; registers[21] <= 32'd0; registers[22] <= 32'd0; registers[23] <= 32'd0;
      registers[24] <= 32'd0; registers[25] <= 32'd0; registers[26] <= 32'd0; registers[27] <= 32'd0;
      registers[28] <= 32'd0; registers[29] <= 32'd0; registers[30] <= 32'd0; registers[31] <= 32'd0;
    end else if (i_rd_wren && (i_rd_addr != 5'd0)) begin
      // Write to register (except x0)
      registers[i_rd_addr] <= i_rd_data;
    end
  end

endmodule
