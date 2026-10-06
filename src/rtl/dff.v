// promaa 06/10/2026 - D flip-flop, the only state element (behavioural, like the Nand2Tetris DFF)

module dff #(parameter WIDTH = 1) (
    input  wire             clk,
    input  wire [WIDTH-1:0] d,
    output reg  [WIDTH-1:0] q
);

  initial q = 0;
  always @(posedge clk) q <= d;
endmodule
