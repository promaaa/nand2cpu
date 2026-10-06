// promaa 06/10/2026 - Full adder: two half adders and an OR gate

module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire s,
    output wire cout
);

  wire s1, c1, c2;
  half_adder ha1 (.a(a),  .b(b),   .s(s1), .c(c1));
  half_adder ha2 (.a(s1), .b(cin), .s(s),  .c(c2));
  or_gate    u1  (.a(c1), .b(c2),  .y(cout));
endmodule
