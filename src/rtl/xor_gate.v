// promaa 06/10/2026 - XOR gate using four NAND gates

module xor_gate #(parameter WIDTH = 1) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] y
);

  wire [WIDTH-1:0] n, na, nb;
  nand_gate #(WIDTH) u1 (.a(a),  .b(b),  .y(n));
  nand_gate #(WIDTH) u2 (.a(a),  .b(n),  .y(na));
  nand_gate #(WIDTH) u3 (.a(b),  .b(n),  .y(nb));
  nand_gate #(WIDTH) u4 (.a(na), .b(nb), .y(y));
endmodule
