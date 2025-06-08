# promaa 08/06/2025 - TCL script for FPGA build with Vivado
# Usage: vivado -mode batch -source build_fpga.tcl

set project_name "nand2cpu"
set part_name "xc7z020clg400-1"  # Pynq-Z1/Z2

# Create project
create_project $project_name ./build/synth/$project_name -part $part_name -force

# Add RTL sources
add_files -norecurse [glob ./src/rtl/*.v]
add_files -norecurse [glob ./src/fpga/*.v]

# Add constraints
add_files -fileset constrs_1 -norecurse [glob ./src/fpga/*.xdc]

# Set top module
set_property top top [current_fileset]

# Synthesis
launch_runs synth_1 -jobs 4
wait_on_run synth_1

# Implementation
launch_runs impl_1 -jobs 4
wait_on_run impl_1

# Bitstream generation
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1

puts "FPGA build completed successfully!"
puts "Bitstream available at: build/synth/$project_name/$project_name.runs/impl_1/top.bit"