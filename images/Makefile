ROOT_DIR=$(abspath ..)
include $(ROOT_DIR)/settings.mk
SIGN_DIR=$(abspath ../signoff)
REV_DIR=$(abspath ../rev)

export ROOT_DIR

DEGATE_DIR?=$(REV_DIR)/$(TOP)
DEGATE_XML?=$(DEGATE_DIR)/lmodel.xml
DEGATE_XML_LIB?=$(DEGATE_DIR)/gate_library.xml

GDS=$(ROOT_DIR)/lib/$(TECH).gds
VERILOG=$(ROOT_DIR)/lib/$(TECH).v
CELL_LIST=$(ROOT_DIR)/lib/$(TECH).allcells
TOON_OUT=$(ROOT_DIR)/images/toon
LIB_OUT=$(ROOT_DIR)/images/real_$(LEVELS)
TOON_LYP=$(ROOT_DIR)/images/$(TECH)_toon.lyp
REAL_LYP=$(ROOT_DIR)/images/$(TECH)_real.lyp

CELLS=$(shell cat $(CELL_LIST))
IMAGES_OUT = $(CELLS:%=$(TOON_OUT)/%.toon.png)
ALL_REAL_OUT = $(CELLS:%=$(LIB_OUT)/%_metal.tif)

TOP_GDS=$(SIGN_DIR)/outputs/$(TOP).gds

EXT_GDS=$(LIB_OUT)/$(TOP)_rec_$(RECLEVELS).degate_detect.gds
EXT_PNG=$(LIB_OUT)/$(TOP)_rec_$(RECLEVELS).degate_detect.png
EXT_T_PNG=$(LIB_OUT)/$(TOP)_rec_$(RECLEVELS).t.degate_detect.png

all:
	make lib_real
	make lib_out
	make top_real
	make lib_install
	make lib_toon
	make top_toon


install: lib_install

lib_real: $(GDS) $(VERILOG)
	mkdir -p $(LIB_OUT)
	klayout -z -r make_real_gatelib.py -rd toplist=$(CELL_LIST) -rd infile=$(GDS) -rd outxmlfile=$(LIB_OUT)/gate_library.xml -rd invfile=$(VERILOG) -rd libout=$(LIB_OUT) -rd levels=$(RECLEVELS) -rd techname=$(TECH)

lib_out: $(ALL_REAL_OUT)

$(LIB_OUT)/%_metal.tif: $(LIB_OUT)/%.metal.png
	convert $(LIB_OUT)/$*.full.png -transparent black $(LIB_OUT)/$*.t.full.png
	convert $(LIB_OUT)/$*.tran.png -transparent black $(LIB_OUT)/$*.t.tran.png
	convert $(LIB_OUT)/$*.metal.png -transparent black $(LIB_OUT)/$*.t.metal.png
	gimp -ifs -b "(load \"layerfx.scm\") (load \"make_real.scm\") (make-real-metal \"$(LIB_OUT)/$*.t.metal.png\" \"$(LIB_OUT)/$*.r.metal.png\" \"$(LIB_OUT)/$*_metal.png\") (make-real-tran \"$(LIB_OUT)/$*.t.tran.png\" \"$(LIB_OUT)/$*.r.tran.png\" \"$(LIB_OUT)/$*_tran.png\") (make-real-final \"$(LIB_OUT)/$*.r.metal.png\" \"$(LIB_OUT)/$*.r.tran.png\" \"$(LIB_OUT)/$*_logic.png\")" -b "(gimp-quit 0)"
	convert $(LIB_OUT)/$*_metal.png $(LIB_OUT)/$*_metal.tif
	convert $(LIB_OUT)/$*_logic.png $(LIB_OUT)/$*_logic.tif
	convert $(LIB_OUT)/$*_tran.png $(LIB_OUT)/$*_tran.tif

lib_install:
	make -C $(REV_DIR) clean
	make -C $(REV_DIR) all
	cp -v $(LIB_OUT)/*.tif $(DEGATE_DIR)
	cp -v $(LIB_OUT)/*.xml $(DEGATE_DIR)

lib_toon: $(IMAGES_OUT)

$(TOON_OUT)/%.toon.png: $(GDS)
	mkdir -p $(TOON_OUT)
	@echo Attempting to extract $*
	klayout -z -r make_toon.py -rd top=$* -rd infile=$(GDS) -rd outfile=$(TOON_OUT)/$*.toon.png -rd techname=$(TECH)

top_real:$(LIB_OUT)/$(TOP).r.full.tif

$(LIB_OUT)/$(TOP).r.full.tif: $(TOP_GDS)
	mkdir -p $(LIB_OUT)
	klayout -z -r make_real.py -rd top=$(TOP) -rd infile=$(TOP_GDS) -rd outfile=$(LIB_OUT)/$(TOP).real.png -rd outtranfile=$(LIB_OUT)/$(TOP).tran.png -rd outmetfile=$(LIB_OUT)/$(TOP).met.png -rd techname=$(TECH) -rd dispw=$(DISPW) -rd disph=$(DISPH) -rd dispx=$(DISPX) -rd dispy=$(DISPY)
	convert $(LIB_OUT)/$(TOP).real.png -transparent black $(LIB_OUT)/$(TOP).t.real.png
	convert $(LIB_OUT)/$(TOP).tran.png -transparent black $(LIB_OUT)/$(TOP).t.tran.png
	convert $(LIB_OUT)/$(TOP).met.png -transparent black $(LIB_OUT)/$(TOP).t.met.png
	gimp -ifs -b "(load \"layerfx.scm\") (load \"make_real.scm\") (make-real-metal \"$(LIB_OUT)/$(TOP).t.met.png\" \"$(LIB_OUT)/$(TOP).r.met.png\" \"$(LIB_OUT)/$(TOP).r.met.png\") (make-real-tran \"$(LIB_OUT)/$(TOP).t.tran.png\" \"$(LIB_OUT)/$(TOP).r.tran.png\" \"$(LIB_OUT)/$(TOP).r.tran.png\") (make-real-final \"$(LIB_OUT)/$(TOP).r.met.png\" \"$(LIB_OUT)/$(TOP).r.tran.png\" \"$(LIB_OUT)/$(TOP).r.full.png\")" -b "(gimp-quit 0)"
	convert $(LIB_OUT)/$(TOP).r.met.png $(LIB_OUT)/$(TOP).r.met.tif
	convert $(LIB_OUT)/$(TOP).r.full.png $(LIB_OUT)/$(TOP).r.full.tif
	convert $(LIB_OUT)/$(TOP).r.tran.png $(LIB_OUT)/$(TOP).r.tran.tif

top_toon: $(TOON_OUT)/$(TOP).toon.png

$(TOON_OUT)/$(TOP).toon.png: $(TOP_GDS)
	mkdir -p $(TOON_OUT)
	@echo Attempting to extract $(TOP)
	klayout -z -r make_toon.py -rd top=$(TOP) -rd infile=$(TOP_GDS) -rd outfile=$(TOON_OUT)/$(TOP).toon.png -rd techname=$(TECH) -rd dispw=$(DISPW) -rd dispw=$(DISPW) -rd disph=$(DISPH) -rd dispx=$(DISPX) -rd dispy=$(DISPY)

extract: $(EXT_GDS)

$(EXT_GDS): $(TOP_GDS) extract.py
	@echo Attempting to extract $(TOP)
	klayout -z -r extract.py -rd top=$(TOP) -rd infile=$(TOP_GDS) -rd inxmlfile=$(DEGATE_XML) -rd inxmllib=$(DEGATE_XML_LIB) -rd outpngfile=$(EXT_PNG) -rd outgdsfile=$(EXT_GDS) -rd techname=$(TECH) -rd dispw=$(DISPW) -rd disph=$(DISPH) -rd dispx=$(DISPX) -rd dispy=$(DISPY) -rd output_stat=$(LIB_OUT)/$(TOP).stat
	convert $(EXT_PNG) -transparent black $(EXT_T_PNG)

view_extract: $(EXT_GDS)
	klayout -s $(EXT_GDS) -l $(ROOT_DIR)/lib/$(TECH)_degate_detect.lyp

clean:
	rm -rfv *.png *.log *.xml $(LIB_OUT) $(TOON_OUT)

.PHONY: all lib clean

