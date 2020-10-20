PWD := $(shell pwd)
TOP := $(PWD)/../../..

PREFIX?=$(TOP)/inst

LIBDIR?=$(PREFIX)/lib/
TARGETDIR=$(LIBDIR)/tcllib/workstation/images

# Icon are from
# We need to credit them in workstation
# http://www.famfamfam.com/lab/icons/silk/

IMAGEFILES = \
	Sim.gif \
	add.gif \
	application_go.gif \
	application_lightning.gif \
	application_link.gif \
	application_xp.gif \
	arrow_rotate_clockwise.gif \
	asterisk_yellow.gif \
	bDW.gif \
	book_go.gif \
	book_link.gif \
	bullet_black.gif \
	bullet_blue.gif \
	bullet_go.gif \
	bullet_green.gif \
	bullet_red.gif \
	bullet_orange.gif \
	bullet_pink.gif \
	bullet_purple.gif \
	bullet_white.gif \
	bullet_yellow.gif \
	cancel.gif \
	cog.gif \
	control_fastforward.gif \
	control_fastforward_blue.gif \
	control_play.gif \
	control_play_blue.gif \
	control_stop.gif \
	control_stop_blue.gif \
	copy.gif \
	cut.gif \
	database_add.gif \
	database_edit.gif \
	database_gear.gif \
	database_lightning.gif \
	database_link.gif \
	delete.gif \
	error.gif \
	exclamation.gif \
	file.gif \
	folder.gif \
	gtkwave_24x24.gif \
	hourglass.gif \
	info.gif \
	lightning.gif \
	new.gif \
	open.gif \
	page_lightning.gif \
	page_white_lightning.gif \
	paste.gif \
	question.gif \
	save.gif \
	script.gif \
	script_add.gif \
	script_gear.gif \
	script_go.gif \
	script_lightning.gif \
	script_link.gif \
	table_lightning.gif \
	tick.gif \
	warning.gif \
	checked.gif \
	unchecked.gif


.PHONY: all
all: install

.PHONY: install
install:
	install -d -m755 $(TARGETDIR)
	install -m644 $(IMAGEFILES) $(TARGETDIR)

.PHONY: clean realclean
realclean: clean

clean:
