
##
# @file select_file_dialog.tcl
#
# @brief Definition of class select_dialog.
#

##
# @brief Definition of class select_file
#
package require BDWIwidgets

#catch "itcl::delete class ::select_file"
itcl::class select_file {
        inherit iwidgets::Fileselectiondialog

        ##
        # @brief Adds an entryfield
        #
        # @param n name of the component
        #
        # @param l entry label
        #
        method add_entry {n l} {
                itk_component add $n {
                        iwidgets::entryfield $itk_interior.$n\
                        -labeltext $l -textbackground white -labelpos nw \
                        -command "$this invoke OK"
                } {
                        keep -cursor -background
                }
                pack $itk_component($n) -fill x -expand true -side bottom
        }

        ##
        # @brief Adds an
        #
        # @param n name of the component
        #
        # @param l entry label
        #
        method add_checkbox {n l v state} {
                itk_component add $n {
                        checkbutton $itk_interior.$n -text $l \
                                -variable $v
                } {
                          keep -cursor -background
                }
                pack $itk_component($n) -side bottom -anchor nw
                if {$state} {
                        $itk_component($n) select
                } else {
                        $itk_component($n) deselect
                }
        }

        ##
        # @brief Gets the selection
        #
        # @return the selection
        #
        method get_selection {} {
                global checkvar
                set s [commands::extract_spaces [$this get]]
                if {[info exists checkvar] && $checkvar == 1} {
                        return [commands::make_related_path $s]
                }
                return [commands::make_absolute_path $s]
        }

        ##
        # @brief Gets the entry
        #
        # @return the contents of the entryfield
        #
        method get_entry {name} {
                return [$itk_component($name) get]
        }

        ##
        # @brief Sets the bindings
        #
        method set_bindings {} {
                set w [string replace $this 0 1]
                bind $w <Control-w> {
                        .[lindex [split %W .] 1] deactivate 0
                }
        }

        constructor {args} {
                set stdargs [list -modality application -height 400 \
                             -width 250 -textbackground white -filteron false]
                default 0
                hide 1
                set_bindings
                eval itk_initialize $stdargs $args
        }

        destructor {
        }
}

##
# @brief Sets settings for the Select Directory dialog
#
# @param checkbox if 1 then the checkbox will be selected, deselected otherwise
#
proc set_select_dir_settings {checkbox} {
        [.sd component fsb] component dirs configure -dblclickcommand {
                .sd component fsb filter
        }
        .sd add_checkbox ch "Relative" checkvar $checkbox
        .sd buttonconfigure OK -command {
                set d [.sd get_selection]
                if {$d == ""} {
                        error_message "The directory is not specified." .sd
                        return
                }
                # if {$d == "+"} {
                #         .sd deactivate 1
                #         return
                # }
                if {![file isdirectory [regsub "%" $d $env(BLUESPECDIR)]]} {
                        error_message "The file '$d' is not a directory." .sd
                        return
                }
                .sd deactivate 1
        }
}

##
# @brief Opens the "Select Directory" dialog
#
# @param checkbox if 1 then the checkbox will be selected, deselected
# otherwise, defaults to 0
#
proc select_dir {{checkbox 1}} {
        global BSPEC
        set dir $BSPEC(CURRENT_DIR)
        select_file .sd -title "Select Directory" -directory $dir \
                -fileson 0 -filetype directory
        set_select_dir_settings $checkbox
        focus -force .sd
        if {[winfo exists .po]} {
                set g [split [winfo geometry .po] "+"]
                wm geometry .sd "+[lindex $g 1]+[lindex $g 2]"
        } else {
                set g [split [winfo geometry $BSPEC(MAIN_WINDOW)] "+"]
                wm geometry .sd "+[lindex $g 1]+[lindex $g 2]"
        }
        wm minsize .sd 400 400
        if {[.sd activate]} {
                set d [.sd get_selection]
        } else {
                set d ""
        }
        itcl::delete object .sd
        return $d
}

##
# @brief Sets settings for the Select Makefile dialog
#
proc set_select_makefile_settings { {checkbox 1}} {

        .sf add_checkbox ch "Relative" checkvar $checkbox

        [.sf component fsb] component dirs configure -dblclickcommand {
                .sf component fsb filter
        }
        .sf buttonconfigure OK -command {
                if {[.sf get_selection] == ""} {
                        error_message "The makefile is not specified." .sf
                } else {
                        .sf deactivate 1
                }
        }
}

##
# @brief Opens the "Makefile" dialog
#
# TODO use tk_getOpenFile dialog
proc select_makefile {} {
        global env
        global PROJECT
        if {$PROJECT(NAME) != ""} {
                set dir $PROJECT(DIR)
        } else {
                set dir [pwd]
        }
        select_file .sf -title "Makefile" -directory $dir -fileson 1
        set_select_makefile_settings
        focus -force .sf
        set g [split [winfo geometry .po] "+"]
        wm geometry .sf "+[lindex $g 1]+[lindex $g 2]"
        wm minsize .sf 400 400
        if {[.sf activate]} {
                set d [.sf get_selection]
        } else {
                set d ""
        }
        itcl::delete object .sf
        return $d
}

proc check_open_project_settings {} {
        global PROJECT
        if {[.sf get_selection] == ""} {
                error_message "The project name is not specified." .sf
                return error
        }
        if {![file exists [.sf get_selection]]} {
                error_message "The specified file does not exist." .sf
                return error
        }
        if {[file extension [.sf get_selection]] != ".bspec"} {
                error_message "The specified file is not a project." .sf
                return error
        }
        if {$PROJECT(STATUS) == ""} {
                save_current 
                if {$PROJECT(STATUS) == ""} {
                        return error
                } 
        } 
        return ""
}

##
# @brief Opens the "Project->Open" dialog
#
proc create_project_open {} {
        global BSPEC
        global env
        global PROJECT
        if {$PROJECT(NAME) != ""} {
                set dir $PROJECT(DIR)
        } else {
                set dir $env(PWD)
        }
        select_file .sf -directory $dir -title "Open Project" \
                -fileslabel "Project" -mask "*.bspec"
        .sf component fsb component dirs configure -dblclickcommand {
                .sf component fsb filter
        }
        .sf buttonconfigure OK -command {
                if {[check_open_project_settings] == ""} {
                        .sf deactivate 1
                        commands::open_project [.sf get_selection] 
                }
        }
        set g [split [winfo geometry $BSPEC(MAIN_WINDOW)] "+"]
        wm geometry .sf "320x400+[lindex $g 1]+[lindex $g 2]"
        wm minsize .sf 300 400
        .sf activate
        itcl::delete object .sf
}

proc check_select_file_settings {} {
        if {[.sff get_selection] == ""} {
                error_message "The file name is not specified." .sff
                return error
        }
        .sff deactivate 1
}

##
# @brief Opens the "Select File" dialog
#
proc create_select_file {} {
        global BSPEC
        global PROJECT
        select_file .sff -directory $PROJECT(DIR) -title "Select File" \
                -fileslabel "File" -mask "*.*"
        .sff component fsb component dirs configure -dblclickcommand {
                .sff component fsb filter
        }
        .sff buttonconfigure OK -command {
                check_select_file_settings
        }
        set g [split [winfo geometry $BSPEC(IMPORT_BVI)] "+"]
        wm geometry .sff "320x400+[lindex $g 1]+[lindex $g 2]"
        wm minsize .sff 300 400
        if {[.sff activate]} {
                set s [.sff get_selection]
        } else {
                set s ""
        }
        itcl::delete object .sff
        return $s
}

## Local Variables:
## eval: (set (make-local-variable 'tcl-indent-level) 8)
## End:
