## top.xdc — contraintes pour Pynq Z1

# 1) Horloge 100 MHz
set_property PACKAGE_PIN W5 [get_ports CLK_100MHZ]
set_property IOSTANDARD LVCMOS33 [get_ports CLK_100MHZ]

# 2) Bouton reset BTN0 (actif bas)
set_property PACKAGE_PIN V5 [get_ports BTN0]
set_property IOSTANDARD LVCMOS33 [get_ports BTN0]

# 3) LED utilisateur LD0 connectée sur PMOD JA1
set_property PACKAGE_PIN W7 [get_ports LED0]
set_property IOSTANDARD LVCMOS33 [get_ports LED0]
