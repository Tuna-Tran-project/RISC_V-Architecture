// =============================================================================
// Clock Divider: 50MHz → 10MHz
// =============================================================================
// Divides input 50MHz clock by 5 to generate 10MHz output clock
// For DE-10 Standard FPGA board
// =============================================================================
module clock_10M (
   input  logic clk50,      // Input: 50 MHz from CLOCK_50
   input  logic i_reset,    // Reset (active-low)
   output logic o_clk       // Output: 10 MHz
);

   // -------------------------------------------------------------------------
   // Clock Division Counter
   // -------------------------------------------------------------------------
   // To divide by 5: count 0,1,2,3,4 then toggle (5 cycles = half period)
   // Full period = 10 cycles at 50MHz = 1 cycle at 10MHz
   logic [2:0] count;  // 3-bit counter (0-7, we only use 0-4)

   always_ff @(posedge clk50 or negedge i_reset) begin
      if (~i_reset) begin
         o_clk <= 1'b0;
         count <= 3'd0;
      end
      else if (count == 3'd4) begin
         o_clk <= ~o_clk;     // Toggle every 5 input clocks
         count <= 3'd0;       // Reset counter
      end
      else begin
         count <= count + 3'd1;  // Increment counter
      end
   end

endmodule 