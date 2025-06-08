// promaa 08/06/2025 - Test adder 7 + 8

`timescale 1ns/1ps
module add7_plus_8;
  reg  [7:0] A, B;
  reg  [2:0] Op;
  reg        Cin;
  wire [7:0] Y;
  wire       Cout;

  alu8 dut (
    .A(A),
    .B(B),
    .Op(Op),
    .Cin(Cin),
    .Y(Y),
    .Cout(Cout)
  );

  initial begin
    $dumpfile("add7_plus_8.vcd");
    $dumpvars(0, add7_plus_8);

    A = 7;
    B = 8;
    Op = 3'b000;  // Addition
    Cin = 0;

    #10;  // Laisser la propagation

    if (Y == 15 && Cout == 0) begin
      $display("PASS : Y=%0d, Cout=%0d", Y, Cout);
    end else begin
      $display("FAIL : Y=%0d, Cout=%0d", Y, Cout);
    end

    $finish;
  end
endmodule
