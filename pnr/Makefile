ROOT_DIR=$(abspath ../)
include $(ROOT_DIR)/settings.mk
PNR_DIR=$(abspath .)
SYN_DIR=$(abspath ../syn)

export SYN_DIR
export PNR_DIR
export SYN_SRC
export TOP
export ROOT_DIR
export PX
export PY
export PR
export X
export Y

all: $(PNR_DIR)/outputs/$(TOP).gds

$(PNR_DIR)/outputs/$(TOP).gds: $(SYN_DIR)/$(TOP)_net.v $(PNR_DIR)/tcl/pnr.tcl
	openroad -exit $(PNR_DIR)/tcl/pnr.tcl | tee -a openroad.log

manual: $(SYN_DIR)/$(TOP)_net.v $(PNR_DIR)/tcl/pnr.tcl
	openroad -gui $(PNR_DIR)/tcl/pnr.tcl | tee -a openroad.log

clean:
	rm -vrf fv/ *.post.v *.net.v *.cmd* *.log* *.jou *.rep *.sdf outputs reports *.cts timingReports *.rpt *.fp.tcl mp_data DBS encou* *.cts_trace *.rguide *.gds *.ctsrpt *.macro *.report *.map *.txt *.def .z0of .z1of .z2of *.old .cadence mp_data* *.ascii *.lef *.sdc *.spef .metalfill* DesignLib* *.spec *.size summaryReport verify_rpt

.PHONY: all manual clean

