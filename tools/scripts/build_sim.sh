#!/bin/bash
# promaa 08/06/2025 - Build script for Verilog simulations
# Usage: ./build_sim.sh <testbench_name>

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILD_DIR="$PROJECT_ROOT/build/sim"
SRC_DIR="$PROJECT_ROOT/src"
TESTBENCH_DIR="$SRC_DIR/testbenches"

# Create build directory if it doesn't exist
mkdir -p "$BUILD_DIR"

if [ $# -eq 0 ]; then
    echo "Usage: $0 <testbench_name>"
    echo "Available testbenches:"
    find "$TESTBENCH_DIR" -name "tb_*.v" -o -name "*test*.v" | xargs -n1 basename | sed 's/\.v$//'
    exit 1
fi

TESTBENCH="$1"
TESTBENCH_FILE="$TESTBENCH_DIR/${TESTBENCH}.v"

if [ ! -f "$TESTBENCH_FILE" ]; then
    echo "Error: Testbench $TESTBENCH_FILE not found"
    exit 1
fi

# Detect RTL dependencies
RTL_FILES=""
case "$TESTBENCH" in
    "tb_nand_gate")
        RTL_FILES="$SRC_DIR/rtl/nand_gate.v"
        ;;
    "tb_and_gate")
        RTL_FILES="$SRC_DIR/rtl/nand_gate.v $SRC_DIR/rtl/and_gate.v"
        ;;
    "tb_or_gate")
        RTL_FILES="$SRC_DIR/rtl/nand_gate.v $SRC_DIR/rtl/or_gate.v"
        ;;
    "tb_alu16"|"add7_plus_8")
        RTL_FILES="$SRC_DIR/rtl/alu8.v $SRC_DIR/rtl/alu16.v"
        ;;
    "tb_top_fast")
        RTL_FILES="$SRC_DIR/rtl/*.v $SRC_DIR/fpga/top_fast.v"
        ;;
    *)
        RTL_FILES="$SRC_DIR/rtl/*.v"
        ;;
esac

echo "Building simulation for $TESTBENCH..."
echo "RTL files: $RTL_FILES"

# Compilation with iverilog
cd "$BUILD_DIR"
iverilog -o "${TESTBENCH}" $RTL_FILES "$TESTBENCH_FILE"

echo "Build successful! Run with: cd build/sim && vvp ${TESTBENCH}"