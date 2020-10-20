
package require FileSupport

namespace eval ::Editor {

    namespace export \
	isRunning \
	jumpToPosition \
        openNewFile \
	quit \
	start

proc start {{only_if_needed 1}} {

    global PROJECT

    if {$only_if_needed && [isRunning]} {
	return
    }

    if {$PROJECT(EDITOR_NAME) == "gvim"} {
	Gvim::start

    } elseif {$PROJECT(EDITOR_NAME) == "emacs"} {
	Emacs::start "BluespecEmacs" -iconic

    } else {
    }
}


proc quit {} {

    global PROJECT

    if {![isRunning]} {
	return
    }

    if {$PROJECT(EDITOR_NAME) == "gvim"} {
	Gvim::quit
    }

    if {$PROJECT(EDITOR_NAME) == "emacs"} {
	Emacs::quit
    }
}

proc isRunning {} {
    global PROJECT
    if { ! [info exists PROJECT(EDITOR_NAME)] } {
        set  PROJECT(EDITOR_NAME) xxx
    }

    if {$PROJECT(EDITOR_NAME) == "gvim"} {
	return [Gvim::isRunning]
    }

    if {$PROJECT(EDITOR_NAME) == "emacs"} {
	return [Emacs::isRunning]
    }

    return false;
}

proc jumpToPosition {position} {

    global PROJECT

    set pos [FileSupport::createRealPosition $position]

    set file_desc [FileSupport::getPositionFile $pos]

    set code [lindex $file_desc 0]

    if {$code == 0} {

	set message [lindex $file_desc 1]
	error_message $message
	return

    }

    if {$PROJECT(EDITOR_NAME) == "gvim"} {
	return [Gvim::jumpToPosition $pos]

    } elseif {$PROJECT(EDITOR_NAME) == "emacs"} {
	return [Emacs::jumpToPosition $pos]

    } else {
        set e "$PROJECT(EDITOR_[string toupper $PROJECT(EDITOR_NAME)])"
        set e [regsub -all "%f" $e [FileSupport::getPositionFile $pos]]
        set e [regsub -all "%l" $e [FileSupport::getPositionLine $pos]]
        set e [regsub -all "%c" $e [FileSupport::getPositionColumn $pos]]
        eval exec xterm -e $e &
    }
}

proc openNewFile {name} {

    global PROJECT

    if {$PROJECT(EDITOR_NAME) == "gvim"} {
	return [Gvim::openNewFile $name]

    } elseif {$PROJECT(EDITOR_NAME) == "emacs"} {
	return [Emacs::jumpToPosition "$name 0 0"]

    } else {
        set e "$PROJECT(EDITOR_[string toupper $PROJECT(EDITOR_NAME)])"
        set e [regsub -all "%f" $e $name]
        set e [regsub -all "%l" $e 0]
        set e [regsub -all "%c" $e 0]
        eval exec xterm -e $e &
    }
}

}

package provide Editor 1.0
