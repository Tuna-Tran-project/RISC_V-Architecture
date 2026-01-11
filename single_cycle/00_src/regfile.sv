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

  // Asynchronous read with x0 hardwired to zero
  assign o_rs1_data = (i_rs1_addr == 5'd0) ? 32'd0 : registers[i_rs1_addr];
  assign o_rs2_data = (i_rs2_addr == 5'd0) ? 32'd0 : registers[i_rs2_addr];

  // Synchronous write with x0 protection
  // Note: Milestone-2 forbids 'for' loops in RTL, so registers are not reset
  // Register values are undefined after reset (acceptable for RV32I)
  // x0 is hardwired to zero via read logic, not reset
  always_ff @(posedge i_clk) begin
    if (i_rd_wren && (i_rd_addr != 5'd0)) begin
      // Write to register (except x0)
      registers[i_rd_addr] <= i_rd_data;
    end
  end

  // Debug signals for waveform viewing (optional)
  logic [31:0] x0,  x1,  x2,  x3,  x4,  x5,  x6,  x7;
  logic [31:0] x8,  x9,  x10, x11, x12, x13, x14, x15;
  logic [31:0] x16, x17, x18, x19, x20, x21, x22, x23;
  logic [31:0] x24, x25, x26, x27, x28, x29, x30, x31;

  assign x0  = registers[0];   assign x1  = registers[1];
  assign x2  = registers[2];   assign x3  = registers[3];
  assign x4  = registers[4];   assign x5  = registers[5];
  assign x6  = registers[6];   assign x7  = registers[7];
  assign x8  = registers[8];   assign x9  = registers[9];
  assign x10 = registers[10];  assign x11 = registers[11];
  assign x12 = registers[12];  assign x13 = registers[13];
  assign x14 = registers[14];  assign x15 = registers[15];
  assign x16 = registers[16];  assign x17 = registers[17];
  assign x18 = registers[18];  assign x19 = registers[19];
  assign x20 = registers[20];  assign x21 = registers[21];
  assign x22 = registers[22];  assign x23 = registers[23];
  assign x24 = registers[24];  assign x25 = registers[25];
  assign x26 = registers[26];  assign x27 = registers[27];
  assign x28 = registers[28];  assign x29 = registers[29];
  assign x30 = registers[30];  assign x31 = registers[31];

endmodule
