// promaa 02/06/2025 - Testbench porte OR

`timescale 1ns/1ps
module tb_or_gate;

  // Parameters
  parameter WIDTH = 1;

  // Inputs
  reg [WIDTH-1:0] a;
  reg [WIDTH-1:0] b;

  // Outputs
  wire [WIDTH-1:0] y;

  // Instantiate the Unit Under Test (UUT)
  or_gate #(WIDTH) uut (
    .a(a),
    .b(b),
    .y(y)
  );

  initial begin
    // Initialize Inputs
    a = 0;
    b = 0;

    // Wait 100 ns for global reset to finish
    #100;
        
    // Add stimulus here

  end
      
endmodule