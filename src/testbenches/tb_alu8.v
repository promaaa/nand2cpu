// promaa 06/10/2026 - 8-bit ALU testbench: every input combination against a behavioural model

`timescale 1ns/1ps

module tb_alu8;
  reg  [7:0] A, B;
  reg  [2:0] Op;
  reg        Cin;
  wire [7:0] Y;
  wire       Cout;
  reg  [8:0] expected;   // {Cout, Y}
  integer    i, errors = 0;

  alu8 dut (.A(A), .B(B), .Op(Op), .Cin(Cin), .Y(Y), .Cout(Cout));

  initial begin
    for (i = 0; i < (1 << 20); i = i + 1) begin
      {Op, Cin, A, B} = i;
      #1;
      case (Op)
        3'b000: expected = A + B + Cin;
        3'b001: expected = A - B - Cin;          // bit 8 is the borrow
        3'b010: expected = {1'b0, A & B};
        3'b011: expected = {1'b0, A | B};
        3'b100: expected = {1'b0, A ^ B};
        3'b101: expected = {A, Cin};
        3'b110: expected = {A[0], Cin, A[7:1]};
        3'b111: expected = {1'b0, ~A};
      endcase
      if ({Cout, Y} !== expected) begin
        errors = errors + 1;
        if (errors <= 10)
          $display("FAIL : Op=%b A=%0d B=%0d Cin=%b -> Y=%0d Cout=%b, expected Y=%0d Cout=%b",
                   Op, A, B, Cin, Y, Cout, expected[7:0], expected[8]);
      end
    end
    if (errors) $fatal(1, "%0d of %0d cases failed", errors, i);
    $display("PASS : all %0d combinations of A, B, Op and Cin", i);
    $finish;
  end
endmodule
