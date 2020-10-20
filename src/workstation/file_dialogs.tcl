
##
# @file file_dialogs.tcl
#
# @brief Definition of "File->New" and "File->Save As" dialog windows.
#

##
# Definition of class create_file_dialog
#
itcl::class create_file_dialog {
        inherit base::selection_dialog

        ##
        # @brief Checks file location settings
        #
        method check_location_settings {}

        ##
        # @brief Checks file name settings
        #
        method check_name_settings {}

        ##
        # @brief Checks current settings
        #
        method check_settings {}

        ##
        # @brief Gets current settings
        #
        method get_settings {}

        ##
        # @brief Adds an entryfield
        #
        # @param n name of the component
        #
        # @param l entry label
        #
        method add_entry {n l}

        ##
        # @brief Gets the entry
        #
        # @param name the name of the entryfield
        #
        # @return the contents of the entryfield
        #
        method get_entry {name} {
                return [commands::extract_spaces [$itk_component($name) get]]
        }

        constructor {args} {
                lappend args -itemslabel "Search Paths" \
                        -selectionlabel "Selected directory"
                add_entry ent "File name"
                eval itk_initialize $args
        }

        destructor {
        }
}

itcl::body create_file_dialog::check_location_settings {} {
        if {[get_selection] == ""} {
                error_message "The path is not specified." \
                        [string replace $this 0 1]
                return false
        } 
        set al [commands::make_absolute_path [get_selection]]
        set rl [commands::make_related_path [get_selection]]
        set l [component selectionbox component items get 0 end]
        if {![file isdirectory [get_selection]]} {
                error_message "The path '[get_selection]' does not exist." \
                        [string replace $this 0 1]
                return false
        }
        if {[lsearch $l $al] == -1 && [lsearch $l $rl] == -1} {
                set s "The path '[get_selection]' is not \
                        in the project search paths"
                if {![ignore_warning $s   [string replace $this 0 1]]} {
                        return false
                }
        }
        return true
}

itcl::body create_file_dialog::check_name_settings {} {
        if {[get_entry ent] == ""} {
                error_message "The file name is not specified." \
                        [string replace $this 0 1]
                return false
        }
        if {[regexp {\s} [get_entry ent]]} {
                error_message "The file name should not contain any spaces." \
                        [string replace $this 0 1]
                return false
        }
        return true
}

itcl::body create_file_dialog::check_settings {} {
        if {![check_name_settings]} {
                return false
        }
        if {![check_location_settings]} {
                return false
        }
        return true
}

itcl::body create_file_dialog::get_settings {} {
        set f [get_entry ent]
        if {[file extension $f] == ""} {
                set f $f.bsv
        }
        return [get_selection]/$f 
}

itcl::body create_file_dialog::add_entry {n l} {
        itk_component add $n {
                iwidgets::entryfield $itk_interior.$n\
                -labeltext $l -textbackground white \
                -labelpos nw -command "$this invoke OK"
        } {
                keep -cursor -background
        }
        pack $itk_component($n) -fill x -expand true -side bottom
}

##
# @brief Create the "File->New" dialog
#
proc create_file_new {} {
        global BSPEC
        global PROJECT
        set path $PROJECT(PATHS)
        foreach i $BSPEC(LIBRARIES) {
                set path [regsub $i $path ""]
        }
        create_file_dialog .fn -title "File New"
        .fn update $path
        .fn buttonconfigure OK -command {
                if {[.fn check_settings]} {
                        .fn deactivate 1
                        commands::new_file [.fn get_settings]
                }
        }
        set g [split [winfo geometry $BSPEC(PROJECT)] "+"]
        wm geometry .fn "+[lindex $g 1]+[lindex $g 2]"
        wm minsize .fn 200 400
        .fn activate
        itcl::delete object .fn
}

##
# @brief Creates the "File->Save_As" dialog
#
proc create_file_save_as {} {
        global BSPEC
        global PROJECT
        set path $PROJECT(PATHS)
        foreach i $BSPEC(LIBRARIES) {
                set path [regsub $i $path ""]
        }
        create_file_dialog .fs -title "File Save As"
        .fs update $path
        .fs buttonconfigure OK -command {
                if {[.fs check_settings]} {
                        .fs deactivate 1
                        commands::save_file_as [.fs get_settings]
                }
        }
        set g [split [winfo geometry $BSPEC(PROJECT)] "+"]
        wm geometry .fs "+[lindex $g 1]+[lindex $g 2]"
        wm minsize .fs 200 400
        .fs activate
        itcl::delete object .fs
}

## Local Variables:
## eval: (set (make-local-variable 'tcl-indent-level) 8)
## End:
