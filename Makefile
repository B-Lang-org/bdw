
PWD := $(shell pwd)
TOP := $(PWD)

PREFIX?=$(TOP)/inst

.PHONY: all
all: install

$(PREFIX):
	mkdir -p $@

.PHONY: install clean realclean
install clean realclean: $(PREFIX)
	make -C src  PREFIX=$(PREFIX)  $@
