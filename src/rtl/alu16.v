// promaa 16/05/2025 - 16-bit ALU by chaining two 8-bit ALUs

module alu16 (
  input  wire [15:0] A,     // First operand
  input  wire [15:0] B,     // Second operand
  input  wire [2:0]  Op,    // Operation code (same as alu8)
  input  wire        Cin,   // Carry in
  output wire [15:0] Y,     // Result
  output wire        Cout   // Carry out
);

  // ADD, SUB and SHL pass the carry from the low byte to the high byte.
  // SHR (110) passes it the other way: bit 8 drops into bit 7.
  // NOT (111) shares the SHR path because it ignores the carries.
  wire right, c_lo_in, c_lo, c_hi_in, c_hi;
  and_gate dir (.a(Op[2]), .b(Op[1]), .y(right));

  // ALU low part (bits 0-7)
  mux2 lo_in (.a(Cin), .b(A[8]), .s(right), .y(c_lo_in));
  alu8 alu_low (
    .A(A[7:0]),
    .B(B[7:0]),
    .Op(Op),
    .Cin(c_lo_in),
    .Y(Y[7:0]),
    .Cout(c_lo)
  );

  // ALU high part (bits 8-15)
  mux2 hi_in (.a(c_lo), .b(Cin), .s(right), .y(c_hi_in));
  alu8 alu_high (
    .A(A[15:8]),
    .B(B[15:8]),
    .Op(Op),
    .Cin(c_hi_in),
    .Y(Y[15:8]),
    .Cout(c_hi)
  );

  mux2 out (.a(c_hi), .b(c_lo), .s(right), .y(Cout));

endmodule
