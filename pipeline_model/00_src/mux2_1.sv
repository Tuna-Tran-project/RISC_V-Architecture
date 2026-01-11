// ============================================================================
// Module: mux2_1
// Description: 2-to-1 Multiplexer (32-bit)
//              Selects between two 32-bit inputs based on select signal
// ============================================================================
module mux2_1(
  input  [31:0] i_a,                 // Input A
  input  [31:0] i_b,                 // Input B
  input         i_sel,               // Select: 1=A, 0=B
  output [31:0] o_c                  // Output
);

  assign o_c = (i_sel) ? i_a : i_b;

endmodule
