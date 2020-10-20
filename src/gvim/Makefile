PWD := $(shell pwd)
TOP := $(PWD)/../..

PREFIX?=$(TOP)/inst

LIBDIR=$(PREFIX)/lib
TARGETDIR=$(LIBDIR)/tcllib/gvim


FILES = \
	gvim_config.vim \


.PHONY: clean all install

all: install

install: 
	install -d -m755 $(TARGETDIR)
	install -m644 $(FILES) $(TARGETDIR)

.PHONY: clean realclean	
realclean: clean

clean:
