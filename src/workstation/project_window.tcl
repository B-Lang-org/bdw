
##
# @file project_window.tcl
#
# @brief Definition of the Project Window.
#
# Project Window is dedicated to represent project specific
# information (list of files, status information for each file).
# Following operations can be performed from Project Window for particular file:
# 	- Edit
#	- Refresh
#	- Compile file
#	- Compile file with dependencies 
# Following operations can be performed from Project Window for current project:
# 	- Compile project
#	- Refresh
#

##
# @brief Definition of class project_window
#

itcl::class project_window {

        ##
        # @brief Creates project window. 
        #
        proc create {}

        ##
        # @brief Changes the menu status for the Project window
        #
        # @param m the name of menu from Project window
        # @param n the number of menu action from menu
        # @param st the status of menu action
        #
        proc change_menu_status {m n st}

        ##
        # @brief Changes the item menu status for the Project window
        #
        # @param n the name(s) of menu action from item menu
        # @param st the status of menu action
        #
        proc change_item_menu_status {n st} 

        ##
        # @brief Changes the background menu status for the Project window
        #
        # @param n the name(s) of menu action from bg menu
        # @param st the status of menu action
        #
        proc change_bg_menu_status {n st} 

        ##
        # @brief Closes the Project window 
        #
        proc close {}

        ##
        # @brief Removes all information from Project window 
        #
        proc clear {}
        
        ##
        # @brief Used as the -querycommand for the hierarchy viewer.
        # Returns the list of files under a particular directory.        
        #
        # @param f the id of the recently selected file
        #
        proc get_files {f} 
        
        ##
        # @brief Returns tagged list {id file_name} for specified files 
        #
        # @param paths the project search paths
        #
        proc get_items {paths} 
        
        ##
        # @brief Select/Deselect the node
        #
        # @param t the most recently selected node
        # @param s if 1/0 then selected/deselected
        # @param p the name of the hierarchy
        #
        proc select_node {t s}
        
        ##
        # @brief Select/Deselect the node
        #
        # @param t the most recently selected node
        #
        proc dblclick_node {t}
        
        ##
        # @brief Select/Deselect the current node
        #
        proc select_current {}

        ##
        # @brief Handles the Project->Options action
        #
        proc project_options {}

        ##
        # @brief Launches the editor on the selected file.
        #
        proc exec_editor_for_selection {}
        
        ##
        # @brief Launches the editor on the current.
        #
        proc exec_editor_for_current {}

        ##
        # @brief Refreshes the selected file.
        #
        proc file_refresh_for_selection {}
        
        ##
        # @brief Refreshes the current file.
        #
        proc file_refresh_for_current {}

        ##
        # @brief Compiles the selected file.
        #
        proc compile_file_for_selection {}

        ##
        # @brief Typecheck the selected file.
        #
        proc typecheck_file_for_selection {}
        
        ##
        # @brief Compiles the current.
        #
        proc compile_file_for_current {}

        ##
        # @brief Typecheck the current.
        #
        proc typecheck_file_for_current {}

        ##
        # @brief Compiles the selected file with deps.
        #
        proc compile_file_with_deps_for_selection {}
        
        ##
        # @brief Typecheck the selected file with deps.
        #
        proc typecheck_file_with_deps_for_selection {}
        
        ##
        # @brief Compiles the current with deps.
        #
        proc compile_file_with_deps_for_current {}

        ##
        # @brief Typecheck the current with deps.
        #
        proc typecheck_file_with_deps_for_current {}

        ##
        # @brief Enables/disables menu items of File menu            
        #
        proc open_file_menu {}

        ##
        # @brief Enables/disables menu items of Edit menu            
        #
        proc open_editor_menu {}

        private {

                ##
                # @brief Returnes the file directory
                #
                # @param f the URL of the file
                #
                # @return
                #
                proc sub_string {f}

                ##
                # @brief Creates menubar. 
                #
                # @param p parent window
                #
                proc create_menubar {p} 

                ##
                # @brief Creates the Project menu. 
                #
                # @param p parent window
                #
                proc create_project_menu {p} 

                ##
                # @brief Creates the File menu. 
                #
                # @param p parent window
                #
                proc create_file_menu {p} 

                ##
                # @brief Creates the File menu. 
                #
                # @param p parent window
                #
                proc create_editor_menu {p} 

                ##
                # @brief Creates the project hierarchy. 
                #
                # @param p parent window
                #
                proc create_project_hierarchy {p} 

                ##
                # @brief Creates statusbar. 
                #
                # @param p parent window
                #
                proc create_statusbar {p} 

                ##
                # @brief Sets the arrow key bindings for Project Window 
                # 
                proc set_bindings {}
        }
}


itcl::body project_window::create_menubar {p} { 
        base::menubar $p.mb 
        create_project_menu $p.mb
        create_file_menu $p.mb
        create_editor_menu $p.mb
        pack $p.mb -fill x
}

itcl::body project_window::create_project_menu {p} { 
        $p add_menubutton .project "Project" 0 
        $p add_command .project.options "Options..." 0 \
                "Opens the Files tab of the Project Options dialog" \
                project_window::project_options normal
        $p add_command .project.tccompile "Type Check" 0 \
                "Type check, Compile without elaboration" \
                commands::typecheck normal
        $p add_command .project.compile "Compile" 0\
                "Compiles the project" commands::compile normal
        $p add_command .project.refresh "Refresh" 0 \
                "Refreshes the project tree" commands::refresh normal
        $p add_command .project.close "Close" 1 "Closes the project window" \
                project_window::close normal
}

itcl::body project_window::create_file_menu {p} { 
        $p add_menubutton .file "File" 0 "project_window::open_file_menu"
        $p add_command .file.new "New..." 0 "Create new file" \
                menu_actions::file_new normal
        $p add_command .file.edit "Edit" 0 "Launch editor on selected file"\
                       project_window::exec_editor_for_selection
        $p add_command .file.refresh "Refresh" 0 "Refresh file information"\
                       project_window::file_refresh_for_selection 
        $p add_command .file.compile "Compile" 0 \
                                "Compile file without dependencies" \
                                project_window::compile_file_for_selection 
        $p add_command .file.compile_with_deps "Compile with Deps" 13 \
                                "Compile file with dependencies" \
                 project_window::compile_file_with_deps_for_selection 
        $p add_command .file.tccompile "Typecheck" 0 \
                                "Typecheck file without dependencies" \
                                project_window::typecheck_file_for_selection 
        $p add_command .file.tccompile_with_deps "Typecheck with Deps" 1 \
                                "Typecheck file with dependencies" \
                 project_window::typecheck_file_with_deps_for_selection 

}

itcl::body project_window::create_editor_menu {p} { 
        $p add_menubutton .editor "Editor" 0 "project_window::open_editor_menu" 
        $p add_command .editor.save "Save" 0 "Save existing file" \
                      menu_actions::editor_save
        $p add_command .editor.save_as "Save As..." 5 "Save file as..." \
                      menu_actions::editor_save_as
        $p add_command .editor.close "Close" 0 "Close current file" \
                      menu_actions::editor_close
        $p add_command .editor.close_all "Close All" 2 \
                "Close all open files" menu_actions::editor_close_all 
}

itcl::body project_window::create_project_hierarchy {p} {
        global BSPEC
        base::hierarchy $p.h -querycommand "project_window::get_files %n"\
                -selectcommand "project_window::select_node %n %s" \
                -dblclickcommand "project_window::dblclick_node %n"
        $p.h component itemMenu configure -cursor {}
        $p.h component bgMenu configure -cursor {}
        pack $p.h -side top -expand yes -fill both
        set BSPEC(PROJECT_HIERARCHY) $p.h
        $p.h add_itemmenu Edit "{project_window::exec_editor_for_current}"
        $p.h add_itemmenu Refresh "{project_window::file_refresh_for_current}"
        $p.h add_separator
        $p.h add_itemmenu "Compile file"\
                          "{project_window::compile_file_for_current}"
        $p.h add_itemmenu "Compile file with deps"\
                          "{project_window::compile_file_with_deps_for_current}"
        $p.h add_itemmenu "Typecheck file"\
                          "{project_window::typecheck_file_for_current}"
        $p.h add_itemmenu "Typecheck file with deps"\
                          "{project_window::typecheck_file_with_deps_for_current}"
        $p.h add_bgmenu "New File" "{menu_actions::file_new}"
        $p.h add_bgmenu "Compile project" "{commands::compile}"
        $p.h add_bgmenu "Refresh" "{commands::refresh}"
}

itcl::body project_window::create_statusbar {p} {
    global pwstatus ""
    set pwstatus ""
        pack [ttk::sizegrip $p.grip] -side right -anchor se
        frame $p.sb

        label $p.sb.l -textvariable pwstatus -bd 1 -font bscTooltipFont
        pack $p.sb.l -side left -padx 2 -fill x
        pack $p.sb -fill x -side bottom
}

itcl::body project_window::set_bindings {} {
        global BSPEC
        bindtags $BSPEC(PROJECT) [list $BSPEC(PROJECT) \
                $BSPEC(PROJECT_HIERARCHY) . all]
        bind $BSPEC(PROJECT) <Control-w> {
                project_window::close
        }
}

itcl::body project_window::create {} {
        global BSPEC
        global PROJECT
        if {![winfo exists $BSPEC(PROJECT)]} { 
                toplevel $BSPEC(PROJECT)
                create_menubar $BSPEC(PROJECT)
                create_project_hierarchy $BSPEC(PROJECT)
                create_statusbar $BSPEC(PROJECT)
                set_bindings
                wm title $BSPEC(PROJECT) "Project Files$BSPEC(TITLE)"
                wm geometry $BSPEC(PROJECT) $PROJECT(PROJECT_PLACEMENT)
                wm minsize $BSPEC(PROJECT) 250 250
        }
}

itcl::body project_window::clear {} {
        global BSPEC
        if {[winfo exists $BSPEC(PROJECT)]} {
                $BSPEC(PROJECT_HIERARCHY) clear
                change_menu_status project {options tccompile compile refresh} \
                        disabled
                change_menu_status file \
                        {new edit refresh compile compile_with_deps tccompile \
                        tccompile_with_deps} disabled
                change_bg_menu_status {"New File" "Compile project" "Refresh"} \
                        disabled
        }
}

itcl::body project_window::change_menu_status {m n st} {
        global BSPEC
        foreach i $n {
                 $BSPEC(PROJECT).mb set_state $m $i $st
        }
}

itcl::body project_window::change_item_menu_status {n st} {
        global BSPEC
        foreach i $n {
                set id [$BSPEC(PROJECT_HIERARCHY) component itemMenu index "$i"]
                $BSPEC(PROJECT_HIERARCHY) component itemMenu \
                        entryconfigure $id -state $st
        }
}

itcl::body project_window::change_bg_menu_status {n st} {
        global BSPEC
        foreach i $n {
                set id [$BSPEC(PROJECT_HIERARCHY) component bgMenu index "$i"]
                $BSPEC(PROJECT_HIERARCHY) component bgMenu \
                        entryconfigure $id -state $st
        }
}

itcl::body project_window::close {} {
        global BSPEC
        destroy $BSPEC(PROJECT)
}

itcl::body project_window::sub_string {f} {
        set t [file tail $f]
        set d [file tail [file dirname $f]]
        return [file join $d $t]
}

itcl::body project_window::get_items {paths} {
        global PROJECT
        set r ""
        if {$PROJECT(COMP_TYPE) == "make" && $PROJECT(MAKE_FILE) != ""} {
                lappend r [list $PROJECT(MAKE_FILE) \
                        [file tail $PROJECT(MAKE_FILE)]]
        }
        set included {}
        set excluded {}
        foreach d $paths {
                foreach f $PROJECT(INCLUDED_FILES) {
                        foreach i [lsort [glob -nocomplain -directory $d $f]] {
                                lappend included $i
                        }
                }
                foreach f $PROJECT(EXCLUDED_FILES) {
                        foreach i [lsort [glob -nocomplain -directory $d $f]] {
                                lappend excluded $i
                        }
                }
        }
        foreach i $included {
                if {[lsearch $excluded $i] == -1} {
                        lappend r [list $i [project_window::sub_string $i]]
                }
        }
        return $r
}

itcl::body project_window::get_files {f} {
        global env
        global PROJECT
        if {$f != ""} {
            return ""
        }
        set ldir [regsub -all "%/Libraries " $PROJECT(PATHS) ""]
        set ldir [regsub -all "%" $ldir $env(BLUESPECDIR)]
        set rlist [project_window::get_items $ldir]

        return $rlist
}

itcl::body project_window::select_node {t s} {
        global BSPEC
        if {!$s} {
                $BSPEC(PROJECT_HIERARCHY) selection clear
                $BSPEC(PROJECT_HIERARCHY) selection add $t
                change_menu_status file {edit refresh} normal
                change_item_menu_status {"Compile file" \
                        "Compile file with deps" "Typecheck file" \
                        "Typecheck file with deps"} disabled
                if {$BSPEC(BUILDPID) == ""} {
                        change_menu_status file {compile compile_with_deps \
                                tccompile tccompile_with_deps} normal
                        change_item_menu_status {"Compile file" \
                                "Compile file with deps" "Typecheck file" \
                                "Typecheck file with deps"} normal
                }
        } else {
                $BSPEC(PROJECT_HIERARCHY) selection clear
                change_menu_status file \
                        {edit refresh compile compile_with_deps tccompile \
                             tccompile_with_deps} disabled
        }
}

itcl::body project_window::dblclick_node {t} {
    commands::edit_file [FileSupport::createPosition $t]
}

itcl::body project_window::exec_editor_for_selection {} {
        global BSPEC 
        commands::edit_file [FileSupport::createPosition \
				 [$BSPEC(PROJECT_HIERARCHY) selection get]]
}

itcl::body project_window::file_refresh_for_selection {} {
        global BSPEC
        commands::refresh [$BSPEC(PROJECT_HIERARCHY) selection get]
}
        
itcl::body project_window::compile_file_for_selection {} {
        global BSPEC
        commands::compile_file [$BSPEC(PROJECT_HIERARCHY) selection get] "" ""
}

itcl::body project_window::compile_file_with_deps_for_selection {} {
        global BSPEC
        commands::compile_file [$BSPEC(PROJECT_HIERARCHY) selection get] 1 ""
}

itcl::body project_window::typecheck_file_for_selection {} {
        global BSPEC
        commands::compile_file [$BSPEC(PROJECT_HIERARCHY) selection get] "" 1
}

itcl::body project_window::typecheck_file_with_deps_for_selection {} {
        global BSPEC
        commands::compile_file [$BSPEC(PROJECT_HIERARCHY) selection get] 1 1
}

itcl::body project_window::select_current {} {
        global BSPEC
        if {[$BSPEC(PROJECT_HIERARCHY) selection get] != ""} {
                $BSPEC(PROJECT_HIERARCHY) selection clear
        }
        $BSPEC(PROJECT_HIERARCHY) selection add \
                [$BSPEC(PROJECT_HIERARCHY) current]
        change_menu_status file {edit refresh compile compile_with_deps \
                tccompile tccompile_with_deps} normal
}

itcl::body project_window::project_options {} {
        global PROJECT
        global BSPEC
        if {$PROJECT(NAME) != ""} {
                create_project_options 0 
        } else {
                error_message "There is no open project." $BSPEC(PROJECT)
        }
}

itcl::body project_window::exec_editor_for_current {} {
        global BSPEC 
        select_current 
        commands::edit_file [FileSupport::createPosition \
				 [$BSPEC(PROJECT_HIERARCHY) current]]
}

itcl::body project_window::file_refresh_for_current {} {
        global BSPEC
        select_current 
        commands::refresh [$BSPEC(PROJECT_HIERARCHY) current]
}
        
itcl::body project_window::compile_file_for_current {} {
        global BSPEC
        select_current 
        commands::compile_file [$BSPEC(PROJECT_HIERARCHY) current] "" ""
}

itcl::body project_window::compile_file_with_deps_for_current {} {
        global BSPEC
        select_current 
        commands::compile_file [$BSPEC(PROJECT_HIERARCHY) current] 1 ""
}

itcl::body project_window::typecheck_file_for_current {} {
        global BSPEC
        select_current 
        commands::compile_file [$BSPEC(PROJECT_HIERARCHY) current] "" 1
}

itcl::body project_window::typecheck_file_with_deps_for_current {} {
        global BSPEC
        select_current 
        commands::compile_file [$BSPEC(PROJECT_HIERARCHY) current] 1 1
}

itcl::body project_window::open_file_menu {} {
        global BSPEC
        if {[$BSPEC(PROJECT_HIERARCHY) selection get] == ""} {
                project_window::change_menu_status file {edit refresh compile \
                        compile_with_deps tccompile tccompile_with_deps} \
                        disabled
        } else { 
                project_window::change_menu_status file {edit refresh} normal
                if {$BSPEC(BUILDPID) == ""} {
                        project_window::change_menu_status file \
                                {compile compile_with_deps tccompile \
                                tccompile_with_deps} normal
                } 
        }
}

itcl::body project_window::open_editor_menu {} {
    global PROJECT
    project_window::change_menu_status editor \
        {save save_as close close_all} disabled
    if { $PROJECT(EDITOR_NAME) == "gvim" && [commands::gvim_check_existance_of_editor_server]} {
        project_window::change_menu_status editor \
            {save save_as close close_all} normal
    } 
}
