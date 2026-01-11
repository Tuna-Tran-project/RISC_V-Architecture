// ============================================================================
// Module: imm_gen
// Description: Immediate Generator for RV32I Instructions
//              Extracts and sign-extends immediate values from instructions
//              Supports I, S, B, U, and J-type formats
// ============================================================================
module imm_gen(
  input  logic [31:0] i_instr,       // 32-bit instruction
  output logic [31:0] o_imm_out      // Sign-extended immediate value
);

  logic [31:0] imm_i, imm_s, imm_b, imm_j, u_imm;

  // I-type: imm[11:0] = instr[31:20]
  sign_extend #(.IN_WIDTH(12), .OUT_WIDTH(32)) ext_i (
    .in(i_instr[31:20]),
    .out(imm_i)
  );

  // S-type: imm[11:0] = {instr[31:25], instr[11:7]}
  sign_extend #(.IN_WIDTH(12), .OUT_WIDTH(32)) ext_s (
    .in({i_instr[31:25], i_instr[11:7]}),
    .out(imm_s)
  );

  // B-type: imm[12:1] = {instr[31], instr[7], instr[30:25], instr[11:8]}, imm[0] = 0
  sign_extend #(.IN_WIDTH(13), .OUT_WIDTH(32)) ext_b (
    .in({i_instr[31], i_instr[7], i_instr[30:25], i_instr[11:8], 1'b0}),
    .out(imm_b)
  );

  // J-type: imm[20:1] = {instr[31], instr[19:12], instr[20], instr[30:21]}, imm[0] = 0
  sign_extend #(.IN_WIDTH(21), .OUT_WIDTH(32)) ext_j (
    .in({i_instr[31], i_instr[19:12], i_instr[20], i_instr[30:21], 1'b0}),
    .out(imm_j)
  );

  // U-type: imm[31:12] = instr[31:12], imm[11:0] = 0 (not sign-extended)
  assign u_imm = {i_instr[31:12], 12'b0};

  // Select immediate based on opcode
  always_comb begin
    case (i_instr[6:0])
      7'b0010011,  // I-type (ALU immediate: ADDI, SLTI, etc.)
      7'b0000011,  // I-type (Load: LB, LH, LW, etc.)
      7'b1100111:  // I-type (JALR)
        o_imm_out = imm_i;
      7'b0100011:  // S-type (Store: SB, SH, SW)
        o_imm_out = imm_s;
      7'b1100011:  // B-type (Branch: BEQ, BNE, BLT, BGE, etc.)
        o_imm_out = imm_b;
      7'b0110111,  // U-type (LUI)
      7'b0010111:  // U-type (AUIPC)
        o_imm_out = u_imm;
      7'b1101111:  // J-type (JAL)
        o_imm_out = imm_j;
      default:
        o_imm_out = 32'b0;
    endcase
  end

endmodule

// ============================================================================
// Module: sign_extend
// Description: Parameterized sign extension module
//              Replicates MSB to extend smaller values to larger widths
// ============================================================================
module sign_extend #(
  parameter IN_WIDTH  = 12,
  parameter OUT_WIDTH = 32
)(
  input  logic [IN_WIDTH-1:0]  in,   // Input value
  output logic [OUT_WIDTH-1:0] out   // Sign-extended output
);

  assign out = {{(OUT_WIDTH-IN_WIDTH){in[IN_WIDTH-1]}}, in};

endmodule