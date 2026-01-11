module wrapper (
    input  logic        CLOCK_50,
    input  logic [9:0]  SW,          // DE10-Standard: 10 switches (SW[0] = pause/resume)
    input  logic [3:0]  KEY,         // DE10-Standard: 4 buttons (KEY[0] = reset, active-low)
    output logic [9:0]  LEDR,        // 10 red LEDs
    output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5  // 7-segment displays (HEX5=leftmost, HEX0=rightmost)
);

    // -------------------------------------------------------------------------
    // Clock & Reset
    // -------------------------------------------------------------------------
    logic clk_25;
    logic reset_n;            // active-low reset as expected by single_cycle
    assign reset_n = KEY[0];  // KEY[0] is system reset (active-low)

    // 50MHz -> 10MHz clock divider
    clock_10M u_clkdiv (
        .clk50   (CLOCK_50),
        .i_reset (reset_n),
        .o_clk   (clk_25)
    );

    // -------------------------------------------------------------------------
    // Interconnect to single_cycle
    // -------------------------------------------------------------------------
    logic        insn_vld;
    logic [31:0] ledr32;

    // Unused 7-seg from core (the core outputs 8 digits, board has 6)
    logic [6:0] hex6_nc, hex7_nc;

    single_cycle dut (
        .i_clk      (clk_25),
        .i_reset    (reset_n),

        // Map switches and KEY buttons to 32-bit input
        // KEYs are active-low (pressed=0), invert to active-high for software
        // SWs: ON=1, OFF=0 (no inversion needed)
        // SW[0]=1 means running, SW[0]=0 means paused in the program logic
        .i_io_sw    ({18'd0, ~KEY, SW}),

        // Optional debug (left unconnected)
        .o_pc_debug (),
        .o_insn_vld (insn_vld),

        // Map LEDRs (core drives 32; board shows 10)
        .o_io_ledr  (ledr32),
        .o_io_ledg  (),           // not brought to the board
        
        // 7-segment displays: HEX5(leftmost) to HEX0(rightmost)
        .o_io_hex0  (HEX0),
        .o_io_hex1  (HEX1),
        .o_io_hex2  (HEX2),
        .o_io_hex3  (HEX3),
        .o_io_hex4  (HEX4),
        .o_io_hex5  (HEX5),
        .o_io_hex6  (hex6_nc),    // tie off extra digits
        .o_io_hex7  (hex7_nc),
        .o_io_lcd   ()            // not used on DE10-Standard
    );

    // -------------------------------------------------------------------------
    // Board LED assignments
    // -------------------------------------------------------------------------
    // Show core LEDR[8:0] on board, and use LEDR[9] as "instruction valid" pulse
    always_comb begin
        LEDR[8:0] = ledr32[8:0];
        LEDR[9]   = insn_vld;
    end

endmodule
