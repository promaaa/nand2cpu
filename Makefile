# nand2cpu - build and test commands

RTL      := $(wildcard src/rtl/*.v)
SIM      := build/sim
TESTS    := tb_nand_gate tb_and_gate tb_or_gate tb_alu8 tb_alu16 add7_plus_8
PROGRAMS := $(basename $(notdir $(wildcard programs/*.asm)))
PROGRAM  ?= fibonacci

.PHONY: help test fpga clean
.SECONDARY:

help:
	@echo "make test           run every testbench and every program in programs/"
	@echo "make run-<program>  run programs/<program>.asm on the CPU, e.g. make run-fibonacci"
	@echo "make sim-<name>     run one testbench from src/testbenches, e.g. make sim-tb_alu8"
	@echo "make fpga           build the PYNQ-Z1 bitstream with PROGRAM=$(PROGRAM) (needs Vivado)"
	@echo "make clean          delete build/"

test: $(addprefix sim-,$(TESTS)) $(addprefix check-,$(PROGRAMS))
	@iverilog -o $(SIM)/top $(RTL) src/fpga/top.v
	@echo "All tests passed."

sim-%:
	@mkdir -p $(SIM)
	@iverilog -s $* -o $(SIM)/$* $(RTL) src/testbenches/$*.v
	@cd $(SIM) && vvp -n $*

build/%.bin.hex: programs/%.asm tools/assembler/*.py
	@mkdir -p build
	@python3 tools/assembler/main.py $< build/$*.bin > /dev/null

$(SIM)/tb_computer: $(RTL) src/testbenches/tb_computer.v
	@mkdir -p $(SIM)
	@iverilog -s tb_computer -o $@ $^

run-%: build/%.bin.hex $(SIM)/tb_computer
	@vvp -n $(SIM)/tb_computer +program=$< | grep -v "Not enough words"

# Compare the output of a program with its "; out:" comment
check-%: build/%.bin.hex $(SIM)/tb_computer
	@vvp -n $(SIM)/tb_computer +program=$< > build/$*.log
	@grep '^; out:' programs/$*.asm | cut -c3- > build/$*.expected
	@grep '^out:' build/$*.log | diff build/$*.expected -
	@echo "PASS : $*"

fpga: build/$(PROGRAM).bin.hex
	cp $< build/program.mem
	vivado -mode batch -source tools/scripts/build_fpga.tcl

clean:
	rm -rf build
