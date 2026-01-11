//==============================================================================
// Module: lsu (Load-Store Unit)
//==============================================================================
// Description:
//   Top-level load-store unit for the RISC-V single-cycle processor.
//   Handles all memory and I/O access operations including:
//     - Load/store byte/halfword/word operations (LB, LH, LW, LBU, LHU, SB, SH, SW)
//     - Sign/zero extension for loads
//     - Byte-enable generation for partial writes
//     - Misalignment detection and blocking
//     - Memory-mapped I/O for LEDs, 7-segment displays, LCD, and switches
//     - Address decoding between DMEM and I/O regions
//
// Memory Map:
//   0x0000_0000 - 0x0000_07FF: Data memory (2 KiB)
//   0x1000_0000 - 0x1000_0FFF: Red LEDs (LEDR)
//   0x1000_1000 - 0x1000_1FFF: Green LEDs (LEDG)
//   0x1000_2000 - 0x1000_2FFF: 7-segment displays (low 4 digits, HEX0-3)
//   0x1000_3000 - 0x1000_3FFF: 7-segment displays (high 4 digits, HEX4-7)
//   0x1000_4000 - 0x1000_4FFF: LCD display
//   0x1001_0000 - 0x1001_0FFF: Switch inputs
//
// Alignment Rules:
//   - SB/LB:  No alignment required (any address)
//   - SH/LH:  Half-word aligned (addr[0] == 0)
//   - SW/LW:  Word aligned (addr[1:0] == 00)
//   - Misaligned accesses return zero for loads, are blocked for stores
//
// Sub-modules:
//   - dmem:         2 KiB data memory with per-byte write enables
//   - input_mux:    Address decoder (DMEM vs I/O regions)
//   - output_mux:   Load data multiplexer (selects between DMEM and I/O)
//   - input_buffer: Input synchronization for switches
//   - output_buffer: Memory-mapped I/O write handler for LEDs/displays
//==============================================================================

module lsu(
  // System signals
  input  logic        i_clk,
  input  logic        i_reset,
  input  logic [2:0]  i_funct3,    // Load/store type (LB/LH/LW/LBU/LHU/SB/SH/SW)
  
  // Load-Store interface from CPU
  input  logic [31:0] i_lsu_addr,  // Memory/IO address
  input  logic [31:0] i_st_data,   // Store data from CPU (rs2)
  input  logic        i_lsu_wren,  // Write enable from control unit
  output logic [31:0] o_ld_data,   // Load data to CPU (to rd)
  
  // IO outputs to FPGA peripherals
  output logic [31:0] o_io_ledr,   // Red LEDs
  output logic [31:0] o_io_ledg,   // Green LEDs
  output logic [ 6:0] o_io_hex0,   // 7-segment display digit 0 (rightmost)
  output logic [ 6:0] o_io_hex1,   // 7-segment display digit 1
  output logic [ 6:0] o_io_hex2,   // 7-segment display digit 2
  output logic [ 6:0] o_io_hex3,   // 7-segment display digit 3
  output logic [ 6:0] o_io_hex4,   // 7-segment display digit 4
  output logic [ 6:0] o_io_hex5,   // 7-segment display digit 5
  output logic [ 6:0] o_io_hex6,   // 7-segment display digit 6
  output logic [ 6:0] o_io_hex7,   // 7-segment display digit 7 (leftmost)
  output logic [31:0] o_io_lcd,    // LCD display data
  
  // IO inputs from FPGA peripherals
  input  logic [31:0] i_io_sw      // Switch inputs
);

  // Memory-mapped I/O address definitions (bits [15:12] for 4KB blocks)
  localparam LEDR = 4'h0;  // Red LEDs at 0x1000_0xxx
  localparam LEDG = 4'h1;  // Green LEDs at 0x1000_1xxx
  localparam HEXL = 4'h2;  // 7-segment low (digits 0-3) at 0x1000_2xxx
  localparam HEXH = 4'h3;  // 7-segment high (digits 4-7) at 0x1000_3xxx
  localparam LCD  = 4'h4;  // LCD display at 0x1000_4xxx
  localparam SW   = 4'h0;  // Switch inputs at 0x1001_0xxx (note: different upper 16 bits)

  // Internal signals for memory and I/O data paths
  logic [31:0] b_dmem_data;    // Data read from DMEM
  logic [31:0] b_io_ledr;      // Buffered red LED data
  logic [31:0] b_io_ledg;      // Buffered green LED data
  logic [31:0] b_io_hexl;      // Buffered 7-seg low data
  logic [31:0] b_io_hexh;      // Buffered 7-seg high data
  logic [31:0] b_io_lcd;       // Buffered LCD data
  logic [31:0] b_io_sw;        // Synchronized switch inputs
  logic [31:0] b_io_btn;       // Buffered button data (unused)
  
  // Address decode flags
  logic        f_dmem_valid;   // Address in DMEM range (0x0000_0000 - 0x0000_07FF)
  logic        f_io_valid;     // Address in I/O range (0x1000_xxxx or 0x1001_xxxx)
  logic        f_dmem_wren;    // Write enable for DMEM (= i_lsu_wren && f_dmem_valid)
  logic        f_io_wren;      // Write enable for I/O (= i_lsu_wren && f_io_valid)
  
  // DMEM interface signals
  logic [3:0]  dmem_byte_enable;      // Per-byte write enables [3:0] for DMEM
  logic [31:0] dmem_write_data;       // Write data to DMEM (replicated bytes/halfwords)
  logic [31:0] dmem_read_data;        // Raw read data from DMEM
  logic [31:0] processed_read_data;   // Load data after sign/zero extension and lane selection
  logic        misaligned_access;     // Flag for misaligned load/store
  
  //============================================================================
  // Misalignment Detection
  //============================================================================
  // Check if the access violates alignment rules:
  //   - SB/LB (funct3=000/100): Never misaligned
  //   - SH/LH (funct3=001/101): Misaligned if addr[0] != 0
  //   - SW/LW (funct3=010):     Misaligned if addr[1:0] != 00

  always_comb begin
    misaligned_access = 1'b0;
    case (i_funct3)
      3'b001, 3'b101: misaligned_access = i_lsu_addr[0];        // SH/LH: misaligned if addr[0] != 0
      3'b010:         misaligned_access = |i_lsu_addr[1:0];     // SW/LW: misaligned if addr[1:0] != 00
      default:        misaligned_access = 1'b0;                 // SB/LB: never misaligned
    endcase
  end
  
  //============================================================================
  // Store Data Preparation
  //============================================================================
  // Generate byte enable signals and replicate store data to appropriate lanes.
  // For SB: Replicate byte to all 4 lanes, enable only target lane
  // For SH: Replicate halfword to both positions, enable target halfword
  // For SW: Pass through word unchanged, enable all lanes
  // Misaligned stores are blocked (all enables = 0)
  
  always_comb begin
    dmem_byte_enable = 4'b0000;
    dmem_write_data = i_st_data;
    
    if (f_dmem_wren && !misaligned_access) begin  // Only generate enables if writing to DMEM and aligned
      case (i_funct3)
        3'b000: begin // SB - Store byte
          case (i_lsu_addr[1:0])
            2'b00: dmem_byte_enable = 4'b0001;  // Byte 0 (bits [7:0])
            2'b01: dmem_byte_enable = 4'b0010;  // Byte 1 (bits [15:8])
            2'b10: dmem_byte_enable = 4'b0100;  // Byte 2 (bits [23:16])
            2'b11: dmem_byte_enable = 4'b1000;  // Byte 3 (bits [31:24])
          endcase
          // Replicate byte to all 4 positions
          dmem_write_data = {4{i_st_data[7:0]}};
        end

        3'b001: begin // SH - Store halfword (must be 2-byte aligned)
          if (!i_lsu_addr[0]) begin  // Only if addr[0] == 0
            case (i_lsu_addr[1])
              1'b0: dmem_byte_enable = 4'b0011;  // Halfword 0 (bits [15:0])
              1'b1: dmem_byte_enable = 4'b1100;  // Halfword 1 (bits [31:16])
            endcase
            // Replicate halfword to both positions
            dmem_write_data = {2{i_st_data[15:0]}};
          end
        end

        3'b010: begin // SW - Store word (must be 4-byte aligned)
          if (i_lsu_addr[1:0] == 2'b00) begin  // Only if addr[1:0] == 00
            dmem_byte_enable = 4'b1111;  // Enable all bytes
            dmem_write_data = i_st_data; // Pass through unchanged
          end
        end

        default: dmem_byte_enable = 4'b0000;  // Invalid funct3
      endcase
    end
  end
  
  //============================================================================
  // Load Data Processing - OPTIMIZED
  //============================================================================
  // Extract the correct byte/halfword/word from the DMEM read data based on
  // the address offset, and apply sign/zero extension as needed.
  // 
  // OPTIMIZATION: Select narrow byte/half FIRST with 2-bit mux, THEN extend.
  //   This keeps fan-in small on the 32-bit sign-extension logic.
  //   Original version had 4-way 32-bit mux after extension (4x wider).
  //
  // For misaligned loads, return zero.
  
  logic [7:0]  selected_byte;   // Narrow byte selection
  logic [15:0] selected_half;   // Narrow halfword selection
  logic [31:0] extended_byte;   // Sign/zero-extended byte
  logic [31:0] extended_half;   // Sign/zero-extended halfword
  logic        is_unsigned;     // Load unsigned flag

  // Step 1: Select byte/halfword using narrow 2-bit address mux
  always_comb begin
    case (i_lsu_addr[1:0])
      2'b00: selected_byte = dmem_read_data[7:0];
      2'b01: selected_byte = dmem_read_data[15:8];
      2'b10: selected_byte = dmem_read_data[23:16];
      2'b11: selected_byte = dmem_read_data[31:24];
    endcase
  end

  always_comb begin
    case (i_lsu_addr[1])
      1'b0: selected_half = dmem_read_data[15:0];
      1'b1: selected_half = dmem_read_data[31:16];
    endcase
  end

  // Step 2: Extend narrow values (small fan-in)
  assign is_unsigned = (i_funct3 == 3'b100) | (i_funct3 == 3'b101);  // LBU or LHU
  assign extended_byte = is_unsigned ? {24'b0, selected_byte} : {{24{selected_byte[7]}}, selected_byte};
  assign extended_half = is_unsigned ? {16'b0, selected_half} : {{16{selected_half[15]}}, selected_half};

  // Step 3: Final mux based on load type (after extension)
  always_comb begin
    if (misaligned_access) begin
      processed_read_data = 32'b0;  // Return 0 for misaligned
    end else begin
      case (i_funct3[1:0])  // Use only lower 2 bits (00=byte, 01=half, 10=word)
        2'b00:   processed_read_data = extended_byte;  // LB/LBU
        2'b01:   processed_read_data = extended_half;  // LH/LHU
        2'b10:   processed_read_data = dmem_read_data; // LW
        default: processed_read_data = 32'b0;
      endcase
    end
  end
  
  //============================================================================
  // Sub-module Instantiations
  //============================================================================

// Input Buffer: Synchronize external switch inputs to prevent metastability
input_buffer u0(
  .i_clk(i_clk),
  .i_reset(i_reset),
  .i_io_sw(i_io_sw),    // Raw switch inputs from FPGA
  .b_io_sw(b_io_sw)     // Synchronized switch data
);  

// Output Buffer: Handle memory-mapped I/O writes to LEDs, 7-segment, and LCD
output_buffer u1(
  .i_clk(i_clk),
  .i_reset(i_reset),
  .i_st_data(i_st_data),     // Store data from CPU
  .i_io_addr(i_lsu_addr),    // I/O address for decoding
  .i_funct3(i_funct3),       // Store type (SB/SH/SW)
  .f_io_wren(f_io_wren),     // Write enable for I/O region
  .b_io_ledr(b_io_ledr),     // Buffered red LED data
  .b_io_ledg(b_io_ledg),     // Buffered green LED data
  .b_io_hexl(b_io_hexl),     // Buffered 7-seg low data
  .b_io_hexh(b_io_hexh),     // Buffered 7-seg high data
  .b_io_lcd(b_io_lcd)        // Buffered LCD data
);

// Data Memory: 2 KiB SRAM with per-byte write enables
dmem dmem_inst(
  .i_reset(i_reset),
  .address(i_lsu_addr[11:0]),      // Word address (12 bits for 2 KiB = 512 words)
	.i_clk(i_clk),
	.data(dmem_write_data),          // Write data (replicated bytes/halfwords)
	.wren(dmem_byte_enable),         // Per-byte write enables [3:0]
	.q(dmem_read_data)               // Read data output
);

// Input Mux: Address decoder to determine if access is to DMEM or I/O
input_mux u2(
  .i_lsu_addr(i_lsu_addr),         // Full 32-bit address
  .i_lsu_wren(i_lsu_wren),         // Write enable from control unit
  .f_dmem_valid(f_dmem_valid),     // Flag: address in DMEM range
  .f_io_valid(f_io_valid),         // Flag: address in I/O range
  .f_dmem_wren(f_dmem_wren),       // Write enable for DMEM
  .f_io_wren(f_io_wren)            // Write enable for I/O
);

// Output Mux: Select load data from DMEM or I/O regions, unpack 7-segment displays
output_mux u3(
  .i_clk(i_clk),
  // Data sources
  .b_dmem_data(processed_read_data),  // Processed DMEM load data (sign/zero extended)
  .b_io_ledr(b_io_ledr),              // Red LED buffer
  .b_io_ledg(b_io_ledg),              // Green LED buffer
  .b_io_hexl(b_io_hexl),              // 7-segment low buffer
  .b_io_hexh(b_io_hexh),              // 7-segment high buffer
  .b_io_lcd(b_io_lcd),                // LCD buffer
  .b_io_sw(b_io_sw),                  // Synchronized switch inputs
  .b_io_btn(b_io_btn),                // Button buffer (unused)
  
  // Address decode flags
  .f_dmem_valid(f_dmem_valid),        // Select DMEM data if in DMEM range
  .f_io_valid(f_io_valid),            // Select I/O data if in I/O range
  .i_ld_addr(i_lsu_addr),             // Load address for I/O region decode
  
  // Outputs
  .o_ld_data(o_ld_data),              // Load data to CPU
  .o_io_ledr(o_io_ledr),              // Red LEDs to FPGA
  .o_io_ledg(o_io_ledg),              // Green LEDs to FPGA
  .o_io_hex0(o_io_hex0),              // 7-segment digit 0
  .o_io_hex1(o_io_hex1),              // 7-segment digit 1
  .o_io_hex2(o_io_hex2),              // 7-segment digit 2
  .o_io_hex3(o_io_hex3),              // 7-segment digit 3
  .o_io_hex4(o_io_hex4),              // 7-segment digit 4
  .o_io_hex5(o_io_hex5),              // 7-segment digit 5
  .o_io_hex6(o_io_hex6),              // 7-segment digit 6
  .o_io_hex7(o_io_hex7),              // 7-segment digit 7
  .o_io_lcd(o_io_lcd)                 // LCD to FPGA
);

endmodule
