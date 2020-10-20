
##
# @file menu_actions.tcl
#
# @brief Definitions of Project, File and Window menus' handlers
#

##
# @brief Namespace for menubar actions 
#
namespace eval menu_actions {

##
# @brief Handles the "Project->New" command
#
proc project_new {} {
        global PROJECT
        if {$PROJECT(STATUS) == ""} {
                save_current 
                if {$PROJECT(STATUS) == ""} {
                        return
                } 
        }
        set type {{{Bspec files} {.bspec} }}
        set initfile [file tail [pwd]]
        if {[set f [tk_getSaveFile -minsize "350 200" -title "New Project" \
                        -filetypes $type -initialfile $initfile]] != ""} {
                if {[file extension $f] != ""} {
                        set f [regsub -- ".bspec" $f ""]
                }
                commands::new_project [file tail $f] [file dirname $f]
                create_project_options 0 
        }
        debug "Selected : Project->New"
}

##
# @brief Handles the "Project->Open" command
#
proc project_open {} {
        global env
        global PROJECT
        if {$PROJECT(NAME) != ""} {
                set dir $PROJECT(DIR)
        } else {
                set dir $env(PWD)
        }
        if {$PROJECT(STATUS) == ""} {
                save_current 
                if {$PROJECT(STATUS) == ""} {
                        return
                } 
        }
        set type {{{Bspec files} {.bspec} }}
        if {[set f [tk_getOpenFile -minsize "350 200" -title "Open Project" \
                        -filetypes $type -initialdir $dir]] != ""} {
                commands::open_project $f 
        }
        debug "Selected : Project->Open"
}

##
# @brief Handles the "Project->Options" command
#
proc project_options {} {
        global PROJECT
        if {$PROJECT(NAME) != ""} {
                create_project_options
        } else {
                error_message "There is no open project."
        }
        debug "Selected : Project->Options"
}

##
# @brief Handles the "Project->Save" command
#
proc project_save {} {
        global PROJECT
        if {$PROJECT(NAME) != ""} {
                commands::save_project
        } else {
                error_message "There is no open project."
        }
        debug "Selected : Project->Save"
}

##
# @brief Handles the "Project->Save as" command
#
proc project_saveas {} {
        global PROJECT
        if {$PROJECT(NAME) != ""} {
                commands::create_save_as_dialog
        } else {
                error_message "There is no open project."
        }
        debug "Selected : Project->Save as"
}

##
# @brief Handles the "Project->Save Placement" command
#
proc project_save_placement {} {
        commands::project_save_placement
        debug "Selected : Project->Save Placement"
}

##
# @brief Handles the "Project->Backup files" command
#
proc project_backup {} {
        create_back_up_dialog
        debug "Selected : Project->Backup files"
}

##
# @brief Handles the "Project->Export Makefile" command
#
proc export_makefile {} {
        global PROJECT
        if {$PROJECT(STATUS) == ""} {
                if {![ignore_warning "The project is not saved."]} {
                        return error
                }
        }
        set f [tk_getSaveFile -title "Export Makefile" -minsize "350 200" \
                -initialfile Makefile]
        if {$f != ""} {
                commands::export_makefile [file tail $f] [file dirname $f]
        }
        debug "Selected : Project->Export Makefile"
}

##
# @brief Handles the "Project->Close" command
#
proc project_close {} {
        global PROJECT
        if {$PROJECT(STATUS) == ""} {
                save_current 
        } 
        if {$PROJECT(STATUS) != ""} {
                commands::close_project
        } 
        debug "Selected : Project->Close"
}

##
# @brief Handles the "Project->Quit" command
#
proc project_quit {} {
        debug "Selected : Project->Quit"
        commands::exit_main_window
}

##
# @brief Handles the "File->New" command
#
# @return file name of file
#
proc file_new {} {
        create_file_new
        debug "Selected : File->New"
}

##
# @brief Handles the "Editor->Save" command
#
proc editor_save {} {
        commands::save_file
        debug "Selected : Editor->Save"
}

##
# @brief Handles the "Editor->Save as" command
#
# @return file Name of the created file
#
proc editor_save_as {} {
        if {[commands::gvim_check_existance_of_editor_server]} {
                create_file_save_as
        }
        debug "Selected : Editor->Save as"
}

##
# @brief Handles the "Editor->Close" command
#
proc editor_close {} {
        commands::close_file
        debug "Selected : Editor->Close"
}

##
# @brief Handles the "Editor->Close All" command
#
proc editor_close_all {} {
        commands::close_all_files
        debug "Selected : Editor->Close All"
}

##
# @brief Handles the "Build->Type Check" command
#
proc build_typecheck_compile {} {
        commands::typecheck
        debug "Selected : Build->Type Check"
}

##
# @brief Handles the "Build->Compile" command
#
proc build_compile {} {
        commands::compile
        debug "Selected : Build->Compile"
}

##
# @brief Handles the "Build->Link" command
#
proc build_link {} {
        commands::link
        debug "Selected : Build->Link"
}

##
# @brief Handles the "Build->Simulate" command
#
proc build_simulate {} {
        commands::simulate
        debug "Selected : Build->Simulate"
}

proc build_comp_and_link {} {
    commands::comp_and_link
    debug "Selected : Build->Compile/Link"
}
proc build_comp_link_and_sim {} {
    commands::comp_link_and_sim
    debug "Selected : Build->Compile/Link/Simulate"
}
##
# @brief Handles the "Build->Clean" command
#
proc build_clean {} {
        commands::clean
        debug "Selected : Build->Clean"
}

##
# @brief Handles the "Build->Full Clean" command
#
proc build_full_clean {} {
        commands::full_clean
        debug "Selected : Build->Full Clean"
}

##
# @brief Handles the "Build->Full Rebuild" command
#
proc full_rebuild {} {
        commands::build
        debug "Selected : Build->Full Rebuild"
}

##
# @brief Handles the "Build->Stop" command
#
proc build_stop {} {
        commands::stop
        debug "Selected : Build->Stop viewer"
}

##
# @brief Handles the "Window->Project Window" command
#
proc activate_project_window {} {
        commands::show_project_window
        debug "Selected : Window->Project window"
}

##
# @brief Handles the "Window->Editor Window" command
#
proc activate_editor_window {} {
        commands::show_editor_window
        debug "Selected : Window->Editor window"
}

##
# @brief Handles the "Window->Package Window" command
#
proc activate_package_window {} {
        commands::show_package_window
        debug "Selected : Window->Package window"
}

##
# @brief Handles the "Window->Type Browser" command
#
proc activate_type_browser_window {} {
        commands::show_type_browser_window
        debug "Selected : Window->Type Browser window"
}

##
# @brief Handles the "Window->Module Browser" command
#
proc activate_module_browser_window {} {
        commands::show_module_browser_window
        debug "Selected : Window->Module Browser window"
}

##
# @brief Handles the "Window->Schedule Analysis Window" command
#
proc activate_schedule_window {} {
        commands::show_schedule_analysis_window
        debug "Selected : Window->Schedule Analyser window"
}

##
# @brief Handles the "Window->Scheduling Graphs->Conflict Graph" command
#
proc activate_conflict_graph {} {
        commands::show_graph_window conflict
        debug "Selected : Window->Scheduing Graphs->Conflict"
}

##
# @brief Handles the "Window->Scheduling Graphs->Execution" command
#
proc activate_execution_graph {} {
        commands::show_graph_window exec
        debug "Selected : Window->Scheduing Graphs->Execution Order"
}

##
# @brief Handles the "Window->Scheduling Graphs->Urgency" command
#
proc activate_urgency_graph {} {
        commands::show_graph_window urgency
        debug "Selected : Window->Scheduing Graphs->Urgency"
}

##
# @brief Handles the "Window->Scheduling Graphs->Combined" command
#
proc activate_combined_graph {} {
        commands::show_graph_window combined
        debug "Selected : Window->Scheduing Graphs->Combined"
}

##
# @brief Handles the "Window->Scheduling Graphs->Combined Full" command
#
proc activate_combined_full_graph {} {
        commands::show_graph_window combined_full
        debug "Selected : Window->Scheduing Graphs->Combined Full"
}

##
# @brief Handles the "Window->Import BVI Wizard" command
#
proc activate_import_bvi_window {} {
        commands::show_import_bvi_window
        debug "Selected : Window->Import BVI Wizard"
}

##
# @brief Handles the "Window->Minimize All" command
#
proc minimize_all {} {
        commands::minimize_all
        debug "Selected : Window->Minimize all"
}

##
# @brief Handles the "Window->Close All" command
#
proc close_all {} {
        commands::close_all
        debug "Selected : Window->Close all"
}

##
# @brief Copies the selection to clipboard
#
proc copy {} {
        if {[catch "selection get"] != 1} {
                clipboard clear
                clipboard append [selection get]
        }
#       global eval
#       tk_textCopy [$eval(status) gettext]
        debug "Selected : Edit->Copy"
}

##
# @brief Pastes the contents of the clipboard
#
proc paste {} {
        global eval
        tk_textPaste $eval(text)
        debug "Selected : Edit->Paste"
}

##
# @brief Creates the "Help->About" dialog
#
proc help_about {} {
        commands::help -about
}

##
# @brief Creates the "Help->Contents" dialog
#
proc help_contents {} {
        commands::help -content
}

##
# @brief Creates the "Help->Bsv" dialog
#
proc help_bsc {} {
        commands::help -bsc
}

##
# @brief Creates the "Help->Index" dialog
#
proc help_index {} {
        commands::help -index
}
} 

