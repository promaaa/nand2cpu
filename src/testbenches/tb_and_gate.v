// promaa 02/06/2025 - AND gate testbench

`timescale 1ns/1ps

module tb_and_gate;

  parameter WIDTH = 4;

  reg  [WIDTH-1:0] a;
  reg  [WIDTH-1:0] b;
  wire [WIDTH-1:0] y;

  // Instantiate AND gate module
  and_gate #(WIDTH) uut (
    .a(a),
    .b(b),
    .y(y)
  );

  initial begin
    $dumpfile("and_gate_waveform.vcd");
    $dumpvars(0, tb_and_gate);

    // Test cases
    a = 4'b1111; b = 4'b1111; #10;
    if (y !== (a & b)) $fatal(1, "Test failed at t=%0t: y=%b, expected=%b", $time, y, (a & b));

    a = 4'b1010; b = 4'b1100; #10;
    if (y !== (a & b)) $fatal(1, "Test failed at t=%0t: y=%b, expected=%b", $time, y, (a & b));

    a = 4'b0000; b = 4'b1111; #10;
    if (y !== (a & b)) $fatal(1, "Test failed at t=%0t: y=%b, expected=%b", $time, y, (a & b));

    a = 4'b1111; b = 4'b0000; #10;
    if (y !== (a & b)) $fatal(1, "Test failed at t=%0t: y=%b, expected=%b", $time, y, (a & b));

    a = 4'b0101; b = 4'b1010; #10;
    if (y !== (a & b)) $fatal(1, "Test failed at t=%0t: y=%b, expected=%b", $time, y, (a & b));

    $display("All tests passed.");
    $finish;
  end

endmodule
