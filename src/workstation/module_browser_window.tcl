
##
# @file module_browser_window.tcl
#
# @brief Definition of the Module Browser window.
#

set BSPEC(MODULE_HIERARCHY) ""

package require Bluetcl
package require Waves
package require Virtual

##
# @brief Definition of class module_browser
#
catch "itcl::delete class module_browser"
itcl::class module_browser {
        inherit itk::Toplevel

        common view_buttons [list position jump_to]
        common send_buttons [list send_to_wave send_canfire send_willfire \
                                send_clk send_qout send_pred send_body]
        common view_menu_items0 [list collapse_all restoretop source]
        common view_menu_items1 [list expand collapse show_schedule promotetop prune]

        private variable _lastsearch ""
        private variable _searchlist ""
        private variable _searchindex ""
        private variable _viewer ""
        # which window was last selected
        private variable _winsel hier
        private variable _foundMsg ""
        # a promoted hierarchy node
        private variable _current_top ""
        ##
        # @brief Get items for the selected node
        #
        # @param n the id of the recently selected node in the hierarchy
        #
        method get_items {n}

        ##
        # @brief Select/Deselect the node
        #
        # @param t the id of the recently selected node
        # @param s if 1/0 then selected/deselected
        #
        method select_node {win t s}

        ##
        # @brief Select/Deselect an additional node
        #
        # @param t the id of the recently selected node
        # @param s if 1/0 then selected/deselected
        #
        method select_onemore_node {win t s}

        ##
        # @brief Select a set of nodes
        #
        # @param args are the ids of the recently selected nodes
        #
        method select_many {win args}

        ##
        # @brief Select/Deselect the node
        #
        # @param t the most recently selected node
        #
        method dblclick_node {t}

        ##
        # @brief Based on the current selection set, enable/disable appropriate
        # action buttons accordingly
        #
        method update_buttons {}

        ##
        # @brief Based on the current selection set, enable/disable appropriate
        # action menu items accordingly
        #
        method update_menus

        ##
        # @brief Based on the current selection set, enable/disable appropriate
        # action menu items and action buttons accordingly
        #
        method update_menus_and_buttons

        ##
        # @brief Expands the selected item from the hierarchy
        #
        method view_expand {}

        ##
        # @brief Collapses the selected item from the hierarchy
        #
        method view_collapse {}

        ##
        # @brief Collapses the module hierarchy
        #
        method view_collapse_all {}

        ##
        # @brief Opens the Schedule Analysis window for the loaded module
        #
        method view_show_schedule {}

        ##
        # @brief Starts the Waveform Viewer
        #
        method viewer_start {}

        ##
        # @brief Opens the Select File dialog
        #
        method viewer_load_dump_file {}

        ##
        # @brief Reloads the file
        #
        method viewer_reload_file {}

        ##
        # @brief Closes the waveform viewer
        #
        method viewer_close {}

        ##
        # @brief Opens the Waveform Viewer tab of the Project Options dialog
        #
        proc viewer_options {}

        ##
        # @brief Opens the editor at the instance position
        #
        method view_source {win}

        ##
        # @brief Sends the selected item to the wave viewer
        #
        method send_to_wave { modifier }

        ##
        # @brief Removes all informiton from Module Browser window
        #
        proc clear {}

        ##
        # @brief Changes the menu status for the Module Browser window
        #
        # @param m the name of menu from Module Browser window
        # @param n the number of menu action from menu
        # @param st the status of menu action
        #
        method change_menu_status {m n st}

        ##
        # @brief Changes the item menu status for the Module Browser window
        #
        # @param n the name of menu action from item menu
        # @param st the status of menu action
        #
        method change_item_menu_status {win n st}

        ##
        # @brief Closes the Module Browser window
        #
        method close {}

        ##
        # @brief Enables/disables menu items of Module menu
        #
        method open_module_menu {}

        ##
        # @brief Enables/disables menu items of View menu
        #
        method open_view_menu {}

        ##
        # @brief Enables/disables menu items of Wave Viewer menu
        #
        method open_wave_menu {}

        ##
        # @brief Adds sub menu to Wave Viewer->Attach menu item
        #
        method add_attach_submenu {}
        method search_inst {dir}
        method attach_viewer {viewer} {
            $_viewer attach $viewer
            update_menus_and_buttons
        }
        method get_viewer {} {return $_viewer}

    method post_select {win}
    method s_get_items {n}
    method m_get_items {n}
    method m_get_items_top {}
    method m_get_items_first {n}
    method m_get_items_other {n obj}
    method format_method {n rel obj}
    method text_menu {win}

    method jump_to_instance {win}

        private {
                ##
                # @brief Creates the Module menu
                #
                method create_module_menu {}

                ##
                # @brief Creates the View menu
                #
                method create_view_menu {}

                ##
                # @brief Creates the Wave Viewer menu
                #
                method create_wave_viewer_menu {}

                ##
                # @brief Creates menubar
                #
                method create_menubar {}

                ##
                # @brief Creates panedwindow
                #
                method create_paned_window {}

                ##
                # @brief Creates the instance hierarchy pane
                #
                method create_instance_hierarchy {container}
                method create_signal_list {container}
                method create_method_list {container}

                ##
                # @brief Creates the action buttons pane
                #
                method create_action_buttons {container}

                ##
                # @brief Creates statusbar
                #
                method create_statusbar {}

                ##
                # @brief Adds components to statusbar
                #
                # @param cname name of the component
                # @param cval the value of the component
                # @param wname the name of the window component
                # @param side the side to display the component
                #
                method add_status_component {cname cval wname side}

                ##
                # @brief Sets the arrow key bindings for Module Browser Window
                #
                method set_bindings {}

                ##
                # @brief Opens the Select Module dialog
                #
                method module_load {}

                ##
                # @brief Reloads the currently loaded module
                #
                method module_reload {}
            }
        public {
                ##
                # @brief Loads the top module
                #
                method module_load_top {}

                # @brief method called after module load called
                method module_load_trace {commandStr code result op} {
                    set subcmd [lindex $commandStr 1]
                    # reload hierarchy and search on reload
                    if {-1 != [lsearch -exact [list "load" "clear"] $subcmd]} {
                        set _lastsearch ""
                        promoteToTop 0
                        post_select hier
                    }
                }
                method create_viewer {reason {n1 ""} {n2 ""} {op ""} } {
                    switch -exact $reason {
                        "init" {
                            set _viewer [Waves::create_viewer]
                            return
                        }
                        "changed" {
                            if { [$_viewer class] ne [Waves::get_waveviewer] } {
                                set _viewer [Waves::create_viewer]
                                # reattach variables.....
                                $itk_component(menu) menuconfigure viewer.recording \
                                    -variable [$_viewer scope_variable recording]
                                $itk_component(nstatus) configure \
                                    -textvariable [$_viewer scope_variable StatusMsg]
                            }
                        }
                    }
                    update_menus_and_buttons
                }
                ##
                # @brief Promotes the selected module(s) as the top node(s) in the hierarchy
                method promoteToTop {mode} {
                    if { $mode } {
                        set _current_top  [$itk_component(hier) selection get]
                        change_menu_status view restoretop normal
                    } else {
                        set _current_top ""
                        change_menu_status view restoretop disabled
                    }
                    $itk_component(hier) selection clear
                    $itk_component(hier) configure -expanded false
                    set cmd [$itk_component(hier) cget -querycommand]
                    $itk_component(hier) configure -querycommand $cmd
                    post_select hier
                }
                method prune_selected {} {
                    set selected [$itk_component(hier) selection get]
                    foreach sel $selected {
                        $itk_component(hier) prune $sel
                        change_menu_status view restoretop normal
                    }
                    $itk_component(hier) selection clear
                    post_select hier
                }


        }

        constructor {args} {
                create_viewer init
                create_menubar
                create_paned_window
                create_statusbar
                set_bindings
                eval itk_initialize $args


                # look for module load commands to invalid search field, etc.
                trace add execution Bluetcl::module [list leave] \
                    [itcl::code $this module_load_trace]
                # If the view option is changed,  create new one.
                trace add variable ::Waves::OPTS(viewer) [list write] \
                    [itcl::code $this create_viewer changed]
        }

        destructor {
                trace remove execution Bluetcl::module [list leave] \
                    [itcl::code $this module_load_trace]
                trace remove variable ::Waves::OPTS(viewer) [list write] \
                    [itcl::code $this create_viewer changed]
        }
}

itcl::body module_browser::get_items {n} {
    if {$n == ""} {
        if { $_current_top == "" } {
            if { [catch "Virtual::inst top" inst] } {
                set inst [list]
            }
        } else {
            set inst $_current_top
        }
        change_menu_status view collapse_all disabled
    } else {
        set inst [$n children]
        change_menu_status view collapse_all normal
    }
    update_menus_and_buttons
    set rlist [Virtual::omap "hiertree" $inst]
    return $rlist
}

# called after an item is selected...
# update the menu status
itcl::body module_browser::update_menus {} {
    change_menu_status view source disabled

    foreach n [$itk_component($_winsel) selection get]  {
        set obj [lindex [split $n "."] end]
        if { [string is upper $obj] } { continue }
        if { [$obj position] ne "" } {
            change_menu_status view source normal
            break;
        }
    }
}

itcl::body module_browser::update_buttons {} {
    foreach i [concat $view_buttons $send_buttons] {
         component $i configure -state disabled
    }

    switch -exact $_winsel {
        "hier" {
            foreach t [$itk_component(hier) selection get] {
                # only set position ...
                component position configure -state normal
                if {[$_viewer can_send_instance $t]} {
                    foreach but $send_buttons {
                        if { [string first $but "send_pred%send_body%send_canfire%send_willfire"] != -1} {
                            if {[$t kind] ne "Rule"} {
                                continue
                            }
                        }
                        component $but configure -state normal
                    }
                }
            }
        }
        "slist" {   # viewer is slist
            # set the position and send to wave button only
            foreach t [$itk_component(slist) selection get] {
                set obj [lindex [split $t "."] end]

                component position configure -state normal
                #component jump_to  configure -state normal

                if { ![$_viewer ready_to_send] } { break }
                if { [$obj wave_format] ne "" } {
                    component send_to_wave configure -state normal
                    break
                }
            }
        }
        "mlist" {
            # set the position and send to wave, can/will fire buttons
            foreach t [$itk_component(mlist) selection get] {
                set obj [lindex [split $t "."] end]
                if { [string is upper $obj] } { continue }

                component position configure -state normal
                component jump_to  configure -state normal

                if { ![$_viewer ready_to_send] } { break }
                if { [$obj wave_format] ne "" } {
                    component send_to_wave configure -state normal
                    break
                }
            }
            foreach t [$itk_component(mlist) selection get] {
                set obj [lindex [split $t "."] end]
                if { [string is upper $obj] } { continue }

                if { ![$_viewer ready_to_send] } { break }
                # enable send can/will fire buttons if this is a rule
                if { [$obj class] ne "VRule" } { continue }
                component send_canfire configure -state normal
                component send_willfire configure -state normal
                break;
            }

        }
    }
}


itcl::body module_browser::select_node {win t s} {
    if {$t eq ""}  return
    if {!$s} {
        $itk_component($win) selection clear
        $itk_component($win) selection add $t
        $itk_component($win) see "$t.first"
    } else {
        $itk_component($win) selection clear
    }
    # clear the selection in the opposite list
    switch -exact $win {
        "slist" { $itk_component(mlist) selection clear }
        "mlist" { $itk_component(slist) selection clear }
    }
}

itcl::body module_browser::select_onemore_node {win t s} {
    if {$t eq ""}  return
    if {!$s} {
        $itk_component($win) selection add $t
        $itk_component($win) see "$t.first"
    } else {
        $itk_component($win) selection remove $t
    }
    # clear the selection in the opposite list
    switch -exact $win {
        "slist" { $itk_component(mlist) selection clear }
        "mlist" { $itk_component(slist) selection clear }
    }
}


itcl::body module_browser::select_many {win args} {
    $itk_component($win) selection clear
    eval $itk_component($win) selection add $args
    set t [lindex $args 0]
    $itk_component($win) see "$t.first"

    # clear the selection in the opposite list
    switch -exact $win {
        "slist" { $itk_component(mlist) selection clear }
        "mlist" { $itk_component(slist) selection clear }
    }
}

itcl::body module_browser::update_menus_and_buttons {} {
        update_menus
        update_buttons
}


itcl::body module_browser::dblclick_node {t} {
    set t [lindex $t end]
    set pos [$t position]
    if {$pos ne ""} {
        commands::edit_file $pos
    }
}

itcl::body module_browser::s_get_items {n} {
    set ret [list]
    if { $n eq "" } {
        foreach sel [$itk_component(hier) selection get] {
            set tags [list leaf]
            if {[$sel kind] eq "Rule"} { lappend tags rule }
            foreach s [$sel signals] {
                set xtags $tags
                if { [$s wave_format] eq "" } {
                    lappend xtags inlined
                }
                lappend ret [list $s "[$s name]  [$s type]" $xtags]
            }
        }
    } else {
        set obj [lindex [split $n "."] end]
        switch [$obj class] {
            "VMethod" {
                foreach s [$obj signals] {
                    set xtags leaf
                    if { [$s wave_format] eq "" } {
                        lappend xtags inlined
                    }
                    lappend ret [list $s "[$s name]  [$s type]" $xtags]
                }
            }
        }
    }
    return $ret
}

itcl::body module_browser::post_select {win} {
    set _winsel $win
    update_menus_and_buttons

    if { $win eq "hier" } {
        # update the signal window
        set qc [$itk_component(slist) cget -querycommand]
        $itk_component(slist) configure -querycommand $qc

        # update the methods window
        set qc [$itk_component(mlist) cget -querycommand]
        $itk_component(mlist) configure -querycommand $qc

        update idletasks
        # expand out the ALL list
        set top [lindex [m_get_items  ""] 0 0]
        catch "$itk_component(mlist) expand $top" e1
    }

    focus $itk_component($win)
}

#################################################################
## Method lists
itcl::body module_browser::m_get_items {n} {
    if {$n eq ""} {
        return [m_get_items_top]
    }
    set x [split $n .]
    if { [llength $x] == 1 } {
        return [m_get_items_first $n]
    }
    m_get_items_other $n [lindex $x end]
}
itcl::body module_browser::m_get_items_top {} {
    array set X [list]
    set selections [$itk_component(hier) selection get]
    if { [llength $selections] != 1 } { return [list] }
    foreach sel $selections {
        switch -exact [$sel kind] {
            "Rule" {
                set X(A) [list ALL  "methods called" [list branch inlined]]
                set X(C) [list PRED "methods called in predicate" [list branch inlined]]
                set X(D) [list BODY "methods called in body" [list branch inlined]]
            }
            "Prim" {
                set X(B) [list PRIM "methods provided" [list branch inlined]]
            }
            "Synth" {
                set X(B) [list PROV "methods provided" [list branch inlined]]
            }
            "Inst" {
                # no action
            }
            default {error "Unexpected kind in m_get_items_top" }
        }
    }
    set ret [list]
    foreach k [lsort [array names X]] {
        lappend ret $X($k)
    }
    return $ret
}
itcl::body module_browser::m_get_items_first {n} {
    set meths [list]
    set selections [$itk_component(hier) selection get]
    if { [llength $selections] != 1 } { return [list] }
    foreach sel [$itk_component(hier) selection get] {
        set rel $sel
        switch -exact $n {
            "ALL" {
                eval lappend meths [concat [$sel predmethods] [$sel bodymethods]]
            }
            "BODY" {
                eval lappend meths [$sel bodymethods]
            }
            "PRED" {
                eval lappend meths [$sel predmethods]
            }
            "PRIM" {
                eval lappend meths [$sel portmethods]
            }
            "PROV" {
                foreach m  [$sel portmethods] {
                    # remove the RDY methods...
                    if { [$m rule] eq "" } { continue }
                    lappend meths $m
                }
            }
        }
    }
    set meths [utils::nub $meths]
    set dlist [utils::map "format_method $n $rel" $meths]
    lsort -index {1 0} $dlist
}

# obj should only be a VMethod
itcl::body module_browser::m_get_items_other {n obj} {
    if { [$obj class] ne "VMethod" } { return [list] }
    set rel [lindex [$itk_component(hier) selection get] 0]
    set items [list]
    eval lappend items [$obj used_by]
    eval lappend items [$obj signals]
    eval lappend items [$obj ready]
    eval lappend items [$obj enable]
    eval lappend items [$obj allmethods]

    # remove any object already on the path
    set items2 [list]
    set Parents($rel) 1
    set Parents([$rel rule]) 1

    foreach p  [split $n .] {
        set Parents($p) 1
        if { [catch "$p class" cl] } { continue }
        switch [$p class] {
            VMethod {
                set r [$p rule]
                set Parents($r) 1
            }
        }
    }
    foreach i $items {
        if { [info exists Parents($i)] } continue
        lappend items2 $i
    }

    utils::map "format_method $n $rel" $items2
}

itcl::body module_browser::format_method {n rel obj} {
    switch -exact [$obj class] {
        "VInst" { error "Unexpected instance found under [$rel show] -> [$obj show]"}
        "VRule" {
            set mpath [utils::mkRelativePath [$rel path] [$obj show]]
            set name $mpath
            set tags [list leaf rule]
        }
        "VSignal" {
            set mpath ""
            set name "[$obj name] [$obj type]"
            set tags [list leaf]
        }
        "VMethod" {
            set mpath [utils::mkRelativePath [$rel path] [$obj path]]
            if { $mpath eq "." } {
                set name ".[$obj name]"
            } else {
                set name  [join [ list $mpath [$obj name]] . ]
            }
            append name "()"
            set tags [list branch meth]
        }
    }
    if { [$obj wave_format] eq "" } {
        lappend tags inlined
    }
    list "$n.$obj" "$name" $tags
}

# called when button 2 is pressed
# setup the item menu
itcl::body module_browser::text_menu {win} {
    set item [lindex [$itk_component($win) current] end]
    set item [lindex [split $item "."] end]

    switch -exact $win {
        "hier" {
            change_item_menu_status hier [list "View Source"] disabled
            if { [$item position] ne "" } {
                change_item_menu_status $win [list "View Source"] normal
            }
        }
        "slist" {
            change_item_menu_status slist [list "View Source"  "Send to Wave"] disabled
            if { [$item position] ne "" } {
                change_item_menu_status $win [list "View Source"] normal
            }
            if { [$_viewer ready_to_send] } {
                if { [$item wave_format] ne "" } {
                    change_item_menu_status $win [list "Send to Wave"] normal
                }
            }
        }
        "mlist" {
            change_item_menu_status mlist [list "View Source"  "Send to Wave"] disabled
            if { [$item position] ne "" } {
                change_item_menu_status $win [list "View Source"] normal
            }
            if { [$_viewer ready_to_send] } {
                if { [$item wave_format] ne "" } {
                    change_item_menu_status $win [list "Send to Wave"] normal
                }
            }
        }
    }
}

itcl::body module_browser::create_menubar {} {
        itk_component add menu {
                base::menubar $itk_interior.menu -helpvariable helpVar \
                    -cursor ""
        } {
                keep -activebackground -cursor
        }
        create_module_menu
        create_view_menu
        create_wave_viewer_menu
        pack $itk_component(menu) -fill x
}

itcl::body module_browser::create_module_menu {} {
        $itk_component(menu) add menubutton module -text "Module" \
            -underline 0 -menu {
                    options -tearoff false
                    command load_top -label "Load Top Module" -underline 5 \
                        -helpstr "Loads the Top Module" -state normal
                    command load -label "Load..." -underline 0 \
                        -helpstr "Opens the Select Module dialog" \
                        -state normal
                    command reload -label "Reload" -underline 0 \
                        -helpstr "Reloads the currently loaded module" \
                        -state disabled
                    command close -label "Close" -underline 0 \
                        -helpstr "Closes the Module Browser window" \
                        -state normal
            }
    $itk_component(menu).menubar.module.menu configure -postcommand [itcl::code $this open_module_menu]

    $itk_component(menu) menuconfigure module.load_top -command [itcl::code $this module_load_top]
    $itk_component(menu) menuconfigure module.load     -command [itcl::code $this module_load]
    $itk_component(menu) menuconfigure module.reload   -command [itcl::code $this module_reload]
    $itk_component(menu) menuconfigure module.close    -command [itcl::code $this close]
}

itcl::body module_browser::create_view_menu {} {
        $itk_component(menu) add menubutton view -text "View" \
            -underline 0 -menu {
                    options -tearoff false
                    command expand -label "Expand" -underline 0 \
                        -helpstr  "Expands the selected item"
                    command collapse -label "Collapse" -underline 0 \
                        -helpstr  "Collapses the selected item"
                    command collapse_all -label "Collapse All" -underline 9 \
                        -helpstr "Collapsing the view to the instance view"
                    separator spr
                    command show_schedule -label "Show Schedule" -underline 0 \
                        -helpstr "Opens the Schedule Analysis Window"
                    command source -label "View Source" -underline 0 \
                        -helpstr  "Opens the source file"
                separator spr2
                command promotetop -label "Promote To Top" -underline 0 \
                        -helpstr "Promote selected items as top hierarchy"
                command prune -label "Prune Item" -underline 2 \
                        -helpstr "Prune selected items and children from hierarchy"
                command restoretop -label "Restore Hierarchy" -underline 0 \
                        -helpstr "Restores complete display of design"
            }

    change_menu_status view $view_menu_items0 disabled
    change_menu_status view $view_menu_items1 disabled

    $itk_component(menu).menubar.view.menu configure  -postcommand [itcl::code $this open_view_menu]
    $itk_component(menu) menuconfigure view.source        -command [itcl::code $this view_source _winsel]
    $itk_component(menu) menuconfigure view.expand        -command [itcl::code $this view_expand]
    $itk_component(menu) menuconfigure view.collapse      -command [itcl::code $this view_collapse]
    $itk_component(menu) menuconfigure view.collapse_all  -command [itcl::code $this view_collapse_all]

    $itk_component(menu) menuconfigure view.promotetop  -command [itcl::code $this promoteToTop 1]
    $itk_component(menu) menuconfigure view.prune       -command [itcl::code $this prune_selected]
    $itk_component(menu) menuconfigure view.restoretop  -command [itcl::code $this promoteToTop 0]
    $itk_component(menu) menuconfigure view.show_schedule -command [itcl::code $this view_show_schedule]

}

itcl::body module_browser::create_wave_viewer_menu {} {
    $itk_component(menu) add menubutton viewer -text "Wave Viewer" \
        -underline 0 -menu {
                    options -tearoff false
                    command start -label "Start" -underline 0 \
                        -helpstr  "Starts the Waveform Viewer" -state normal
                    cascade attach -label "Attach" -underline 0 \
                        -helpstr  "Attaches to the Waveform Viewer" \
                        -state normal -menu {
                                options -tearoff false
                        }
                    command load -label "Load Dump File..." -underline 0 -helpstr \
                        "Opens the Select File dialog" -state normal
                    command reload -label "Reload Dump File" -underline 0 \
                        -helpstr  "Reloads the dump file" -state normal
                    separator spr1
                    checkbutton recording \
                        -label "Record Commands" -underline 7 \
                        -helpstr "Enable/Disable the recording of command to Waveviewer"
                    command clr -label "Clear History" -underline 6 \
                        -helpstr "Clear the recorded Waveviewer history" \
                        -state normal
                    command save -label "Save session..." -underline 2 \
                        -helpstr "Save the signals sent to wave viewer" \
                        -state normal
                    command replay -label "Replay session..." -underline 2 \
                        -helpstr "Replay the signals sent to wave viewer" \
                        -state normal
                    separator spr2
                    command options -label "Options..." -underline 0 -state normal \
                        -helpstr  "Opens the Project Options dialog"
                    command xhost -label "Allow XServer connections" -underline 6 -state normal \
                        -helpstr  "Allow xhost connection with wave viewer"
                    command close -label "Close" -underline 4 -state normal \
                        -helpstr  "Closes the waveform viewer"
        }

    $itk_component(menu) menuconfigure viewer.recording -variable [$_viewer scope_variable recording]

    $itk_component(menu).menubar.viewer.menu configure -postcommand [itcl::code $this open_wave_menu]
    $itk_component(menu) menuconfigure viewer.start   -command [itcl::code $this viewer_start]
    $itk_component(menu) menuconfigure viewer.load    -command [itcl::code $this viewer_load_dump_file]
    $itk_component(menu) menuconfigure viewer.reload  -command [itcl::code $this viewer_reload_file]

    $itk_component(menu) menuconfigure viewer.clr      -command [itcl::code $_viewer clear_history]
    $itk_component(menu) menuconfigure viewer.save     -command  \
        [itcl::code $_viewer save_history_dialog -parent $itk_component(hull)]
    $itk_component(menu) menuconfigure viewer.replay   -command \
        [itcl::code $_viewer play_back_dialog -parent $itk_component(hull)]

    $itk_component(menu) menuconfigure viewer.options  -command module_browser::viewer_options
    $itk_component(menu) menuconfigure viewer.xhost    -command Waves::open_xhost
    $itk_component(menu) menuconfigure viewer.close    -command [itcl::code $this viewer_close]

}

itcl::body module_browser::add_attach_submenu {} {
        set m $itk_component(menu)
        catch "$m  delete .viewer.attach.0 .viewer.attach.end"
        foreach v [$_viewer attach] {
                regsub -all {[ ]+} $v "" win
                if {[$m index .viewer.attach.$win] == -1} {
                        if {[$m index .viewer.attach.detach] != -1} {
                                $m delete .viewer.attach.detach
                        }
                        $m add_command .viewer.attach.$win "$v" 0 \
                            "Attaches to the $v viewer" \
                            [itcl::code $this attach_viewer $v]  "normal"
                }
        }
        $m add_command .viewer.attach.detach "Detach" 0 \
            "Detaches the viewer" [itcl::code $this attach_viewer {}] "normal"
}

itcl::body module_browser::create_paned_window {} {
    set f [frame $itk_interior.main]
    pack $f -side top -expand 1 -fill both -anchor nw -pady 1 -padx 1

    itk_component add splitw {
            base::panedwindow $f.splitw -orient vertical
    }
    $itk_component(splitw) add spltl
    $itk_component(splitw) add spltr
    $itk_component(splitw) fraction 50 50

    create_instance_hierarchy [$itk_component(splitw) childsite spltl]

    # Split the right window for signals and modules
    itk_component add splitsm {
        base::panedwindow [$itk_component(splitw) childsite spltr].splitsm -orient horizontal
    }
    $itk_component(splitsm) add sigpane
    $itk_component(splitsm) add mthpane

    create_signal_list        [$itk_component(splitsm) childsite sigpane]
    create_method_list        [$itk_component(splitsm) childsite mthpane]
    set b [create_action_buttons $f]

    pack $itk_component(splitsm) -expand 1 -fill both
    pack $itk_component(splitw) -expand 1 -fill both -side left
    pack $b -side left -anchor n -expand 0 -fill y  -pady 1 -padx 1
    return $f
}

itcl::body  module_browser::create_signal_list {container} {
    set t $container
    set texttags [list {rule  {-foreground blue}} \
                      {meth   {-foreground #000020}} \
                      {inlined  {-foreground grey35}} \
                      {hilite {-foreground white -background #100842}} \
                     ]

    itk_component add slist {
                base::hierarchy $t.slist \
                    -querycommand          [itcl::code $this s_get_items %n] \
                    -selectcommand         [itcl::code $this select_node slist %n %s] \
                    -selectonemorecommand  [itcl::code $this select_onemore_node slist %n %s] \
                    -selectmanymorecommand [itcl::code $this select_many slist %n] \
                    -dblclickcommand       [itcl::code $this dblclick_node %n] \
                    -postselectcommand     [itcl::code $this post_select slist]\
                    -textmenuloadcommand   [itcl::code $this text_menu slist] \
                    -foreground            black \
                    -visibleitems 5x5 \
                    -texttags $texttags
        } {}


    $t.slist add_itemmenu "Send to Wave"     [itcl::code $this send_to_wave ALL]
    #$t.slist add_itemmenu "Jump to Instance" [itcl::code $this jump_to_instance slist]
    $t.slist add_itemmenu "View Source"      [itcl::code $this view_source slist]
    $t.slist component list configure -padx 3
    pack $t.slist -side top -anchor nw -expand 1 -fill both

}
itcl::body  module_browser::create_method_list {container} {
    set t $container
    set texttags [list {rule  {-foreground blue}} \
                      {meth   {-foreground #000020}} \
                      {inlined  {-foreground grey35}} \
                      {hilite {-foreground white -background #100842}} \
                     ]

    itk_component add mlist {
                base::hierarchy $t.mlist \
                    -querycommand          [itcl::code $this m_get_items %n] \
                    -selectcommand         [itcl::code $this select_node mlist %n %s] \
                    -selectonemorecommand  [itcl::code $this select_onemore_node mlist %n %s] \
                    -selectmanymorecommand [itcl::code $this select_many mlist %n] \
                    -dblclickcommand       [itcl::code $this dblclick_node %n] \
                    -postselectcommand     [itcl::code $this post_select mlist] \
                    -textmenuloadcommand   [itcl::code $this text_menu mlist] \
                    -foreground            black \
                    -visibleitems 5x5 \
                    -texttags $texttags
        } {}


    $t.mlist add_itemmenu "Send to Wave"     [itcl::code $this send_to_wave ALL]
    $t.mlist add_itemmenu "View Source"      [itcl::code $this view_source mlist]
    $t.mlist add_itemmenu "Jump to Instance" [itcl::code $this jump_to_instance mlist]
##    $t.mlist add_itemmenu "Used By ..."      [itcl::code $this jump_to_instance mlist]
    $t.mlist component list configure -padx 3
    pack $t.mlist -side top -anchor nw -expand 1 -fill both

}


itcl::body module_browser::create_instance_hierarchy {container} {
    global BSPEC
    set t $container
    set texttags [list {rule {-foreground blue}} \
                      {synth {-foreground black}} \
                      {prim {-foreground black}} \
                      {hilite {-foreground white -background #100842}} \
                     ]
    itk_component add hier {
        base::hierarchy $t.h \
            -querycommand          [itcl::code $this get_items %n] \
            -selectcommand         [itcl::code $this select_node hier %n %s] \
            -selectonemorecommand  [itcl::code $this select_onemore_node hier %n %s] \
            -selectmanymorecommand [itcl::code $this select_many hier %n] \
            -dblclickcommand       [itcl::code $this dblclick_node %n] \
            -postselectcommand     [itcl::code $this post_select hier] \
            -textmenuloadcommand   [itcl::code $this text_menu hier] \
            -visibleitems 5x5 \
            -texttags $texttags
    } {}

    $t.h add_itemmenu Expand        [itcl::code $this view_expand]
    $t.h add_itemmenu Collapse      [itcl::code $this view_collapse]
    $t.h add_itemmenu Prune         [itcl::code $this prune_selected]
    $t.h add_itemmenu "View Source" [itcl::code $this view_source hier]
    $t.h add_itemmenu "Promote to Top" [itcl::code $this promoteToTop 1]

    $itk_component(hier) configure -foreground grey35
    $itk_component(hier) component itemMenu configure -foreground Black

    set BSPEC(MODULE_HIERARCHY) $t.h
    pack $t.h -side left -anchor nw -expand 1 -fill both

}

itcl::body module_browser::create_action_buttons {container} {
    set c [frame $container.c]
    set width 13
    set pady 2
    # should use a button box here...
    set buttons [list \
                     position 		"View Source" 		"view_source _winsel" \
                     jump_to 		"JumpTo Inst" 		"jump_to_instance _winsel" \
                     send_canfire 	"Send Can Fire" 	"send_to_wave CANFIRE" \
                     send_willfire 	"Send Will Fire" 	"send_to_wave WILLFIRE" \
                     send_qout	 	"Send Reg Output" 	"send_to_wave QOUT" \
                     send_clk	 	"Send Clock"	 	"send_to_wave CLK" \
                     send_pred	 	"Send Predicate" 	"send_to_wave PREDICATE" \
                     send_body	 	"Send Body"	 	"send_to_wave BODY" \
                     send_to_wave 	"Send To Wave"	 	"send_to_wave ALL" \
                    ]

    foreach {w txt cmd} $buttons {
        itk_component add $w {
                button $c.$w -text $txt -command \
                    [eval itcl::code $this $cmd] -width $width \
                    -state disabled
        }
        pack $itk_component($w) -side top -pady $pady
    }
    return $c
}

itcl::body module_browser::add_status_component {cname cval wname side} {
        itk_component add $cname {
                label $itk_component(frame).$wname -textvariable $cval -font bscTooltipFont
        } {
                keep -cursor -font
                rename -font -statusfont statusfont Font
                ignore -background
        }
        pack $itk_component($cname) -side $side -padx 2 -fill x
}

itcl::body module_browser::create_statusbar {} {
        itk_component add frame {
                frame $itk_interior.fr
        }
        pack $itk_component(frame) -fill x -side bottom

        set f $itk_component(frame)
        itk_component add search {
                iwidgets::combobox $f.search -labeltext "Find" \
                    -command "$itk_interior search_inst Next" -completion false \
                    -width 30
        }
        pack $f.search -fill x -side left
        button $f.next -text "Next" -command "$itk_interior search_inst Next"
        pack  $f.next -side left
        button $f.prev -text "Prev" -command "$itk_interior search_inst Prev"
        pack  $f.prev -side left

        pack [ttk::sizegrip $f.grip] -side right -anchor se

        add_status_component fnd [itcl::scope _foundMsg]  fnd left
        add_status_component status mstatus st left
        add_status_component mlstatus BSPEC(LOADED_MODULES) mst right
        add_status_component plstatus BSPEC(LOADED_PACKAGES) pst right
        add_status_component nstatus [$_viewer scope_variable StatusMsg] rst right
}

itcl::body module_browser::set_bindings {} {
    bind $itk_component(hull) <Control-w>  [itcl::code $this  close]
    bind $itk_component(hull) <Control-d>  [itcl::code $this send_to_wave ALL]
}

itcl::body module_browser::clear {} {
        global BSPEC
        set BSPEC(MODULE) ""
        Bluetcl::module clear
        if {[winfo exists $BSPEC(MODULE_BROWSER)] } {
            $BSPEC(MODULE_HIERARCHY) clear
            $BSPEC(MODULE_BROWSER) change_menu_status module {load_top load reload} disabled
            $BSPEC(MODULE_BROWSER) change_menu_status view $view_menu_items0 disabled
            $BSPEC(MODULE_BROWSER) change_menu_status view $view_menu_items1 disabled
            $BSPEC(MODULE_BROWSER) change_menu_status viewer {start attach load reload options \
                                               close} disabled
            foreach i [concat $view_buttons $send_buttons] {
                $BSPEC(MODULE_BROWSER) component $i configure \
                    -state disabled
            }
        }
}

itcl::body module_browser::change_menu_status {m n st} {
        foreach i $n {
                [component menu] set_state $m $i $st
        }
}

itcl::body module_browser::change_item_menu_status {win n st} {
    foreach i $n {
        set id [$itk_component($win) component itemMenu index "$i"]
        $itk_component($win) component itemMenu \
            entryconfigure $id -state $st
    }
}

itcl::body module_browser::close {} {
        wm withdraw $itk_interior
}

itcl::body module_browser::module_load_top {} {
        global PROJECT
        foreach i [concat $view_buttons $send_buttons] {
            component $i configure -state disabled
        }
        if {$PROJECT(TOP_MODULE) != ""} {
                commands::load_module $PROJECT(TOP_MODULE)
        }
    focus $itk_component(hier)
}

itcl::body module_browser::module_load {} {
        global BSPEC
        set m [select_module]
        if {$m != ""} {
                foreach i [concat $view_buttons $send_buttons] {
                    component $i configure \
                            -state disabled
                }
                commands::load_module $m
        }
    focus $itk_component(hier)
}

itcl::body module_browser::module_reload {} {
        foreach i [concat $view_buttons $send_buttons] {
                $itk_component(hull) component $i configure -state disabled
        }
        commands::reload_module

}

itcl::body module_browser::view_expand {} {
    foreach sel [$itk_component(hier) selection get] {
        $itk_component(hier) expand $sel
    }
}

itcl::body module_browser::view_collapse {} {
    foreach sel [$itk_component(hier) selection get] {
        $itk_component(hier) collapse $sel
    }
}

itcl::body module_browser::view_collapse_all {} {
    foreach i $_current_top {
        $itk_component(hier) collapse $i
    }
}

itcl::body module_browser::view_show_schedule {} {
        commands::show_schedule
}


itcl::body module_browser::viewer_start {} {
    commands::start_load
    if { [catch "$_viewer start" err] } {
        error_message $err $itk_component(hull)
        return
    }

    if { [$_viewer cget -DumpFile] eq "" } {
        # give time for viewer window to settle
        after 1000
        raise $itk_interior
        viewer_load_dump_file
    } else {
        commands::finish_load
        update_buttons
        update_menus
    }
}

itcl::body module_browser::viewer_load_dump_file {} {
    global PROJECT
    if {$PROJECT(NAME) != ""} {
        set dir $PROJECT(DIR)
    } else {
        set dir [pwd]
    }
    commands::start_load

    set type {}
    set at   {}
    foreach t [Waves::get_dump_file_extensions] {
        lappend at    ".$t"
    }
    lappend type "{All dump files} {$at}"
    foreach t [Waves::get_dump_file_extensions] {
        lappend type "{$t files} {.$t}"
    }
    lappend type "{All files} {*}"

    set d [tk_getOpenFile -minsize "350 200" -title "Load Dump File" \
               -filetypes $type -initialdir $dir \
               -parent $itk_component(hull)]
    if { $d != ""} {
        $_viewer load_dump_file $d
    }
    commands::finish_load
    update_buttons
    update_menus
}

itcl::body module_browser::viewer_reload_file {} {
        commands::start_load
        $_viewer reload_dump_file
        commands::finish_load
}

itcl::body module_browser::viewer_close {} {
    if { [catch "$_viewer close" err] } {
        error_message $err $::BSPEC(MODULE_BROWSER)
    }
    update_buttons
    update_menus
}


itcl::body module_browser::viewer_options {} {
        global BSPEC
        global PROJECT
        if {$PROJECT(NAME) != ""} {
                create_project_options 5
        } else {
                error_message "There is no open project." $this
        }
}

itcl::body module_browser::view_source {win} {
    if { $win == "_winsel" } { set win $_winsel }
    foreach sel [$itk_component($win) selection get] {
        set obj [lindex [split $sel "."] end]

        set pos [$obj position]
        if {$pos ne ""} {
            commands::edit_file $pos
            break
        }
    }
}


itcl::body module_browser::send_to_wave { modifier } {
    switch -exact $_winsel {
        "hier"  {
            $_viewer send_instance [$itk_component(hier) selection get] $modifier
        }
        "slist" { # signal have a differnt naming pattern
            set objs [list]
            foreach sel [$itk_component(slist) selection get] {
                lappend objs [lindex [split $sel "."] end]
            }
            $_viewer send_objects_mod $objs $modifier
        }
        "mlist" {
            # objects are signals and rules (insts)
            set objs [list]
            foreach sel [$itk_component(mlist) selection get] {
                lappend objs [lindex [split $sel "."] end]
            }
            $_viewer send_objects_mod $objs $modifier
        }
    }
}

itcl::body module_browser::open_module_menu {} {
        global BSPEC
        global PROJECT
        set f "$PROJECT(COMP_BDIR)/$PROJECT(TOP_MODULE).ba"
        change_menu_status module {load_top reload} disabled
        if {$PROJECT(TOP_MODULE) != "" && [file exists $f]} {
                change_menu_status module load_top normal
        }
        if {$BSPEC(MODULE) != ""} {
                change_menu_status module reload normal
        }
}

# set the memu item status before the menu is opened...
itcl::body module_browser::open_view_menu {} {
    set mode normal
    if {[$itk_component(hier) selection get] == ""} {
        set mode disabled
    }
    change_menu_status view $view_menu_items1 $mode
}

itcl::body module_browser::open_wave_menu {} {
    change_menu_status viewer \
                {attach load reload close replay} disabled
    change_menu_status viewer start normal

    if {[$_viewer attach] != ""} {
        change_menu_status viewer attach normal
        add_attach_submenu
    }
    if {[$_viewer isRunning]} {
        change_menu_status viewer {load close} normal
        change_menu_status viewer start disabled
    }
    if {[$_viewer dump_file_loaded]} {
        change_menu_status viewer reload normal
        if {[Bluetcl::module list] != ""} {
            change_menu_status viewer replay normal
        }
    }
}

itcl::body module_browser::jump_to_instance { win } {
    if { $win eq "_winsel" } {
        set s [lindex [$itk_component($_winsel) selection get] 0]
    } else {
        set s [lindex [$itk_component($win)  current] end]
    }
    set obj [lindex [split $s "."] end]

    set inst ""
    switch -exact [$obj class] {
        "VInst" { set inst [$obj path bsv] }
        "VSignal" { set inst [[$obj inst] path bsv] }
        "VMethod" {
            set xinst [$obj path bsv]
            set inst [lindex [split $xinst "."] 0]
        }
        "VRule"  {
            set inst [$obj path bsv]
        }

    }
    if { $inst ne "" } {
        $itk_component(search) clear entry
        $itk_component(search) insert entry 0 $inst
        search_inst "Next"
    }
}


## Search feature
itcl::body module_browser::search_inst {dir} {
    # Check if search has changed
    set search [string trim [$itk_component(search) get]]
    if {$_lastsearch != $search} {
        set _lastsearch $search
        commands::start_load
        if { [catch [list  Virtual::inst filter $search] err] } {
            commands::finish_load
            set _searchlist [list]
            error_message $err $itk_component(hull)
        } else {
            commands::finish_load
            set _searchlist $err
            set _searchindex -1
            if {$dir == "Prev"} {
                set _searchindex 0
            }
        }
    }
    if {$_searchlist == ""} {
        set _foundMsg "Nothing Found"
        $itk_component(hier) selection clear
        return
    }

    set foundLen  [llength $_searchlist]
    if {$dir == "Next"} {
        incr _searchindex
        if {$_searchindex >= $foundLen} {
            set _searchindex 0
        }
    } else {
        incr _searchindex -1
        if {$_searchindex < 0} {
            set _searchindex [expr $foundLen - 1]
        }
    }
    set _foundMsg [format "%d of %d found" [expr $_searchindex +1] $foundLen]
    set cur [lindex $_searchlist $_searchindex]
    foreach i [$cur ancestors] {
        catch "$itk_component(hier) expand [lindex $i 0]"
    }
    $itk_component(hier) draw
    select_node hier [lindex $cur {end 0}] 0
    post_select hier
    # focus back to the search field so "ret" is bound to the next item
    focus [$itk_component(search) component entry]

    # update the find targets
    if { [lsearch -exact [$itk_component(search) component list get 0 end] $search] == -1 } {
        $itk_component(search) insert list 0 $search
    }
}

proc create_module_browser_window {} {
        global BSPEC
        global PROJECT
        module_browser $BSPEC(MODULE_BROWSER) \
                -title "Module Browser$BSPEC(TITLE)" \
                -statusfont bscTooltipFont
        wm geometry $BSPEC(MODULE_BROWSER) $PROJECT(MODULE_PLACEMENT)
        wm minsize $BSPEC(MODULE_BROWSER) 750 410
        wm protocol $BSPEC(MODULE_BROWSER) WM_DELETE_WINDOW \
             "$BSPEC(MODULE_BROWSER) close"

    # Load the top module if possible
    set f "$PROJECT(COMP_BDIR)/$PROJECT(TOP_MODULE).ba"
    if {$PROJECT(TOP_MODULE) != "" && [file exists $f]} {
        set loaded [Bluetcl::module list]
        if {[lsearch -exact $loaded $PROJECT(TOP_MODULE) ] == -1} {
            $BSPEC(MODULE_BROWSER) module_load_top
        }
    }

}
 
