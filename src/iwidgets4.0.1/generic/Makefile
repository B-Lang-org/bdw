LIBDIR ?= install

INSTALL ?= install


FILES = \
      tclIndex \
      $(wildcard *.itcl) \
      $(wildcard *.itk) \
      $(wildcard *.gif) \


.PHONY: all
all: install

.PHONY: install
install:
	$(INSTALL) -m 755 -d $(LIBDIR)
	$(INSTALL) -m 644 $(FILES) $(LIBDIR)


.PHONY: clean full_clean
clean full_clean:

