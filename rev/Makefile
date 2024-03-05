ROOT_DIR=$(abspath ..)
include $(ROOT_DIR)/settings.mk
REV_DIR=$(abspath .)

DEGATE_GIT=$(abspath ../../Degate)
DEGATE=$(DEGATE_GIT)/build/out/bin/Degate

manual:
	$(DEGATE)

clean:
	rm -rf $(TOP)

.PHONY: manual clean

