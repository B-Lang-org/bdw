#!/bin/sh
## \
exec bluetcl "$0" "$@"


##
# @file open_graph.tcl
#

lappend auto_path $env(BDWDIR)/tcllib/workstation
lappend auto_path /usr/lib/tcltk/graphviz/

package require BDWIwidgets
package require Tcldot

# standard BDW colours and fonts
fonts::set_colours
fonts::initialize

global BSPEC
set BSPEC(NEW_GRAPH_ID) 0

proc get_settings {} {
	set f [.list get]
	set n [file tail [file rootname $f]]
	if {![winfo exists .$n]} {
		create_graph_window $f $n
	} else {
		focus -force .$n
		raise .$n
	}
}

proc check_settings {} {
        global BSPEC
	set s [.list get]
	if {$s == ""} {
		error_message "The graph file is not specified." \
                        ".gr$BSPEC(NEW_GRAPH_ID)"
		return error
	}
	if {![file exists $s]} {
		error_message "The specified file does not exist." \
                        ".gr$BSPEC(NEW_GRAPH_ID)"
		return error
	}
	if {[file extension $s] != ".dot"} {
		error_message "The specified file is not a DOT file." \
                        ".gr$BSPEC(NEW_GRAPH_ID)"
		return error
	}
	return ""
}

proc set_bindings {} {
	bind . <Return> {
		if {[check_settings] == ""} {
			get_settings
		}
	}
}

proc create_open_graph_dialog {} {
	iwidgets::fileselectionbox .list -filteron false -textbackground white \
		-fileson 1 -mask "*.dot"
	pack .list -fill both -expand true
	.list component files configure -dblclickcommand {
		get_settings
	}
	frame .frame
	pack .frame -padx 5 -pady 10
	button .frame.bo -text "Open" -width 7 -command {
		if {[check_settings] == ""} {
			get_settings
		}
	}
	pack .frame.bo -side left -padx 10
	button .frame.bc -text "Close All" -width 7 -command {
		destroy .
	}
	pack .frame.bc -side right -padx 20

}

proc create_graph_open {} {
	create_open_graph_dialog
	wm geometry . 350x400+0+0
	wm title . "Open Graph"
	wm minsize . 300 350
	set_bindings
}

proc open_graph_file {filename} {
	if {$filename != ""} {
		if {![file exists $filename]} {
			puts "The requested $filename file does \
				not exist."
		} elseif {[file extension $filename] != ".dot"} {
			puts "The requested $filename file is \
				not a DOT file."
		} else {
			set title [file tail [file rootname $filename]]
			create_graph_window $filename $title
		}
	}
}

create_graph_open
open_graph_file [lindex $argv 0]
