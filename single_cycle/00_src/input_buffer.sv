// ============================================================================
// Module: input_buffer
// Description: Input Synchronization Buffer for I/O Switches
//              Registers external switch inputs to prevent metastability
// ============================================================================
module input_buffer(
  input  logic        i_clk,         // Clock
  input  logic        i_reset,       // Active-low reset
  input  logic [31:0] i_io_sw,       // Switch inputs (asynchronous)
  output logic [31:0] b_io_sw        // Buffered switch values (synchronized)
);

  // Synchronize inputs on clock edge
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      b_io_sw <= 32'd0;
    end else begin
      b_io_sw <= i_io_sw;            // Register input
    end
  end

endmodule