PWD := $(shell pwd)
TOP := $(PWD)/../..

PREFIX?=$(TOP)/inst

LIBDIR=$(PREFIX)/lib
TARGETDIR=$(LIBDIR)/tcllib/novas


.PHONY: all
all: install

.PHONY: install
install:
	install -d -m755 $(TARGETDIR)
	make -C etc PREFIX=$(PREFIX) install


TAGS: */*.tcl
	ctags -R -e

.PHONY: clean realclean
realclean clean:
	rm -f TAGS
	make -C etc $@
