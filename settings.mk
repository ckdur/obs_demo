#######################################################
# Proportional dimmentions
ROOT_DIR?=$(abspath .)
TECH?=sky130
LEVELS?=4
RECLEVELS?=1

PX?=4
PY?=2
PR?=0.75

DISPX=100
DISPY=100
DISPW=100
DISPH=100

#######################################################
# Rules to create the files. 
# If there is no really rules, then can leave it blank
TOP?=aes
AES_DIR=$(ROOT_DIR)/aes
SYN_SRC?=$(AES_DIR)/src/rtl/aes_core.v \
  $(AES_DIR)/src/rtl/aes_decipher_block.v \
  $(AES_DIR)/src/rtl/aes_encipher_block.v \
  $(AES_DIR)/src/rtl/aes_inv_sbox.v \
  $(AES_DIR)/src/rtl/aes_key_mem.v \
  $(AES_DIR)/src/rtl/aes_sbox.v \
  $(AES_DIR)/src/rtl/aes.v

