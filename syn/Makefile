TECH?=sky130
ROOT_DIR=$(abspath ..)
include $(ROOT_DIR)/settings.mk
SYN_DIR=$(abspath .)

export SYN_DIR
export SYN_SRC
export TOP
export ROOT_DIR
export TECH

SYN_NET=$(SYN_DIR)/outputs/$(TOP)_net.v
OBS_NET=$(SYN_DIR)/outputs/$(TOP)_net.obs.v

all: $(SYN_NET) $(OBS_NET)

$(SYN_NET): $(SYN_DIR)/tcl/synthesis.tcl $(SYN_SRC) $(SYN_DIR)/tcl/rtl.sdc.tcl
	yosys -h tcl $(SYN_DIR)/tcl/synthesis.tcl | tee -a yosys.log

manual: $(SYN_DIR)/tcl/synthesis.tcl $(SYN_SRC) $(SYN_DIR)/tcl/rtl.sdc.tcl
	yosys -h tcl

clean:
	rm -rfv *.log* *.cmd* *_intermediate.v *_net.v *.sdf fv reports outputs *.tstamp

$(OBS_NET): $(SYN_DIR)/tcl/aleatorize.py $(SYN_NET)
	python3 $(SYN_DIR)/tcl/aleatorize.py $(SYN_NET) $(OBS_NET) $(LEVELS)

.PHONY: clean

