PWD := $(shell pwd)
TOP := $(PWD)/..

PREFIX?=$(TOP)/inst

.PHONY: all
all: install

$(PREFIX):
	mkdir -p $@

.PHONY: install clean full_clean
install clean full_clean: $(PREFIX)
	make -C emacs          PREFIX=$(PREFIX) $@
	make -C exec           PREFIX=$(PREFIX) $@
	make -C gvim           PREFIX=$(PREFIX) $@
	make -C iwidgets4.0.1  PREFIX=$(PREFIX) $@
	make -C novas          PREFIX=$(PREFIX) $@
	make -C tk             PREFIX=$(PREFIX) $@
	make -C util           PREFIX=$(PREFIX) $@
	make -C workstation    PREFIX=$(PREFIX) $@
