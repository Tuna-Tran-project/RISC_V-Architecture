module execute_cycle(
    input logic i_clk,
    input logic i_reset, // ACTIVE-LOW reset
    // Data inputs from ID/EX pipeline register
    input logic [31:0] RD1_E,
    input logic [31:0] RD2_E,
    input logic [31:0] imm_E,
    input logic [31:0] PC_E,
    input logic [31:0] PCPlus4_E,
    input logic [4:0] RD_E,
    input logic [4:0] RS1_E,
    input logic [4:0] RS2_E,
    // Control signals from ID/EX pipeline register
    input logic rd_wren_E,
    input logic mem_wren_E,
    input logic [1:0] wb_sel_E,
    input logic [1:0] opa_sel_E,
    input logic opb_sel_E,
    input logic [3:0] alu_op_E,
    input logic [2:0] funct3_E,
    input logic br_un_E,
    input logic is_branch_E,
    input logic is_jal_E,
    input logic is_jalr_E,
    input logic insn_vld_E,
    
    // [NEW] Input tín hiệu Load từ Decode gửi xuống
    input logic mem_read_E_in, 

    // Forwarding signals from hazard unit
    input logic [1:0] ForwardA_E,
    input logic [1:0] ForwardB_E,
    // Forwarding data from MEM and WB stages
    input logic [31:0] ALUResultM,  // Forward from MEM stage
    input logic [31:0] ResultW,     // Forward from WB stage
    // Inputs from hazard unit
    input logic Flush,             // Flush EX/MEM register (control hazard)
    
    // Outputs to EX/MEM pipeline register
    // Data outputs
    output logic [31:0] ALUResult_M,
    output logic [31:0] WriteData_M,
    output logic [31:0] PCPlus4_M,
    output logic [4:0] RD_M,
    output logic [2:0] funct3_M,
    // Control signal outputs
    output logic rd_wren_M,
    output logic mem_wren_M,
    output logic [1:0] wb_sel_M,
    output logic insn_vld_M,
    
    // Outputs to fetch stage (branch/jump control)
    output logic PCSrc_E,           // Branch/jump taken
    output logic [31:0] PCTarget_E, // Branch/jump target address
    
    // Outputs to hazard unit
    output logic [4:0] RD_E_out,    // Destination register (for forwarding)
    output logic mem_read_E         // Load instruction flag (for load-use hazard)
);

//==============================================================================
// Internal Signals - Execute Stage
//==============================================================================
logic [31:0] operand_a_fwd;
logic [31:0] operand_b_fwd;
logic [31:0] operand_a;
logic [31:0] operand_b;
logic [31:0] alu_result;
logic br_less;
logic br_equal;
logic take_branch;

//------------------------------------------------------------------------------
// Forwarding Muxes
//------------------------------------------------------------------------------
always_comb begin
    case (ForwardA_E)
        2'b00: operand_a_fwd = RD1_E;         
        2'b01: operand_a_fwd = ResultW;       
        2'b10: operand_a_fwd = ALUResultM;    
        default: operand_a_fwd = RD1_E;
    endcase

    case (ForwardB_E)
        2'b00: operand_b_fwd = RD2_E;         
        2'b01: operand_b_fwd = ResultW;       
        2'b10: operand_b_fwd = ALUResultM;    
        default: operand_b_fwd = RD2_E;
    endcase
end

//------------------------------------------------------------------------------
// ALU Operand Selection
//------------------------------------------------------------------------------
always_comb begin
    case (opa_sel_E)
        2'b00: operand_a = operand_a_fwd;    // RS1 (forwarded)
        2'b01: operand_a = PC_E;             // PC (for JAL/AUIPC)
        2'b10: operand_a = 32'd0;            // Zero
        default: operand_a = operand_a_fwd;
    endcase
end

assign operand_b = opb_sel_E ? imm_E : operand_b_fwd;


//------------------------------------------------------------------------------
// ALU & Branch Comparator
//------------------------------------------------------------------------------
alu alu_inst (
    .i_op_a(operand_a),
    .i_op_b(operand_b),
    .i_alu_op(alu_op_E),
    .i_jalr_mode(is_jalr_E), 
    .o_alu_data(alu_result)
);

brc branch_comp (
    .i_rs1_data(operand_a_fwd),
    .i_rs2_data(operand_b_fwd),
    .i_br_un(br_un_E),
    .o_br_less(br_less),
    .o_br_equal(br_equal)
);

// Branch decision logic
always_comb begin
    case (funct3_E)
        3'b000: take_branch = br_equal;       
        3'b001: take_branch = ~br_equal;      
        3'b100: take_branch = br_less;        
        3'b101: take_branch = ~br_less;       
        3'b110: take_branch = br_less;        
        3'b111: take_branch = ~br_less;       
        default: take_branch = 1'b0;
    endcase
end

assign PCSrc_E = insn_vld_E & ((is_branch_E & take_branch) | is_jal_E | is_jalr_E);

//------------------------------------------------------------------------------
// Branch/Jump Target Calculation (JALR FIX KEPT HERE)
//------------------------------------------------------------------------------
logic [31:0] jump_base;
logic [31:0] jump_target_raw;

always_comb begin
    if (is_jalr_E)
        jump_base = operand_a_fwd; // JALR uses RS1 (Forwarded)
    else
        jump_base = PC_E;          // JAL and Branch use PC
end

assign jump_target_raw = jump_base + imm_E;
assign PCTarget_E = is_jalr_E ? (jump_target_raw & 32'hFFFFFFFE) : jump_target_raw;

//------------------------------------------------------------------------------
// Detect Load Instructions (for hazard unit)
//------------------------------------------------------------------------------
// [NEW LOGIC] Pass through the clean signal from Decode
assign mem_read_E = mem_read_E_in; 

// Output RD_E for hazard detection
assign RD_E_out = RD_E;

//==============================================================================
// EX/MEM Pipeline Register
//==============================================================================
always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
        ALUResult_M  <= 32'd0;
        WriteData_M  <= 32'd0;
        PCPlus4_M    <= 32'd0;
        RD_M         <= 5'd0;
        funct3_M     <= 3'd0;
        rd_wren_M    <= 1'b0;
        mem_wren_M   <= 1'b0;
        wb_sel_M     <= 2'd0;
        insn_vld_M   <= 1'b0;
    end else if (Flush) begin
        ALUResult_M  <= 32'd0;
        WriteData_M  <= 32'd0;
        PCPlus4_M    <= 32'd0;
        RD_M         <= 5'd0;
        funct3_M     <= 3'd0;
        rd_wren_M    <= 1'b0;
        mem_wren_M   <= 1'b0;
        wb_sel_M     <= 2'd0;
        insn_vld_M   <= 1'b0;
    end else begin
        ALUResult_M  <= alu_result;
        WriteData_M  <= operand_b_fwd;
        PCPlus4_M    <= PCPlus4_E;
        RD_M         <= RD_E;
        funct3_M     <= funct3_E;
        rd_wren_M    <= rd_wren_E;
        mem_wren_M   <= mem_wren_E;
        wb_sel_M     <= wb_sel_E;
        insn_vld_M   <= insn_vld_E;
    end
end

endmodule