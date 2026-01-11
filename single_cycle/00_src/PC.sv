// ============================================================================
// Module: PC
// Description: Program Counter Register
//              Stores current instruction address, updates on clock edge
// ============================================================================
module PC(
  input               i_clk,        // Clock
  input               i_reset,      // Active-low reset
  input  [31:0]       i_pc_next,    // Next PC value
  output logic [31:0] o_pc          // Current PC value
);

  // Synchronous update with asynchronous reset
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
      o_pc <= 32'd0;                 // Reset PC to 0
    end else begin
      o_pc <= i_pc_next;             // Update PC
    end
  end

endmodule