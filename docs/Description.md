## 📺 Démo ALU 8-bits sur Pynq Z1 + mesure oscilloscope

Dans cette vidéo, je vous montre comment passer  
1) de la simulation Verilator  
2) à la programmation d’une Pynq Z1  
3) puis à la mesure réelle sur oscilloscope  

Vous verrez :  
- Compilation et exécution du testbench `add7_plus_8.v`  
- Création d’un wrapper hardware `top.v` sur Pynq Z1  
- Branchement de la sonde et réglages de l’oscillo  
- Plans B-roll variés pour illustrer tout le process

---

### ⏱️ Timestamps
0:00 Intro & présentation du projet  
0:30 Simulation Verilator & testbench  
1:30 Synthèse & génération du bitstream  
2:15 Programmation de la Pynq Z1  
3:00 Branchement sonde & réglages oscillo  
3:30 Mesure 1 Hz (LED0)  
4:00 Plans B-roll (close-ups, angles)  
4:30 Résumé & prochaines étapes  

---

### 🔗 Matériel & liens affiliés

- **Pynq Z1 FPGA Board** – Prototypage hardware/logiciel  
  https://amzn.to/4jZJtc3
- **Oscilloscope Siglent SDS1104X-E 100 MHz** – Mesure de signaux numériques  
https://amzn.to/3GVwmKn
- **Sonde oscilloscopique 10 :1** – Pour capturer propres vos signaux  
  https://amzn.to/5Probe  
- **Ring-light UBeesize 10″** – Éclairage uniforme pour face-cam  
  https://amzn.to/3LightRL  
- **Micro Blue Yeti** – Son clair sans souffle  
  https://amzn.to/3H0epdS
- **Câbles PMOD & Dupont** – Connexions FPGA → oscillo  
  https://amzn.to/6Jumper  
- **FT2232H JTAG/USB-SPI** – Debug et programmation alternative  
  https://amzn.to/7FT2232  

---

### 📂 Ressources
- GitHub du projet : https://github.com/tonpseudo/edge-asic-journey  
- Docs & scripts CI : ➡️ `/scripts/run_ci.sh`  
- Fichiers Verilog : ➡️ `/rtl/alu8.v` et `/sim/add7_plus_8.v`  

---

🙏 Si cette vidéo vous a aidé, pensez à liker et à vous abonner pour suivre l’aventure **“Road to Edge AI Hardware”** !

---  
*Ces liens sont affiliés : cela ne change rien pour vous, mais me permet de financer du matériel pour la chaîne.*  
