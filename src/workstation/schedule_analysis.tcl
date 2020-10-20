##
# @file schedule_analysis.tcl
#
# @brief Definition of Schedule Analysis Window.
#

## TODO Change the structure of the class not to use global variables 

global SCHEDULE

##
# @brief The name of the tabnotebook 
#
set SCHEDULE(TABNOTEBOOK) ""

##
# @brief The name of the message-box in the Warnings tab 
#
set SCHEDULE(WARNINGS) ""

##
# @brief The name of the message-box in the "Rule Order" tab 
#
set SCHEDULE(RULE_INFO) ""

##
# @brief The name of the scrolled-listbox in the "Rule Order" tab 
#
set SCHEDULE(RULES) ""

##
# @brief The name of the hierarchy widget in the "Method Call" tab
#
set SCHEDULE(HIERARCHY) ""

##
# @brief The number of the rule
#
set SCHEDULE(UID) 0

##
# @brief A list which contains lists with rule name and type 
#
set SCHEDULE(METHODS) ""

##
# @brief The name of the message-box in the "Method Call" tab 
#
set SCHEDULE(METHOD_INFO) ""

##
# @brief The name of the message-box in the "Rule Relations" tab 
#
set SCHEDULE(RULE_REL) ""

##
# @brief The name of the "Rule 1" scrolled-listbox
#
set SCHEDULE(RULE1) ""

##
# @brief The name of the "Rule 2" scrolled-listbox
#
set SCHEDULE(RULE2) ""

package require Bluetcl

##
# @brief Definition of class schedule_analysis
#
itcl::class schedule_analysis {
        inherit itk::Toplevel

        ##
        # @brief The name "Rule Relations" tab
        #
        variable rule ""

        ##
        # @brief The list of rules 
        #
        common rule_list {}

        ##
        # @brief Removes all information from Schedule Analysis Window
        #
        proc clear {}

        ##
        # @brief Changes the menu status for the Schedule Analysis window
        #
        # @param m name of the menu item
        # @param n the list of menu action ids from the "m" menu
        # @param st the status of menu action
        #
        proc change_menu_status {m n st}

        ##
        # @brief Changes the item menu status for the Schedule Analysis window
        #
        # @param n the name of menu action from item menu
        # @param st the status of menu action
        #
        proc change_item_menu_status {n st}

        ##
        # @brief Closes the Schedule Analysis Window
        #
        method close {}

        ##
        # @brief Gets rules and methods for the currently loaded module
        #
        proc get_rules {}

        ##
        # @brief Shows the relation for the currently selected rules in the
        # Rule Relation tab
        #
        proc show_rule_rel {}

        ##
        # @brief Loads the top module
        #
        proc module_load_top {}

        ##
        # @brief Loads a module
        #
        proc module_load {}

        ##
        # @brief Reloads a module
        #
        proc module_reload {}

        ##
        # @brief Launches the editor on the definition of the selected rule
        #
        proc module_source {}

        ##
        # @brief Set the browser to a module that has been loaded.
        #
        # @param m the module to be set
        #
        proc set_module {m}

        ##
        # @brief Shows information for the selected rule in the Rule Order tab
        #
        proc select_rule {}

        ##
        # @brief Select/Deselect the node
        #
        # @param t the most recently selected node in the Method Call tab
        #
        proc method_dblclick_node {t}

        ##
        # @brief Function to be called when selecting tab
        # in the Schedule Analysis window
        #
        # @param t the number of the tab
        #
        proc select_tab {t}

        ##
        # @brief Returns the list of instances for the currently loaded module
        #
        # @return the list of instances
        #
        proc get_instances {}

        ##
        # @brief Returns methods for the selected instance in the Method Call
        # tab
        #
        # @param n name of the instance
        #
        # @return list of methods
        #
        proc get_methods {n}

        ##
        # @brief creates the method hierarchy
        #
        # @param n the most recently selected node
        #
        proc get_items {n}

        ##
        # @brief Selects/Deselects node in the method hierarchy
        #
        # @param t the id of the node
        # @param s 0/1 if selected/not selected
        # @param p the parent window
        #
        proc select_node {t s p}

        ##
        # @brief Selects/Deselects node in the Rules Order tab of Schedule
        # Analysis window
        #
        # @param side the side to move the selection up/down
        proc move_rules_up_down {side}

        ##
        # @brief Adds submenus to Module->Set module menu item
        #
        proc add_sub_menus {}

        ##
        # @brief Deletes submenus from Module->Set module menu item
        #
        proc delete_sub_menus {}

        ##
        # @breif Selects all rules in Rule 1 pane
        #
        # @param d name of the dialog window
        #
        proc rule1_select_all {d}

        ##
        # @breif Clears all rules in Rule 1 pane
        #
        # @param d name of the dialog window
        #
        proc rule1_clear_all {d}

        ##
        # @breif Selects all rules in Rule 2 pane
        #
        # @param d name of the dialog window
        #
        proc rule2_select_all {d}

        ##
        # @breif Clears all rules in Rule 2 pane
        #
        # @param d name of the dialog window
        #
        proc rule2_clear_all {d}

        ##
        # @breif Selects rules in Rule 1 pane which match the filter
        #
        # @param d name of the dialog window
        #
        proc rule1_select_match {d}

        ##
        # @breif Clears rules in Rule 1 pane which match the filter
        #
        # @param d name of the dialog window
        #
        proc rule1_clear_match {d}

        ##
        # @breif Selects rules in Rule 2 pane which match the filter
        #
        # @param d name of the dialog window
        #
        proc rule2_select_match {d}

        ##
        # @breif Clears rules in Rule 2 pane which match the filter
        #
        # @param d name of the dialog window
        #
        proc rule2_clear_match {d}

        ##
        # @brief Enables/disables menu items of Module menu
        #
        proc open_module_menu {}

        ##
        # @brief Enables/disables menu items of Scheduling Graphs menu
        #
        proc open_scheduling_graphs_menu {}

        ##
        # @breif Adds rules to checkboxes
        #
        method add_rules {rule}

        ##
        # @breif Returnes the list of filtered rules in Rule 1 pane
        #
        method get_filter_rule1 {} {
                return [$itk_component(rule1_filter_entry) get]
        }

        ##
        # @breif Returnes the list of filtered rules in Rule 2 pane
        #
        method get_filter_rule2 {} {
                return [$itk_component(rule2_filter_entry) get]
        }

        ##
        # @breif Clears all rules from the checkboxes
        #
        method clear_rules {}

        method exportinfo {} {
            global BSPEC
            global SCHEDULE
            set tab "warnmsg"
            set fn "schedule_info.txt"
            switch [$itk_component(tab) view] {
                0  {
                    set tab "warnmsg"
                    set fn "$BSPEC(MODULE)_schedule_warnings.txt"
                }
                1  {
                    set tab "ruleinfomsg"
                    set rl [$SCHEDULE(RULES) getcurselection]
                    set fn "${rl}_rule_info.txt"
                }
                2  {
                    set tab "methodinfomsg"
                    set m [$SCHEDULE(HIERARCHY) selection get]
                    set hk [lindex $SCHEDULE(METHODS) $m]
                    set type [lindex $hk 1]
                    if { $type == "instance" } {
                        set m [lindex $hk 0]
                    } else {
                        set m [lindex $SCHEDULE(METHODS) $type 0]
                        set m "${m}_[lindex $hk 0]"
                    }
                    set fn "${m}_method_info.txt"
                }
                3  {
                    set tab "rulerelmsg"
                    set fn "$BSPEC(MODULE)_rule_relation.txt"
                }
            }
            set mb $itk_component($tab)
            set types {
                {{Text Files}       {.txt}        }
                {{All Files}        *             }
            }

            set f [tk_getSaveFile  -minsize "450 200" \
                       -filetypes $types \
                       -initialfile "$fn" \
                      -title "Save Schedule Information as" \
                      -parent $itk_component(hull) ]
            if { $f != "" } {
                $mb export $f
                puts "$f has been created"
            }
        }

        private {
                ##
                # @brief Creates menubar of the Schedule Analysis window
                #
                method create_menubar {}

                ##
                # @brief Creates the Module menu
                #
                method create_module_menu {}

                ##
                # @brief Creates the Scheduling Graph menu
                #
                method create_scheduling_graph_menu {}

                ##
                # @brief Creates statusbar of the Schedule Analysis window
                #
                method create_statusbar {}

                ##
                # @brief Creates tabnotebook of the Schedule Analysis window
                #
                method create_tabnotebook {}

                ##
                # @brief Creates tab for warnings representation
                #
                method create_warnings_tab {}

                ##
                # @brief Creates rules list pane for the rule order tab
                #
                method create_rules_list {}

                ##
                # @brief Creates info pane for the rule order tab
                #
                method create_rule_info_window {}

                ##
                # @brief Creates tab for rule order representation
                #
                method create_rule_order_tab {}

                ##
                # @brief Creates the method hierarchy
                #
                method create_method_hierarchy {}

                ##
                # @brief Creates info pane for the method call tab
                #
                method create_method_info_window {}

                ##
                # @brief Creates tab for method call representation
                #
                method create_method_call_tab {}

                ##
                # @brief Creates tab for rule relatuions representation
                #
                method create_rule_rel_tab {}

                ##
                # @brief Creates pane for rule 1
                #
                method create_rule1_pane {}

                ##
                # @brief Creates pane for rule 1
                #
                method create_rule2_pane {}

                ##
                # @breif Creates the filter entry in Rule 1 pane
                #
                method create_rule1_filter {}

                ##
                # @breif Creates the filter entry in Rule 2 pane
                #
                method create_rule2_filter {}

                ##
                # @breif Creates the "Clear" and "Analyse" buttons
                #
                method create_rule_rel_but {}

                ##
                # @brief Sets the arrow key bindings for Schedule Analysis
                # Window
                #
                method set_bindings {}
        }

        constructor {args} {
                create_menubar
                create_tabnotebook
                create_statusbar
                set_bindings
                eval itk_initialize $args
        }

        destructor {}
}

itcl::body schedule_analysis::get_instances {} {
        global BSPEC
        global SCHEDULE
        if {$BSPEC(MODULE) == ""} {
               return ""
        }
        set inst ""
        set l [commands::fetch_schedule_info check]
        foreach i $l {
                lappend inst [list $SCHEDULE(UID) [lindex $i 0]]
                lappend SCHEDULE(METHODS) [list [lindex $i 0] instance]
                incr SCHEDULE(UID)
        }
        return $inst
}

itcl::body schedule_analysis::get_methods {n} {
        global BSPEC
        global SCHEDULE
        if {[lindex [lindex $SCHEDULE(METHODS) $n] 1] != "instance"} {
                return ""
        }
        set mthd ""
        set l [commands::fetch_schedule_info check]
        set m [lindex [lindex $l $n] 3]
        for {set i 1} {$i < [llength $m]} {incr i} {
                lappend mthd [list $SCHEDULE(UID) [lindex [lindex $m $i] 0]]
                lappend SCHEDULE(METHODS) [list [lindex [lindex $m $i] 0] $n ]
                incr SCHEDULE(UID)
        }
        return $mthd
}

itcl::body schedule_analysis::get_items {n} {
        global SCHEDULE
        set rlist ""
        if {$n == ""} {
                set SCHEDULE(UID) 0
                set SCHEDULE(METHODS) ""
                $SCHEDULE(METHOD_INFO) clear
                set rlist [get_instances]
        } else {
                set rlist [get_methods $n]
        }
        return $rlist
}

itcl::body schedule_analysis::select_node {t s p} {
        global BSPEC
        global SCHEDULE
        if {!$s} {
                $p selection clear
                $p selection add $t
                $p see "$t.first"
                commands::get_method_info $t
                change_menu_status module source disabled
                change_item_menu_status View_Source disabled
                if {[lindex [lindex $SCHEDULE(METHODS) $t] 1] == "instance"} {
                        set l [commands::fetch_schedule_info check]
                        set m [lindex $l $t]
                        if {[lsearch -regexp $m "position"] != -1} {
                            change_menu_status module source normal
                            change_item_menu_status View_Source normal
                        }
                }
        } else {
            $p selection clear
            change_menu_status module source disabled
            change_item_menu_status View_Source disabled
        }
}

itcl::body schedule_analysis::select_rule {} {
        global SCHEDULE
        if {[$SCHEDULE(RULES) getcurselection] != ""} {
                commands::get_rule_info [$SCHEDULE(RULES) getcurselection]
            change_menu_status module source normal
        }
}

itcl::body schedule_analysis::method_dblclick_node {t} {
        commands::method_view_source $t
}

itcl::body schedule_analysis::create_menubar {} {
        itk_component add menu {
                base::menubar $itk_interior.menu -helpvariable helpVar \
                        -cursor ""
        } {
                keep -activebackground -cursor
        }
        create_module_menu
        create_scheduling_graph_menu
        pack $itk_component(menu) -fill x
}

itcl::body schedule_analysis::create_module_menu {} {
        $itk_component(menu) add menubutton module -text "Module" \
        -underline 0 -menu {
                options -tearoff false -postcommand \
                        "schedule_analysis::open_module_menu"
                command load_top -label "Load Top Module" -underline 5 \
                        -helpstr "Loads the Top Module" -state normal \
                        -command schedule_analysis::module_load_top
                command load -label "Load ..." -underline 0 \
                        -helpstr "Opens the Select Module dialog" \
                        -state normal -command schedule_analysis::module_load
                command reload -label "Reload" -underline 0 \
                        -helpstr "Reloads the currently loaded module" \
                        -state disabled \
                        -command schedule_analysis::module_reload
                cascade set_modul -label "Set module" -underline 4 \
                        -helpstr  "Sets the specifed module" \
                        -state disabled -menu {
                                options -tearoff false
                        }
                command source -label "View source" -underline 0 \
                        -helpstr "Search for a string" -state disabled \
                        -command schedule_analysis::module_source
                command export -label "Export Information ..." -underline 1 \
                    -helpstr "Export selected information to file" -state disabled
                command close -label "Close" -underline 0 \
                        -helpstr "Close the Schedule analysis window" \
                    -state normal
        }

    $itk_component(menu) menuconfigure module.close -command [itcl::code $itk_interior close]
    $itk_component(menu) menuconfigure module.export -command [itcl::code $itk_interior exportinfo]
    add_sub_menus
}

itcl::body schedule_analysis::create_scheduling_graph_menu {} {
        $itk_component(menu) add menubutton scheduling_graphs \
        -text "Scheduling Graphs" -underline 0 -menu {
                options -tearoff false -postcommand \
                        "schedule_analysis::open_scheduling_graphs_menu"
                command conflict -label "Conflict" -underline 0 \
                        -helpstr "Opens the Conflict Graph window" \
                        -state normal \
                        -command menu_actions::activate_conflict_graph
                command exec -label "Execution Order" -underline 0 \
                        -helpstr "Opens the Execution Graph window" \
                        -state normal \
                        -command menu_actions::activate_execution_graph
                command urgency -label "Urgency" -underline 0 \
                        -helpstr "Opens the Urgency Graph window" \
                        -state normal \
                        -command menu_actions::activate_urgency_graph
                command combined -label "Combined" -underline 2 \
                        -helpstr "Opens the Coombined Graph window" \
                        -state normal \
                        -command menu_actions::activate_combined_graph
                command combined_full -label "Combined Full" -underline 9 \
                        -helpstr "Opens the Coombined Full Graph window" \
                        -state normal \
                        -command menu_actions::activate_combined_full_graph
        }
}

itcl::body schedule_analysis::create_tabnotebook {} {
        global SCHEDULE
        global BSPEC
        itk_component add tab {
                base::tabnotebook $itk_interior.tab
        } {
                keep -cursor -background
        }
        $itk_component(tab) configure -tabpos n
        pack $itk_component(tab) -fill both -expand yes
        create_warnings_tab
        create_rule_order_tab
        create_method_call_tab
        create_rule_rel_tab
        $itk_component(tab) select 0
        if {$BSPEC(MODULE) != ""} {
                commands::get_schedule
        }
        set SCHEDULE(TABNOTEBOOK) $itk_component(tab)
}

itcl::body schedule_analysis::create_warnings_tab {} {
        global SCHEDULE
        set warn [$itk_component(tab) add_label "Warnings" \
                "schedule_analysis::select_tab 0"]
        itk_component add warnmsg {
            base::messagebox $warn.mb
        } { }
        $warn.mb add_type INFO white black bscInfoFont
        $warn.mb add_type WARNING white red bscInfoHeadingFont
        [$warn.mb gettext] tag raise sel
        pack $warn.mb -fill both -expand yes
        set SCHEDULE(WARNINGS) $warn.mb
}

itcl::body schedule_analysis::create_rule_order_tab {} {
        set ord [$itk_component(tab) add_label "Rule Order" \
                "schedule_analysis::select_tab 1"]
        itk_component add opane {
                base::panedwindow $ord.opane
        } { }
        create_rules_list
        create_rule_info_window
        $itk_component(opane) configure -orient vertical
        $itk_component(opane) fraction 40 60
        pack $itk_component(opane) -fill both -expand yes
}

itcl::body schedule_analysis::create_rules_list {} {
        global SCHEDULE
        $itk_component(opane) add "left" -margin 0 -minimum 50
        set l [$itk_component(opane) childsite "left"]
        pack $l -padx 0 -pady 0 -fill both -expand yes -side top
        iwidgets::scrolledlistbox $l.lb -textbackground white \
                -width 300 -textfont bscTextFont \
                -selectioncommand {schedule_analysis::select_rule} \
                -dblclickcommand "schedule_analysis::module_source"
        pack $l.lb -expand yes -fill both
        set SCHEDULE(RULES) $l.lb
}

itcl::body schedule_analysis::create_rule_info_window {} {
        global SCHEDULE
        $itk_component(opane) add "right" -margin 0 -minimum 50
        set r [$itk_component(opane) childsite "right"]
        pack $r -padx 0 -pady 0 -fill both -expand yes -side top
        itk_component add ruleinfomsg {
            base::messagebox $r.mb
        } { }
        $r.mb add_type INFO
        $r.mb add_type HED white black bscInfoHeadingFont
        $r.mb add_type EXPR white black bscFixedFont
        [$r.mb gettext] tag raise sel
        pack $r.mb -fill both -expand yes
        set SCHEDULE(RULE_INFO) $r.mb
}

itcl::body schedule_analysis::create_method_call_tab {} {
        set mcall [$itk_component(tab) add_label "Method Call" \
                "schedule_analysis::select_tab 2"]
        itk_component add mpane {
                base::panedwindow $mcall.mpane
        } 
        create_method_hierarchy
        create_method_info_window
        $itk_component(mpane) configure -orient vertical
        $itk_component(mpane) fraction 40 60
        pack $itk_component(mpane) -fill both -expand yes
}

itcl::body schedule_analysis::create_method_hierarchy {} {
        global SCHEDULE
        $itk_component(mpane) add "left" -margin 0 -minimum 50
        set l [$itk_component(mpane) childsite "left"]
        pack $l -padx 0 -pady 0 -fill both -expand yes -side top
        base::hierarchy $l.h -querycommand "schedule_analysis::get_items %n" \
                -selectcommand "schedule_analysis::select_node %n %s $l.h" \
                -dblclickcommand "schedule_analysis::method_dblclick_node %n"
        pack $l.h -side left -expand yes -fill both
        $l.h add_itemmenu "View_Source" "{schedule_analysis::module_source}"
        set SCHEDULE(HIERARCHY) $l.h
}

itcl::body schedule_analysis::create_method_info_window {} {
        global SCHEDULE
        $itk_component(mpane) add "right" -margin 0 -minimum 50
        set r [$itk_component(mpane) childsite "right"]
        pack $r -padx 0 -pady 0 -fill both -expand yes -side top
        itk_component add methodinfomsg {
            base::messagebox $r.mb
        } { }
        $r.mb add_type INFO
        $r.mb add_type HED white black bscInfoHeadingFont
        [$r.mb gettext] tag raise sel
        pack $r.mb -fill both -expand yes
        set SCHEDULE(METHOD_INFO) $r.mb
}

itcl::body schedule_analysis::create_rule_rel_tab {} {
        global SCHEDULE
        set rule [$itk_component(tab) add_label "Rule Relations" \
                              "schedule_analysis::select_tab 3"]
        itk_component add rpane {
                base::panedwindow $rule.pane -sashindent 30
        }
        create_rule1_pane
        create_rule2_pane
        $itk_component(rpane) configure -orient vertical
        $itk_component(rpane) fraction 50 50
        pack $itk_component(rpane) -fill both -expand true
        canvas $rule.sp1 -width 2000 -height 1
        $rule.sp1 create line 0 1 2000 1 -fill black
        pack $rule.sp1 -pady 1 -padx 5
        create_rule_rel_but
        itk_component add rulerelmsg {
            base::messagebox $rule.mb -height 10
        } { }
        $rule.mb add_type INFO
        [$rule.mb gettext] tag raise sel
        pack $rule.mb -fill both -expand yes
        set SCHEDULE(RULE_REL) $rule.mb
}

itcl::body schedule_analysis::create_rule1_pane {} {
        global SCHEDULE
        $itk_component(rpane) add "left" -margin 0 -minimum 50
        set r [$itk_component(rpane) childsite "left"]
        itk_component add rule1 {
                base::scrolledcheckbox $r.rule1 -labeltext "Rule 1" \
                        -labelpos nw -canvbackground white
        }
        pack $itk_component(rule1) -side top -expand true -fill both
        set SCHEDULE(RULE1) $itk_component(rule1)
        itk_component add rule1_buttons {
                frame $r.buts
        }
        pack $itk_component(rule1_buttons) -side bottom -fill x -pady 2
        itk_component add rule1_select_all {
                button $itk_component(rule1_buttons).select -text "Select All" \
                        -command [list schedule_analysis::rule1_select_all $this]
        }
        pack $itk_component(rule1_select_all) -side left -padx 10
        itk_component add rule1_clear_all {
                button $itk_component(rule1_buttons).clear -text "Clear All" \
                        -command [list schedule_analysis::rule1_clear_all $this]
        }
        pack $itk_component(rule1_clear_all) -side right -padx 10
        create_rule1_filter
}

itcl::body schedule_analysis::create_rule1_filter {} {
        set r [$itk_component(rpane) childsite "left"]
        itk_component add rule1_filter_but {
                frame $r.r1filter_but
        }
        pack $itk_component(rule1_filter_but) -side bottom -fill x
        itk_component add rule1_clear_match {
                button $itk_component(rule1_filter_but).clear -text \
                        "Clear matching" -command \
                        [list schedule_analysis::rule1_clear_match $this]
        }
        pack $itk_component(rule1_clear_match) -side right -padx 10
        itk_component add rule1_select_match {
                button $itk_component(rule1_filter_but).select -text \
                        "Select matching" -command \
                        [list schedule_analysis::rule1_select_match $this]
        }
        pack $itk_component(rule1_select_match) -side left -padx 10
        itk_component add rule1_filter_entry {
                iwidgets::entryfield $r.r1entry -labeltext "Filter by regex" \
                        -textbackground white -labelpos w
        } {
                keep -cursor -background
        }
        pack $itk_component(rule1_filter_entry) -side left -expand true -padx 20
}

itcl::body schedule_analysis::create_rule2_pane {} {
        global SCHEDULE
        $itk_component(rpane) add "right" -margin 0 -minimum 50
        set r [$itk_component(rpane) childsite "right"]
        itk_component add rule2 {
                base::scrolledcheckbox $r.rule2 -labeltext "Rule 2" \
                        -labelpos nw -canvbackground white
        }
        pack $itk_component(rule2) -side top -expand true -fill both
        set SCHEDULE(RULE2) $itk_component(rule2)
        itk_component add rule2_buttons {
                frame $r.buts
        }
        pack $itk_component(rule2_buttons) -side bottom -fill x -pady 2
        itk_component add rule2_select_all {
                button $itk_component(rule2_buttons).select -text "Select All" \
                        -command [list schedule_analysis::rule2_select_all $this]
        }
        pack $itk_component(rule2_select_all) -side left -padx 10
        itk_component add rule2_clear_all {
                button $itk_component(rule2_buttons).clear -text "Clear All" \
                        -command [list schedule_analysis::rule2_clear_all $this]
        }
        pack $itk_component(rule2_clear_all) -side right -padx 10
        create_rule2_filter
}

itcl::body schedule_analysis::create_rule2_filter {} {
        set r [$itk_component(rpane) childsite "right"]
        itk_component add rule2_filter_but {
                frame $r.r2filter_but
        }
        pack $itk_component(rule2_filter_but) -side bottom -fill x
        itk_component add rule2_clear_match {
                button $itk_component(rule2_filter_but).clear -text \
                        "Clear matching" -command \
                        [list schedule_analysis::rule2_clear_match $this]
        }
        pack $itk_component(rule2_clear_match) -side right -padx 10
        itk_component add rule2_select_match {
                button $itk_component(rule2_filter_but).select -text \
                        "Select matching" -command \
                        [list schedule_analysis::rule2_select_match $this]
        }
        pack $itk_component(rule2_select_match) -side left -padx 10
        itk_component add rule2_filter_entry {
                iwidgets::entryfield $r.r2entry -labeltext "Filter by regex" \
                        -textbackground white -labelpos w
        } {
                keep -cursor -background
        }
        pack $itk_component(rule2_filter_entry) -side left -expand true -padx 20
}

itcl::body schedule_analysis::create_rule_rel_but {} {
        itk_component add rule_rel_buttons {
                frame $rule.buts
        }
        pack $itk_component(rule_rel_buttons) -fill x -pady 2

        itk_component add rule_rel_clear {
                frame $itk_component(rule_rel_buttons).cbut
        }
        pack $itk_component(rule_rel_clear) -fill x -side left
        itk_component add rule_clear {
                button $itk_component(rule_rel_clear).clear \
                        -text "Clear" -command {$SCHEDULE(RULE_REL) clear}
        }
        pack $itk_component(rule_clear) -side right -padx 30

        itk_component add rule_rel_analyse {
                frame $itk_component(rule_rel_buttons).abut
        }
        pack $itk_component(rule_rel_analyse) -fill x -side right
        itk_component add rule_analyse {
                button $itk_component(rule_rel_analyse).analyse -text "Analyse"\
                -command schedule_analysis::show_rule_rel
        }
        pack $itk_component(rule_analyse) -side left -padx 30
}

itcl::body schedule_analysis::select_tab {t} {
        global SCHEDULE
        global BSPEC
        switch -exact $t {
                0 {
                        change_menu_status module source disabled
                        change_menu_status module export normal
                }
                1 {
                        if {[$SCHEDULE(RULES) getcurselection] != ""} {
                            change_menu_status module source normal
                        } else {
                            change_menu_status module source disabled
                        }

                }
                2 {
                    change_menu_status module source disabled
                        if {[$SCHEDULE(HIERARCHY) selection get] != ""} {
                            set l [commands::fetch_schedule_info check]
                            set m [lindex $l [$SCHEDULE(HIERARCHY) selection get]]
                            if {[lsearch -regexp $m "position"] != -1} {
                                change_menu_status module source normal
                            }
                        }
                }
                3 {
                        change_menu_status module source disabled
                        change_menu_status module export normal
                        $SCHEDULE(RULE1) configure -hscrollmode dynamic
                        $SCHEDULE(RULE2) configure -hscrollmode dynamic
                }
        }

}

itcl::body schedule_analysis::add_sub_menus {} {
        global BSPEC
        set s "$BSPEC(SCHEDULE).menu"
        foreach m [lsort [Bluetcl::module list]] {
                if {[$s index .module.set_modul.$m] == -1} {
                        $s add_command .module.set_modul.$m "$m" 0 \
                        "Module $m" "schedule_analysis::set_module $m" normal
                }
        }
}

itcl::body schedule_analysis::delete_sub_menus {} {
        global BSPEC
        set s "$BSPEC(SCHEDULE).menu"
        foreach m [lsort [Bluetcl::module list]] {
                if {[$s index .module.set_modul.$m] != -1} {
                        $s delete .module.set_modul.$m
                }
        }
}

itcl::body schedule_analysis::set_bindings {} {
        global BSPEC
        global SCHEDULE
        bindtags $BSPEC(SCHEDULE) [list $BSPEC(SCHEDULE) \
                $SCHEDULE(HIERARCHY) . all]
        bind $BSPEC(SCHEDULE) <Left> {
              if {$BSPEC(MODULE) != ""} {
                        set hier $SCHEDULE(HIERARCHY)
                        if {[$SCHEDULE(TABNOTEBOOK) view] == 2 && \
                                [$hier selection get] != ""} {
                                if {![$hier expanded [$hier selection get]]} {
                                        set s [$hier selection get]
                                        set p [$hier _getParent $s]
                                        if {$p != ""} {
                                              $hier collapse $p
                                              schedule_analysis::select_node \
                                                        $p 0 $hier
                                        }
                                } else {
                                        set s [$hier selection get]
                                        $hier collapse $s
                                        schedule_analysis::select_node $s 0 \
                                                $hier
                                }
                        }
                }
        }
        bind $BSPEC(SCHEDULE) <Right> {
              if {$BSPEC(MODULE) != ""} {
                        set hier $SCHEDULE(HIERARCHY)
                        if {[$SCHEDULE(TABNOTEBOOK) view] == 2 && \
                                        [$hier selection get] != ""} {
                                set s [$hier selection get]
                                set c [$hier _contents $s]
                                if {$c != ""} {
                                        $hier selection clear
                                        $hier expand $s
                                        schedule_analysis::select_node \
                                                [lindex $c 0] 0 $hier
                                }
                        }
                }
        }
        bind $BSPEC(SCHEDULE) <Up> {
              if {$BSPEC(MODULE) != ""} {
                        set hier $SCHEDULE(HIERARCHY)
                        if {[$SCHEDULE(TABNOTEBOOK) view] == 2} {
                                if {[$hier selection get] != ""} {
                                        set s [$hier selection get]
                                        set dn [$hier get_displayed_nodes]
                                        set ns [expr [lsearch $dn $s] - 1]
                                        if {$ns >= 0} {
                                                schedule_analysis::select_node \
                                                        [lindex $dn $ns] 0 $hier
                                        }
                                } else {
                                        schedule_analysis::select_node 0 0 $hier
                                }
                        } elseif {[$SCHEDULE(TABNOTEBOOK) view] == 1} {
                                schedule_analysis::move_rules_up_down up
                        }
                }
        }
        bind $BSPEC(SCHEDULE) <Down> {
              if {$BSPEC(MODULE) != ""} {
                        set hier $SCHEDULE(HIERARCHY)
                        if {[$SCHEDULE(TABNOTEBOOK) view] == 2} {
                                if {[$hier selection get] != ""} {
                                        set s [$hier selection get]
                                        set dn [$hier get_displayed_nodes]
                                        set ns [expr [lsearch $dn $s] + 1]
                                        if {$ns < [llength $dn]} {
                                                schedule_analysis::select_node \
                                                        [lindex $dn $ns] 0 $hier
                                        }
                                } else {
                                        schedule_analysis::select_node 0 0 $hier
                                }
                        } elseif {[$SCHEDULE(TABNOTEBOOK) view] == 1} {
                                schedule_analysis::move_rules_up_down down
                        }
                }
        }
        bind [$SCHEDULE(WARNINGS) gettext] <Double-1> {+
                set err [$SCHEDULE(WARNINGS) gettext]
                set x [expr %X - [winfo rootx $err]]
                set y [expr %Y - [winfo rooty $err]]
                set i [$err index @$x,$y]
                set s [$err get "$i linestart" "$i lineend"]
                commands::view_error_warning_source $s
        }
        bind $BSPEC(SCHEDULE) <Control-w> {
            $BSPEC(SCHEDULE) close
        }
}

itcl::body schedule_analysis::move_rules_up_down {side} {
        global SCHEDULE
        if {[$SCHEDULE(RULES) curselection] != ""} {
                if {$side == "down"} {
                        set ns [expr [$SCHEDULE(RULES) curselection] + 1]
                } elseif {$side == "up"} {
                        set ns [expr [$SCHEDULE(RULES) curselection] - 1]
                }
                if {$ns >= 0 && $ns < [$SCHEDULE(RULES) size]} {
                       $SCHEDULE(RULES) selection clear 0 end
                       $SCHEDULE(RULES) selection set $ns
                       schedule_analysis::select_rule
                       $SCHEDULE(RULES) see "$ns"
                }
        } else {
               $SCHEDULE(RULES) selection set 0
               schedule_analysis::select_rule
        }
}

itcl::body schedule_analysis::get_rules {} {
        global SCHEDULE
        global BSPEC
        $SCHEDULE(RULES) clear
        $SCHEDULE(RULE_INFO) clear
        $SCHEDULE(RULE_REL) clear
        if {$BSPEC(MODULE) != ""} {
                set rules [Bluetcl::schedule execution $BSPEC(MODULE)]
                foreach i $rules {
                        $SCHEDULE(RULES) insert end $i
                }
                $BSPEC(SCHEDULE) add_rules [lsort $rules]
                commands::display_command_results $rules
        }
}

itcl::body schedule_analysis::show_rule_rel {} {
        global BSPEC
        global PROJECT
        global SCHEDULE
        set r1 [list]
        set r2 [list]
        if {$PROJECT(NAME) == ""} {
                error_message "There is no open project." $BSPEC(SCHEDULE)
                return
        }
        if {$BSPEC(MODULE) == ""} {
		error_message "There is no Module loaded." $BSPEC(SCHEDULE)
		return
	}
        if {[$SCHEDULE(RULE1) get] == ""} {
                error_message "There is no selected rule in Rule 1" \
                        $BSPEC(SCHEDULE)
                return
        }
        if {[$SCHEDULE(RULE2) get] == ""} {
                error_message "There is no selected rule in Rule 2" \
                        $BSPEC(SCHEDULE)
                return
        }
        foreach i [$SCHEDULE(RULE1) get] {
                lappend r1 [lindex $rule_list $i]
        }
        foreach i [$SCHEDULE(RULE2) get] {
                lappend r2 [lindex $rule_list $i]
        }
        commands::get_rule_relations $r1 $r2
}

itcl::body schedule_analysis::create_statusbar {} {
        set sstatus ""
        itk_component add frame {
                frame $itk_interior.fr
        }

        pack $itk_component(frame) -fill x -side bottom
        pack [ttk::sizegrip $itk_component(frame).grip] -side right -anchor se
        label $itk_component(frame).l -textvariable sstatus -bd 1 \
                -font bscTooltipFont
        pack $itk_component(frame).l -side left -padx 2 -fill x
}

itcl::body schedule_analysis::clear {} {
        global SCHEDULE
        global BSPEC
        if {[winfo exists $BSPEC(SCHEDULE)] } {
                $SCHEDULE(HIERARCHY) clear
                $SCHEDULE(WARNINGS) clear
                $SCHEDULE(RULE_INFO) clear
                $SCHEDULE(RULES) clear
                $SCHEDULE(METHOD_INFO) clear
                $SCHEDULE(RULE_REL) clear
                $BSPEC(SCHEDULE) clear_rules
                change_menu_status module {load_top load} disabled
                wm title $BSPEC(SCHEDULE) "Schedule Analysis$BSPEC(TITLE)"
        }

}

itcl::body schedule_analysis::change_menu_status {m n st} {
        global BSPEC
        foreach i $n {
                $BSPEC(SCHEDULE).menu set_state $m $i $st
        }
}

itcl::body schedule_analysis::change_item_menu_status {n st} {
        global SCHEDULE
        foreach i $n {
                set id [$SCHEDULE(HIERARCHY) component itemMenu index "$i"]
                $SCHEDULE(HIERARCHY) component itemMenu \
                        entryconfigure $id -state $st
        }
}

itcl::body schedule_analysis::close {} {
    wm withdraw $itk_interior
}

itcl::body schedule_analysis::set_module {m} {
       global BSPEC
       if {$m != ""} {
               set cm $BSPEC(MODULE)
               commands::set_module $m
               set BSPEC(MODULE) $m
       }
}

itcl::body schedule_analysis::module_load_top {} {
        global PROJECT
        if {$PROJECT(TOP_MODULE) != ""} {
                commands::load_module $PROJECT(TOP_MODULE)
        }
}

itcl::body schedule_analysis::module_load {} {
        set m [select_module]
        if {$m != ""} {
                commands::load_module $m
        }
}

itcl::body schedule_analysis::module_reload {} {
        commands::reload_module
}

itcl::body schedule_analysis::module_source {} {
        global SCHEDULE
        if {[$SCHEDULE(TABNOTEBOOK) view] == 1} {
                commands::rule_view_source [$SCHEDULE(RULES) getcurselection]
        }
        if {[$SCHEDULE(TABNOTEBOOK) view] == 2} {
                commands::method_view_source [$SCHEDULE(HIERARCHY) selection get]
        }
}

itcl::body schedule_analysis::add_rules {rule} {
        $this clear_rules
        set rule_list $rule
        set rule_id 0
        foreach i $rule {
                $itk_component(rule1) add $rule_id -text $i
                $itk_component(rule2) add $rule_id -text $i
                incr rule_id
        }
        $itk_component(rule1) select_all
        $itk_component(rule2) select_all
}

itcl::body schedule_analysis::rule1_select_all {d} {
        $d component rule1 select_all
}

itcl::body schedule_analysis::rule1_clear_all {d} {
        $d component rule1 deselect_all
}

itcl::body schedule_analysis::rule2_select_all {d} {
        $d component rule2 select_all
}

itcl::body schedule_analysis::rule2_clear_all {d} {
        $d component rule2 deselect_all
}

itcl::body schedule_analysis::rule1_select_match {d} {
        set r [$d get_filter_rule1]
        if {$r != "" && $r != "\\" && $r != "\[\]" && \
                        ![catch "regexp -all -- $r $rule_list"]} {
                foreach i [lsearch -all -regexp $rule_list $r] {
                        $d component rule1 select $i
                }
        }
}

itcl::body schedule_analysis::rule1_clear_match {d} {
        set r [$d get_filter_rule1]
        if {$r != "" && $r != "\\" && $r != "\[\]" && \
                        ![catch "regexp -all -- $r $rule_list"]} {
                foreach i [lsearch -all -regexp $rule_list $r] {
                        $d component rule1 deselect $i
                }
        }
}

itcl::body schedule_analysis::rule2_select_match {d} {
        set r [$d get_filter_rule2]
        if {$r != "" && $r != "\\" && $r != "\[\]" && \
                        ![catch "regexp -all -- $r $rule_list"]} {
                foreach i [lsearch -all -regexp $rule_list $r] {
                        $d component rule2 select $i
                }
        }
}

itcl::body schedule_analysis::rule2_clear_match {d} {
        set r [$d get_filter_rule2]
        if {$r != "" && $r != "\\" && $r != "\[\]" && \
                        ![catch "regexp -all -- $r $rule_list"]} {
                foreach i [lsearch -all -regexp $rule_list $r] {
                        $d component rule2 deselect $i
                }
        }
}

itcl::body schedule_analysis::open_module_menu {} {
        global BSPEC
        global PROJECT
        set f "$PROJECT(COMP_BDIR)/$PROJECT(TOP_MODULE).ba"
        schedule_analysis::change_menu_status module {load_top reload \
                set_modul} disabled
        if {$PROJECT(TOP_MODULE) != "" && [file exists $f]} {
                schedule_analysis::change_menu_status module load_top normal
        }
        if {$BSPEC(MODULE) != ""} {
                schedule_analysis::change_menu_status module {reload \
                      set_modul export} normal
        }
}

itcl::body schedule_analysis::open_scheduling_graphs_menu {} {
        global TCLDOT_EXIST
        schedule_analysis::change_menu_status scheduling_graphs \
                {conflict exec urgency combined combined_full} disabled
        set graphtype "conflict exec urgency combined combined_full"
        foreach i $graphtype {
                if {[file exists [commands::get_dot_file_name $i]] && \
                                $TCLDOT_EXIST} {
                        schedule_analysis::change_menu_status \
                                scheduling_graphs [lsearch $graphtype $i] normal
                }
        }
}

itcl::body schedule_analysis::clear_rules {} {
        set l [expr [llength $rule_list] -1]
        for {set i $l} { $i >= 0} {incr i -1} {
                if {[$itk_component(rule1) get_buttons] != ""} {
                        $itk_component(rule1) delete $i
                        $itk_component(rule2) delete $i
                }
        }
        set rule_list ""
}

##
# @brief Creates Schedule Analysis Window
#
proc create_schedule_analysis_window {} {
        global BSPEC
        global PROJECT
        global SCHEDULE
        schedule_analysis $BSPEC(SCHEDULE) \
                -title "Schedule Analysis$BSPEC(TITLE)"
        wm geometry $BSPEC(SCHEDULE) $PROJECT(SCHEDULE_PLACEMENT)
        wm minsize $BSPEC(SCHEDULE) 400 400
        wm geometry $BSPEC(SCHEDULE) 650x650
        wm protocol $BSPEC(SCHEDULE) WM_DELETE_WINDOW "$BSPEC(SCHEDULE) close"
}
