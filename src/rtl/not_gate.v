// promaa 06/10/2026 - NOT gate using one NAND gate with tied inputs

module not_gate #(parameter WIDTH = 1) (
    input  wire [WIDTH-1:0] a,
    output wire [WIDTH-1:0] y
);

  nand_gate #(WIDTH) u1 (.a(a), .b(a), .y(y));
endmodule
