// promaa 08/06/2025 - 16-bit ALU testbench against a behavioural model

`timescale 1ns/1ps

module tb_alu16;
  reg  [15:0] A, B;
  reg  [2:0]  Op;
  reg         Cin;
  wire [15:0] Y;
  wire        Cout;
  reg  [16:0] expected;  // {Cout, Y}
  integer     i, j, k, cases = 0, errors = 0;

  // Values where carries, borrows and shifts cross the byte boundary
  localparam [16*9-1:0] EDGES = {16'h0000, 16'h0001, 16'h007F, 16'h0080, 16'h00FF,
                                 16'h0100, 16'h7FFF, 16'h8000, 16'hFFFF};

  alu16 dut (.A(A), .B(B), .Op(Op), .Cin(Cin), .Y(Y), .Cout(Cout));

  task check;
    begin
      #1;
      case (Op)
        3'b000: expected = A + B + Cin;
        3'b001: expected = A - B - Cin;          // bit 16 is the borrow
        3'b010: expected = {1'b0, A & B};
        3'b011: expected = {1'b0, A | B};
        3'b100: expected = {1'b0, A ^ B};
        3'b101: expected = {A, Cin};
        3'b110: expected = {A[0], Cin, A[15:1]};
        3'b111: expected = {1'b0, ~A};
      endcase
      cases = cases + 1;
      if ({Cout, Y} !== expected) begin
        errors = errors + 1;
        if (errors <= 10)
          $display("FAIL : Op=%b A=%h B=%h Cin=%b -> Y=%h Cout=%b, expected Y=%h Cout=%b",
                   Op, A, B, Cin, Y, Cout, expected[15:0], expected[16]);
      end
    end
  endtask

  initial begin
    for (i = 0; i < 16; i = i + 1)
      for (j = 0; j < 9; j = j + 1)
        for (k = 0; k < 9; k = k + 1) begin
          {Op, Cin} = i;
          A = EDGES[16*j +: 16];
          B = EDGES[16*k +: 16];
          check;
        end

    repeat (100000) begin
      {Op, Cin, A, B} = {$random, $random};
      check;
    end

    if (errors) $fatal(1, "%0d of %0d cases failed", errors, cases);
    $display("PASS : %0d boundary and random cases", cases);
    $finish;
  end
endmodule
