#
# Makefile for the user guide

PWD := $(shell pwd)
TOP := $(PWD)/..

PREFIX?=$(TOP)/inst

INSTALL?=install -c
RM=rm

LATEX = latex '\scrollmode\input'
PDFLATEX = pdflatex '\scrollmode\input'

# -------------------------

# Install location
INSTALLDIR=$(PREFIX)/doc

# Name in the release
INSTALLNAME=bdw-user-guide

# Local file names
DOC=user_guide

# -------------------------

## Included .tex Files
INCLUDES = \
	version.tex \
	bluetcl.tex \

.PHONY: doc clean realclean

doc:	$(DOC).pdf

clean:
	${RM} -f *.dvi *.ps *.pdf figures/*.pdf

realclean: clean
	${RM} -f *.log *.aux *.blg *.bbl *.toc *.out *.idx *.ind *.ilg user_guide.cdx user_guide.cnd

$(DOC).dvi: $(DOC).tex
	$(RM) -f *.log *.aux *.blg *.bbl *.out *.toc *.idx *.ind *.ilg
	-latex $(DOC).tex
	bibtex $(DOC)
	latex $(DOC).tex
	makeindex $(DOC)
	latex $(DOC).tex

$(DOC).pdf: $(DOC).tex $(INCLUDES)
	$(RM) -f *.log *.aux *.blg *.bbl *.out *.toc *.idx *.ind *.ilg *.cnd *.cdx
	-pdflatex $(DOC).tex
	-pdflatex $(DOC).tex
	makeindex $(DOC)
	makeindex $(DOC).cdx -o $(DOC).cnd
	-pdflatex $(DOC).tex
	pdflatex $(DOC).tex

$(DOC).ps:	$(DOC).dvi
	dvips -t letter $(DOC).dvi -o $(DOC).ps

# target for building a tarball
.PHONY: install
install: $(DOC).pdf
	$(INSTALL) -m 755 -d         $(INSTALLDIR)
	$(INSTALL) -m 644 $(DOC).pdf $(INSTALLDIR)/$(INSTALLNAME).pdf

# -------------------------

