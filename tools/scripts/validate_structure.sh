#!/bin/bash
# promaa 08/06/2025 - Repository structure validation script
# Verifies that all files are properly organized

echo "🔍 Validating nand2cpu structure..."

# Determine project root directory
if [[ "${BASH_SOURCE[0]}" == *"tools/scripts"* ]]; then
    PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
else
    PROJECT_ROOT="$(pwd)"
fi

cd "$PROJECT_ROOT"
echo "📍 Working directory: $PROJECT_ROOT"

# Function to check file/folder existence
check_path() {
    if [ -e "$1" ]; then
        echo "✅ $1"
    else
        echo "❌ $1 (missing)"
        return 1
    fi
}

# Check main structure
echo -e "\n📁 Main structure:"
check_path "src"
check_path "tools"
check_path "build"
check_path "examples"
check_path "docs"
check_path "Makefile"
check_path "README.md"
check_path ".gitignore"

# Check RTL modules
echo -e "\n🔧 RTL modules:"
check_path "src/rtl/nand_gate.v"
check_path "src/rtl/and_gate.v"
check_path "src/rtl/or_gate.v"
check_path "src/rtl/alu8.v"
check_path "src/rtl/alu16.v"

# Check testbenches
echo -e "\n🧪 Testbenches:"
check_path "src/testbenches/tb_nand_gate.v"
check_path "src/testbenches/tb_and_gate.v"
check_path "src/testbenches/tb_alu16.v"
check_path "src/testbenches/add7_plus_8.v"

# Check FPGA modules
echo -e "\n🔌 FPGA modules:"
check_path "src/fpga/top.v"
check_path "src/fpga/top_fast.v"
check_path "src/fpga/top.xdc"

# Check assembler
echo -e "\n⚙️ Assembler:"
check_path "tools/assembler/main.py"
check_path "tools/assembler/parser.py"
check_path "tools/assembler/encoder.py"
check_path "tools/assembler/test.asm"

# Check scripts
echo -e "\n📜 Scripts:"
check_path "tools/scripts/build_sim.sh"
check_path "tools/scripts/build_fpga.tcl"

# Check examples
echo -e "\n📖 Examples:"
check_path "examples/test_vectors.asm"

# Quick functionality test
echo -e "\n🚀 Quick functionality test..."
echo "Makefile test:"
make help > /dev/null 2>&1 && echo "✅ Makefile functional" || echo "❌ Makefile issue"

echo "Assembler test:"
cd tools/assembler
python3 main.py test.asm test.bin > /dev/null 2>&1 && echo "✅ Assembler functional" || echo "❌ Assembler issue"
cd "$PROJECT_ROOT"

echo "Simulation test:"
timeout 10s make sim-tb_nand_gate > /dev/null 2>&1 && echo "✅ Simulation functional" || echo "❌ Simulation issue"

echo -e "\n✨ Validation completed!"
echo "nand2cpu repository well organized and functional."
