
##
# @file selection_dialog.tcl
#
# @brief Definitions of selection dialog windows.
#

##
# @brief Definition of namespace base
#
namespace eval base {

package require Bluetcl

##
# @brief Definition of class selection_dialog.
#
itcl::class selection_dialog {
        inherit iwidgets::Selectiondialog

        ##
        # @brief Updates the selection list
        #
        # @param l the updated list
        #
        method update {l} {
                $this delete 0 end
                foreach i $l {
                        $this insert items end $i
                }
        }

        ##
        # @brief Returns the elements of the listbox indicated by the indexes.
        #
        # @param first index, may be a number, active, anchor, end, @x,y, or a
        # pattern.
        # @param last index, may be a number, active, anchor, end, @x,y, ora
        # pattern.
        #
        method get_index {first {last {}}}

        ##
        # @brief Adjusts the view such that the element given by index is
        # visible.
        #
        # @param index the specified node index
        #
        method see {index}

        ##
        # @brief Returnes the selection
        #
        # @return the selected item
        #
        method get_selection {} {
                set s [commands::extract_spaces [$this get]]
                return $s
        }

        ##
        # @brief Sets the arrow key bindings
        #
        method set_bindings {}

        constructor {args} {
                set stdargs [list \
                             -modality application  \
                             -hscrollmode dynamic -vscrollmode dynamic \
                             -selectioncommand "$this invoke OK" \
                             -dblclickcommand "$this invoke OK" \
                                ]
                hide Apply
                default OK
                set_bindings
                eval itk_initialize $stdargs $args
        }

        destructor {
        }
}

itcl::body selection_dialog::get_index {first {last {}}} {
        return [$itk_component(selectionbox) get_index $first $last]
}

itcl::body selection_dialog::see {index} {
        return [$itk_component(selectionbox) see $index]
}

itcl::body selection_dialog::set_bindings {} {
        set w [string replace $this 0 1]
        bind $w <Up> {
                set wi ".[lindex [split %W .] 1]"
                if {[$wi curselection] == ""} {
                        $wi selection set 0
                } else {
                        set next [expr [$wi curselection] - 1]
                        if {$next >= 0 && $next < [$wi size]} {
                                $wi selection clear 0 end
                                $wi selection set $next
                                $wi see $next
                        }
                }
        }
        bind $w <Down> {
                set wi ".[lindex [split %W .] 1]"
                if {[$wi curselection] == ""} {
                        $wi selection set 0
                } else {
                        set next [expr [$wi curselection] + 1]
                        if {$next >= 0 && $next < [$wi size]} {
                                $wi selection clear 0 end
                                $wi selection set $next
                                $wi see $next
                        }
                }
        }
        bind $w <Control-w> {
                .[lindex [split %W .] 1] deactivate 0
        }
}
}

##
# @brief Sets settings for the Select Module dialog
#
proc set_select_module_settings {} {
        global PROJECT
        global env
        set mlist ""
        foreach i [regsub -all "%" $PROJECT(PATHS) "$env(BLUESPECDIR)"] {
                set bafiles [lsort [glob -nocomplain -directory $i *.ba]]
                if {$bafiles == ""} continue;
                foreach f $bafiles {
                        lappend mlist [file rootname [file tail $f]]
                }
                lappend mlist "--------------------"
        }
        .lm update $mlist
        .lm buttonconfigure OK -command {
                check_module_selection
        }
}

proc check_module_selection {} {
        if {[.lm get_selection] == "--------------------"} {
                return
        }
        if {[.lm get_selection] == ""} {
                error_message "There is no selected module." .lm
                return
        }
        if {![commands::file_exists_in_search_paths "[.lm get_selection].ba"]} {
                error_message "The module '[.lm get_selection]' does not\
                        exist" .lm
                return
        }
        .lm deactivate 1
}

##
# @brief Creates the "Module->Load" dialog
#
# @return the selection or an empty string
#
proc select_module {} {
        global BSPEC
        base::selection_dialog .lm -title "Load Module" \
                -selectionlabel "Module"  -itemslabel "Modules"
        set_select_module_settings
        if {[winfo exists $BSPEC(MODULE_BROWSER)]} {
                set g [split [winfo geometry $BSPEC(MODULE_BROWSER)] "+"]
                wm geometry .lm "+[lindex $g 1]+[lindex $g 2]"
        } elseif {[winfo exists $BSPEC(SCHEDULE)]} {
                set g [split [winfo geometry $BSPEC(SCHEDULE)] "+"]
                wm geometry .lm "+[lindex $g 1]+[lindex $g 2]"
        }
        wm minsize .lm 200 400
        if {[.lm activate]} {
                set s [.lm get_selection]
        } else {
                set s ""
        }
        itcl::delete object .lm
        return $s
}

##
# @brief Sets the bindings for the Select Type dialog
#
proc set_select_type_bindings {} {
        bind .tl <Up> {
                set wi ".[lindex [split %W .] 1]"
                set next ""
                if {[llength [$wi curselection]] == 1} {
                        set next [expr [$wi curselection] - 1]
                        while {$next >= 0 && $next< [$wi size] && \
                        [lsearch [Bluetcl::bpackage list] [$wi get_index $next]] != -1} {
                                set next [expr $next - 1]
                        }
                } else {
                        set next 0
                        while {$next >= 0 && $next< [$wi size] && \
                        [lsearch [Bluetcl::bpackage list] [$wi get_index $next]] != -1} {
                                set next [expr $next + 1]
                        }
                }
                if {$next >= 0 && $next < [$wi size]} {
                        $wi selection clear 0 end
                        $wi see $next
                        $wi selection set $next
                        $wi clear selection
                        $wi insert selection 0 [commands::extract_spaces \
                        [lindex [.tl component selectionbox getcurselection] 0]]
                }
        }
        bind .tl <Down> {
                set wi ".[lindex [split %W .] 1]"
                set next ""
                if {[llength [$wi curselection]] == 1} {
                        set next [expr [$wi curselection] + 1]
                } else {
                        set next 0
                }
                while {$next >= 0 && $next< [$wi size] && \
                [lsearch [Bluetcl::bpackage list] [$wi get_index $next]] != -1} {
                        set next [expr $next + 1]
                }
                if {$next >= 0 && $next < [$wi size]} {
                        $wi selection clear 0 end
                        $wi see $next
                        $wi selection set $next
                        $wi clear selection
                        $wi insert selection 0 [commands::extract_spaces \
                        [lindex [.tl component selectionbox getcurselection] 0]]
                }
        }
}

##
# @brief Sets settings for the Select Type dialog
#
proc set_select_type_settings {} {
        set tlist ""
        foreach i [Bluetcl::browsepackage list 0] {
                foreach j [Bluetcl::browsepackage list [lindex $i 0]] {
                        if {[Bluetcl::bpackage types [lindex $j 1]] == ""} {
                                continue
                        } else {
                                lappend tlist [lindex $j 1]
                        }
                        foreach k [lsort [Bluetcl::bpackage types [lindex $j 1]]] {
                                lappend tlist "    $k"
                        }
                }
        }
        .tl update $tlist
        .tl configure -selectmode extended
        .tl buttonconfigure OK -command {
                if {[.tl get_selection] == ""} {
                        error_message "There is no selected type." .tl
                        return
                }
                .tl deactivate 1
        }
}

proc select_item {} {
        set s [.tl component selectionbox getcurselection]
        set sel {}
        foreach typ $s {
                set t [commands::extract_spaces $typ]
                if {$t != $typ} {
                        .tl selectitem
                        lappend sel $t
                } else {
                        .tl selection clear $typ
                }
        }
        .tl clear selection
        .tl insert selection 0 $sel
}

##
# @brief Creates the "Type->Add" dialog
#
# @return the selection/selections or an empty string
#
proc select_type {} {
        global BSPEC
        base::selection_dialog .tl -title "Select Type" \
                -selectionlabel "Type" -itemslabel "Types" \
                -itemscommand select_item
        set_select_type_settings
        set_select_type_bindings
        set g [split [winfo geometry $BSPEC(TYPE_BROWSER)] "+"]
        wm geometry .tl "+[lindex $g 1]+[lindex $g 2]"
        wm minsize .tl 200 400
        if {[.tl activate]} {
                foreach typ [.tl get_selection] {
                        set t [commands::extract_spaces $typ]
                        if {[catch "Bluetcl::type constr $t"] != 1} {
                                lappend s [Bluetcl::type constr $t]
                        } else {
                                lappend s $t
                        }
                }
        } else {
                set s ""
        }
        itcl::delete object .tl
        return $s
}

##
# @brief Checks settings for the Select Package dialog
#
proc check_package_selection {} {
        if {[.pl get_selection] == ""} {
                error_message "There is no selected package." .pl
                return
        }
        if {![commands::file_exists_in_search_paths "[.pl get_selection].bo"]} {
                error_message "The package '[.pl get_selection]' does \
                        not exist." .pl
                return
        }
        .pl deactivate 1
}

##
# @brief Checks settings for the Select Package dialog
#
proc set_select_package_settings {} {
        global PROJECT
        global env
        set plist ""
        foreach i [regsub -all "%" $PROJECT(PATHS) "$env(BLUESPECDIR)"] {
                set f [lsort [glob -nocomplain -directory $i *.bo]]
                if {$f == ""} {
                        continue
                }
                foreach i $f {
                        lappend plist [file rootname [file tail $i]]
                }
                lappend plist "--------------------"
        }
        .pl update $plist
        .pl buttonconfigure OK -command {
                check_package_selection
        }
}

proc select_package_item {} {
        if {[.pl component selectionbox getcurselection] != \
                "--------------------"} {
                .pl selectitem
        } else {
                .pl clear selection
                .pl selection clear [.pl curselection]
        }
}

proc set_select_package_bindings {} {
        bind .pl <Up> {+
                set wi ".[lindex [split %W .] 1]"
                if {[$wi component selectionbox getcurselection] == \
                        "--------------------"} {
                        set next [expr [$wi curselection] - 1]
                        $wi clear selection
                        $wi selection clear [$wi curselection]
                        if {$next >= 0 && $next < [$wi size]} {
                                $wi selection set $next
                                $wi see $next
                        }
                }
        }
        bind .pl <Down> {+
                set wi ".[lindex [split %W .] 1]"
                if {[$wi component selectionbox getcurselection] == \
                        "--------------------"} {
                        set next [expr [$wi curselection] + 1]
                        $wi selection clear [$wi curselection]
                        if {$next >= 0 && $next < [$wi size]} {
                                $wi selection set $next
                                $wi see $next
                        }
                }
        }
}

##
# @brief Creates the "Package->Load" dialog
#
# @return the selection or an empty string
#
proc select_package {} {
        global BSPEC
        base::selection_dialog .pl -title "Select Package" \
                -selectionlabel "Package" -itemslabel "Packages" \
                -itemscommand select_package_item
        set_select_package_settings
        set_select_package_bindings
        if {[winfo exists $BSPEC(PACKAGE)]} {
                set g [split [winfo geometry $BSPEC(PACKAGE)] "+"]
                wm geometry .pl "+[lindex $g 1]+[lindex $g 2]"
        } elseif {[winfo exists $BSPEC(TYPE_BROWSER)]} {
                set g [split [winfo geometry $BSPEC(TYPE_BROWSER)] "+"]
                wm geometry .pl "+[lindex $g 1]+[lindex $g 2]"
        }
        wm minsize .pl 200 400
        if {[.pl activate]} {
                set s [.pl get_selection]
        } else {
                set s ""
        }
        itcl::delete object .pl
        return $s
}

##
# @brief Checks top file selection
#
# @return true if selected file is a project file, false otherwise.
#
proc check_top_file_settings {} {
        global BSPEC
        if {[.tf get_selection] == ""} {
                error_message "The top file is not specified." .tf
                return false
        } elseif {[lsearch -regexp $BSPEC(FILES) [.tf get_selection]] == -1} {
                error_message "The file '[.tf get_selection]' is not a \
                        project file" .tf
                return false
        }
        return true
}

##
# @brief Creates the "Top File" dialog
#
# @return the selection or an empty string
#
proc select_top_file {} {
        global BSPEC
        base::selection_dialog .tf -title "Top File" -selectionlabel "File" \
		-itemslabel "Project files"
        set plist ""
        foreach i $BSPEC(FILES) {
                lappend plist [lindex $i 1]
        }
        .tf update $plist
        .tf buttonconfigure OK -command {
                if {[check_top_file_settings]} {
                        .tf deactivate 1
                }
        }
        focus -force .tf
        set g [split [winfo geometry .po] "+"]
        wm geometry .tf "+[lindex $g 1]+[lindex $g 2]"
        wm minsize .tf 200 400
        if {[.tf activate]} {
                set s [.tf get_selection]
        } else {
                set s ""
        }
        itcl::delete object .tf
        return $s
}


## Local Variables:
## eval: (set (make-local-variable 'tcl-indent-level) 8)
## End:
