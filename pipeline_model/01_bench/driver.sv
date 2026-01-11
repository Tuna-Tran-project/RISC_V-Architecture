module driver (
  input  logic        i_clk  ,
  input  logic        i_reset,
  output logic [31:0] i_io_sw
);

  // Drive switches with constant value
  assign i_io_sw = 32'h12345678;

endmodule : driver



