
##
# @file package_window.tcl
#
# @brief Definition of the Package window.
#

## TODO Change the structure of the class to have constructor/destructor 
## TODO Change the structure of the class to use less global variables 

global PACKAGE

##
# @brief The list of nodes 
# 
set PACKAGE(NODES) ""

##
# @brief The name of the message-box
# 
set PACKAGE(INFO) ""

##
# @brief The selected item 
# 
set PACKAGE(SELECTION) ""

##
# @brief A list which contains lists with package id and name 
# 
set PACKAGE(IMPORT) ""

##
# @brief The id for packages 
# 
set PACKAGE(IMPORT_UID) 0

##
# @brief The id of searched package 
# 
set PACKAGE(SEARCH_ID) -1

##
# @brief The package name to be searched
# 
set PACKAGE(SEARCH) ""

package require Bluetcl

##
# @brief Definition of class package_window
# 
itcl::class package_window {

        ##
        # @brief Gets items for the selected node
        #
        # @param n recently selected node in the hierarchy
        #
        proc get_items {n}
        
        ##
        # @brief Creates Package window 
        # 
        proc create {}

        ##
        # @brief Removes all information from Package Window
        # 
        proc clear {}

        ##
        # @brief Changes the menu status for the Package window
        #
        # @param m the name of menu from Package window
        # @param n the number of menu action from menu
        # @param st the status of menu action
        #
        proc change_menu_status {m n st}

        ##
        # @brief Changes the item menu status for the Package window
        #
        # @param n the name of menu action from item menu
        # @param st the status of menu action
        #
        proc change_item_menu_status {n st} 

        ##
        # @brief Closes the Package Window
        # 
        proc close {}
        
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
        # @brief Check the type of the selected node
        #
        # @param t the most recently selected node
        #
        proc check_node {t}

        ##
        # @brief Opens a listbox to load a package.
        #
        proc package_load {} 

        ##
        # @brief Loads the top package.
        #
        proc package_top_load {} 

        ##
        # @brief Reloads all loaded packages.
        #
        proc package_reload {} 

        ##
        # @brief Refreshes the package hierarchy.
        #
        proc package_refresh {} 

        ##
        # @brief Shows the import hierarchy in a separate window.
        #
        proc import_hierarchy {}         

        ##
        # @brief Searches for a string through definitions of all loaded 
        # packages.
        #
        proc package_search {} 

        ##
        # @brief Expands the selected item.
        #
        proc view_expand {} 

        ##
        # @brief Collapses the selected item.
        #
        proc view_collapse {}

        ##
        # @brief Collapses the hierarchy to only the package view.
        #
        proc view_collapse_all {} 

        ##
        # @brief Opens the Type Browser window for the selected type.
        #
        proc view_totype {} 

        ##
        # @brief Launches editor on the definition of the selected item. 
        #
        proc view_source {}
        
        ##
        # @brief Select/Deselect the current node
        #
        proc select_current {}

        ##
        # @brief Expands the selected item.
        #
        proc expand_current {} 

        ##
        # @brief Colapses the selected item.
        #
        proc collapse_current {} 
        
        ##
        # @brief Returns the list of imported packages for the specified package
        #
        # @param n the selected node
        #
        proc get_package_depends {n}
        
        ##
        # @brief Creates the Import hierarchy            
        #
        # @param n the selected node
        #
        proc get_depend {n}

        ##
        # @brief Enables/disables menu items of Package menu            
        #
        proc open_package_menu {}

        ##
        # @brief Enables/disables menu items of View menu            
        #
        proc open_view_menu {}

        private {
                ##
                # @brief Creates menubar 
                # 
                # @param p parent window
                #
                proc create_menubar {p}
                
                ##
                # @brief Creates the Package menu
                # 
                # @param p parent window
                #
                proc create_package_menu {p}
                
                ##
                # @brief Creates the View menu
                # 
                # @param p parent window
                #
                proc create_view_menu {p}
                
                ##
                # @brief Creates the package hierarchy
                # 
                # @param p parent window
                #
                proc create_package_hierarchy {p}
                
                ##
                # @brief Creates the message window 
                # 
                # @param p parent window
                #
                proc create_message_window {p}
                
                ##
                # @brief Creates the paned window 
                # 
                # @param p parent window
                #
                proc create_paned_window {p}

                ##
                # @brief Creates statusbar 
                # 
                # @param p parent window
                #
                proc create_statusbar {p} 

                ##
                # @brief Sets the arrow key bindings for Package Window 
                # 
                proc set_bindings {}
        }

        proc exportinfo {} {
            global PACKAGE
            global BSPEC

            set types {
                {{Text Files}       {.txt}        }
                {{All Files}        *             }
            }
            set node  [$BSPEC(PACKAGE_HIERARCHY) selection get]
            set fn ""
            if { $node != "" } {
                set fn [Bluetcl::browsepackage detail $node]
                set fn [lindex $fn 1]
                regsub {::} $fn "__" fn
                regsub {#.*$} $fn "" fn
            }
            set fn "${fn}_info.txt"

            set f [tk_getSaveFile  -minsize "450 200" \
                       -filetypes $types \
                       -initialfile "$fn" \
                       -title "Save Package Information as" \
                       -parent $BSPEC(PACKAGE) ]
            if { $f != "" } {
                $PACKAGE(INFO) export $f
                puts "$f has been created"
            }
        }
}

itcl::body package_window::change_menu_status {m n st} {
        global BSPEC
        foreach i $n {
                $BSPEC(PACKAGE).mb set_state $m $i $st
        }
}

itcl::body package_window::change_item_menu_status {n st} {
        global BSPEC
        foreach i $n {
                set id [$BSPEC(PACKAGE_HIERARCHY) component itemMenu index "$i"]
                $BSPEC(PACKAGE_HIERARCHY) component itemMenu \
                        entryconfigure $id -state $st
        }
}

itcl::body package_window::get_items {n} {
        global PACKAGE
        if {$n == ""} {
                Bluetcl::browsepackage refresh
                set rlist [Bluetcl::browsepackage list 0]
                set PACKAGE(NODES) ""
                $PACKAGE(INFO) clear
        } else {
                set rlist [Bluetcl::browsepackage list $n]
        }
        foreach i $rlist {
                lappend PACKAGE(NODES) $i
        }
        return $rlist
}

itcl::body package_window::select_node {t s} {
        global PACKAGE
        global BSPEC
        if {!$s} {
                $BSPEC(PACKAGE_HIERARCHY) selection clear
                $BSPEC(PACKAGE_HIERARCHY) selection add $t
                commands::get_package_comp_info $t
                check_node $t
                $BSPEC(PACKAGE_HIERARCHY) see "$t.first"
        } else {
                $BSPEC(PACKAGE_HIERARCHY) selection clear
                set PACKAGE(SELECTION) "" 
                change_menu_status view {expand collapse totype source} disabled
        }
}
        
itcl::body package_window::dblclick_node {t} {
        commands::package_view_source $t
}

itcl::body package_window::check_node {t} {
        global BSPEC
        change_menu_status view {expand collapse} normal
        change_menu_status view {totype source} disabled
        change_menu_status package import disabled
        change_item_menu_status {"Send_to_type" "View_Source"} disabled
        if {[lsearch -regexp [Bluetcl::browsepackage detail $t] "position"] != -1} {
                change_item_menu_status "View_Source" normal
                change_menu_status view source normal
        } 
        if {[Bluetcl::browsepackage nodekind $t] == "Type"} {
                change_item_menu_status "Send_to_type" normal
                change_menu_status view totype normal
        }
        if {[Bluetcl::browsepackage nodekind $t] == "Package"} {
                change_menu_status package import normal
        }
}

itcl::body package_window::create_menubar {p} { 
        global PROJECT
        base::menubar $p.mb 
        create_package_menu $p.mb
        create_view_menu $p.mb
        pack $p.mb -fill x
}

itcl::body package_window::create_package_menu {p} { 
        $p add_menubutton .package "Package" 0 \
                "package_window::open_package_menu"
        $p add_command .package.load_top_package "Load Top Package" 5 \
                "Loads the top package" package_window::package_top_load
        $p add_command .package.load_package "Load Package" 0 \
                "Loads a package" package_window::package_load
        $p add_command .package.reload "Reload" 0 "Reloads all packages" \
                package_window::package_reload
        $p add_command .package.refresh "Refresh" 2 "Refreshes the hierarchy" \
                package_window::package_refresh 
        $p add_command .package.import "Import hierarchy ..." 0 \
                "Show the import hierarchy"  package_window::import_hierarchy
        $p add_command .package.search "Search..." 0 "Search a string" \
                package_window::package_search
        $p add_command .package.export "Export Information ..." 1 "Export selected information to file" \
                package_window::exportinfo normal
        $p add_command .package.close "Close" 0 "Close the Package window" \
                package_window::close normal
}

itcl::body package_window::create_view_menu {p} { 
        $p add_menubutton .view "View" 0 "package_window::open_view_menu"
        $p add_command .view.expand "Expand" 0 "Expand the selected item" \
                                     package_window::view_expand 
        $p add_command .view.collapse "Collapse" 0 "Collapse the selected item"\
                                          package_window::view_collapse
        $p add_command .view.collapseall "Collapse All" 6 \
               "Collapse the hierarchy" package_window::view_collapse_all normal
        $p add_command .view.totype "Send to Type" 9 \
                "Send to the Type package_viewer" package_window::view_totype
        $p add_command .view.source "View Source" 0 "View the source" \
                                        package_window::view_source 
}

itcl::body package_window::create_package_hierarchy {p} {
        global BSPEC
        base::hierarchy $p.h -querycommand "package_window::get_items %n" \
        -alwaysquery yes -selectcommand "package_window::select_node %n %s" \
        -dblclickcommand "package_window::dblclick_node %n"
        pack $p.h -side left -expand yes -fill both
        $p.h add_itemmenu Expand package_window::expand_current
        $p.h add_itemmenu Collapse package_window::collapse_current
        $p.h add_itemmenu "Send_to_type" package_window::view_totype
        $p.h add_itemmenu "View_Source" package_window::view_source
        set BSPEC(PACKAGE_HIERARCHY) $p.h
}

itcl::body package_window::create_message_window {p} {
        global PACKAGE
        base::messagebox $p.mb -wrap word
        $p.mb add_type INFO
        $p.mb add_type HED white black bscInfoHeadingFont
        [$p.mb gettext] tag raise sel
        pack $p.mb -fill both -expand true
        set PACKAGE(INFO) $p.mb
}

itcl::body package_window::create_paned_window {p} {
        base::panedwindow $p.pw  
        $p.pw add "left" -margin 0 -minimum 50
        set l [$p.pw childsite "left"]
        create_package_hierarchy $l
        $p.pw add "right" -margin 0 -minimum 50
        set r [$p.pw childsite "right"]
        create_message_window $r
        $p.pw configure -orient vertical 
        $p.pw fraction 30 70
        pack $p.pw -fill both -expand true
}

itcl::body package_window::create_statusbar {p} {
        global BSPEC
        set pstatus ""
        frame $p.sb
        iwidgets::entryfield $p.sb.search -labeltext "Find" \
                -textbackground white -labelpos w -command \
                {commands::search_in_packages [.pk.sb.search get] "Next"} 
        pack $p.sb.search -fill x -side left
        button $p.sb.next -text "Next" -command \
                {commands::search_in_packages [.pk.sb.search get] "Next"}
        pack  $p.sb.next -side left
        button $p.sb.prev -text "Previous" -command \
                {commands::search_in_packages [.pk.sb.search get] "Prev"}
        pack  $p.sb.prev -side left
        pack [ttk::sizegrip $p.sb.grip] -side right -anchor se

        label $p.sb.l -textvariable pstatus -bd 1 -font bscTooltipFont
        pack $p.sb.l -side left -padx 2 -fill x
        label $p.sb.r -textvariable BSPEC(LOADED_PACKAGES) -bd 1 \
                -font bscTooltipFont
        pack $p.sb.r -side right -padx 2 -fill x
        pack $p.sb -fill x -side bottom 
}

itcl::body package_window::set_bindings {} {
        global BSPEC
        bindtags $BSPEC(PACKAGE) [list $BSPEC(PACKAGE) \
                $BSPEC(PACKAGE_HIERARCHY) . all]
        bind $BSPEC(PACKAGE) <Control-w> {
                package_window::close
        }
}

itcl::body package_window::create {} {
        global BSPEC
        global PROJECT
        destroy $BSPEC(PACKAGE)
        toplevel $BSPEC(PACKAGE)
        create_menubar $BSPEC(PACKAGE) 
        create_statusbar $BSPEC(PACKAGE)
        create_paned_window $BSPEC(PACKAGE)
        set_bindings
        wm title $BSPEC(PACKAGE) "Package$BSPEC(TITLE)"
        wm geometry $BSPEC(PACKAGE) $PROJECT(PACKAGE_PLACEMENT)
        wm protocol  $BSPEC(PACKAGE) WM_DELETE_WINDOW package_window::close
        wm minsize $BSPEC(PACKAGE) 480 200
}

itcl::body package_window::clear {} {
        global BSPEC
        global PACKAGE
        Bluetcl::bpackage clear
        if {[winfo exists $BSPEC(PACKAGE)] } {
                $BSPEC(PACKAGE_HIERARCHY) clear
                $PACKAGE(INFO) clear
                change_menu_status package {load_top_package load_package \
                        reload refresh import search} disabled
                change_menu_status view \
                        {expand collapse collapseall totype source} disabled
        }
}

itcl::body package_window::close {} {
    global BSPEC
    wm withdraw $BSPEC(PACKAGE)
}

itcl::body package_window::package_load {} {
        set p [select_package]
        if {$p != ""} {
                commands::load_package $p
        }
}

itcl::body package_window::package_top_load {} {
        global PROJECT
        commands::load_package [file rootname [file tail $PROJECT(TOP_FILE)]]
}

itcl::body package_window::package_reload {} {
        commands::reload_packages
}

itcl::body package_window::package_refresh {} {
        commands::package_refresh
}

itcl::body package_window::import_hierarchy {} {
        global BSPEC
        commands::import_hierarchy [$BSPEC(PACKAGE_HIERARCHY) selection get] 
}

itcl::body package_window::package_search {} {
        global PACKAGE
        set PACKAGE(SEARCH_ID) -1
        create_package_search_dialog        
}

itcl::body package_window::view_expand {} {
        global BSPEC
        commands::package_expand [$BSPEC(PACKAGE_HIERARCHY) selection get]
}

itcl::body package_window::view_collapse {} {
        global BSPEC
        commands::package_collapse [$BSPEC(PACKAGE_HIERARCHY) selection get]
}

itcl::body package_window::view_collapse_all {} {
        change_menu_status view {expand collapse} disabled
        change_menu_status package import disabled
        commands::package_collapse_all
}

itcl::body package_window::view_totype {} {
        global BSPEC 
        set selection [$BSPEC(PACKAGE_HIERARCHY) selection get] 
        if { $selection!= ""} {
                commands::package_view_type $selection
        }
}

itcl::body package_window::view_source {} {
        global BSPEC
        commands::package_view_source [$BSPEC(PACKAGE_HIERARCHY) selection get]

}

itcl::body package_window::select_current {} {
        global BSPEC
        if {[$BSPEC(PACKAGE_HIERARCHY) selection get] != ""} {
                $BSPEC(PACKAGE_HIERARCHY) selection clear
        }
        $BSPEC(PACKAGE_HIERARCHY) selection add \
                [$BSPEC(PACKAGE_HIERARCHY) current]
        check_node [$BSPEC(PACKAGE_HIERARCHY) current]
}

itcl::body package_window::expand_current {} {
        global BSPEC
#        select_current
        commands::package_expand [$BSPEC(PACKAGE_HIERARCHY) current]
}

itcl::body package_window::collapse_current {} {
        global BSPEC
#        select_current
        commands::package_collapse [$BSPEC(PACKAGE_HIERARCHY) current]
}


itcl::body package_window::get_package_depends {n} {
        global PACKAGE
        set p [Bluetcl::bpackage depend]
        set a [list]
        foreach i $p {
                lappend a [lindex $i 0]
        }
        set node [lindex [lindex $PACKAGE(IMPORT) \
                [lsearch -regexp $PACKAGE(IMPORT) $n]] 1]
        set d [lindex [lindex $p [lsearch $a $node]] 1]
        return $d
}

itcl::body package_window::get_depend {n} {
        global PACKAGE
        set ilist ""
        if {$n == ""} {
                set PACKAGE(IMPORT) ""
                set PACKAGE(IMPORT_UID) 0
                if {$PACKAGE(SELECTION) != ""} {
                        lappend ilist [list id$PACKAGE(IMPORT_UID)\
                                $PACKAGE(SELECTION)] 
                        incr PACKAGE(IMPORT_UID)
                        set PACKAGE(IMPORT) $ilist
                } else { set ilist ""}
        } else {
                foreach i [get_package_depends $n] {
                        lappend ilist [list id$PACKAGE(IMPORT_UID) $i]
                        lappend PACKAGE(IMPORT) [list id$PACKAGE(IMPORT_UID) $i]
                        incr PACKAGE(IMPORT_UID)
                }
        }
        return $ilist
}

itcl::body package_window::open_package_menu {} {
        global BSPEC
        global PROJECT
        if {[$BSPEC(PACKAGE_HIERARCHY) selection get] == ""} {
                package_window::change_menu_status package \
                        import disabled
        }
        package_window::change_menu_status package load_top_package disabled 
        set f "$PROJECT(COMP_BDIR)/[file rootname [file tail $PROJECT(TOP_FILE)]].bo"
        if {$PROJECT(TOP_FILE) != "" && [file exists $f]} {
                package_window::change_menu_status package \
                        load_top_package normal
        }
}

itcl::body package_window::open_view_menu {} {
        global BSPEC
        if {[$BSPEC(PACKAGE_HIERARCHY) selection get] == ""} {
                package_window::change_menu_status view \
                        {expand collapse totype source} disabled
        }
} 
