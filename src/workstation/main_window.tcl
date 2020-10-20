 
##
# @file main_window.tcl
#
# @brief Definition of Main window.
#
# This is the top window of BSC Workstation.
# Main window contains :
#       - menubar
#       - toolbar 
#       - status window 
#       - command line 
#       - status bar
#

itcl::class main_window {

        private {
                ##
                # @brief Adds menu buttons to the Main window
                #
                method add_menubuttons {} 

                ##
                # @brief Adds menu actions 
                #
                method add_menuactions {} {
                        add_project_actions
                        add_edit_actions 
                        add_build_actions
                        add_tool_actions
                        add_window_actions
                        add_message_actions
                        add_help_actions  
                }

                ##
                # @brief Adds actions for the Project menu button
                #
                method add_project_actions {} 

                ##
                # @brief Adds actions for the Tool menu button
                #
                method add_tool_actions {} 

                ##
                # @brief Adds actions for the Edit menu button
                #
                method add_edit_actions {}

                ##
                # @brief Adds actions for the Build menu button
                #
                method add_build_actions {}

                ##
                # @brief Adds actions for the Window menu button
                #
                method add_window_actions {}

                ##
                # @brief Adds actions for the Message menu button
                #
                method add_message_actions {}

                ##
                # @brief Adds actions for the Help menu button
                #
                method add_help_actions {}

                ##
                # @brief Creates menubar of the Main window 
                #
                method create_menubar {} {
                        add_menubuttons
                        add_menuactions
                }

                ##
                # @brief Creates toolbar of the Main window 
                #
                method create_toolbar {}
                
                ##
                # @brief Creates user defined toolbuttons 
                #
                method create_user_toolbutton {}
                
                ##
                # @brief Creates the status-command window 
                #
                method create_status_command_window {} {
                        status_command_window .sw 
                        pack .sw -fill both -expand true
                }

                ##
                # @brief Creates the status-bar 
                #
                method create_status_bar {}
        }

        ##
        # @brief Changes the state of the specified tool button
        #
        # @param n name of the tool button
        # @param s state : disabled or active
        #
        proc change_toolbar_state {n s}

        ##
        # @brief Sets the menu status disabled or active
        #
        # @param m the menu button name
        # @param n a list with indexes of menuitems
        # @param s state : disabled or active
        #
        proc change_menu_status {m n s}

        ##
        # @brief Clears the Main window
        #
        proc clear {}

        ##
        # @brief Enables/disables menu items of Build menu            
        #
        proc open_build_menu {}

        constructor {} {
                create_menubar
                create_toolbar
                create_status_command_window
                create_status_bar
                create_user_toolbutton
        }

        destructor {
        }
}

itcl::body main_window::create_status_bar {} {
        global BSPEC
        set menustatus "    "
        frame .sb
        pack [ttk::sizegrip .sb.grip] -side right -anchor se

        label .sb.l -textvariable menustatus -bd 1 -font bscTooltipFont
        label .sb.p -textvariable BSPEC(CURRENT_DIR) -font bscTooltipFont
        pack .sb.l -side left -padx 2 -fill x
        pack .sb.p -side right
        pack .sb -fill x -side bottom
}

itcl::body main_window::add_menubuttons {} { 
        base::menubar .mb
        .mb add_menubutton .project "Project"  0     
        .mb add_menubutton .edit    "Edit"     0
        .mb add_menubutton .build   "Build"    0 "main_window::open_build_menu" 
        .mb add_menubutton .tool    "Tools"    0     
        .mb add_menubutton .window  "Window"   0 
        .mb add_menubutton .message "Message"  0
        .mb add_menubutton .help    "Help"     0
        pack .mb -fill x
}

itcl::body main_window::add_project_actions {} {
        .mb add_command .project.new "New..." 0 "Create new project" \
                         menu_actions::project_new normal
        .mb add_command .project.open "Open..." 0 "Open existing project" \
                         menu_actions::project_open normal
        .mb add_command .project.save "Save" 0 "Save current project" \
                         menu_actions::project_save 
        .mb add_command .project.save_as "Save As..." 5 \
                        "Save current project as..." \
                         menu_actions::project_saveas 
        .mb add_command .project.options "Options..." 1 \
                        "Specify options for current project" \
                         menu_actions::project_options 
        .mb add_command .project.save_placement "Save Placement" 2 \
                        "Save window placement for the project..." \
                         menu_actions::project_save_placement 
        .mb add_command .project.close "Close" 0 "Close existing project" \
                         menu_actions::project_close 
        .mb add_command .project.quit "Quit" 0 "Close the application" \
                         menu_actions::project_quit normal 
}

itcl::body main_window::add_tool_actions {} {
        .mb add_command .tool.back_up "Backup project..." 0 \
                        "Archives the project..." menu_actions::project_backup 
        .mb add_command .tool.export_makefile "Export Makefile..." 0 \
                        "Exports a makefile" menu_actions::export_makefile
        .mb add_command .tool.import_bvi "Import BVI Wizard..." 0 \
                "Activate Import BVI Gui Wizard" \
                 menu_actions::activate_import_bvi_window
}

itcl::body main_window::add_edit_actions {} {        
        .mb add_command .edit.copy "Copy" 0 "Copy selection to clipboard" \
                         menu_actions::copy disabled Ctrl-C
        .mb add_command .edit.paste "Paste" 0 \
                        "Paste clipboard contents into file" \
                         menu_actions::paste disabled Ctrl-V
        .mb add_command .edit.fontp "Font Size +" 10 \
            "Increase font size for all windows" \
            "fonts::bump_fonts +1" normal Ctrl-+
        .mb add_command .edit.fontm "Font Size -" 10 \
               "Decrease font size for all windows" \
               "fonts::bump_fonts -1" normal Ctrl--

}

itcl::body main_window::add_build_actions {} {        
        .mb add_command .build.tccompile "Type Check" 1 \
                "Type check, Compile without elaboration" \
                menu_actions::build_typecheck_compile
        .mb add_command .build.compile "Compile" 0 "Compile the project" \
                         menu_actions::build_compile
        .mb add_command .build.link "Link" 0 "Link the project" \
                         menu_actions::build_link
        .mb add_command .build.simulate "Simulate" 0 "Simulate the project" \
                         menu_actions::build_simulate 

        .mb add_separator .build.s1

        .mb add_command .build.compilelink "Compile + Link" 13 "Compile and Link the project" \
                         menu_actions::build_comp_and_link
        .mb add_command .build.compilelinksim "Compile + Link + Simulate" 22 "Compile, Link and Simulate the project" \
                         menu_actions::build_comp_link_and_sim

        .mb add_separator .build.s2

        .mb add_command .build.rebuild "Full Clean + Compile + Link + Simulate" 1 \
                        "Performs full clean, then compiles links and simulates the project" \
                         menu_actions::full_rebuild 
        .mb add_command .build.clean "Clean" 2 "Clean build results" \
                         menu_actions::build_clean 
        .mb add_command .build.full_clean "Full Clean" 0 \
                        "Clean build results and log files" \
                         menu_actions::build_full_clean 

        .mb add_command .build.stop "Stop" 1 \
                        "Stops the currently executing action" \
                         menu_actions::build_stop 
}

itcl::body main_window::add_window_actions {} {        
        .mb add_command .window.project_window "Project Files" 8 \
                "Activate Project Window" menu_actions::activate_project_window
        .mb add_command .window.editor_window "Editor Window" 0 \
                "Activate Editor Window" menu_actions::activate_editor_window
        .mb add_command .window.package_window "Package Window" 0 \
                "Activate Package Window" menu_actions::activate_package_window
        .mb add_command .window.type_window "Type Browser" 0 \
                        "Activate Type Browser Window" \
                         menu_actions::activate_type_browser_window
        .mb add_command .window.module_window "Module Browser" 0 \
                        "Activate Module Browser Window" \
                         menu_actions::activate_module_browser_window 
        .mb add_command .window.schedule_window "Schedule Analysis" 0 \
                        "Activate Schedule Analysis Window" \
                         menu_actions::activate_schedule_window
        .mb add_command .window.minimize_all "Minimize All" 9 \
                "Minimize all active windows" menu_actions::minimize_all normal
        .mb add_command .window.close_all "Close All" 0 \
                "Closes all active windows"  menu_actions::close_all normal 
}

itcl::body main_window::add_message_actions {} {        
        .mb add_command .message.find "Find     " 0 \
                "Searches for a string in the log" {$eval(status) find} normal
        .mb add_command .message.save "Save" 0 "Saves the log"\
                        {$eval(status) save} normal
        .mb add_command .message.clear "Clear" 0 "Clears the log"\
                        {$eval(status) clear} normal
        .mb add_command .message.hidemessages "Hide Messages" 0 "Hide user messages leaving system messages"\
                        {status_command_window::set_result_font hide} normal
        .mb add_command .message.showmessages "Show Message" 5 "Restore user messages"\
                        {status_command_window::set_result_font show} disabled
}

itcl::body main_window::add_help_actions {} {        
#         .mb add_command .help.contents "Contents..." 0 "Show help contents" \
#                          menu_actions::help_contents normal
        .mb add_command .help.bsv "BSC..." 0 "Show BSC Documentation" \
                         menu_actions::help_bsc normal
        .mb add_command .help.about "About..." 0 "About BSC Workstation" \
                         menu_actions::help_about normal            
}

itcl::body main_window::create_toolbar {} {
        base::toolbar .tb
        .tb add_button new "New project" new.gif "New project" \
                menu_actions::project_new
        .tb add_button open "Open project" open.gif "Open project" \
                menu_actions::project_open
        .tb change_state {new open} normal
        .tb add_button save "Save project" save.gif "Save project" \
                menu_actions::project_save

    .tb add_separator s0 25 20 flat ""

        .tb add_button tccompile "Type Check" table_lightning.gif \
            "Type check; Compile without elaboration" \
            menu_actions::build_typecheck_compile
        .tb add_button compile "Compile the project" application_lightning.gif \
                "Compile the project" menu_actions::build_compile
        .tb add_button link "Link the project" application_link.gif \
                "Link the project" menu_actions::build_link
        .tb add_button simulate "Simulate the project" bullet_go.gif \
                "Simulate the project" menu_actions::build_simulate

    .tb add_separator s1 25 20 flat ""

        .tb add_button compilelink "Compile + Link the project" book_link.gif \
                "Compile + Link the project" menu_actions::build_comp_and_link
        .tb add_button compilelinksim "Compile + Link + Simulate the project" book_go.gif \
                "Compile + Link + Simulate the project" menu_actions::build_comp_link_and_sim

    .tb add_separator s2 25 20 flat ""

        .tb add_button build "Clean + Compile + Link + Simulate the project" \
                arrow_rotate_clockwise.gif \
                "Clean + Compile + Link + Simulate the project" menu_actions::full_rebuild
        .tb add_button clean "Clean the project" application_xp.gif \
                "Clean the project" menu_actions::build_clean

        .tb add_button stop "Stop build" cancel.gif "Stop build" \
                menu_actions::build_stop

        pack .tb -side top -anchor nw -padx 0 -pady 0
}

itcl::body main_window::create_user_toolbutton {} {
        global USER_TOOLBUTTON
        set cmd [list "menu_actions::project_new" "menu_actions::project_open" \
                "menu_actions::project_save" \
                "menu_actions::build_typecheck_compile" \
                "menu_actions::build_compile" "menu_actions::build_link" \
                "menu_actions::build_simulate" "menu_actions::build_clean" \
                "menu_actions::full_rebuild" "menu_actions::build_stop"]

    if { $USER_TOOLBUTTON != [list] } {
        .tb add_separator usersep 25 20 flat ""
    }

        foreach i $USER_TOOLBUTTON {
                set n [lindex $i 0]
                set c [lindex $i 1]
                .tb add button [lindex $i 0] -helpstr [lindex $i 3] \
                        -image [image create photo -file [lindex $i 2]] \
                        -height 25 -width 25 -balloonstr [lindex $i 3] \
                        -command "commands::handle_command \"$c\" $n" \
                        -state normal
                .tb change_state [lindex $i 0] normal
                if {[lsearch $cmd $c] != -1} {
                        puts stderr "Tool button with \"$c\" command is \
                                duplicated."
                } else {
                        lappend cmd $c
                }
        }
}

itcl::body main_window::change_toolbar_state {n s} {
        .tb change_state $n $s
}

itcl::body main_window::change_menu_status {m n s} {
        foreach i $n {
                .mb set_state $m $i $s
        }
}

itcl::body main_window::clear {} {
        main_window::change_menu_status project {save save_as save_placement \
                options close} disabled
        main_window::change_menu_status tool {back_up export_makefile \
                import_bvi} disabled
        main_window::change_menu_status build {tccompile compile link simulate \
                rebuild clean stop full_clean} disabled
        main_window::change_menu_status window {project_window editor_window \
                package_window type_window module_window schedule_window} \
                disabled
        main_window::change_toolbar_state {save tccompile compile link \
                compilelink compilelinksim simulate clean build stop} disabled
}

itcl::body main_window::open_build_menu {} {
        global BSPEC
        global PROJECT
        if {$PROJECT(NAME) != "" && $BSPEC(BUILDPID) == ""} {
                commands::change_menu_toolbar_state
        }
}

frame .embed -container 1 
