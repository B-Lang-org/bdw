
##
# @file analysis_commands.tcl
#
# @brief Definition of Tcl commands.
#

##
# @brief Namespace for Tcl commands.
#
namespace eval commands {

package require Bluetcl
package require utils 1.0
package require SignalTypes 
package require FileSupport

##
# @brief Returns the contents of the specified tag from the given list
#
# @param list tagged list
# @param tag the name of the tag
#
# @return the contents of the tag
#
proc get_tag_from_list {list tag} {
        set t [lindex [lindex $list [lsearch -regexp $list $tag]] 1]
        return $t
}

##
# @brief Shows the position information in the specified window
#
# @param wnd the window name
# @param pos list containing the position information
#
proc show_position {wnd pos} {
        $wnd issue "\nPosition" HED
        $wnd issue "File    : [FileSupport::getPositionFile $pos]" INFO
        $wnd issue "Line    : [FileSupport::getPositionLine $pos]" INFO
        $wnd issue "Column  : [FileSupport::getPositionColumn $pos]" INFO
}

##
# @brief Loads package with given name 
#
# @param p name of package   
#
proc load_package {p} {
        global BSPEC
        start_load
        set c "Bluetcl::bpackage load $p"
        if {[catch $c log]} {
                puts stderr "\n$log"
        } else {
                update_load_package_status
                commands::display_command_results $log
        }
        if {[winfo exists $BSPEC(PACKAGE)]} {
                commands::show_package_window
                $BSPEC(PACKAGE_HIERARCHY) configure\
                        -querycommand "package_window::get_items %n"
                package_window::change_menu_status package \
                        {load_package reload search refresh} normal
                package_window::change_menu_status view collapseall normal
        }
        finish_load
        if {[winfo exists $BSPEC(TYPE_BROWSER)]} {
                type_browser::change_menu_status types add normal
        }
        if {[winfo exists $BSPEC(PACKAGE)] && $BSPEC(PACKAGE_HIERARCHY) != ""} {
                expand_loaded_package $p
        }
}

proc update_load_package_status {} {
    global BSPEC
    set BSPEC(LOADED_PACKAGES) "[llength [Bluetcl::bpackage list]] packages"
}

##
# @brief Expands the specified node of the package hierarchy
#
# @param name name of the node
#
proc expand_node {name} {
        global PACKAGE
        global BSPEC        
        set id [lindex [lindex $PACKAGE(NODES) [lsearch -regexp \
                $PACKAGE(NODES) $name]] 0]
        if {$id != ""} {
                $BSPEC(PACKAGE_HIERARCHY) expand $id
        }
}

##
# @brief Expands the recently loaded package
#
# @param package the name of the package
#
proc expand_loaded_package {package} {
        global PROJECT
        global env
        set d ""
        foreach i [regsub -all "%" $PROJECT(PATHS) "$env(BLUESPECDIR)"] {
                if {[file exists "$i/$package.bo"]} {
                        set d [regsub "$env(BLUESPECDIR)" $i "%"]
                        break
                }
        }
        expand_node $d
        expand_node $package
}

##
# @brief Checks if the specified file exists in the search paths
#
# @param file URL of the file to be searched
# @return true if the file exists in the search paths, false otherwise
#
proc file_exists_in_search_paths {file} {
        global PROJECT
        global env
        foreach i [regsub -all "%" $PROJECT(PATHS) $env(BLUESPECDIR)] {
                if {[file exists "$i/$file"]} {
                        return true
                }
        }
        return false
}

##
# @brief Reloads all loaded packages 
#
proc reload_packages {} {
        global BSPEC
        start_load
        set plist [Bluetcl::bpackage list]
        Bluetcl::bpackage clear
        set loaded [Bluetcl::bpackage list]
        utils::listToSet Loaded $loaded
        foreach i $plist {
                if { ! [info exists Loaded($i)] } {
                        if {[file_exists_in_search_paths "$i.bo"]} {
                                update
                                if {[catch "Bluetcl::bpackage load $i" err] } {
                                        puts stderr $err
                                } else {
                                        utils::listToSet Loaded $err
                                }
                        }
                }
        }
        commands::display_command_results [Bluetcl::bpackage list]
        if { $BSPEC(PACKAGE_HIERARCHY) != "" } {
                $BSPEC(PACKAGE_HIERARCHY) configure\
                        -querycommand "package_window::get_items %n"
                package_window::change_menu_status view \
                        {expand collapse totype source} disabled
        }
        finish_load
}

##
# @brief Refreshes the package hierarchy 
#
proc package_refresh {} {
        global BSPEC
        if {![winfo exists $BSPEC(PACKAGE)]} {
                return
        }
        $BSPEC(PACKAGE_HIERARCHY) configure\
                -querycommand "package_window::get_items %n"
        package_window::change_menu_status view \
                {expand collapse totype source} disabled
}

##
# @brief Select/Deselect the node in the Import Hierarchy
#
# @param t the most recently selected node
# @param s if 1/0 then selected/deselected
#
proc import_hierarchy_select_node {t s} {
        global BSPEC
        if {!$s} {
                $BSPEC(IMPORT_HIERARCHY) selection clear
                $BSPEC(IMPORT_HIERARCHY) selection add $t
                $BSPEC(IMPORT_HIERARCHY) see "$t.first"
        } else {
                $BSPEC(IMPORT_HIERARCHY) selection clear
        }
}

##
# @brief Sets the arrow key bindings for Import Hierarchy 
# 
proc import_hierarchy_set_bindings {} {
        global BSPEC
        bindtags .id [list $BSPEC(IMPORT_HIERARCHY) .id . all]
}

##
# @brief Shows the imports hierarchy for the specified package 
# in a separate window
#
# @param k the key of specified package
#
proc import_hierarchy {k} {
        global BSPEC
        global PACKAGE
        if {![winfo exists .id]} {
                base::dialog .id -title "Import Hierarchy" 
                .id configure -modality none 
                .id buttonconfigure OK -text Close\
                                -command {itcl::delete object .id}
                .id hide Cancel 
                set d [.id childsite]
                base::hierarchy $d.h \
                -selectcommand "commands::import_hierarchy_select_node %n %s"\
                -querycommand "package_window::get_depend %n" -expanded false
                pack $d.h -side left -expand yes -fill both
                set BSPEC(IMPORT_HIERARCHY) $d.h
                wm geometry .id 300x400+300+200 
                wm minsize .id 300 400
                commands::import_hierarchy_set_bindings
        }
        set PACKAGE(SELECTION) [get_tag_from_list $PACKAGE(NODES) $k]
#        $BSPEC(IMPORT_HIERARCHY) configure -querycommand \
#                "package_window::get_depend %n"
        .id activate
}

##
# @brief Updates search variables if the search pattern has changed
#
# @param pattern the pattern to be searched
#
proc update_search_pattern {pattern} {
        global PACKAGE
        if {$PACKAGE(SEARCH) != $pattern} {
                set PACKAGE(SEARCH) $pattern
                set PACKAGE(SEARCH_ID) -1
        } 
}

##
# @brief Searches for the specified pattern through the package hierarchy
# 
# @param pattern pattern to be searched
# @param type either Next or Prev
#
proc search_in_packages {pattern type} {
        global PACKAGE
        set res [Bluetcl::browsepackage search $pattern]
        update_search_pattern $pattern
        if {$res != ""} {
                if {$type == "Next"} {
                        incr PACKAGE(SEARCH_ID)
                        if {$PACKAGE(SEARCH_ID) >= [llength $res]} {
                                set PACKAGE(SEARCH_ID) 0
                        }
                } else {
                        set PACKAGE(SEARCH_ID) [expr $PACKAGE(SEARCH_ID) - 1]
                        if {$PACKAGE(SEARCH_ID) < 0} {
                                set PACKAGE(SEARCH_ID) [expr [llength $res] - 1]
                        }
                } 
                set cur [lindex $res $PACKAGE(SEARCH_ID)]
                foreach i $cur {
                        package_expand [lindex $i 0]
                }
                package_window::select_node [lindex [lindex $cur end] 0] 0
        }
}

##
# @brief Shows information related to selected component in the right pane      # of Package Browser window. 
# 
# @param k unique id of construct 
#
proc get_package_comp_info {k} {
        global PACKAGE
        set info [Bluetcl::browsepackage detail $k]
        $PACKAGE(INFO) clear
        get_info $info $PACKAGE(INFO)
        $PACKAGE(INFO) see 1.1
}

##
# @brief Expands the node of Package Browser tree-view.  
# 
# @param k unique id of construct 
#
proc package_expand {k} { 
        global BSPEC
        $BSPEC(PACKAGE_HIERARCHY) expand $k
}

##
# @brief Collapse the node of Package window tree-view.
#
# @param k unique id of construct 
#
proc package_collapse {k} {
        global BSPEC
        $BSPEC(PACKAGE_HIERARCHY) collapse $k
}

##
# @brief Collapse the package hierarchy.  
#
proc package_collapse_all {} {
        global BSPEC
        $BSPEC(PACKAGE_HIERARCHY) configure \
        -querycommand "package_window::get_items %n"
}

##
# @brief Represents information for selected type in the right pane of 
# the Type Browser window. 
#
# @param k unique key for specified type
#
proc package_view_type {k} {
        global PACKAGE
        set t [Bluetcl::type constr [get_tag_from_list $PACKAGE(NODES) $k]]
        show_type_browser_window
        commands::add_type $t
}

##
# @brief Launch the editor on the definition of specified construct in the
# Package window. 
#
# @param k the key of construct in the package hierarchy 
#
proc package_view_source {k} {
        set info [Bluetcl::browsepackage detail $k]
        set p [get_tag_from_list $info "position"]
        if {$p != ""} {
                commands::edit_file $p
        } else {
	    puts stderr "Cannot determine source file position for this \
                        item"
        }
}

##
# @brief Adds the specified type to the Type Browser window. 
#
# @param n name of the type
#
proc add_type {n} {
        global BSPEC
        if {[lsearch $BSPEC(TYPES) $n] == -1} {
                lappend BSPEC(TYPES) $n
        }
        commands::display_command_results $BSPEC(TYPES)
        show_type_browser_window
        $BSPEC(TYPE_HIERARCHY) configure \
                -querycommand "type_browser::get_items %n"
        while {[$BSPEC(TYPE_HIERARCHY) get_pending] != ""} {
                update
        }
        set n [lindex [lindex [Bluetcl::browsetype list 0] end] 0] 
        if {$n != ""} {
                type_expand $n
                type_browser::select_node $n 0
        }
}

##
# @brief Removes information for specified type from the Type Browser window. 
#
# @param t unique key for specified type
#
proc remove_type {t} { 
        global BSPEC
        set i [lsearch $BSPEC(TYPES) $t]  
        set BSPEC(TYPES) [lreplace $BSPEC(TYPES) $i $i]
        commands::display_command_results $BSPEC(TYPES)
        $BSPEC(TYPE_HIERARCHY) configure \
               -querycommand "type_browser::get_items %n"
}

##
# @brief Shows the specified information in the specified window
#
# @param info the list with tagged information
# @param win the name of the window
#
proc get_info {info win} {
        foreach i $info {
                set d [lindex $i 1]
                if {[lindex $i 0] == "position" && $d != ""} {
                    show_position $win $d
                        break
                }
                $win issue [lindex $i 0] HED
                if {$d != ""} {
                        foreach j $d {
                                $win issue $j INFO
                        }
                }
                $win issue "" INFO
        }
}

##
# @brief Shows information for specified type in the right pane of Type Browser
# window. 
#
# @param k unique key for specified type
#
proc get_type_info {k} {
        global TYPE
        $TYPE(INFO) clear
        set info [Bluetcl::browsetype detail $k]
        get_info $info $TYPE(INFO)
        $TYPE(INFO) see 1.1
}

##
# @brief Expands the node of Type Browser tree-view.
#
# @param k unique id of construct 
#
proc type_expand {k} {
        global BSPEC
        $BSPEC(TYPE_HIERARCHY) expand $k
}

##
# @brief Collapse the node of Type Browser tree-view. 
#
# @param k key of the node which should be collapsed 
#
proc type_collapse {k} { 
        global BSPEC
        $BSPEC(TYPE_HIERARCHY) collapse $k
}

##
# @brief Collapse the hierarchical view to show only type list. 
#
proc type_collapse_all {} {
        global BSPEC
        $BSPEC(TYPE_HIERARCHY) configure \
        -querycommand "type_browser::get_items %n"
}

##
# @brief Launch the editor on the definition of specified type in the
# BDW Type Browser window.
#
# @param k the key of type in the hierarchy 
#
proc type_view_source {k} {
        set info [Bluetcl::browsetype detail $k]
        set p [get_tag_from_list $info "position"]
        if {$p != ""} {
	    commands::edit_file $p
        } else {
	    puts stderr "Cannot determine source file position for this \
                        item"
        }
}

##
# @brief Shows the loaded module in the currently active windows
#
proc show_module { afterLoadModule } {
        global BSPEC
        global PROJECT
        if {[winfo exists $BSPEC(SCHEDULE)]} {
                if {$BSPEC(MODULE) != ""} {
                        wm title $BSPEC(SCHEDULE) \
                             "Schedule Analysis$BSPEC(TITLE)  -  $BSPEC(MODULE)"
                } else {
                        wm title $BSPEC(SCHEDULE) \
                                "Schedule Analysis$BSPEC(TITLE)"
                }
                commands::get_schedule
                schedule_analysis::change_menu_status module \
                        {reload set_modul close} normal
                schedule_analysis::change_menu_status module source disabled
        }
}

proc start_load {} {
        set_cursors watch
}

proc finish_load {} {
        set_cursors ""
}
proc set_cursors { cur } {
        . configure -cursor $cur
        foreach w [winfo children .] {
                $w configure -cursor $cur
        }
        update
}

##
# @brief Loads the specified module. 
#
# @param n name of module to be loaded 
#
proc load_module {n} {
        global BSPEC
        global PROJECT
        start_load
        if {[winfo exists $BSPEC(SCHEDULE)]} {
                schedule_analysis::delete_sub_menus
        }
        switch -exact $PROJECT(COMP_BSC_TYPE) {
                "bluesim" {catch "Bluetcl::flags set -sim"}
                "verilog" {catch "Bluetcl::flags set -verilog"}
                default   {puts  stderr "-sim or -verilog has not be set \
                        properly: $PROJECT(COMP_BSC_TYPE)"}
        }
        set BSPEC(MODULE) $n
        commands::fetch_schedule_info clear
        if {[catch "Bluetcl::module load $BSPEC(MODULE)" err]} {
                puts stderr $err
                set BSPEC(MODULE) ""
        } else {
                set BSPEC(LOADED_MODULES) \
                        "[llength [Bluetcl::module list]] modules"
                if {$PROJECT(COPY_FLAGS)} {
			catch "Bluetcl::flags reset" errs
			catch "eval [concat [list Bluetcl::flags set] [Bluetcl::module flags $BSPEC(MODULE) all]]" errs
		}
                commands::display_command_results $err
        }
        if {$BSPEC(MODULE) != ""} {
                show_module 1
                # the module's package is also loaded
                update_load_package_status
        }
        if {[winfo exists $BSPEC(SCHEDULE)]} {
                schedule_analysis::add_sub_menus
        }
        finish_load
}

##
# @brief Reloads the loaded module in the Module Brower window. 
#
proc reload_module {} {
        global BSPEC
        # new modules should require new packages.
        start_load
        commands::fetch_schedule_info clear
        if {![file_exists_in_search_paths "$BSPEC(MODULE).ba"]} {
                set BSPEC(MODULE) ""
                Bluetcl::module clear
                Bluetcl::bpackage clear
        }
        if {$BSPEC(MODULE) != ""} {
                Bluetcl::module clear
                Bluetcl::bpackage clear
                load_module $BSPEC(MODULE)
        }
        commands::display_command_results [Bluetcl::bpackage list]
        commands::display_command_results [Bluetcl::module list]
        finish_load
}

proc set_module {m} {
    global BSPEC
    set loaded [Bluetcl::module list]
    if { [lsearch  -exact $loaded $m] >= 0 } {
        set BSPEC(MODULE) $m
        show_module 0
    } else {
        puts stderr "Module $m is not loaded, please use load module"
    }
}


##
# @brief Opens the Schedule Analysis window.  
#
proc show_schedule {} {
        commands::show_schedule_analysis_window
        commands::get_schedule
}


##
# @brief Displays schedule information for specified module in the Schedule     # Analysis window
#
proc get_schedule {} {
        global SCHEDULE
        commands::get_schedule_warnings
        commands::get_execution_order
        $SCHEDULE(HIERARCHY) configure \
        -querycommand "schedule_analysis::get_items %n"
}

##
# @brief Displays warnings occurred during scheduling in the Schedule Analysis  # window. 
#
proc get_schedule_warnings {} { 
        global SCHEDULE 
        global BSPEC
        $SCHEDULE(WARNINGS) clear
        if {$BSPEC(MODULE) != ""} {
                set info [concat [Bluetcl::schedule warnings $BSPEC(MODULE)] \
                                 [Bluetcl::schedule errors $BSPEC(MODULE)]]
                if { $info != "" } {
                        foreach w $info {
                                set code [lindex $w 1]
                                set msg  [lindex $w 2]
                                $SCHEDULE(WARNINGS) issue $code WARNING
                                $SCHEDULE(WARNINGS) issue $msg INFO
                        }
                } else {
                        set info "\nThere are no schedule warnings \
                                in module '$BSPEC(MODULE)'"
                        $SCHEDULE(WARNINGS) issue $info INFO
                }
                commands::display_command_results $info
                $SCHEDULE(WARNINGS) see 1.1
        }
}

##
# @ brief Displays rules and methods in the Rule Order and Rule Relations
# panes of the Schedule Analysis window.
#
proc get_execution_order {} {
        schedule_analysis::get_rules
}

##
# @brief Shows the predicate information for the rule
#
# @param predicate the rule predicate information
#
proc get_rule_predicate {predicate} {
        global SCHEDULE
        $SCHEDULE(RULE_INFO) issue "Predicate" HED
        $SCHEDULE(RULE_INFO) issue $predicate EXPR
        commands::display_command_results $predicate
}

##
# @brief Shows methods for the rule  
#
# @param methods methods for the specified rule
#
proc get_rule_methods {methods} {
        global SCHEDULE
        set predms [lindex $methods 0]
        set bodyms [lindex $methods 1]

        $SCHEDULE(RULE_INFO) issue "\nMethods called in predicate" HED
        foreach i $predms {
                $SCHEDULE(RULE_INFO) issue $i INFO
        }
        commands::display_command_results $predms

        $SCHEDULE(RULE_INFO) issue "\nMethods called in body" HED
        foreach i $bodyms {
                $SCHEDULE(RULE_INFO) issue $i INFO
        }
        commands::display_command_results $bodyms
}

##
# @brief Show blocking rules
#
# @param rules the blocking rules
#
proc get_blocking_rules {rules} {
        global SCHEDULE
        $SCHEDULE(RULE_INFO) issue "\nBlocking rules" HED
        foreach i $rules {
                $SCHEDULE(RULE_INFO) issue $i INFO
        }
        commands::display_command_results $rules
}

##
# @brief Displays the predicate, blocking rules and method calls 
# for the specified rule in the right pane of Rule order 
# perspective of Schedule Analysis window. 
#
# @param rule name of the rule 
#
proc get_rule_info {rule} {
        global SCHEDULE
        global BSPEC 
        $SCHEDULE(RULE_INFO) clear
        $SCHEDULE(RULE_INFO) issue "$rule\n" HED
        set info [Bluetcl::rule full $BSPEC(MODULE) $rule]
        set b [Bluetcl::schedule urgency $BSPEC(MODULE)]
        get_rule_predicate [get_tag_from_list $info "predicate"]
        get_rule_methods [get_tag_from_list $info "methods"]
        get_blocking_rules [get_tag_from_list $b $rule]
        set pos [get_tag_from_list $info "position"]
        if {$pos != ""} {
                show_position $SCHEDULE(RULE_INFO) $pos
        }
        $SCHEDULE(RULE_INFO) see 1.1
}

proc fetch_schedule_info {cmd} {
        global BSPEC
        global SCHEDULE
        switch $cmd {
                check {
                        if { ![info exists SCHEDULE(FULL,$BSPEC(MODULE))] } {
                                set SCHEDULE(FULL,$BSPEC(MODULE)) [lsort -index 0 [Bluetcl::submodule full $BSPEC(MODULE)]]
                        }
                        return $SCHEDULE(FULL,$BSPEC(MODULE))
                }
                clear {
                        array unset SCHEDULE "FULL,*"
                }
        }
        return [list]
}

##
# @brief Shows information for the selected instance in the method hierarchy
#
# @param name name of the instance
#
proc get_instance_info {name} {
        global BSPEC
        global SCHEDULE
        set l [commands::fetch_schedule_info check]
        set m [lindex $l $name]
        $SCHEDULE(METHOD_INFO) issue "Module" HED
        $SCHEDULE(METHOD_INFO) issue [lindex $m 1] INFO
        set p [get_tag_from_list $m "position"]
        if {$p != ""} {
                show_position $SCHEDULE(METHOD_INFO) $p
        }
}

##
# @brief Shows rules which use the method in their predicate
#
# @param info the information to display
#
proc get_rules_with_meth_in_pred {info} {
        global SCHEDULE
        $SCHEDULE(METHOD_INFO) issue "Rules which use the method \
        in their predicate" HED
        foreach i $info {
                $SCHEDULE(METHOD_INFO) issue $i INFO
        }
}

##
# @brief Shows rules which use the method in their body
#
# @param info the information to display
#
proc get_rules_with_meth_in_body {info} {
        global SCHEDULE
        $SCHEDULE(METHOD_INFO) issue "\nRules which use the method \
        in their body" HED
        foreach i $info {
                $SCHEDULE(METHOD_INFO) issue $i INFO
        }
}

##
# @brief Shows submodules which use the method in their instances
#
# @param info the information to display
#
proc get_submods_with_meth_in_inst {info} {
        global SCHEDULE
        $SCHEDULE(METHOD_INFO) issue "\nSubmodules which use the method \
        in their instantiations" HED
        foreach i $info {
                $SCHEDULE(METHOD_INFO) issue $i INFO
        }
}

##
# @brief Shows information for the selected method in the method hierarchy
#
# @param name name of the method
#
proc get_methods_info {name} {
        global SCHEDULE
        global BSPEC
        set l [commands::fetch_schedule_info check]
        set i [lindex [lindex $SCHEDULE(METHODS) $name] 1] 
        set m [lindex [lindex $l $i] 3]
        set mthd [lindex [lindex $SCHEDULE(METHODS) $name] 0]
        foreach i [lrange $m 1 end] {
                if {[lsearch -exact $i $mthd] != -1} {
                        set m $i
                        break
                }
        }
        get_rules_with_meth_in_pred [lindex $m 1]
        get_rules_with_meth_in_body [lindex $m 2]
        get_submods_with_meth_in_inst [lindex $m 3]
}

##
# @brief Displays list of rules which contain the call of specified method. 
#
# @param name name of the method 
#
proc get_method_info {name} {
        global SCHEDULE
        $SCHEDULE(METHOD_INFO) clear
        if {[lindex [lindex $SCHEDULE(METHODS) $name] 1] == "instance"} {
                get_instance_info $name
        } else {
                get_methods_info $name
        }
        $SCHEDULE(METHOD_INFO) see 1.1
}

##
# @brief Launches the editor on the definition of the specified rule
#
# @param rule rule name 
#
proc rule_view_source {rule} {
        global BSPEC
        set info [Bluetcl::rule full $BSPEC(MODULE) $rule]
        set f [get_tag_from_list $info "position"]
        if {$f != ""} {
	    commands::edit_file $f
        } else {
	    puts stderr "Cannot determine source file position for this \
                        item"
        }
}

##
# @brief Launches the editor on the definition of the specified method
#
# @param mthd method name 
#
proc method_view_source {mthd} {
        global BSPEC
        set l [commands::fetch_schedule_info check]
        set info [lindex $l $mthd]
        set f [get_tag_from_list $info "position"]
        if {$f != ""} {
	    commands::edit_file $f
        } else {
                puts stderr "Cannot determine source file position for this \
                        item"
        }
}

##
# @brief Displays relations for given pair of rules in the Rule relationsâ
# perspective of the Schedule Analysis window. 
#
# @param rule1 name of first rule 
# @param rule2 name of second rule 
#
proc get_rule_relations {rule1 rule2} {
        global BSPEC
        global SCHEDULE
        set rel [list]
        foreach r1 $rule1 {
                if {[lsearch [Bluetcl::schedule execution $BSPEC(MODULE)] $r1] == -1} {
                        error_message "$r1 is not a rule of $BSPEC(MODULE)\
                                module" $BSPEC(SCHEDULE)
                        return
                }
                foreach r2 $rule2 {
                        if {[lsearch [Bluetcl::schedule execution $BSPEC(MODULE)] $r2] \
                                        == -1} {
                                error_message "$r2 is not a rule of \
                                        $BSPEC(MODULE) module" $BSPEC(SCHEDULE)
                                return
                        }
                        lappend rel "[Bluetcl::rule rel $BSPEC(MODULE) $r1 $r2]"
                }
        }
        set rel [join $rel "\n"]
        $SCHEDULE(RULE_REL) clear
        $SCHEDULE(RULE_REL) issue $rel INFO
        $SCHEDULE(RULE_REL) see 1.1
        commands::display_command_results $rel
}

##
# @brief Launches the editor on the definition of the specified error/warning 
#
# @param s the error/warning line in the messagebox 
# e.g. 'Warning: "Switch.bsv", line 37, column 20: (S0015)'
#   During elaboration of `mkTb' at "Tb.bsv", line 27, column 8.'
#
proc view_error_warning_source {s} {
        set f ""
        set l 0
        set c 0

        if { [regexp {(?:(?:Error:)|(?:Warning:)|(?:at)) \"(.*)\"(?:, line ([0-9]+)(?:, column ([0-9]+))?)?} $s m f l c] } {
                #puts "XXX $s -- $f $l $c"
                if { [file exists $f] } {
                        commands::edit_file [FileSupport::createPosition $f $l $c]
                }
        }
        return ""
}


##
# @brief Catches the errors generated by the given command.
#
# @param c the command.
#
# Used as wrapper for user added commands to the tool bar.
# executes the command in the secondary interp so the behavior remains identical
# between command line and tool bar added commands.
proc handle_command {c {n ""}} {        
        global BSPEC
        global eval
        if {[catch {$eval(sinterp) eval $c} err]} {
                error_message "User Customization Command:\n$c\n\n$err"
        }
}

# End of namespace commands
}


## Local Variables:
## eval: (set (make-local-variable 'tcl-indent-level) 8)
## End:
