PWD := $(shell pwd)
TOP := $(PWD)/../..

PREFIX?=$(TOP)/inst

LIBDIR=$(PREFIX)/lib
TARGETDIR=$(LIBDIR)/tcllib/util


BLUETCL_EXEC?=bluetcl


FILES = \
	tclIndex \
	pkgIndex.tcl \

# tcl files which need each proc listed in tclIndex
TCLFILES = \
        Editor.tcl \
        Emacs.tcl \
        Gvim.tcl \

# tcl packages
PACKAGES = \
        EvalChannel.tcl \
        FileSupport.tcl \
        GtkWave.tcl \
        GtkWaveMac.tcl \
        MathSupport.tcl \
        NovasSupport.tcl \
        NovasSupportSendSignal.tcl \
        SignalTypes.tcl \
        Trace.tcl \
        TypeSupport.tcl \
        Unique.tcl \
        ViewerCommon.tcl \
	VisitorPattern.tcl \
        Waves.tcl \
        virtual.tcl \
        functional.tcl


.PHONY: all
all: install

# pkg_mkIndex.tcl is produced here
tclIndex: *.tcl
	TCLSH=$(BLUETCL_EXEC) ./tclIndex.sh "$(TCLFILES)" "$(PACKAGES)"

.PHONY: install
install: tclIndex
	install -d -m755 $(TARGETDIR)
	install -m644 $(FILES) $(PACKAGES) $(TCLFILES) $(TARGETDIR)


.PHONY: TAGS
TAGS:
	make -C .. TAGS
	ln -s ../TAGS

.PHONY: clean realclean
realclean: clean
	-rm -f TAGS

clean:
	@-rm -f tclIndex pkg_mkIndex.tcl pkgIndex.tcl
