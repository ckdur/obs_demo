# Obfuscation demostration for sky130

This is an obfuscation demostration for the sky130 technology.

The project will take an RTL that wants to be obfuscated (example: the AES 
bundled), then creates a semi-valid layout using open-source tools.

The obfuscation works by shuffling different versions of the same standard
cell by changing their positioning and internal routing, which makes it
difficult for a potential attacker to reverse-engineer the netlist of the
digital circuit.

# Requirements

The project requires the instalation of open-source tools for chip integration.

# Running the demo

Please just see the submission of VLSI24 make-a-chip for details.

The submission can be seen in:

[VLSI24 SSCS Code-A-Chip](https://github.com/ckdur/sscs-ose-code-a-chip.github.io/blob/main/VLSI24/submitted_notebooks/obs_demo/obs_demo.ipynb)


