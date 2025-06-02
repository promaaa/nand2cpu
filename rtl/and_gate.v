// promaa 13/05/2025 - Porte AND via deux portes NAND

module and_gate #(parameter WIDTH = 1) (
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] y
);

  wire [WIDTH-1:0] n;

  // 1) NAND(a, b) → n
  nand_gate #(WIDTH) u1 (
    .a(a),
    .b(b),
    .y(n)
  );

  // 2) NAND(n, n) → y
  nand_gate #(WIDTH) u2 (
    .a(n),
    .b(n),
    .y(y)
  );

endmodule
