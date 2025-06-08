// promaa 08/06/2025 - Fast top module testbench

`timescale 1ns/1ps

module tb_top_fast;
  reg  [7:0] a, b;
  reg  [1:0] op;
  wire [7:0] y;
  wire       carry;

  // Instantiate your ALU8
  alu8 dut (
    .a    (a),
    .b    (b),
    .op   (op),
    .y    (y),
    .carry(carry)
  );

  initial begin
    $display("\nTime   a    b   op |  y    carry");
    $display("--------------------------------");
    // Test #1:  3 + 5 = 8
    a  = 8'd3;  b = 8'd5;  op = 2'b00;   #10;
    $display("%4dns  %2d   %2d  %b |  %2d   %b", $time, a, b, op, y, carry);

    // Test #2:  7 + 8 = 15
    a  = 8'd7;  b = 8'd8;  op = 2'b00;   #10;
    $display("%4dns  %2d   %2d  %b |  %2d   %b", $time, a, b, op, y, carry);

    // Test #3: 15 + 1 = 16 (carry)
    a  = 8'd15; b = 8'd1;  op = 2'b00;   #10;
    $display("%4dns  %2d   %2d  %b |  %2d   %b", $time, a, b, op, y, carry);

    // Test #4: AND (3 & 5 = 1)
    a  = 8'd3;  b = 8'd5;  op = 2'b01;   #10;
    $display("%4dns  %2d   %2d  %b |  %2d   %b", $time, a, b, op, y, carry);

    // Test #5: OR (7 | 8 = 15)
    a  = 8'd7;  b = 8'd8;  op = 2'b10;   #10;
    $display("%4dns  %2d   %2d  %b |  %2d   %b", $time, a, b, op, y, carry);

    // Test #6: XOR (15 ^ 1 = 14)
    a  = 8'd15; b = 8'd1;  op = 2'b11;   #10;
    $display("%4dns  %2d   %2d  %b |  %2d   %b", $time, a, b, op, y, carry);

    $finish;
  end
endmodule
