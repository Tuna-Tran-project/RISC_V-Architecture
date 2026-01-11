// ============================================================================
// Module: dmem
// Description: Data Memory (DMEM) - 2 KiB word-addressed memory
//              Asynchronous read, synchronous write with byte enables
//              Implements single-port BRAM-compatible behavior
// ============================================================================
module dmem(
  input  logic        i_clk,        // Clock
  input  logic        i_reset,      // Active-low reset (unused, memory persists)
  input  logic [10:0] address,      // Byte address [10:0] (2 KiB range)
  input  logic [31:0] data,         // Write data (32-bit word)
  input  logic [3:0]  wren,         // Byte write enables [3:0]
  output logic [31:0] q             // Read data (32-bit word)
);

  localparam DEPTH = 512;             // 512 words × 4 bytes = 2 KiB

  // Memory array with FPGA BRAM synthesis attributes
  (* ramstyle = "M10K" *)             // Quartus: Force M10K block RAM
  (* ram_style = "block" *)           // Vivado: Force block RAM  
  logic [31:0] mem [0:DEPTH-1];

  // Initialize memory to zero at simulation start
  // Contents persist across resets (no reset logic in always_ff)
  integer i;
  initial begin
    for (i = 0; i < DEPTH; i = i + 1)
      mem[i] = 32'h00000000;
  end

  // Convert byte address to word address
  logic [8:0] word_addr;
  assign word_addr = address[10:2];   // Drop lower 2 bits for word alignment

  // Asynchronous read: output updates combinationally with address
  assign q = mem[word_addr];

  // Synchronous write with per-byte enables
  // Implements byte-enable writes without read-modify-write
  // Infers BRAM with byte enables on FPGA
  always_ff @(posedge i_clk) begin
    if (wren[0]) mem[word_addr][7:0]   <= data[7:0];    // Byte 0
    if (wren[1]) mem[word_addr][15:8]  <= data[15:8];   // Byte 1
    if (wren[2]) mem[word_addr][23:16] <= data[23:16];  // Byte 2
    if (wren[3]) mem[word_addr][31:24] <= data[31:24];  // Byte 3
  end

endmodule
