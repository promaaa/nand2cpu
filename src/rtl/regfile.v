// promaa 06/10/2026 - Register file: eight 16-bit registers, two read ports and one write port

module regfile (
  input  wire        clk,
  input  wire        we,      // Write wd into register wa at the clock edge
  input  wire [2:0]  wa,
  input  wire [15:0] wd,
  input  wire [2:0]  ra,      // Read port A
  input  wire [2:0]  rb,      // Read port B
  output wire [15:0] a,
  output wire [15:0] b
);

  wire [2:0]   nwa;
  wire [127:0] q;             // Register i is q[16*i +: 16]
  not_gate #(3) inv (.a(wa), .y(nwa));

  // Write decoder: register i loads when we = 1 and wa = i
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : r
      wire [2:0] hit = {(i & 4) ? wa[2] : nwa[2], (i & 2) ? wa[1] : nwa[1], (i & 1) ? wa[0] : nwa[0]};
      wire       h01, h012, load;
      and_gate a1 (.a(hit[0]), .b(hit[1]), .y(h01));
      and_gate a2 (.a(h01),    .b(hit[2]), .y(h012));
      and_gate a3 (.a(h012),   .b(we),     .y(load));
      register #(16) rg (.clk(clk), .load(load), .d(wd), .q(q[16*i +: 16]));
    end
  endgenerate

  mux8 #(16) read_a (.in(q), .sel(ra), .y(a));
  mux8 #(16) read_b (.in(q), .sel(rb), .y(b));
endmodule
