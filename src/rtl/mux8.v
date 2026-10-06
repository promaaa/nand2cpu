// promaa 06/10/2026 - 8:1 multiplexer: a tree of seven 2:1 multiplexers, y = input number sel

module mux8 #(parameter WIDTH = 1) (
    input  wire [8*WIDTH-1:0] in,    // input i is in[WIDTH*i +: WIDTH]
    input  wire [2:0]         sel,
    output wire [WIDTH-1:0]   y
);

  wire [WIDTH-1:0] m0, m1, m2, m3, m4, m5;
  mux2 #(WIDTH) s0 (.a(in[0*WIDTH +: WIDTH]), .b(in[1*WIDTH +: WIDTH]), .s(sel[0]), .y(m0));
  mux2 #(WIDTH) s1 (.a(in[2*WIDTH +: WIDTH]), .b(in[3*WIDTH +: WIDTH]), .s(sel[0]), .y(m1));
  mux2 #(WIDTH) s2 (.a(in[4*WIDTH +: WIDTH]), .b(in[5*WIDTH +: WIDTH]), .s(sel[0]), .y(m2));
  mux2 #(WIDTH) s3 (.a(in[6*WIDTH +: WIDTH]), .b(in[7*WIDTH +: WIDTH]), .s(sel[0]), .y(m3));
  mux2 #(WIDTH) s4 (.a(m0), .b(m1), .s(sel[1]), .y(m4));
  mux2 #(WIDTH) s5 (.a(m2), .b(m3), .s(sel[1]), .y(m5));
  mux2 #(WIDTH) s6 (.a(m4), .b(m5), .s(sel[2]), .y(y));
endmodule
