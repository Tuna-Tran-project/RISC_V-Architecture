// ============================================================================
// Module: output_buffer
// Description: Memory-Mapped I/O Output Buffer
//              Handles store operations to LED, 7-segment, and LCD peripherals
//              Supports byte, halfword, and word writes with masking
// ============================================================================
module output_buffer(
  input  logic        i_clk,         // Clock
  input  logic        i_reset,       // Active-low reset
  input  logic [31:0] i_st_data,     // Store data
  input  logic [31:0] i_io_addr,     // I/O address
  input  logic [2:0]  i_funct3,      // Function code (SB/SH/SW)
  input  logic        f_io_wren,     // I/O write enable
  output logic [31:0] b_io_ledr,     // Red LED buffer
  output logic [31:0] b_io_ledg,     // Green LED buffer
  output logic [31:0] b_io_hexl,     // 7-segment low (HEX3-0)
  output logic [31:0] b_io_hexh,     // 7-segment high (HEX7-4)
  output logic [31:0] b_io_lcd       // LCD buffer
);

  logic [31:0] write_mask;           // Byte/halfword write mask
  logic [31:0] write_data;           // Aligned write data
  logic [1:0]  addr_offset;          // Lower 2 bits of address

  // Generate write mask and align data based on store type
  always_comb begin
    addr_offset = i_io_addr[1:0];
    
    case (i_funct3)
      3'b000: begin // SB (Store Byte)
        case (addr_offset)
          2'b00: begin
            write_mask = 32'h0000_00FF;
            write_data = {24'h000000, i_st_data[7:0]};
          end
          2'b01: begin
            write_mask = 32'h0000_FF00;
            write_data = {16'h0000, i_st_data[7:0], 8'h00};
          end
          2'b10: begin
            write_mask = 32'h00FF_0000;
            write_data = {8'h00, i_st_data[7:0], 16'h0000};
          end
          2'b11: begin
            write_mask = 32'hFF00_0000;
            write_data = {i_st_data[7:0], 24'h000000};
          end
          default: begin
            write_mask = 32'h0000_0000;
            write_data = 32'h0000_0000;
          end
        endcase
      end
      
      3'b001: begin // SH (Store Halfword)
        if (addr_offset[1] == 1'b0) begin
          write_mask = 32'h0000_FFFF;
          write_data = {16'h0000, i_st_data[15:0]};
        end else begin
          write_mask = 32'hFFFF_0000;
          write_data = {i_st_data[15:0], 16'h0000};
        end
      end
      
      3'b010: begin // SW (Store Word)
        write_mask = 32'hFFFF_FFFF;
        write_data = i_st_data;
      end
      
      default: begin
        write_mask = 32'h0000_0000;
        write_data = 32'h0000_0000;
      end
    endcase
  end

  // Combinational next-state logic for I/O registers
  logic [31:0] next_b_io_ledr, next_b_io_ledg, next_b_io_hexl, next_b_io_hexh, next_b_io_lcd;

  always_comb begin
    // Default: hold current values
    next_b_io_ledr = b_io_ledr;
    next_b_io_ledg = b_io_ledg;
    next_b_io_hexl = b_io_hexl;
    next_b_io_hexh = b_io_hexh;
    next_b_io_lcd  = b_io_lcd;

    // Update addressed I/O register if write enabled
    if (f_io_wren && (write_mask != 32'h0000_0000)) begin
      case (i_io_addr[15:12])  // Use bits [15:12] to decode device (4KB blocks)
        4'h0: next_b_io_ledr = (b_io_ledr & ~write_mask) | (write_data & write_mask); // 0x1000_0xxx
        4'h1: next_b_io_ledg = (b_io_ledg & ~write_mask) | (write_data & write_mask); // 0x1000_1xxx
        4'h2: next_b_io_hexl = (b_io_hexl & ~write_mask) | (write_data & write_mask); // 0x1000_2xxx
        4'h3: next_b_io_hexh = (b_io_hexh & ~write_mask) | (write_data & write_mask); // 0x1000_3xxx
        4'h4: next_b_io_lcd  = (b_io_lcd  & ~write_mask) | (write_data & write_mask); // 0x1000_4xxx
        default: ;  // No change for other addresses
      endcase
    end
  end

  // Sequential logic: register outputs on clock edge
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (~i_reset) begin
      b_io_ledr <= 32'b0;
      b_io_ledg <= 32'b0;
      // Initialize 7-segment displays to 0x7F (all segments OFF for common-anode)
      // instead of 0x00 (all segments ON)
      b_io_hexl <= 32'h7F7F7F7F;  // All digits show blank (segments off)
      b_io_hexh <= 32'h7F7F7F7F;  // All digits show blank (segments off)
      b_io_lcd  <= 32'b0;
    end else begin
      b_io_ledr <= next_b_io_ledr;
      b_io_ledg <= next_b_io_ledg;
      b_io_hexl <= next_b_io_hexl;
      b_io_hexh <= next_b_io_hexh;
      b_io_lcd  <= next_b_io_lcd;
    end
  end

endmodule
	