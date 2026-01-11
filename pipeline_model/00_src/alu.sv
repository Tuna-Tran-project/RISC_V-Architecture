// ============================================================================
// Module: alu
// Description: Arithmetic Logic Unit for RV32I
//              Performs all ALU operations: arithmetic, logical, shifts, comparisons
//              Uses ripple-carry adders and barrel shifters
// ============================================================================
module alu(
  input  logic [31:0] i_op_a,        // Operand A
  input  logic [31:0] i_op_b,        // Operand B
  input  logic [3:0]  i_alu_op,      // ALU operation select
  input  logic        i_jalr_mode,   // JALR mode: clear LSB of result
  output logic [31:0] o_alu_data,    // Result
  // Debug outputs for SRAI
  output logic [31:0] dbg_srai_op_a,
  output logic [4:0]  dbg_srai_shamt,
  output logic [31:0] dbg_srai_result
);

  // ALU operation encoding
  localparam ADD  = 4'd0;            // Addition
  localparam SUB  = 4'd1;            // Subtraction
  localparam SLL  = 4'd2;            // Shift left logical
  localparam SLT  = 4'd3;            // Set less than (signed)
  localparam SLTU = 4'd4;            // Set less than unsigned
  localparam XOR  = 4'd5;            // Bitwise XOR
  localparam SRL  = 4'd6;            // Shift right logical
  localparam SRA  = 4'd7;            // Shift right arithmetic
  localparam OR   = 4'd8;            // Bitwise OR
  localparam AND  = 4'd9;            // Bitwise AND

  // Internal signals
  logic [31:0] add_result, sub_result;
  logic        slt_result, sltu_result;
  logic        slt_sign_diff;
  logic [31:0] and_result, or_result, xor_result;
  logic [31:0] sll_result, srl_result, sra_result;
  logic [31:0] slt_sum;
  logic        slt_cout, sltu_cout;
  logic [31:0] alu_result;  // ALU result before JALR LSB clearing

  // Addition: A + B
  FA_32bit add_fa(.A(i_op_a), .B(i_op_b), .Cin(1'b0), .Sum(add_result), .Cout());

  // Subtraction: A - B (using two's complement: A + ~B + 1)
  FA_32bit sub_fa(.A(i_op_a), .B(~i_op_b), .Cin(1'b1), .Sum(sub_result), .Cout());

  // Set Less Than (signed): result = (A < B) ? 1 : 0
  FA_32bit slt_fa(.A(i_op_a), .B(~i_op_b), .Cin(1'b1), .Sum(slt_sum), .Cout(slt_cout));
  assign slt_sign_diff = i_op_a[31] ^ i_op_b[31];  // Check if signs differ
  assign slt_result = (slt_sign_diff) ? i_op_a[31] : slt_sum[31];

  // Set Less Than Unsigned: result = (A < B) ? 1 : 0
  FA_32bit sltu_fa(.A(i_op_a), .B(~i_op_b), .Cin(1'b1), .Sum(), .Cout(sltu_cout));
  assign sltu_result = ~sltu_cout;   // No borrow means A >= B, so A < B when cout = 0

  // Logical operations
  assign and_result = i_op_a & i_op_b;
  assign or_result  = i_op_a | i_op_b;
  assign xor_result = i_op_a ^ i_op_b;

  // Shift operations (shift amount limited to 5 bits [4:0])
  SLL sll_inst(.tmp(i_op_b[4:0]), .A(i_op_a), .Sll_out(sll_result));
  SRL srl_inst(.tmp(i_op_b[4:0]), .A(i_op_a), .Srl_out(srl_result));
  SRA sra_inst(.tmp(i_op_b[4:0]), .A(i_op_a), .Sra_out(sra_result));

  // Output multiplexer
  always_comb begin
    case(i_alu_op)
      ADD:  alu_result = add_result;
      SUB:  alu_result = sub_result;
      SLT:  alu_result = {31'b0, slt_result};   // Zero-extend 1-bit result
      SLTU: alu_result = {31'b0, sltu_result};  // Zero-extend 1-bit result
      XOR:  alu_result = xor_result;
      OR:   alu_result = or_result;
      AND:  alu_result = and_result;
      SLL:  alu_result = sll_result;
      SRL:  alu_result = srl_result;
      SRA:  alu_result = sra_result;
      default: alu_result = 32'b0;
    endcase
  end

  // JALR LSB clearing: Clear bit 0 when i_jalr_mode is asserted
  // Per RISC-V spec, JALR target address must have LSB set to 0
  assign o_alu_data = i_jalr_mode ? {alu_result[31:1], 1'b0} : alu_result;

endmodule

// ============================================================================
// Barrel Shifter Modules
// Description: Implement shift operations using cascaded muxes
//              Each stage shifts by powers of 2 (1, 2, 4, 8, 16 bits)
// ============================================================================

// Shift Left Logical: fills with zeros on the right
module SLL(
  input  [4:0]  tmp,                 // Shift amount
  input  [31:0] A,                   // Input value
  output [31:0] Sll_out              // Shifted output
);

  logic [31:0] temp_0, temp_1, temp_2, temp_3, temp_4;

  assign temp_0 = (tmp[0]) ? {A[30:0], 1'b0} : A;
  assign temp_1 = (tmp[1]) ? {temp_0[29:0], 2'b0} : temp_0;
  assign temp_2 = (tmp[2]) ? {temp_1[27:0], 4'b0} : temp_1;
  assign temp_3 = (tmp[3]) ? {temp_2[23:0], 8'b0} : temp_2;
  assign temp_4 = (tmp[4]) ? {temp_3[15:0], 16'b0} : temp_3;
  assign Sll_out = temp_4;

endmodule

// Shift Right Logical: fills with zeros on the left
module SRL(
  input  [4:0]  tmp,                 // Shift amount
  input  [31:0] A,                   // Input value
  output [31:0] Srl_out              // Shifted output
);

  logic [31:0] temp_0, temp_1, temp_2, temp_3, temp_4;

  assign temp_0 = (tmp[0]) ? {1'b0, A[31:1]} : A;
  assign temp_1 = (tmp[1]) ? {2'b0, temp_0[31:2]} : temp_0;
  assign temp_2 = (tmp[2]) ? {4'b0, temp_1[31:4]} : temp_1;
  assign temp_3 = (tmp[3]) ? {8'b0, temp_2[31:8]} : temp_2;
  assign temp_4 = (tmp[4]) ? {16'b0, temp_3[31:16]} : temp_3;
  assign Srl_out = temp_4;

endmodule

// Shift Right Arithmetic: sign-extends on the left
module SRA(
  input  logic [4:0]  tmp,
  input  logic [31:0] A,
  output logic [31:0] Sra_out
);

  logic sign_bit;
  logic [31:0] temp_0, temp_1, temp_2, temp_3, temp_4;

  assign sign_bit = A[31];
  assign temp_0 = (tmp[0]) ? {sign_bit, A[31:1]} : A;
  assign temp_1 = (tmp[1]) ? {{2{sign_bit}}, temp_0[31:2]} : temp_0;
  assign temp_2 = (tmp[2]) ? {{4{sign_bit}}, temp_1[31:4]} : temp_1;
  assign temp_3 = (tmp[3]) ? {{8{sign_bit}}, temp_2[31:8]} : temp_2;
  assign temp_4 = (tmp[4]) ? {{16{sign_bit}}, temp_3[31:16]} : temp_3;
  assign Sra_out = temp_4;
endmodule