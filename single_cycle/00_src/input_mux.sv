// ============================================================================
// Module: input_mux
// Description: Address Decoder for Memory-Mapped I/O
//              Generates valid and write enable flags for DMEM and I/O regions
// ============================================================================
module input_mux(
  input  logic [31:0] i_lsu_addr,    // Load/store address
  input  logic        i_lsu_wren,    // Load/store write enable
  output logic        f_dmem_valid,  // DMEM region valid flag
  output logic        f_io_valid,    // I/O region valid flag
  output logic        f_dmem_wren,   // DMEM write enable
  output logic        f_io_wren      // I/O write enable
);

  // Memory-mapped address ranges per spec:
  // - DMEM: 0x0000_0000 to 0x0000_07FF (2 KiB)
  // - I/O:  0x1000_xxxx (output devices) and 0x1001_xxxx (input devices)
  //   Where xxxx can be any value (full 16-bit range for device addresses)

  // DMEM valid when address[31:11] == 0 (first 2 KiB)
  assign f_dmem_valid = (i_lsu_addr[31:11] == 21'd0);

  // I/O valid when address matches upper 16 bits: 0x1000 or 0x1001
  assign f_io_valid = (i_lsu_addr[31:16] == 16'h1000) ||
                      (i_lsu_addr[31:16] == 16'h1001);

  // Generate write enables for each region
  assign f_dmem_wren = i_lsu_wren && f_dmem_valid;
  assign f_io_wren   = i_lsu_wren && f_io_valid;

endmodule

