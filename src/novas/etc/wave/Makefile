TOP=../../..
PREFIX?=$(TOP)/inst

LIBDIR=$(PREFIX)/lib
TARGETDIR=$(LIBDIR)/tcllib/novas/etc/wave


FILES = \
	wave.menu \


.PHONY: clean all install

all: install

install: 
	install -d -m755 $(TARGETDIR)
	install -m644 $(FILES) $(TARGETDIR)


.PHONY: TAGS
TAGS: ../TAGS

.PHONY: clean full_clean
full_clean: clean

clean:
