PWD := $(shell pwd)
TOP := $(PWD)/../..

PREFIX?=$(TOP)/inst

LIBDIR=$(PREFIX)/lib
TARGETDIR=$(LIBDIR)/tcllib/tk


BLUETCL_EXEC?=bluetcl


TCLFILES = \
	msgbox.tcl \
	tkfbox.tcl \


.PHONY: all
all: install

tclIndex: *.tcl
	TCLSH=$(BLUETCL_EXEC) ./tclIndex.sh "$(TCLFILES)" ""

.PHONY: install
install: tclIndex
	install -d -m755 $(TARGETDIR)
	install -m644 tclIndex $(TCLFILES) $(TARGETDIR)


.PHONY: clean full_clean	
full_clean: clean

clean:
	rm -f pkgIndex.tcl tclIndex
