PWD := $(shell pwd)
TOP := $(PWD)/../..

PREFIX?=$(TOP)/inst

LIBDIR=$(PREFIX)/lib/tcllib
TARGETDIR=$(LIBDIR)/iwidgets4.0

INSTALL?=install


FILES = *.tcl
DIRS = generic


.PHONY: all
all: install

.PHONY: install
install:
	$(INSTALL) -m755 -d $(TARGETDIR)
	$(INSTALL) -m644 $(FILES) $(TARGETDIR)
	$(foreach dir, $(DIRS), \
		$(MAKE) -C $(dir) LIBDIR=$(abspath $(TARGETDIR)/$(dir)) $@ ; )


.PHONY: clean full_clean
clean full_clean:

