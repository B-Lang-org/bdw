# for "make clean" to work everywhere

#assume that config files live relative to
# the 'testsuite' in our parent directory(ies)

CONFDIR := $(shell git rev-parse --show-toplevel)

KEEPFILES := $(wildcard *.v)

include $(CONFDIR)/clean.mk
