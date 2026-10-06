// promaa 06/10/2026 - 2:1 multiplexer using NAND gates: y = s ? b : a

module mux2 #(parameter WIDTH = 1) (
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             s,
    output wire [WIDTH-1:0] y
);

  wire             ns;
  wire [WIDTH-1:0] pa, pb;
  not_gate           u0 (.a(s), .y(ns));
  nand_gate #(WIDTH) u1 (.a(a),  .b({WIDTH{ns}}), .y(pa));
  nand_gate #(WIDTH) u2 (.a(b),  .b({WIDTH{s}}),  .y(pb));
  nand_gate #(WIDTH) u3 (.a(pa), .b(pb),          .y(y));
endmodule
