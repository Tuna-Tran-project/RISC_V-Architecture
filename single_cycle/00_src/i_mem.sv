// ============================================================================
// Module: i_mem
// Description: Instruction Memory (IMEM) - 2 KiB word-addressed ROM
//              Asynchronous read, preloaded from hex file
//              For FPGA: Uses $readmemh with synthesis attributes
//              For Quartus: Memory Initialization File (.mif) or .hex
// ============================================================================
module i_mem(
  input  [31:0] i_addr,              // Byte address input
  output [31:0] o_data               // 32-bit instruction output
);

  // Memory array with FPGA BRAM synthesis attributes
  (* ramstyle = "M10K" *)        // Quartus: Use M10K block RAM
  (* ram_style = "block" *)      // Vivado: Use block RAM
  (* rom_style = "block" *)      // Additional hint for ROM inference
  logic [31:0] mem [0:2047];     // 2048 words × 4 bytes = 8 KiB

  // Load instruction memory from hex file
  // For FPGA synthesis: Quartus supports $readmemh in initial blocks
  // Memory contents are baked into the FPGA bitstream
  initial begin
    $readmemh("../02_test/isa_4b.hex", mem);
  end

  // Asynchronous read: convert byte address to word address
  assign o_data = mem[i_addr[12:2]];  // Drop lower 2 bits for word alignment

endmodule

