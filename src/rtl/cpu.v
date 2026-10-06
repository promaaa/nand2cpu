// promaa 06/10/2026 - 16-bit single-cycle CPU core, NAND gates and D flip-flops only
//
// Instruction formats
//   R  op[15:12] rd[11:9] rs1[8:6] rs2[5:3] 000
//   I  op[15:12] rd[11:9] imm[8:0]                 imm is signed, -256 to 255
//   B  op[15:12] rs[11:9] 0 addr[7:0]
//
// op    instruction        effect
// 0xxx  ALU rd, rs1, rs2   rd = rs1 (ALU op xxx) rs2: ADD SUB AND OR XOR SHL SHR NOT
// 1000  LDI rd, imm        rd = imm
// 1001  LD  rd, [rs1]      rd = RAM[rs1]
// 1010  ST  rs, [rs1]      RAM[rs1] = rs
// 1011  OUT rs             out = rs
// 1100  BZ  rs, addr       if rs == 0, jump to addr
// 1101  BNZ rs, addr       if rs != 0, jump to addr
// 1110  JMP addr           jump to addr
// 1111  HALT               stop

module cpu (
  input  wire        clk,
  input  wire        reset,      // PC = 0 at the next clock edge
  input  wire        en,         // 1 = run one instruction at each clock edge
  output wire [7:0]  pc,         // Instruction address
  input  wire [15:0] instr,      // Instruction from the ROM
  output wire [7:0]  ram_addr,
  output wire [15:0] ram_wdata,
  output wire        ram_we,
  input  wire [15:0] ram_rdata,
  output wire [15:0] out,        // Output register, written by OUT
  output wire        halted      // The current instruction is HALT
);

  // Decoder
  wire [3:0] op = instr[15:12];
  wire [3:0] nop;
  wire       op21, writes_reg, op10, op101, st, out_op, op11, op111, op110, jmp;
  not_gate #(4) inv_op (.a(op), .y(nop));
  or_gate   d0 (.a(op[2]),  .b(op[1]),  .y(op21));
  nand_gate d1 (.a(op[3]),  .b(op21),   .y(writes_reg));  // 0xxx, 1000, 1001
  and_gate  d2 (.a(op[3]),  .b(nop[2]), .y(op10));
  and_gate  d3 (.a(op10),   .b(op[1]),  .y(op101));
  and_gate  d4 (.a(op101),  .b(nop[0]), .y(st));          // 1010
  and_gate  d5 (.a(op101),  .b(op[0]),  .y(out_op));      // 1011
  and_gate  d6 (.a(op[3]),  .b(op[2]),  .y(op11));
  and_gate  d7 (.a(op11),   .b(nop[1]), .y(op110));       // 1100, 1101
  and_gate  d8 (.a(op11),   .b(op[1]),  .y(op111));
  and_gate  d9 (.a(op111),  .b(nop[0]), .y(jmp));         // 1110
  and_gate  d10(.a(op111),  .b(op[0]),  .y(halted));      // 1111

  // Register file. Port B reads rs2 for ALU instructions and the rd field for the others.
  wire [2:0]  rb;
  wire [15:0] a, b, wb;
  wire        reg_we;
  mux2 #(3) sel_rb (.a(instr[5:3]), .b(instr[11:9]), .s(op[3]), .y(rb));
  and_gate  we_reg (.a(writes_reg), .b(en), .y(reg_we));
  regfile   rf (.clk(clk), .we(reg_we), .wa(instr[11:9]), .wd(wb), .ra(instr[8:6]), .rb(rb), .a(a), .b(b));

  // ALU, then the value written back: ALU result, immediate (LDI) or RAM word (LD)
  wire [15:0] alu_y, imm_or_ram;
  wire [15:0] imm = {{7{instr[8]}}, instr[8:0]};
  alu16 alu (.A(a), .B(b), .Op(op[2:0]), .Cin(1'b0), .Y(alu_y), .Cout());
  mux2 #(16) sel_ld (.a(imm),   .b(ram_rdata),  .s(op[0]), .y(imm_or_ram));
  mux2 #(16) sel_wb (.a(alu_y), .b(imm_or_ram), .s(op[3]), .y(wb));

  // RAM and output register
  wire out_load;
  assign ram_addr  = a[7:0];
  assign ram_wdata = b;
  and_gate       we_ram  (.a(st),     .b(en), .y(ram_we));
  and_gate       we_out  (.a(out_op), .b(en), .y(out_load));
  register #(16) out_reg (.clk(clk), .load(out_load), .d(b), .q(out));

  // Zero test on port B: OR all 16 bits together, then invert
  wire [7:0] or8;
  wire [3:0] or4;
  wire [1:0] or2;
  wire       nonzero, zero;
  or_gate #(8) z0 (.a(b[15:8]),  .b(b[7:0]),  .y(or8));
  or_gate #(4) z1 (.a(or8[7:4]), .b(or8[3:0]), .y(or4));
  or_gate #(2) z2 (.a(or4[3:2]), .b(or4[1:0]), .y(or2));
  or_gate      z3 (.a(or2[1]),   .b(or2[0]),   .y(nonzero));
  not_gate     z4 (.a(nonzero), .y(zero));

  // Jump when JMP, BZ with a zero register or BNZ with a non-zero one (op[0] picks BZ or BNZ)
  wire cond, taken, jump;
  xor_gate j0 (.a(zero),  .b(op[0]), .y(cond));
  and_gate j1 (.a(op110), .b(cond),  .y(taken));
  or_gate  j2 (.a(taken), .b(jmp),   .y(jump));

  // Program counter: PC + 1 from a chain of half adders, or the jump address.
  // It loads on reset, or on each enabled clock edge until HALT.
  wire [7:0] inc, next, pc_d;
  wire [8:0] c;
  wire       nreset, nhalted, step, pc_load;
  assign c[0] = 1'b1;
  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : pc_inc
      half_adder ha (.a(pc[i]), .b(c[i]), .s(inc[i]), .c(c[i+1]));
    end
  endgenerate
  mux2 #(8)     sel_pc (.a(inc), .b(instr[7:0]), .s(jump), .y(next));
  not_gate      p0 (.a(reset),  .y(nreset));
  not_gate      p1 (.a(halted), .y(nhalted));
  and_gate #(8) p2 (.a(next),   .b({8{nreset}}), .y(pc_d));
  and_gate      p3 (.a(en),     .b(nhalted),     .y(step));
  or_gate       p4 (.a(reset),  .b(step),        .y(pc_load));
  register #(8) pc_reg (.clk(clk), .load(pc_load), .d(pc_d), .q(pc));

endmodule
