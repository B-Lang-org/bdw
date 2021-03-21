
PWD := $(shell pwd)
TOP := $(PWD)

PREFIX?=$(TOP)/inst

.PHONY: all
all: install

# -------------------------

.PHONY: rem_inst
rem_inst:
	rm -fr $(PREFIX)

.PHONY: rem_build
rem_build:
	rm -fr $(BUILDDIR)

# -------------------------

.PHONY: install
install:
	$(MAKE)  -C src  PREFIX=$(PREFIX)  install

.PHONY: install-doc
install-doc:
	$(MAKE)  -C doc  PREFIX=$(PREFIX)  install

# -------------------------

clean: rem_inst rem_build
	-$(MAKE)  -C src  clean
	-$(MAKE)  -C doc  clean

full_clean: rem_inst rem_build
	-$(MAKE)  -C src  full_clean
	-$(MAKE)  -C doc  full_clean

# -------------------------
