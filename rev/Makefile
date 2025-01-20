ROOT_DIR=$(abspath ..)
include $(ROOT_DIR)/settings.mk
REV_DIR=$(abspath .)
IMG_DIR=$(abspath ../images)

DEGATE_GIT=$(REV_DIR)/src/Degate
DEGATE=$(DEGATE_GIT)/build/out/bin/Degate
CREATE_DEGATE=$(REV_DIR)/src/build/create_degate
RUN_TEMPLATE_DEGATE=$(REV_DIR)/src/build/run_template_matching
LAMBDA=$(shell python $(ROOT_DIR)/lib/$(TECH)_util.py)

all: $(DEGATE) $(CREATE_DEGATE) $(RUN_TEMPLATE_DEGATE)
	mkdir -p $(REV_DIR)/$(TOP)_r$(RECLEVELS)
	$(CREATE_DEGATE) $(TOP)_r$(RECLEVELS) $(REV_DIR)/$(TOP)_r$(RECLEVELS) $(IMG_DIR)/real_$(LEVELS)/$(TOP).r.met.tif $(IMG_DIR)/real_$(LEVELS)/$(TOP).r.full.tif $(IMG_DIR)/real_$(LEVELS)/$(TOP).r.tran.tif $(LAMBDA)

$(CREATE_DEGATE) $(RUN_TEMPLATE_DEGATE): $(DEGATE) $(REV_DIR)/src/CMakeLists.txt
	mkdir -p $(REV_DIR)/src/build/
	cd $(REV_DIR)/src/build && cmake $(REV_DIR)/src -DBoost_USE_STATIC_LIBS=OFF
	make -C $(REV_DIR)/src/build

$(DEGATE): $(DEGATE_GIT)/CMakeLists.txt
	mkdir -p $(DEGATE_GIT)/build/
	cd $(DEGATE_GIT)/build && cmake $(DEGATE_GIT) -DBoost_USE_STATIC_LIBS=OFF
	make -C $(DEGATE_GIT)/build

run_template: $(RUN_TEMPLATE_DEGATE)
	time $(RUN_TEMPLATE_DEGATE) $(TOP)_r$(RECLEVELS) $(REV_DIR)/$(TOP)_r$(RECLEVELS)

manual: $(DEGATE)
	$(DEGATE)

clean:
	rm -rf $(TOP) $(TOP)_r$(RECLEVELS)

.PHONY: manual clean

