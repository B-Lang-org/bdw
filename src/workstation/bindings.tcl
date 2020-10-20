
##
# @file bindings.tcl
#
# @brief Bindings for the status-command window
#

##
# @brief Handles the Return button click
#
bind $eval(text) <Return> {+
    if {$BSPEC(BUILDPID) == "killed"} {
        set BSPEC(BUILDPID) ""
    }
    if {$BSPEC(BUILDPID) == "" || $BSPEC(BUILDPID) == "killed" } {
        status_command_window::eval_typed
    }
    break
}

##
# @brief Handles the Backspace button click
#
bind $eval(text) <BackSpace> {
        set eval(tab) new
        if {[%W tag nextrange sel 1.0 end] != ""} {
                %W delete sel.first sel.last
        } elseif {[%W compare insert > limit]} {
                %W delete insert-1c
                %W see insert
        }
        break
}

##
# @brief Handles the Up button click
#
bind $eval(text) <Up> {
        if {$eval(current) != 0} {
                status_command_window::show_command prev
        }
        break
}

bind $eval(text) <Prior> {
    [$eval(status) component text] yview scroll -1 pages
}

bind $eval(text) <Next> {
    [$eval(status) component text] yview scroll +1 pages
}


##
# @brief Handles the Down button click
#
bind $eval(text) <Down> {
        if {$eval(current) < [llength $BSPEC(HISTORY)] && \
                [llength $BSPEC(HISTORY)] != 0} {
                status_command_window::show_command next
        }
        break
}

##
# @brief Handles the Tab button click
#
bind $eval(text) <Tab> {
        status_command_window::switch_command
        break
}

##
# @brief Handles the Home button click
#
bind $eval(text) <Home> {
        $eval(text) mark set insert limit
        break
}


##
# @brief Handles the Insert button click
#
bind $eval(text) <Insert> {
        break
}

##
# @brief Handles Key button clicks
#
bind $eval(text) <Key> {
        set eval(tab) new
        if [%W compare insert < limit] {
                %W mark set insert end
        }
}

##
# @brief Handles the mouse double click on the status window
#
bind [$eval(status) gettext] <Double-1> {+
    set lc [$eval(status) index current]
    lassign [split $lc "."] l c
    set s [$eval(status) get $l.0 $l.end]

    commands::view_error_warning_source $s

    # Uncomment if we want to highlite position
    # [$eval(status) gettext] tag remove sel 0.0 end
    # eval [$eval(status) gettext] tag add sel pos
}

##
# @brief Handles Menuselect events
#
bind Menu <<MenuSelect>> {
        if {[string equal -length 3 "%W" ".bvi"]} {
                set istatus $helpVar
        }
        if {[string equal -length 3 "%W" ".mb"]} {
                set menustatus $helpVar
        }
        if {[string equal -length 3 "%W" ".pk"]} {
                set pstatus $helpVar
        }
        if {[string equal -length 3 "%W" ".tp"]} {
                set tstatus $helpVar
        }
        if {[string equal -length 3 "%W" ".md"]} {
                set mstatus $helpVar
        }
        if {[string equal -length 4 "%W" ".sch"]} {
                set sstatus $helpVar
        }
        if {[string equal -length 6 "%W" ".pw.mb"]} {
                set pwstatus $helpVar
        }
        if {[string equal -length 5 "%W" ".pw.h"]} {
                set pwstatus [%W entrycget active -label]
        }
        update idletasks
}

##
#  @brief Handles mouse enter event for the menu button
#
bind Menubutton <Enter> {+
        set text [%W cget -text]
        if {[string equal -length 3 "%W" ".bvi"]} {
                set istatus $text
        }
        if {[string equal -length 3 "%W" ".mb"]} {
                set menustatus $text
        }
        if {[string equal -length 3 "%W" ".pk"]} {
                set pstatus $text
        }
        if {[string equal -length 3 "%W" ".tp"]} {
                set tstatus $text
        }
        if {[string equal -length 3 "%W" ".md"]} {
                set mstatus $text
        }
        if {[string equal -length 4 "%W" ".sch"]} {
                set sstatus $text
        }
        if {[string equal -length 3 "%W" ".pw"]} {
                set pwstatus $text
        }
        update idletasks
}

##
# @brief Handles mouse leave event for the menu button
#
bind Menubutton <Leave> {+
        set istatus ""
        set menustatus ""
        set pstatus ""
        set tstatus ""
        set mstatus ""
        set sstatus ""
        set pwstatus ""
}

##
# @brief Handles the Copy(Ctrl-c) event
#
bind . <Control-c> {
        menu_actions::copy
}

##
# @brief Handles menu button left clicks
#
bind Menubutton <1> {+
        set text [%W cget -text]
        if {$text == "Edit"} {
                if {[catch "selection get"] != 1} {
                        main_window::change_menu_status edit copy normal
                } else {
                        main_window::change_menu_status edit copy disabled
                }
                if {[catch "clipboard get"] == 1} {
                        main_window::change_menu_status edit paste disabled
                } else {
                        main_window::change_menu_status edit paste normal
                }
        }
        update idletasks
}

##
#  @brief Handles mouse enter event for the menu button
#
bind Menubutton <Enter> {+
        set text [%W cget -text]
        if {$text == "Edit"} {
                if {[catch "selection get"] != 1} {
                        main_window::change_menu_status edit copy normal
                } else {
                        main_window::change_menu_status edit copy disabled
                }
                if {[catch "clipboard get"] == 1} {
                        main_window::change_menu_status edit paste disabled
                } else {
                        main_window::change_menu_status edit paste normal
                }
        }
        update idletasks
}
