# nand2cpu - build and test commands

RTL   := $(wildcard src/rtl/*.v)
SIM   := build/sim
TESTS := tb_nand_gate tb_and_gate tb_or_gate tb_alu8 tb_alu16 add7_plus_8

.PHONY: help test assembler fpga clean

help:
	@echo "make test         run every testbench, the assembler check and the FPGA top compile"
	@echo "make sim-<name>   run one testbench from src/testbenches, e.g. make sim-add7_plus_8"
	@echo "make assembler    assemble tools/assembler/test.asm"
	@echo "make fpga         build the PYNQ-Z1 bitstream (needs Vivado)"
	@echo "make clean        delete build/"

test: $(addprefix sim-,$(TESTS))
	@cd tools/assembler && python3 main.py test.asm ../../build/test.bin > /dev/null
	@cmp build/test.bin tools/assembler/test.bin
	@iverilog -o $(SIM)/top $(RTL) src/fpga/top.v
	@echo "All tests passed."

sim-%:
	@mkdir -p $(SIM)
	@iverilog -s $* -o $(SIM)/$* $(RTL) src/testbenches/$*.v
	@cd $(SIM) && vvp -n $*

assembler:
	cd tools/assembler && python3 main.py test.asm test.bin

fpga:
	vivado -mode batch -source tools/scripts/build_fpga.tcl

clean:
	rm -rf build
