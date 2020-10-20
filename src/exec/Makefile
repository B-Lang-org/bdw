PWD := $(shell pwd)
TOP := $(PWD)/../..

PREFIX?=$(TOP)/inst

LIBDIR=$(PREFIX)/lib
TARGETDIR=$(LIBDIR)/exec


.PHONY: all
all: install

.PHONY: install
install:
	install -d -m755 $(TARGETDIR)
	install -m755 fixvcd.pl $(TARGETDIR)/fixvcd

.PHONY: clean realclean
realclean: clean

clean:
