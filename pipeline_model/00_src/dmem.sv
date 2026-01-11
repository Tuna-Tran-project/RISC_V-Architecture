// ============================================================================
// Module: dmem
// Description: Data Memory (DMEM) - 64 KiB word-addressed memory
//              Asynchronous read, synchronous write with byte enables
//              Implements single-port BRAM-compatible behavior
// ============================================================================
module dmem(
    input  logic        i_clk,        // Clock
    input  logic        i_reset,      // Active-low reset (unused, memory persists)
    input  logic [15:0] address,      // [CHANGED] Byte address [15:0] (64 KiB range)
    input  logic [31:0] data,         // Write data (32-bit word)
    input  logic [3:0]  wren,         // Byte write enables [3:0]
    output logic [31:0] q             // Read data (32-bit word)
);

    // [CHANGED] 16384 words * 4 bytes = 65536 bytes = 64 KiB
    localparam DEPTH = 16384;             

    // Memory array with FPGA BRAM synthesis attributes
    (* ramstyle = "M10K" *)             // Quartus: Force M10K block RAM
    (* ram_style = "block" *)           // Vivado: Force block RAM  
    logic [31:0] mem [0:DEPTH-1];

    // Initialize memory to zero at simulation start
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = 32'h00000000;
    end

    // [CHANGED] Convert byte address to word address (14 bits for 16k depth)
    logic [13:0] word_addr;
    assign word_addr = address[15:2];   // Drop lower 2 bits for word alignment

    // Asynchronous read: output updates combinationally with address
    assign q = mem[word_addr];

    // Synchronous write with per-byte enables
    always_ff @(posedge i_clk) begin
        if (wren[0]) mem[word_addr][7:0]   <= data[7:0];    // Byte 0
        if (wren[1]) mem[word_addr][15:8]  <= data[15:8];   // Byte 1
        if (wren[2]) mem[word_addr][23:16] <= data[23:16];  // Byte 2
        if (wren[3]) mem[word_addr][31:24] <= data[31:24];  // Byte 3
    end

endmodule