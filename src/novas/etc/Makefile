PWD := $(shell pwd)
TOP := $(PWD)/../../..

PREFIX?=$(TOP)/inst

LIBDIR=$(PREFIX)/lib
TARGETDIR=$(LIBDIR)/tcllib/novas/etc


BLUETCL_EXEC?=bluetcl


# NOTE  tclIndex is not included in the list

FILES = \
	pkgIndex.tcl \

# tcl files which need each proc listed in tclIndex
# utils.tcl is really a package, but some initization code require it
TCLFILES = \

# tcl packages
PACKAGES = \
	Blue.tcl

# top level user scripts
EXEFILES = \


.PHONY: clean all install tclIndex

all: tclIndex

# pkg_mkIndex.tcl is produced here
tclIndex: *.tcl
	TCLSH=$(BLUETCL_EXEC) ./tclIndex.sh "$(TCLFILES)" "$(PACKAGES)"

install: tclIndex
	install -d -m755 $(TARGETDIR)
	install -m644 $(FILES) $(PACKAGES) $(TCLFILES) $(TARGETDIR)
	install -d -m755 $(TARGETDIR)/wave
	make -C wave PREFIX=$(PREFIX) install


.PHONY: TAGS
TAGS: ../TAGS

.PHONY: clean full_clean
full_clean: clean

clean:
	@-rm -f tclIndex pkg_mkIndex.tcl pkgIndex.tcl
