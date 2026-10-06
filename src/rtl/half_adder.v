// promaa 06/10/2026 - Half adder: XOR for the sum, AND for the carry

module half_adder (
    input  wire a,
    input  wire b,
    output wire s,
    output wire c
);

  xor_gate u1 (.a(a), .b(b), .y(s));
  and_gate u2 (.a(a), .b(b), .y(c));
endmodule
