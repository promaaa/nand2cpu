// promaa 13/05/2025 - Simple dual-input NAND Gate

module nand_gate #(parameter WIDTH=1) (
  input wire [WIDTH-1:0] a,
  input wire [WIDTH-1:0] b,
  output wire [WIDTH-1:0] y
);

assign y=~(a&b);
endmodule

