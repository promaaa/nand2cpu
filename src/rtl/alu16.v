// promaa 16/05/2025 - 16-bit ALU by chaining two 8-bit ALUs

module alu16 (
  input  wire [15:0] A,     // First operand
  input  wire [15:0] B,     // Second operand
  input  wire [2:0]  Op,    // Operation code
  input  wire        Cin,   // Carry in
  output wire [15:0] Y,     // Result
  output wire        Cout   // Carry out
);

  // Split operands into high and low parts
  wire [7:0] A_low  = A[7:0];
  wire [7:0] A_high = A[15:8];
  wire [7:0] B_low  = B[7:0];
  wire [7:0] B_high = B[15:8];
  
  wire [7:0] Y_low, Y_high;
  wire       C_middle;      // Carry between the two ALUs
  
  // Special handling for shifts (connection between ALUs)
  wire shift_bit_right = (Op == 3'b110) ? A_high[0] : 1'b0;  // For right shift, LSB of A_high
  wire shift_bit_left  = (Op == 3'b101) ? A_low[7]  : 1'b0;  // For left shift, MSB of A_low
  
  // ALU partie basse (bits 0-7)
  alu8 alu_low (
    .A(A_low),
    .B(B_low),
    .Op(Op),
    .Cin(Cin),
    .Y(Y_low),
    .Cout(C_middle)
  );
  
  // ALU high part (bits 8-15)
  // For addition/subtraction operations, carry from low ALU is used
  // For left shift, MSB of low ALU becomes LSB of high ALU
  alu8 alu_high (
    .A(A_high),
    .B(B_high),
    .Op(Op),
    .Cin((Op == 3'b000 || Op == 3'b001) ? C_middle : 
         (Op == 3'b101) ? shift_bit_left : 
         (Op == 3'b110) ? 1'b0 : 1'b0),
    .Y(Y_high),
    .Cout(Cout)
  );
  
  // Result concatenation
  assign Y = {Y_high, Y_low};
  
endmodule