// promaa 02/06/2025 - Testbench porte NAND

`timescale 1ns/1ps

module tb_nand_gate;
  // Signaux de test
  reg [0:0] test_a;
  reg [0:0] test_b;
  wire [0:0] test_y;
  
  // Instanciation du module à tester
  nand_gate #(.WIDTH(1)) dut (
    .a(test_a),
    .b(test_b),
    .y(test_y)
  );
  
  // Procédure de test
  initial begin
    $dumpfile("nand_gate.vcd");
    $dumpvars(0, tb_nand_gate);
    
    // Test des 4 combinaisons possibles
    test_a = 0; test_b = 0; #10;
    $display("a=%b, b=%b, y=%b", test_a, test_b, test_y);
    
    test_a = 0; test_b = 1; #10;
    $display("a=%b, b=%b, y=%b", test_a, test_b, test_y);
    
    test_a = 1; test_b = 0; #10;
    $display("a=%b, b=%b, y=%b", test_a, test_b, test_y);
    
    test_a = 1; test_b = 1; #10;
    $display("a=%b, b=%b, y=%b", test_a, test_b, test_y);
    
    $finish;
  end
endmodule