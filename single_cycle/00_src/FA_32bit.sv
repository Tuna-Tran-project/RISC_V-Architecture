// ============================================================================
// Module: FA_1bit
// Description: 1-bit Full Adder
//              Basic building block for multi-bit addition
// ============================================================================
module FA_1bit(
  input  A,                          // Input A
  input  B,                          // Input B
  input  Cin,                        // Carry in
  output Sum,                        // Sum output
  output Cout                        // Carry out
);

  assign Sum  = A ^ B ^ Cin;
  assign Cout = (A & B) | (Cin & (A ^ B));

endmodule

// ============================================================================
// Module: FA_4bit
// Description: 4-bit Full Adder
//              Ripple-carry adder built from four 1-bit full adders
// ============================================================================
module FA_4bit(
  input  [3:0] A,                    // 4-bit input A
  input  [3:0] B,                    // 4-bit input B
  input        Cin,                  // Carry in
  output [3:0] Sum,                  // 4-bit sum output
  output       Cout                  // Carry out
);

  logic [2:0] carry;                 // Internal carry chain

  FA_1bit fa0 (.A(A[0]), .B(B[0]), .Cin(Cin),      .Sum(Sum[0]), .Cout(carry[0]));
  FA_1bit fa1 (.A(A[1]), .B(B[1]), .Cin(carry[0]), .Sum(Sum[1]), .Cout(carry[1]));
  FA_1bit fa2 (.A(A[2]), .B(B[2]), .Cin(carry[1]), .Sum(Sum[2]), .Cout(carry[2]));
  FA_1bit fa3 (.A(A[3]), .B(B[3]), .Cin(carry[2]), .Sum(Sum[3]), .Cout(Cout));

endmodule

// ============================================================================
// Module: FA_32bit
// Description: 32-bit Full Adder
//              Ripple-carry adder built from eight 4-bit full adders
//              Used for ALU arithmetic operations
// ============================================================================
module FA_32bit(
  input  [31:0] A,                   // 32-bit input A
  input  [31:0] B,                   // 32-bit input B
  input         Cin,                 // Carry in
  output [31:0] Sum,                 // 32-bit sum output
  output        Cout                 // Carry out
);

  logic [6:0] carry;                 // Internal carry chain

  FA_4bit fa0 (.A(A[3:0]),   .B(B[3:0]),   .Cin(Cin),      .Sum(Sum[3:0]),   .Cout(carry[0]));
  FA_4bit fa1 (.A(A[7:4]),   .B(B[7:4]),   .Cin(carry[0]), .Sum(Sum[7:4]),   .Cout(carry[1]));
  FA_4bit fa2 (.A(A[11:8]),  .B(B[11:8]),  .Cin(carry[1]), .Sum(Sum[11:8]),  .Cout(carry[2]));
  FA_4bit fa3 (.A(A[15:12]), .B(B[15:12]), .Cin(carry[2]), .Sum(Sum[15:12]), .Cout(carry[3]));
  FA_4bit fa4 (.A(A[19:16]), .B(B[19:16]), .Cin(carry[3]), .Sum(Sum[19:16]), .Cout(carry[4]));
  FA_4bit fa5 (.A(A[23:20]), .B(B[23:20]), .Cin(carry[4]), .Sum(Sum[23:20]), .Cout(carry[5]));
  FA_4bit fa6 (.A(A[27:24]), .B(B[27:24]), .Cin(carry[5]), .Sum(Sum[27:24]), .Cout(carry[6]));
  FA_4bit fa7 (.A(A[31:28]), .B(B[31:28]), .Cin(carry[6]), .Sum(Sum[31:28]), .Cout(Cout));

endmodule