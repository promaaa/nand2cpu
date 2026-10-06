// promaa 15/05/2025 - 8-bit ALU (arithmetic and logic operations), NAND gates only
//
// Op   Y            Cout
// 000  A + B + Cin  carry
// 001  A - B - Cin  borrow
// 010  A & B        0
// 011  A | B        0
// 100  A ^ B        0
// 101  A << 1       A[7]   (Cin enters bit 0)
// 110  A >> 1       A[0]   (Cin enters bit 7)
// 111  ~A           0

module alu8 (
  input  wire [7:0] A,     // First operand
  input  wire [7:0] B,     // Second operand
  input  wire [2:0] Op,    // Operation code
  input  wire       Cin,   // Carry in
  output wire [7:0] Y,     // Result
  output wire       Cout   // Carry out
);

  // Adder. Op[0] is 0 for ADD and 1 for SUB, so it drives the subtraction directly:
  // A - B - Cin = A + ~B + ~Cin - 256, so invert B and Cin, add, then invert the carry.
  wire [7:0] Bx, sum;
  wire [8:0] c;
  wire       carry;
  xor_gate #(8) inv_b    (.a(B),    .b({8{Op[0]}}), .y(Bx));
  xor_gate      inv_cin  (.a(Cin),  .b(Op[0]),      .y(c[0]));

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : ripple
      full_adder fa (.a(A[i]), .b(Bx[i]), .cin(c[i]), .s(sum[i]), .cout(c[i+1]));
    end
  endgenerate

  xor_gate      inv_cout (.a(c[8]), .b(Op[0]),      .y(carry));

  // Logic operations. The shifts are only wiring.
  wire [7:0] r_and, r_or, r_xor, r_not;
  and_gate #(8) g_and (.a(A), .b(B), .y(r_and));
  or_gate  #(8) g_or  (.a(A), .b(B), .y(r_or));
  xor_gate #(8) g_xor (.a(A), .b(B), .y(r_xor));
  not_gate #(8) g_not (.a(A),        .y(r_not));

  // Operation selector: a tree of 2:1 multiplexers picks {Cout, Y} with Op[0], then Op[1], then Op[2]
  wire [8:0] m01, m23, m45, m67, m03, m47;
  assign m01 = {carry, sum};                                                     // 000 ADD, 001 SUB
  mux2 #(9) s23 (.a({1'b0, r_and}),       .b({1'b0, r_or}),  .s(Op[0]), .y(m23)); // 010 AND, 011 OR
  mux2 #(9) s45 (.a({1'b0, r_xor}),       .b({A, Cin}),      .s(Op[0]), .y(m45)); // 100 XOR, 101 SHL
  mux2 #(9) s67 (.a({A[0], Cin, A[7:1]}), .b({1'b0, r_not}), .s(Op[0]), .y(m67)); // 110 SHR, 111 NOT
  mux2 #(9) s03 (.a(m01), .b(m23), .s(Op[1]), .y(m03));
  mux2 #(9) s47 (.a(m45), .b(m67), .s(Op[1]), .y(m47));
  mux2 #(9) sel (.a(m03), .b(m47), .s(Op[2]), .y({Cout, Y}));

endmodule
