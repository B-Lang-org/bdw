
##
# @file type_browser_window.tcl
#
# @brief Definition of the Type Browser window.
#

## TODO Change the structure of the class to have constructor/destructor 
## TODO Change the structure of the class to use less global variables 

global TYPE

##
# @brief The name of the message-box 
#
set TYPE(INFO) ""

##
# @brief The name of the "Type" combo-box on the status bar
#
set TYPE(ADD) ""

package require Bluetcl

##
# @brief Definition of class type_browser
#
itcl::class type_browser {

        ##
        # @brief Get items for the selected node
        #
        # @param n recently selected node in the hierarchy
        #
        proc get_items {n}

        ##
        # @brief Updates the menu status 
        #
        proc update_menu_status {}

        ##
        # @brief Checks the type of the selected node
        #
        # @param t the most recently selected node
        #
        proc check_node {t}

        ##
        # @brief Select/Deselect the node
        #
        # @param t the most recently selected node
        # @param s if 1/0 then selected/deselected
        #
        proc select_node {t s}

        ##
        # @brief Select/Deselect the node
        #
        # @param t the most recently selected node
        #
        proc dblclick_node {t}
        
        ##
        # @brief Creates Type Browser window 
        #
        proc create {} 

        ##
        # @brief Changes the menu status for the Type Browser window
        #
        # @param m the name of menu from Type Browser window
        # @param n the number of menu action from menu
        # @param st the status of menu action
        #
        proc change_menu_status {m n st} 

        ##
        # @brief Changes the item menu status for the Type Browser window
        #
        # @param n the name of menu action from item menu
        # @param st the status of menu action
        #
        proc change_item_menu_status {n st} 

        ##
        # @brief Removes all information from Type Browser window 
        #
        proc clear {}

        ##
        # @brief Closes the Type Browser window 
        #
        proc close {}

        ##
        # @brief Adds the specified type from the Add type entryfield to the
        # Type hierarchy
        #
        proc show_type {} 
        
        ##
        # @brief Opens the Type Add dialog
        #
        proc types_add {} 
        
        ##
        # @brief Removes the specified type from the type hierarchy
        #
        proc types_remove {} 
        
        ##
        # @brief Expands the selected item from the type hierarchy
        #
        proc view_expand {} 
        
        ##
        # @brief Collopses the selected type from the type hierarchy
        #
        proc view_collapse {} 

        ##
        # @brief Collapses the type hierarchy
        #       
        proc view_collapse_all {} 

        ##
        # @brief Launches the editor on the definition of the selected item
        #
        proc view_source {} 
        
        ##
        # @brief Enables/disables menu items of View menu            
        #
        proc open_view_menu {}

        private {
                ##
                # @brief Creates the Types menu
                #
                # @param p the parent window
                #
                proc create_type_menu {p}

                ##
                # @brief Creates the View menu
                #
                # @param p the parent window
                #
                proc create_view_menu {p}

                ##
                # @brief Creates menubar
                #
                # @param p the parent window
                #
                proc create_menubar {p}

                ##
                # @brief Creates the type hierarchy
                #
                # @param p parent window
                #
                proc create_type_hierarchy {p} 

                ##
                # @brief Creates the message window
                #
                # @param p parent window
                #
                proc create_message_window {p} 

                ##
                # @brief Creates panedwindow
                #
                # @param p parent window
                #
                proc create_paned_window {p} 

                ##
                # @brief Creates statusbar
                #
                # @param p the parent window
                #
                proc create_statusbar {p} 

                ##
                # @brief Sets the arrow key bindings for Type Browser Window 
                # 
                proc set_bindings {}
        }
}

itcl::body type_browser::change_menu_status {m n st} {
        global BSPEC
        foreach i $n {
                $BSPEC(TYPE_BROWSER).mb set_state $m $i $st
        }
}

itcl::body type_browser::change_item_menu_status {n st} {
        global BSPEC
        foreach i $n {
                set id [$BSPEC(TYPE_HIERARCHY) component itemMenu index "$i"]
                $BSPEC(TYPE_HIERARCHY) component itemMenu \
                        entryconfigure $id -state $st
        }
}

itcl::body type_browser::update_menu_status {} {
        global BSPEC 
        change_menu_status types remove disabled
        change_menu_status view {expand collapse collapseall source} disabled
        change_item_menu_status {Expand Collapse "View_Source"} disabled
        if {$BSPEC(TYPES) != ""} {
                change_menu_status view collapseall normal
        }
}

itcl::body type_browser::get_items {n} {
        global BSPEC 
        global TYPE
        set rlist ""
        if {$n == ""} {
                $TYPE(INFO) clear
                Bluetcl::browsetype clear
                update_menu_status
                set tmp $BSPEC(TYPES)
                set BSPEC(TYPES) [list]
                foreach i $tmp {
                        if {[catch "Bluetcl::browsetype add \"$i\"" err]} {
                                puts stderr $err
                                continue 
                        }
                        lappend BSPEC(TYPES) $i
                }
                set rlist [Bluetcl::browsetype list 0]
        } else {
                set rlist [Bluetcl::browsetype list $n]
        }
        return $rlist
}

itcl::body type_browser::select_node {t s} {
        global BSPEC
        if {!$s} {
                $BSPEC(TYPE_HIERARCHY) selection clear
                $BSPEC(TYPE_HIERARCHY) selection add $t
                commands::get_type_info $t
                check_node $t
                $BSPEC(TYPE_HIERARCHY) see "$t.first"
                change_menu_status view {expand collapse collapseall} normal
                change_item_menu_status {Expand Collapse} normal
        } else {
                $BSPEC(TYPE_HIERARCHY) selection clear
                change_menu_status types remove disabled
                change_menu_status view {expand collapse source} disabled
                change_item_menu_status {Expand Collapse "View_Source"} disabled
        }
}

itcl::body type_browser::dblclick_node {t} {
        commands::type_view_source $t
}

itcl::body type_browser::check_node {t} {
        global BSPEC
        global TYPE
        change_menu_status types remove disabled
        change_menu_status view source disabled
        change_item_menu_status "View_Source" disabled
        if {[lsearch -regexp [Bluetcl::browsetype detail $t] "position"] != -1} {
                change_menu_status view source normal
                change_item_menu_status "View_Source" normal
        }
        set p [lindex $BSPEC(TYPES) [expr [lindex [lindex [Bluetcl::browsetype list 0] \
                [lsearch -regexp [Bluetcl::browsetype list 0] $t]] 0] - 1]]
        if {[lsearch $BSPEC(TYPES) $p] != -1} {
                change_menu_status types remove normal
        } 
}

itcl::body type_browser::create_type_menu {p} {
        $p add_menubutton .types "Types" 0
        $p add_command .types.add "Add..." 0 "Add a type" \
                type_browser::types_add
        $p add_command .types.remove "Remove" 0 "Remove the selected type"\
                type_browser::types_remove
        $p add_command .types.pload "Load Package" 0 "Loads a package" \
                package_window::package_load normal
        $p add_command .types.close "Close" 0 \
                "Close the Type Browser window" type_browser::close normal
}

itcl::body type_browser::create_view_menu {p} {
        $p add_menubutton .view "View" 0 "type_browser::open_view_menu"
        $p add_command .view.expand "Expand" 0 "Expand the selected item"\
                                     type_browser::view_expand 
        $p add_command .view.collapse "Collapse" 0 \
                "Collapse the selected item" type_browser::view_collapse 
        $p add_command .view.collapseall "Collapse All" 9 \
                "Collapse the hierarchy" type_browser::view_collapse_all
        $p add_command .view.source "View Source" 0 "View the source"\
                                        type_browser::view_source 
}
        
itcl::body type_browser::create_menubar {p} {
        global PROJECT
        base::menubar $p.mb
        create_type_menu $p.mb
        create_view_menu $p.mb
        pack $p.mb -fill x 
}

itcl::body type_browser::create_type_hierarchy {p} {
        global BSPEC
        base::hierarchy $p.h -querycommand "type_browser::get_items %n" \
                    -selectcommand "type_browser::select_node %n %s" \
                    -dblclickcommand "type_browser::dblclick_node %n"
        pack $p.h -side left -expand yes -fill both
        $p.h add_itemmenu Expand "{type_browser::view_expand}"
        $p.h add_itemmenu Collapse "{type_browser::view_collapse}"
        $p.h add_itemmenu "View_Source" "{type_browser::view_source}"
        set BSPEC(TYPE_HIERARCHY) $p.h
}

itcl::body type_browser::create_message_window {p} {
        global TYPE
        base::messagebox $p.mb -wrap word
        $p.mb add_type INFO 
        $p.mb add_type HED white black bscInfoHeadingFont
        [$p.mb gettext] tag raise sel
        pack $p.mb -fill both -expand true
        set TYPE(INFO) $p.mb
}

itcl::body type_browser::create_paned_window {p} {
        base::panedwindow $p.pw  
        $p.pw add "left" -margin 0 -minimum 50
        set l [$p.pw childsite "left"]
        create_type_hierarchy $l
        $p.pw add "right" -margin 0 -minimum 50
        set r [$p.pw childsite "right"]
        create_message_window $r
        $p.pw configure -orient vertical 
        $p.pw fraction 50 50
        pack $p.pw -fill both -expand true
}

itcl::body type_browser::create_statusbar {p} {
        global TYPE
        global BSPEC
        set tstatus ""
        frame $p.sb
        iwidgets::combobox $p.sb.add -labeltext "Type" -listheight 150 \
                -selectioncommand {type_browser::show_type} \
                -command {type_browser::show_type} -width 40
        pack $p.sb.add -fill x -side left
        set TYPE(ADD) $p.sb.add
        foreach i $BSPEC(TYPES) {
                $TYPE(ADD) insert list end $i
        }
        button $p.sb.but -text "Add" -command {type_browser::show_type}
        pack  $p.sb.but -side left
        pack [ttk::sizegrip $p.sb.grip] -side right -anchor se

        label $p.sb.l -textvariable tstatus -bd 1 -font bscTooltipFont
        pack $p.sb.l -side left
        pack $p.sb -fill x -side bottom 
}

itcl::body type_browser::set_bindings {} {
        global BSPEC
        bindtags $BSPEC(TYPE_BROWSER) [list $BSPEC(TYPE_BROWSER) \
                $BSPEC(TYPE_HIERARCHY) . all]
        bind $BSPEC(TYPE_BROWSER) <Control-w> {
               type_browser::close
        }
}

itcl::body type_browser::create {} {
        global BSPEC
        global PROJECT
        destroy $BSPEC(TYPE_BROWSER)
        toplevel $BSPEC(TYPE_BROWSER)
        create_menubar $BSPEC(TYPE_BROWSER)
        create_statusbar $BSPEC(TYPE_BROWSER)
        create_paned_window $BSPEC(TYPE_BROWSER)
        set_bindings
        wm title $BSPEC(TYPE_BROWSER) "Type Browser$BSPEC(TITLE)"
        wm geometry $BSPEC(TYPE_BROWSER) $PROJECT(TYPE_PLACEMENT) 
        wm minsize $BSPEC(TYPE_BROWSER) 470 200
        wm protocol $BSPEC(TYPE_BROWSER) WM_DELETE_WINDOW type_browser::close
}

itcl::body type_browser::clear {} {
        global BSPEC
        global TYPE                
        set BSPEC(TYPES) ""
        if {[winfo exists $BSPEC(TYPE_BROWSER)] } {
                $BSPEC(TYPE_HIERARCHY) clear
                $TYPE(INFO) clear
                change_menu_status types {add remove pload} disabled
                change_menu_status view {expand collapse collapseall source} \
                        disabled
        }

}

itcl::body type_browser::close {} {
    global BSPEC
    wm withdraw $BSPEC(TYPE_BROWSER)
}

itcl::body type_browser::show_type {} {
        global TYPE
        global BSPEC
        set t [$TYPE(ADD) get] 
        if {[catch "Bluetcl::type constr $t"] != 1} {
                set t [Bluetcl::type constr $t]
        } else {
                set t $t
        }
        if {$t != "" && [lsearch $BSPEC(TYPES) $t] == -1} {
                commands::add_type $t
        }
        if {[lsearch [$TYPE(ADD) component list get 0 end] $t] == -1} {
                $TYPE(ADD) insert list 0 $t
        }
}

itcl::body type_browser::types_add {} {
        set p [select_type]
        if {$p != ""} {
                foreach t $p {
                        commands::add_type $t
                }
        }
}

itcl::body type_browser::types_remove {} {
        global BSPEC
        global TYPE
        if {[$BSPEC(TYPE_HIERARCHY) selection get] != ""} {
                set t [$BSPEC(TYPE_HIERARCHY) selection get]
                set t [lindex $BSPEC(TYPES) [expr [lindex [lindex \
                        [Bluetcl::browsetype list 0] [lsearch -regexp \
                        [Bluetcl::browsetype list 0] $t]] 0] - 1]]
                commands::remove_type $t
        } 
}

itcl::body type_browser::view_expand {} {
        global BSPEC
        commands::type_expand [$BSPEC(TYPE_HIERARCHY) selection get]
}

itcl::body type_browser::view_collapse {} {
        global BSPEC
        commands::type_collapse [$BSPEC(TYPE_HIERARCHY) selection get]
}

itcl::body type_browser::view_collapse_all {} {
        commands::type_collapse_all
}

itcl::body type_browser::view_source {} {
        global BSPEC
        commands::type_view_source [$BSPEC(TYPE_HIERARCHY) selection get]
}

itcl::body type_browser::open_view_menu {} {
        global BSPEC
        if {[$BSPEC(TYPE_HIERARCHY) selection get] == ""} {
                type_browser::change_menu_status view \
                        {expand collapse source} disabled
                type_browser::change_item_menu_status \
                        {Expand Collapse "View_Source"} disabled
        } 
}
