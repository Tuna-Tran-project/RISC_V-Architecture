module pipelined (
    input logic i_clk, i_reset,
    input  logic [31:0] i_io_sw,
    output logic [31:0] o_pc_debug,
    output logic [31:0] o_pc_frontend,  
    output logic        o_insn_vld,
    output logic        o_mispred,      
    output logic        o_ctrl,         
    
    // IO outputs
    output logic [31:0] o_io_ledr, o_io_ledg, o_io_lcd,
    output logic [6:0]  o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3,
    output logic [6:0]  o_io_hex4, o_io_hex5, o_io_hex6, o_io_hex7
);

    //==========================================================================
    // Internal Wires
    //==========================================================================
    logic hz_stall_f, hz_stall_d, hz_flush_d, hz_flush_e;
    logic [1:0] hz_forward_a, hz_forward_b;

    // IF -> ID
    logic [31:0] if_instr_d, if_pc_d, if_pc_plus4_d, pc_f_debug;

    // ID -> EX
    logic [31:0] id_rd1_e, id_rd2_e, id_imm_e, id_pc_e, id_pc_plus4_e;
    logic [4:0]  id_rd_e, id_rs1_e, id_rs2_e;
    logic        id_rd_wren_e, id_mem_wren_e;
    logic [1:0]  id_wb_sel_e, id_opa_sel_e;
    logic        id_opb_sel_e;
    logic [3:0]  id_alu_op_e;
    logic [2:0]  id_funct3_e;
    logic        id_br_un_e, id_is_branch_e, id_is_jal_e, id_is_jalr_e, id_insn_vld_e;
    logic [4:0]  id_rs1_d, id_rs2_d; 
    
    // [NEW] Dây nối tín hiệu Load từ Decode sang Execute
    logic        id_mem_read_e;

    // EX -> MEM
    logic [31:0] ex_alu_result_m, ex_write_data_m, ex_pc_plus4_m;
    logic [4:0]  ex_rd_m;
    logic [2:0]  ex_funct3_m;
    logic        ex_rd_wren_m, ex_mem_wren_m;
    logic [1:0]  ex_wb_sel_m;
    logic        ex_insn_vld_m;
    logic        ex_pc_src;
    logic [31:0] ex_pc_target;
    logic [4:0]  ex_rd_e_out;    
    logic        ex_mem_read_e;  // Hazard check signal

    // MEM -> WB
    logic [31:0] mem_read_data_w, mem_alu_result_w, mem_pc_plus4_w;
    logic [4:0]  mem_rd_w;
    logic        mem_rd_wren_w;
    logic [1:0]  mem_wb_sel_w;
    logic        mem_insn_vld_w;
    logic [4:0]  mem_rd_m_out;   

    // WB -> Loopback
    logic [31:0] wb_result;
    logic [4:0]  wb_rd_out;
    logic        wb_reg_write;
    
    logic [31:0] result_m_fwd;

    //==========================================================================
    // MODULES
    //==========================================================================

    // 1. HAZARD UNIT
    hazard_unit hazard_inst (
        .id_rs1_addr_i (id_rs1_d),
        .id_rs2_addr_i (id_rs2_d),
        .ex_rs1_addr_i (id_rs1_e),
        .ex_rs2_addr_i (id_rs2_e), 
        .ex_rd_addr_i  (ex_rd_e_out),
        .ex_reg_we_i   (id_rd_wren_e), 
        .ex_mem_read_i (ex_mem_read_e), // Tín hiệu này giờ rất ổn định
        .mem_rd_addr_i (mem_rd_m_out), 
        .mem_reg_we_i  (ex_rd_wren_m),  
        .rd_addr_wb    (wb_rd_out),
        .reg_write_wb  (wb_reg_write),
        .pc_src_E      (ex_pc_src),
        .StallF(hz_stall_f), .StallD(hz_stall_d), .FlushD(hz_flush_d), .FlushE(hz_flush_e),
        .ForwardAE(hz_forward_a), .ForwardBE(hz_forward_b)
    );

    // 2. FETCH
    fetch_cycle fetch_stage (
        .i_clk(i_clk), .i_reset(i_reset),
        .pc_sel(ex_pc_src), .alu_target(ex_pc_target),
        .stall(hz_stall_f), .flush(hz_flush_d),
        .InstrD(if_instr_d), .PCD(if_pc_d), .PCPlus4D(if_pc_plus4_d), .PCF(pc_f_debug)
    );

    // 3. DECODE
    decode_cycle decode_stage (
        .i_clk(i_clk), .i_reset(i_reset),
        .InstrD(if_instr_d), .PCPlus4D(if_pc_plus4_d), .PCD(if_pc_d),
        .RegWriteW(wb_reg_write), .ResultW(wb_result), .RD_W(wb_rd_out),
        .StallD(hz_stall_d), .FlushE(hz_flush_e),
        .RD1_E(id_rd1_e), .RD2_E(id_rd2_e), .imm_E(id_imm_e), .PC_E(id_pc_e), .PCPlus4_E(id_pc_plus4_e),
        .RD_E(id_rd_e), .RS1_E(id_rs1_e), .RS2_E(id_rs2_e),
        .rd_wren_E(id_rd_wren_e), .mem_wren_E(id_mem_wren_e),
        .wb_sel_E(id_wb_sel_e), .opa_sel_E(id_opa_sel_e), .opb_sel_E(id_opb_sel_e),
        .alu_op_E(id_alu_op_e), .funct3_E(id_funct3_e),
        .br_un_E(id_br_un_e), .is_branch_E(id_is_branch_e), .is_jal_E(id_is_jal_e), .is_jalr_E(id_is_jalr_e),
        .insn_vld_E(id_insn_vld_e), .RS1_D(id_rs1_d), .RS2_D(id_rs2_d),
        
        // [NEW] Output tín hiệu Load
        .mem_read_E(id_mem_read_e) 
    );

    // 4. MEM RESULT FORWARDING
    always_comb begin
        case (ex_wb_sel_m)
            2'b00: result_m_fwd = ex_alu_result_m;
            2'b01: result_m_fwd = mem_read_data_w;
            2'b10: result_m_fwd = ex_pc_plus4_m;
            default: result_m_fwd = 32'd0;
        endcase
    end

    // 5. EXECUTE
    execute_cycle execute_stage (
        .i_clk(i_clk), .i_reset(i_reset),
        .RD1_E(id_rd1_e), .RD2_E(id_rd2_e), .imm_E(id_imm_e), .PC_E(id_pc_e), .PCPlus4_E(id_pc_plus4_e),
        .RD_E(id_rd_e), .RS1_E(id_rs1_e), .RS2_E(id_rs2_e),
        .rd_wren_E(id_rd_wren_e), .mem_wren_E(id_mem_wren_e), .wb_sel_E(id_wb_sel_e),
        .opa_sel_E(id_opa_sel_e), .opb_sel_E(id_opb_sel_e), .alu_op_E(id_alu_op_e), .funct3_E(id_funct3_e),
        .br_un_E(id_br_un_e), .is_branch_E(id_is_branch_e), .is_jal_E(id_is_jal_e), .is_jalr_E(id_is_jalr_e), .insn_vld_E(id_insn_vld_e),
        
        // [NEW] Input tín hiệu Load
        .mem_read_E_in(id_mem_read_e),

        .ForwardA_E(hz_forward_a), .ForwardB_E(hz_forward_b),
        .ALUResultM(result_m_fwd), .ResultW(wb_result), .Flush(1'b0),
        .ALUResult_M(ex_alu_result_m), .WriteData_M(ex_write_data_m), .PCPlus4_M(ex_pc_plus4_m),
        .RD_M(ex_rd_m), .funct3_M(ex_funct3_m),
        .rd_wren_M(ex_rd_wren_m), .mem_wren_M(ex_mem_wren_m), .wb_sel_M(ex_wb_sel_m), .insn_vld_M(ex_insn_vld_m),
        .PCSrc_E(ex_pc_src), .PCTarget_E(ex_pc_target),
        .RD_E_out(ex_rd_e_out), .mem_read_E(ex_mem_read_e)
    );

    // 6. MEMORY
    memory_cycle memory_stage (
        .i_clk(i_clk), .i_reset(i_reset),
        .ALUResult_M(ex_alu_result_m), .WriteData_M(ex_write_data_m), .PCPlus4_M(ex_pc_plus4_m),
        .RD_M(ex_rd_m), .funct3_M(ex_funct3_m),
        .rd_wren_M(ex_rd_wren_m), .mem_wren_M(ex_mem_wren_m), .wb_sel_M(ex_wb_sel_m), .insn_vld_M(ex_insn_vld_m),
        .i_io_sw(i_io_sw),
        .ReadData_W(mem_read_data_w), .ALUResult_W(mem_alu_result_w), .PCPlus4_W(mem_pc_plus4_w), .RD_W(mem_rd_w),
        .rd_wren_W(mem_rd_wren_w), .wb_sel_W(mem_wb_sel_w), .insn_vld_W(mem_insn_vld_w),
        .o_io_ledr(o_io_ledr), .o_io_ledg(o_io_ledg), .o_io_lcd(o_io_lcd),
        .o_io_hex0(o_io_hex0), .o_io_hex1(o_io_hex1), .o_io_hex2(o_io_hex2), .o_io_hex3(o_io_hex3),
        .o_io_hex4(o_io_hex4), .o_io_hex5(o_io_hex5), .o_io_hex6(o_io_hex6), .o_io_hex7(o_io_hex7),
        .RD_M_out(mem_rd_m_out)
    );

    // 7. WRITEBACK
    logic wb_insn_vld_raw;
    writeback_cycle writeback_stage (
        .ReadData_W(mem_read_data_w), .ALUResult_W(mem_alu_result_w), .PCPlus4_W(mem_pc_plus4_w), .RD_W(mem_rd_w),
        .rd_wren_W(mem_rd_wren_w), .wb_sel_W(mem_wb_sel_w), .insn_vld_W(mem_insn_vld_w),
        .Result_W(wb_result), .RD_W_out(wb_rd_out), .RegWrite_W(wb_reg_write), .insn_vld_out(wb_insn_vld_raw)
    );
    assign o_insn_vld = wb_insn_vld_raw & ~hz_flush_d & ~hz_flush_e;
    // Debug
    assign o_pc_frontend = pc_f_debug;
    assign o_mispred = ex_pc_src;
    assign o_ctrl = hz_flush_d || hz_flush_e;
    always_ff @(posedge i_clk) o_pc_debug <= mem_pc_plus4_w;

endmodule