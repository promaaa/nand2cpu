// promaa 06/10/2026 - Register: D flip-flops that take d when load = 1 and keep their value otherwise

module register #(parameter WIDTH = 16) (
    input  wire             clk,
    input  wire             load,
    input  wire [WIDTH-1:0] d,
    output wire [WIDTH-1:0] q
);

  wire [WIDTH-1:0] next;
  mux2 #(WIDTH) keep (.a(q), .b(d), .s(load), .y(next));
  dff  #(WIDTH) ff   (.clk(clk), .d(next), .q(q));
endmodule
