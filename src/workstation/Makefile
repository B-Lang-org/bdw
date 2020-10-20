PWD := $(shell pwd)
TOP := $(PWD)/../..

PREFIX?=$(TOP)/inst

# -----
# Options

# Set this to 1 if the source files are not in Git or the Git tool
# is not available.  The variable is used by "update-build-version.sh"
# which will not try running Git if the value is 1.
#
NOGIT ?= 0
export NOGIT

# With NOGIT=1, the build version will be update to a null value.
# If you want to pre-create the file and avoid overwriting it,
# then set this variable to 1.
#
NOUPDATEBUILDVERSION ?= 0
export NOUPDATEBUILDVERSION

# -----
# Paths and environment

LIBDIR=$(PREFIX)/lib
BINDIR=$(PREFIX)/bin
TARGETDIR=$(LIBDIR)/tcllib/workstation


BLUETCL_EXEC?=bluetcl

# -----

FILES = \
	tclIndex \
	pkgIndex.tcl \

EXEFILES = open_graph.tcl \

TCLFILES = \
	analysis_commands.tcl \
	bindings.tcl \
	build_commands.tcl \
	build_skeleton_dialog.tcl \
	command_line_handlers.tcl \
	dialog.tcl \
	file_commands.tcl \
	file_dialogs.tcl \
	finddialog.tcl \
	fonts.tcl \
	graph_export_dialog.tcl \
	graph_window.tcl \
	help.tcl \
	hierarchy.tcl \
	import_bvi_wizard_analysis.tcl \
	import_bvi_wizard_graphic.tcl \
	main_window.tcl \
	menu_actions.tcl \
	menubar.tcl \
	messagebox.tcl \
	module_browser_window.tcl \
	package_window.tcl \
	paned_window.tcl \
	project_back_up_dialog.tcl \
	project_commands.tcl \
	project_options_dialog.tcl \
	project_top_file_dialog.tcl \
	project_window.tcl \
	schedule_analysis.tcl \
	scrolledcheckbox.tcl \
	select_file_dialog.tcl \
	selection_dialog.tcl \
	show_text_dialog.tcl \
	status_command_window.tcl \
	tabnotebook.tcl \
	toolbar.tcl \
	type_browser_window.tcl \
	version_commands.tcl \
	workstation.tcl \

PACKAGES = \
	sinterp_namespace.tcl \


.PHONY: all
all: install

.FORCE:
version_commands.tcl: .FORCE
	./update-build-version.sh

tclIndex: $(TCLFILES)
	TCLSH=$(BLUETCL_EXEC) ./tclIndex.sh "$(TCLFILES)" "$(PACKAGES)"

.PHONY: install
install: tclIndex 
	install -d -m755 $(TARGETDIR)
	install -m644 $(FILES) $(TCLFILES) $(PACKAGES) $(TARGETDIR)
	install -m755 $(EXEFILES) $(TARGETDIR)
	install -d -m755 $(BINDIR)
	install -m755 bdw-wrapper.sh $(BINDIR)/bdw
	install -d -m755 $(BINDIR)/core
	install -m755 bdw $(BINDIR)/core
	$(MAKE) -C images PREFIX=$(PREFIX) $@


TAGS: *.tcl
	etags --lang=none \
                --regex='/proc[ \t]+\([^ \t]+\)/\1/' \
                --regex='/itcl::body[ \t]+\([^ \t]+\)/\1/' \
                --regex='/itcl::body[ \t]+[^: \t]+::\([^ \t]+\)/\1/'  $+

tags: *.tcl
	ctags $+

.PHONY: clean realclean clean-tix
clean realclean: clean-tix
	@rm -rf tclIndex pkgIndex.tcl version_commands.tcl logs help TAGS tags

clean-tix:
	@rm -rf *.tix
