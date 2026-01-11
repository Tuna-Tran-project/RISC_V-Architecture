module fetch_cycle (

    input  logic        i_clk,

    input  logic        i_reset,        // ACTIVE-LOW reset

    input  logic        pc_sel,

    input  logic [31:0] alu_target,

    input  logic        stall,

    input  logic        flush,          // <--- [NEW] Thêm cổng flush

    output logic [31:0] InstrD,

    output logic [31:0] PCD,

    output logic [31:0] PCPlus4D,

    output logic [31:0] PCF            

);

    logic [31:0] PCNextF, PCPlus4F, PCNextMux;
    logic [31:0] InstrF;
    // PC mux (mux2_1: sel=1 selects i_a, sel=0 selects i_b)
    // When pc_sel=1 (branch/jump taken), select alu_target
    // When pc_sel=0 (normal), select PCPlus4F
    mux2_1 PC_MUX (

        .i_a(alu_target),      // Branch/jump target (selected when pc_sel=1)

        .i_b(PCPlus4F),        // Sequential PC+4 (selected when pc_sel=0)

        .i_sel(pc_sel),

        .o_c(PCNextMux)

    );
    
    // Stall handling: Keep current PC if stall is asserted
    assign PCNextF = stall ? PCF : PCNextMux;
    
    // PC register (ACTIVE-LOW reset)
    PC PC_REG (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_pc_next(PCNextF),
        .o_pc(PCF)
    );
    // PC + 4 adder
    assign PCPlus4F = PCF + 32'd4;
    // Instruction memory
    i_mem INSTR_MEM (
        .i_addr(PCF),
        .o_data(InstrF)
    );
    
 always @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
        InstrD    <= 32'h00000013; // [RECOMMENDED] Đặt về NOP chuẩn (addi x0, x0, 0)
        PCD       <= 32'b0;
        PCPlus4D  <= 32'b0;
    end else if (flush) begin
        InstrD    <= 32'h00000013; // [RECOMMENDED] Flush thành NOP chuẩn
        PCD       <= 32'b0;        // Hoặc giữ nguyên PC cũ tùy debug, nhưng 0 là an toàn
        PCPlus4D  <= 32'b0;
    end else if (~stall) begin     // Viết gọn (~stall) là đủ, ko cần == 1'b1
        InstrD    <= InstrF;
        PCD       <= PCF;
        PCPlus4D  <= PCPlus4F;
    end
end
endmodule