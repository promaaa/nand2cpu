# promaa 08/06/2025 - TCL script for FPGA build with Vivado
# Usage: vivado -mode batch -source tools/scripts/build_fpga.tcl

set project_name "nand2cpu"
set part_name "xc7z020clg400-1" ;# PYNQ-Z1

# Create project
create_project $project_name ./build/synth/$project_name -part $part_name -force

# Add RTL sources, the program for the ROM (make fpga writes it) and constraints
add_files -norecurse [glob ./src/rtl/*.v ./src/fpga/*.v]
add_files -norecurse ./build/program.mem
add_files -fileset constrs_1 -norecurse ./src/fpga/top.xdc
set_property top top [current_fileset]

# Synthesis, implementation and bitstream
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

puts "Bitstream: build/synth/$project_name/$project_name.runs/impl_1/top.bit"
