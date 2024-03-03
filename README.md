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

The demo consist of three phases, which is the layout generation, the image 
extraction, and a demo of a possible reverse-engineering process.

## Generating the layout

## Image extraction

## Simulating a reverse-engineering scenario

# Problems

1. The cells does not pass DRC. This is a product of a beta standard cell
generator which is not released.

2. 


