// promaa 13/05/2025 - OR gate using three NAND gates

module or_gate #(parameter WIDTH=1) (
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    output wire [WIDTH-1:0] y
);

  wire [WIDTH-1:0] na, nb; 
  nand_gate #(WIDTH) u1 (.a(a), .b(a), .y(na));
  nand_gate #(WIDTH) u2 (.a(b), .b(b), .y(nb));
  nand_gate #(WIDTH) u3 (.a(na),.b(nb),.y(y));
endmodule
