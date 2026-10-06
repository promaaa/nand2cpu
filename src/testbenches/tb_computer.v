// promaa 06/10/2026 - Computer testbench: runs one program and prints every OUT value
// Usage: vvp tb_computer +program=build/fibonacci.bin.hex

`timescale 1ns/1ps

module tb_computer;
  reg              clk = 0, reset = 1, en = 1;
  wire [15:0]      out;
  wire             halted;
  reg  [8*256-1:0] file;
  integer          instructions = 0;

  computer dut (.clk(clk), .reset(reset), .en(en), .out(out), .halted(halted));

  always #5 clk = ~clk;

  // Hold en low on random cycles: the CPU must then wait, so the output stays the same
  always @(negedge clk) en <= $random;

  // Print the value of each OUT instruction and count the instructions that run
  always @(posedge clk)
    if (!reset && en && !halted) begin
      instructions = instructions + 1;
      if (dut.core.out_load) $write(" %0d", dut.core.b);
    end

  initial begin
    if (!$value$plusargs("program=%s", file))
      $fatal(1, "Usage: vvp tb_computer +program=<file.hex>");
    $readmemh(file, dut.rom);
    $write("out:");
    @(negedge clk) reset = 0;
    repeat (200000) if (!halted) @(negedge clk);
    $display("");
    if (!halted) $fatal(1, "no HALT after 200000 clock cycles");
    $display("HALT after %0d instructions", instructions);
    $finish(0);
  end
endmodule
