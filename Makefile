# Makefile pour nand2cpu
# Simplifie les commandes de build et test

.PHONY: help clean test-all test-gates test-alu sim-% fpga assembler

# Configuration
TOOLS_DIR := tools
SCRIPTS_DIR := $(TOOLS_DIR)/scripts
BUILD_DIR := build
SIM_DIR := $(BUILD_DIR)/sim
SYNTH_DIR := $(BUILD_DIR)/synth

help:
	@echo "nand2cpu - Makefile d'aide"
	@echo ""
	@echo "Commandes disponibles:"
	@echo "  help        - Afficher cette aide"
	@echo "  clean       - Nettoyer les builds"
	@echo "  test-all    - Exécuter tous les tests"
	@echo "  test-gates  - Tester les portes logiques"
	@echo "  test-alu    - Tester les ALU"
	@echo "  quick-test  - Tests rapides (NAND + ALU)"
	@echo "  validate    - Valider la structure du repository"
	@echo "  sim-<name>  - Compiler et lancer une simulation (ex: sim-tb_nand_gate)"
	@echo "  fpga        - Build pour FPGA (nécessite Vivado)"
	@echo "  assembler   - Tester l'assembleur"
	@echo ""
	@echo "Exemples:"
	@echo "  make sim-tb_nand_gate"
	@echo "  make test-gates"
	@echo "  make fpga"

clean:
	@echo "Nettoyage des builds..."
	rm -rf $(BUILD_DIR)/*
	mkdir -p $(SIM_DIR) $(SYNTH_DIR)
	@echo "Build directory cleaned."

# Tests spécifiques
test-gates: sim-tb_nand_gate sim-tb_and_gate sim-tb_or_gate
	@echo "✅ Tests des portes logiques terminés"

test-alu: sim-add7_plus_8 sim-tb_alu16
	@echo "✅ Tests ALU terminés"

test-all: test-gates test-alu
	@echo "✅ Tous les tests terminés"

# Pattern pour compiler et lancer les simulations
sim-%:
	@echo "Building simulation for $*..."
	@$(SCRIPTS_DIR)/build_sim.sh $*
	@echo "Running simulation..."
	@cd $(SIM_DIR) && vvp $*

# Build FPGA
fpga:
	@echo "Building for FPGA..."
	@mkdir -p $(SYNTH_DIR)
	@cd . && vivado -mode batch -source $(SCRIPTS_DIR)/build_fpga.tcl

# Test assembleur
assembler:
	@echo "Testing assembler..."
	@cd $(TOOLS_DIR)/assembler && python3 main.py test.asm test.bin
	@echo "✅ Assembleur testé avec succès"
	@echo "Fichier binaire généré: $(TOOLS_DIR)/assembler/test.bin"

# Tests rapides
quick-test: sim-tb_nand_gate sim-add7_plus_8
	@echo "✅ Tests rapides terminés"

# Validation de la structure
validate:
	@echo "Validation de la structure du repository..."
	@./tools/scripts/validate_structure.sh
