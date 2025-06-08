// promaa 08/06/2025 - 16-bit ALU testbench

`timescale 1ns/1ps

module tb_alu16;
  reg  [15:0] A, B;
  reg  [2:0]  Op;
  reg         Cin;
  wire [15:0] Y;
  wire        Cout;

  alu16 dut (
    .A(A),
    .B(B),
    .Op(Op),
    .Cin(Cin),
    .Y(Y),
    .Cout(Cout)
  );

  initial begin
    $dumpfile("alu16.vcd");
    $dumpvars(0, tb_alu16);

    // Test 1: Addition simple
    A = 16'h00FF;  // 255
    B = 16'h0001;  // 1
    Op = 3'b000;   // Addition
    Cin = 0;
    #10;
    $display("Test 1: %h + %h = %h (Cout=%b)", A, B, Y, Cout);
    
    // Test 2: Addition avec carry entre les ALUs
    A = 16'h00FF;  // 255
    B = 16'h0002;  // 2
    Op = 3'b000;   // Addition
    Cin = 0;
    #10;
    $display("Test 2: %h + %h = %h (Cout=%b)", A, B, Y, Cout);

    // Test 3: Left shift
    A = 16'h8080;  // 10000000_10000000
    B = 16'h0000;
    Op = 3'b101;   // Left shift
    Cin = 0;
    #10;
    $display("Test 3: %h << 1 = %h (Cout=%b)", A, Y, Cout);

    $finish;
  end
endmodule