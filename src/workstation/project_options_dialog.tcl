# @file project_options_dialog.tcl
#
# @brief Definition of the Project Options dialog window.
#

##
# @brief Defintion of class options_dialog
#
#catch "itcl::delete class options_dialog"
itcl::class options_dialog {
        inherit iwidgets::Dialog

        ##
        # @brief The names of "Files", "Compile", "Link\nSimulate", "Editor",
        # "Waveform\nViewer" tabs accordingly
        #
        variable file
        variable cmp
        variable sim
        variable edt
        variable wv

        ##
        # @brief The name of "Compile to" radiobox
        #
        common bsc_type ""

        ##
        # @brief The names of "Compile options" and "RTS options" entries
        #
        common comp_cbsc ""

        ##
        # @brief The list with names of "Makefile", "Build target", "Clean
        # target", "Full clean target", "Make options" entries and "Browse"
        # button.
        #
        common comp_cmake ""

        ##
        # @brief The name of "Compile via bsc" and "Compile via make"
        # chechbuttons
        #
        common comp_type ""

        ##
        # @brief A list which contains the names of editors for editors
        #
        common editors ""

        ##
        # @brief A list which contains the names of chechbuttons for editors
        #
        common edt_type ""

        ##
        # @brief The name of "Link to" radiobox
        #
        common lbsc_type ""

        ##
        # @brief A list with names of "Output directory" entry, "Browse"
        # button, "Output name", "Link options", "Run options", "Simulate
        # options" entries and "Verilog Simulator" combobox accordingly
        #
        common lnkbsc ""

        ##
        # @brief A list with names of  "Makefile" entry, "Browse" button, "Link
        # target", "Simulate target", "Clean target", "Full clean target",
        # "Make options" entries
        #
        common lnkmake ""

        ##
        # @brief The names of "Link command" and "Simulate Command" entries
        #
        common lnkcust ""

        ##
        # @brief A list with names of "Link via bsc", "Link via make", "Link
        # via custom cmd" checkbuttons
        #
        common lnk_type ""

        ##
        # @brief The name of "Search Path" listbox 
        #
        common plist ""

        ##
        # @brief A list which contains lists. Each list contains name and
        # widget name 
        #
        common blist ""

        ##
        # @brief The name of the tabnotebook 
        #
        common tab ""

        ##
        # @brief The name of "Verilog Simulator" combobox 
        #
        common ver_sim ""

        ##
        # @brief List with names of "Command" and "Options" entries of Waveform
        # Viewer tab 
        #
        common wv_com ""

        ##
        # @brief The name of type checkbutton in Waveform Viewer tab 
        #
        common wv_type ""

        private {
                ##
                # @brief Adds the tabnotebook
                #
                method add_tabnotebook {}

                ##
                # @brief Adds the files tab
                #
                method add_files_tab {}

                ##
                # @brief Adds the compiler tab
                #
                method add_compile_tab {}

                ##
                # @brief Adds the simulator tab
                #
                method add_link_simulator_tab {}

                ##
                # @brief Adds the editor tab
                #
                method add_editor_tab {}

                ##
                # @brief Adds the waveform viewer tab
                #
                method add_waveform_viewer_tab {}

                ##
                # @brief Adds the search path
                #
                method add_search_path {}

                ##
                # @brief Adds the files tab
                #
                method align_file_tab_labels {}

                ##
                # @brief Sets the variables for the files tab
                #
                method set_file_vars {}

                ##
                # @brief Creates bsc fields for the compiler tab 
                #
                method create_bsc_fields {}

                ##
                # @brief Creates make fields for the compiler tab
                #
                method create_make_fields {}

                ##
                # @brief Sets the variables for the compiler tab
                #
                method set_comp_vars {}

                ##
                # @brief Creates bsc fields for the link tab
                #
                method create_link_bsc_fields {}

                ##
                # @brief Creates make fields for the link tab
                #
                method create_link_make_fields {}

                ##
                # @brief Creates custom command fields for the link tab
                #
                method create_link_custom_command_fields {}

                ##
                # @brief Creates viewer fields for the waveform viewer tab
                #
                method create_viewers {}

                ##
                # @brief Sets variables for the link tab
                #
                method set_link_sim_vars {}

                ##
                # @brief Allignes the enrty labels in the Compiler tab
                #
                method align_comp_tab_labels {}

                ##
                # @brief Allignes the enrty labels in the Link/Simulate tab
                #
                method align_link_sim_tab_labels {}

                ##
                # @brief Adds an entryfield   
                #
                method add_entryfield {tab f name label {y 0}}

                ##
                # @brief Adds an entryfield with a browse button
                #
                method add_browse_entryfield {tab f lname label cmd {y 0}}

                ##
                # @brief Adds an separator  
                #
                method add_separator {tab name}

                ##
                # @brief Adds a checkbutton  Only a select action (like a radio button)
                #
                method add_checkbutton {tab f name text cmd {pady 1}}

                ##
                # @brief Adds a checkbutton with a toggle action  
                #
                method add_togglebutton {tab f name text cmd {pady 5}}

                ##
                # @brief Gets compiler specific options for the current project 
                #
                method get_compiler_options {}

                ##
                # @brief Gets simulator specific options for the current project
                #
                method get_link_sim_options {}

                ##
                # @brief Gets compiler specific options for the current project 
                #
                method get_editor_options {}

                ##
                # @brief Gets waveform viewer specific options for the current
                # project 
                #
                method get_viewer_options {}

                ##
                # @brief Gets files specific options for the current project 
                #
                method get_files_options {}

                ##
                # @brief Sets compiler specific options for the current project 
                #
                method set_compiler_options {}

                ##
                # @brief Sets compiler specific options for the current project 
                #
                method set_link_sim_options {}

                ##
                # @brief Sets compiler specific options for the current project 
                #
                method set_editor_options {}

                ##
                # @brief Sets waveform viewer specific options for the current
                # project 
                #
                method set_viewer_options {}

                ##
                # @brief Sets file options for the current project 
                #
                method set_file_options {}

                ##
                # @brief Checks bsc options for the current project 
                #
                method check_bsc_options {}

                ##
                # @brief Checks compiler make options for the current project 
                #
                method check_make_options {}

                ##
                # @brief Checks files specific options for the current project 
                #
                method check_files_options {}

                ##
                # @brief Checks compiler specific options for the current
                # project 
                #
                method check_compiler_options {}

                ##
                # @brief Checks link bsc options for the current project 
                #
                method check_link_bsc_options {}

                ##
                # @brief Checks link make options for the current project 
                #
                method check_link_make_options {}

                ##
                # @brief Checks link and simulation custom command for 
                # the current project 
                #
                method check_custom_command {}

                ##
                # @brief Checks link and simulation options for the current
                # project 
                #
                method check_link_sim_options {}

                ##
                # @brief Checks editor specific options for the current project 
                #
                method check_editor_options {}

                ##
                # @brief Checks if the specified path is a directory 
                #
                method check_dirs {dirs}
                
                ##
                # @brief Returns the value of the specified entry component
                #
                # @param ent the name of the entry component
                #
                method get_entry {ent} {
                        return [commands::extract_spaces \
                                [$itk_component($ent) get]]
                }

                ##
                # @brief Returns the real path of the specified entry component
                #
                # @param ent the name of the entry component
                #
                method get_real_path_entry {ent} {
                        set s [commands::extract_spaces \
                                [$itk_component($ent) get]]
                        set s [commands::customize_custom_command $s]
                        if {$s == ""} {
                                return ""
                        } elseif {[file pathtype $s] == "absolute"} {
                                return [commands::make_absolute_path $s]
                        } else {
                                return [commands::make_related_path $s]
                        }
                }

                ##
                # @brief Gets the current value for the specified component  
                #
                # @param name the name of the component 
                #
                method get {name} {
                        return [$itk_component($name) get]
                }

                ##
                # @brief Gets the current type of compilation  
                #
                method get_comp_type {} {
                        global comp_type_bsc
                        global comp_type_make
                        if {$comp_type_bsc == 1} {
                                return bsc
                        } else {
                                return make
                        }
                }

                ##
                # @brief Gets the current type of link  
                #
                method get_link_type {} {
                        global link_type_bsc
                        global link_type_make
                        global link_type_custom_command
                        if {$link_type_bsc == 1} {
                                return bsc
                        } elseif {$link_type_make == 1} {
                                return make
                        } else {
                                return custom_command
                        }
                }

                ##
                # @brief Gets the current type of editor 
                #
                method get_editor_type {} {
                        global BSPEC
                        foreach e $BSPEC(EDITORS) {
                                global edt_type_$e
                                set t edt_type_$e
                                eval set t $$t
                                if {$t == 1} {
                                        return $e
                                }
                        }
                }

                ##
                # @brief Gets the name of the currently selected viewer
                #
                method get_viewer_name {} {
                        foreach i [Waves::get_supported_wave_viewers] {
                                global [string tolower $i]
                                eval set s $[string tolower $i]
                                if {$s} {
                                        return $i
                                }
                        }
                }
        }

        ##
        # @brief Sets current options for the project 
        #
        method set_project_options {}

        ##
        # @brief Gets current options for the project 
        #
        method get_project_options {}

        ##
        # @brief Checks current options for the project 
        #
        method check_project_options {}

        ##
        # @brief Sets the bindings for Project Options dialog
        # 
        method set_bindings {} {
                set w [string replace $this 0 1]
                bind $w <Control-w> {
                        .[lindex [split %W .] 1] deactivate 0
                }
        }

        ##
        # @brief Activates bsc fields
        #
        proc activate_bsc_fields {}

        ##
        # @brief Activates make fields
        #
        proc activate_make_fields {}

        ##
        # @brief Activates bluesim fields
        #
        proc activate_bluesim {}

        ##
        # @brief Activates verilog fields
        #
        proc activate_verilog {}

        ##
        # @brief Activates link bluesim fields
        #
        proc activate_link_bluesim {}

        ##
        # @brief Activates link verilog fields
        #
        proc activate_link_verilog {}

        ##
        # @brief Activates viewer fields
        #
        # @param viewer the name of the waveform viewer
        #
        method activate_viewer {viewer}

        ##
        # @brief Activates make fields
        #
        proc activate_link_bsc_fields {}

        ##
        # @brief Activates make fields
        #
        proc activate_link_make_fields {}

        ##
        # @brief Activates make fields
        #
        proc activate_custom_command_fields {}

        ##
        # @brief Activates editor fields
        #
        # @param id the id of the editor in the list
        #
        proc activate_editor_fields {id}

        ##
        # @brief Adds directory to search path
        #
        proc add_dir {{dir ""}}

        ##
        # @brief Removes the selected item from search path
        #
        proc remove {}

        ##
        # @brief Moves the selected item up
        #
        proc move_up {}

        ##
        # @brief Moves the selected item down
        #
        proc move_down {}

        ##
        # @brief Sets compiler specific options for the current project 
        #
        proc set_search_paths {}

        ##
        # @brief Sets value for the current component
        #
        # @param n the name of the component
        #
        proc set_entry {n}

        ##
        # @brief Returns the .bsv and .bs files from the current Search Path 
        #
        proc get_project_files {}

        constructor {args} {
                lappend args -modality application -title "Project Options" \
                                                        -height 760 -width 600
                insert 2 "Save_Exit"
                hide Help
                add_tabnotebook
                add_link_simulator_tab
                add_compile_tab
                add_files_tab
                add_editor_tab
                add_waveform_viewer_tab

                eval itk_initialize $args
                get_project_options
        }

        destructor {
        }
}

itcl::body options_dialog::add_tabnotebook {} {
        itk_component add tab {
                base::tabnotebook $itk_interior.tab -width 200 -pady 2 \
                        -padx 1 -borderwidth 2 -tabpos n -equaltabs true
        } {
                keep -cursor -background
        }

        set file [$itk_component(tab) add -label "Files"]
        set cmp [$itk_component(tab) add -label "Compile"]
        set sim [$itk_component(tab) add -label "Link\nSimulate"]
        set edt [$itk_component(tab) add -label "Editor"]
        set wv [$itk_component(tab) add -label "Waveform\nViewer"] 
        $itk_component(tab) select 0 
        pack $itk_component(tab) -fill both -expand true
        set tab $itk_component(tab)
}

itcl::body options_dialog::add_files_tab {} {
        global PROJECT 
        set spacing 2
        add_browse_entryfield $file f1 top_file "Top file" \
            {options_dialog::set_entry top_file} $spacing
        add_entryfield $file f2 top_mod "Top module" $spacing
        add_separator $file sf1
        add_browse_entryfield $file f3 bdir ".bo/.ba files location" \
            {options_dialog::set_entry bdir} $spacing
        add_browse_entryfield $file f4 simdir "Bluesim files location" \
            {options_dialog::set_entry simdir} $spacing
        add_browse_entryfield $file f5 vdir "Verilog files location" \
            {options_dialog::set_entry vdir} $spacing
        add_browse_entryfield $file f6 info_dir "Info files location" \
            {options_dialog::set_entry info_dir} $spacing

        add_search_path

        add_entryfield $file f7 include_patterns "Display include pattern" $spacing
        add_entryfield $file f8 exclude_patterns "Display exclude pattern" $spacing

	itk_component add flags_mode {
                iwidgets::radiobox $file.rbxx -orient horizontal -labeltext \
                        "Copy flags when loading top module" -labelpos nw
        } {
                keep -cursor -background
        }
        pack $itk_component(flags_mode) -padx 4 -pady 4 -fill both
        $itk_component(flags_mode) add 0 -text "No" -highlightthickness 1
        $itk_component(flags_mode) add 1 -text "Yes" -highlightthickness 1
        $itk_component(flags_mode) select $PROJECT(COPY_FLAGS)

        align_file_tab_labels
        set_file_vars
}

itcl::body options_dialog::add_search_path {} {
        set spacing 2
        itk_component add spath { 
                frame $file.fr
        }
        pack $itk_component(spath) -fill x -pady $spacing
        itk_component add slbox {
                iwidgets::scrolledlistbox $itk_component(spath).lb -width 400 \
                        -labeltext "Search Path" -labelpos nw -height 50p
        } {
                keep -cursor -background
        }
        pack $itk_component(slbox) -padx 5 -pady $spacing -side left -fill both
        $itk_component(slbox) selection set 0 0
        set plist $itk_component(slbox)
        itk_component add butbox {
                iwidgets::buttonbox $itk_component(spath).butbox \
                        -orient vertical -pady 0
        } {
                keep -cursor -background
        }
        pack $itk_component(butbox) -padx 0 -pady 0 -side right -fill both
        $itk_component(butbox) add add_dir -text "Add" -command \
            {options_dialog::add_dir} -height 40 -width 100 -padx 1 -pady 1
        $itk_component(butbox) add remove -text "Remove" -command \
            {options_dialog::remove} -height 40 -width 100 -padx 1 -pady 1
        $itk_component(butbox) add up -text "Move Up" -command \
            {options_dialog::move_up} -height 40 -width 100 -padx 1 -pady 1
        $itk_component(butbox) add down -text "Move Down" -command \
            {options_dialog::move_down} -height 40 -width 100 -padx 1 -pady 1
}

itcl::body options_dialog::align_file_tab_labels {} {
        iwidgets::Labeledwidget::alignlabels $itk_component(include_patterns) \
                                                $itk_component(exclude_patterns)
        iwidgets::Labeledwidget::alignlabels $itk_component(top_file) \
                                                $itk_component(top_mod)
        iwidgets::Labeledwidget::alignlabels $itk_component(bdir) \
                                $itk_component(simdir) $itk_component(vdir) \
                                $itk_component(info_dir) 
}

itcl::body options_dialog::set_file_vars {} {
        lappend blist [list top_file $itk_component(top_file)] \
                      [list bdir $itk_component(bdir)] \
                      [list simdir $itk_component(simdir)]\
                      [list vdir $itk_component(vdir)] \
                      [list info_dir $itk_component(info_dir)]
}

itcl::body options_dialog::add_compile_tab {} {
        global PROJECT 
        itk_component add bsc_type {
                iwidgets::radiobox $cmp.rb2 -orient horizontal -labelpos nw \
                        -labeltext "Compile to"
        } {
                keep -cursor -background
        }
        pack $itk_component(bsc_type) -padx 5 -pady 5 -fill both
        $itk_component(bsc_type) add bluesim -text "Bluesim" \
                -highlightthickness 1 -command {
                options_dialog::activate_bluesim
        }
        $itk_component(bsc_type) add verilog -text "Verilog" \
                -highlightthickness 1 -command {
                options_dialog::activate_verilog
        }
        create_bsc_fields
        add_separator $cmp sep2
        create_make_fields
        align_comp_tab_labels
        set_comp_vars
}

itcl::body options_dialog::create_bsc_fields {} {
        add_checkbutton $cmp cr1 comp_type_bsc "Compile via bsc" \
                "options_dialog::activate_bsc_fields" 
        add_entryfield $cmp cm1 bsc_options "Compile options" 5 
        add_entryfield $cmp cm2 rts_options "RTS options" 5
}

itcl::body options_dialog::create_make_fields {} {
        add_checkbutton $cmp crm2 comp_type_make "Compile via make" \
                "options_dialog::activate_make_fields"
        add_browse_entryfield $cmp cm3 cmake "Makefile" \
            {options_dialog::set_entry cmake} 5 
        add_entryfield $cmp cm4 target "Build target" 5
        add_entryfield $cmp cm5 clean_targ "Clean target" 5
        add_entryfield $cmp cm6 fclean_targ "Full clean target" 5
        add_entryfield $cmp cm7 make_options "Make options" 5
}

itcl::body options_dialog::align_comp_tab_labels {} {
        iwidgets::Labeledwidget::alignlabels $itk_component(rts_options) \
                                                $itk_component(bsc_options)
        iwidgets::Labeledwidget::alignlabels $itk_component(cmake) \
                $itk_component(target) $itk_component(clean_targ)\
                $itk_component(fclean_targ) $itk_component(make_options) 

}

itcl::body options_dialog::set_comp_vars {} {
        set comp_cbsc [list $itk_component(rts_options) \
                       $itk_component(bsc_options)]
        set comp_cmake [list $itk_component(cmake) $itk_component(target) \
                        $itk_component(clean_targ) $itk_component(fclean_targ) \
                        $itk_component(make_options) $itk_component(butcm3)]
        set bsc_type $itk_component(bsc_type)
        set comp_type [list $itk_component(comp_type_bsc) \
                        $itk_component(comp_type_make)]
        lappend blist [list cmake $itk_component(cmake)]
}

itcl::body options_dialog::add_link_simulator_tab {} {
        global PROJECT 
        itk_component add lbsc_type {
                iwidgets::radiobox $sim.rb2 -orient horizontal -labelpos nw \
                        -labeltext "Link to"
        } {
                keep -cursor -background
        }
        pack $itk_component(lbsc_type) -padx 4 -pady 0 -fill both
        $itk_component(lbsc_type) add bluesim -text "Bluesim" \
                -highlightthickness 1 -command {
                options_dialog::activate_link_bluesim
        }
        $itk_component(lbsc_type) add verilog -text "Verilog" \
                -highlightthickness 1 -command {
                options_dialog::activate_link_verilog
        }
        create_link_bsc_fields
        create_link_make_fields
        create_link_custom_command_fields
        align_link_sim_tab_labels
        set_link_sim_vars
}

itcl::body options_dialog::create_link_bsc_fields {} {
        global PROJECT
        add_checkbutton $sim lr1 link_type_bsc "Link via bsc" \
                "options_dialog::activate_link_bsc_fields"
        add_entryfield $sim ls1 output_name "Output name" 
        add_browse_entryfield $sim ls2 output_dir "Output directory" \
            {options_dialog::set_entry output_dir}
        add_entryfield $sim ls3 link_bsc_options "Link options"
        add_entryfield $sim ls4 sim_run_options  "Run options" 
        iwidgets::combobox $sim.cb -labeltext "Verilog simulator" \
                -listheight 120 \
                -selectforeground white -textbackground white -unique true \
                -selectioncommand {} -command {}
        pack $sim.cb -fill x
        set ver_sim $sim.cb
        foreach i [get_system_simulators] {
                $sim.cb insert list end $i
        }
        add_entryfield $sim ls5 sim_options "Simulate options" 
}

itcl::body options_dialog::create_link_make_fields {} {
        add_checkbutton $sim lr2 link_type_make "Link via make" \
                "options_dialog::activate_link_make_fields" 
        add_browse_entryfield $sim ls6 lmake "Makefile" \
            {options_dialog::set_entry lmake}
        add_entryfield $sim ls7 link_target "Link target"
        add_entryfield $sim ls8 link_sim_target "Simulate target"
        add_entryfield $sim ls9 link_clean_target "Clean target"
        add_entryfield $sim ls10 link_full_clean_target "Full clean target"
        add_entryfield $sim ls11 link_options "Make options"
}

itcl::body options_dialog::create_link_custom_command_fields {} {
        add_checkbutton $sim lr3 link_type_custom_command "Link via custom cmd"\
                "options_dialog::activate_custom_command_fields"
        add_entryfield $sim ls12 link_command "Link command"
        add_entryfield $sim ls13 sim_custom "Simulate command" 
}

itcl::body options_dialog::align_link_sim_tab_labels {} {
        iwidgets::Labeledwidget::alignlabels $itk_component(output_name) \
                                $itk_component(output_dir) \
                                $itk_component(link_bsc_options) \
                                $itk_component(sim_run_options) \
                                $itk_component(sim_options) $sim.cb
        iwidgets::Labeledwidget::alignlabels $itk_component(lmake) \
                $itk_component(link_target) $itk_component(link_sim_target) \
                $itk_component(link_clean_target) $itk_component(link_options) \
                $itk_component(link_full_clean_target)
        iwidgets::Labeledwidget::alignlabels $itk_component(link_command)\
                                                $itk_component(sim_custom)
}

itcl::body options_dialog::set_link_sim_vars {} {
        set lbsc_type $itk_component(lbsc_type)
        set lnkbsc [list $itk_component(output_dir) $itk_component(butls2) \
                $itk_component(output_name) $itk_component(link_bsc_options) \
                $itk_component(sim_run_options) $itk_component(sim_options) \
                $ver_sim]
        set lnkmake [list  $itk_component(lmake) $itk_component(butls6) \
                $itk_component(link_target) $itk_component(link_sim_target) \
                $itk_component(link_clean_target) \
                $itk_component(link_full_clean_target) \
                $itk_component(link_options)]
        set lnkcust [list $itk_component(link_command) \
                $itk_component(sim_custom)]
        set lnk_type [list $itk_component(link_type_bsc) \
                        $itk_component(link_type_make) \
                        $itk_component(link_type_custom_command)]
        lappend blist [list output_dir $itk_component(output_dir)] \
                      [list lmake $itk_component(lmake)]
}

itcl::body options_dialog::add_editor_tab {} {
        global BSPEC
        set id 0
        foreach e $BSPEC(EDITORS) {
                set n [string totitle $e]
                add_checkbutton $edt ec$id edt_type_$e "$n" \
                        "options_dialog::activate_editor_fields $id" 
                add_entryfield $edt ef$id edt_$e "$n command" 5
                lappend editors $itk_component(edt_$e)
                lappend edt_type $itk_component(edt_type_$e)
                incr id
        }
        foreach e $BSPEC(EDITORS) {
                iwidgets::Labeledwidget::alignlabels $itk_component(edt_$e) \
                        $itk_component(edt_gvim) $itk_component(edt_emacs) 
        }
}

itcl::body options_dialog::add_waveform_viewer_tab {} {
        global PROJECT
        set pady 2
        add_entryfield $wv wv1 wv_nonbsv_hier "Verilog hierarchy" $pady
        add_entryfield $wv wv2 wv_timeout     "Start timeout (sec)" $pady
        iwidgets::Labeledwidget::alignlabels $itk_component(wv_nonbsv_hier)  \
            $itk_component(wv_timeout) 
        #
        itk_component add wv_close {
                iwidgets::radiobox $wv.rb -orient horizontal -labeltext \
                        "Close viewer on BDW close" -labelpos nw
        } {
                keep -cursor -background
        }
        pack $itk_component(wv_close) -padx 4 -pady $pady -fill both
        $itk_component(wv_close) add close -text "Yes" -highlightthickness 1
        $itk_component(wv_close) add notclose -text "No" -highlightthickness 1
        $itk_component(wv_close) select $PROJECT(VIEWER_CLOSE) 


        itk_component add wv_namemode {
                iwidgets::radiobox $wv.rbx -orient horizontal -labeltext \
                        "Left justify compound signal names" -labelpos nw
        } {
                keep -cursor -background
        }
        pack $itk_component(wv_namemode) -padx 4 -pady $pady -fill both
        $itk_component(wv_namemode) add extend -text "Yes" -highlightthickness 1
        $itk_component(wv_namemode) add noextend -text "No" -highlightthickness 1
        $itk_component(wv_namemode) select $Waves::OPTS(ExtendNameMode)

        itk_component add wv_boolmode {
                iwidgets::radiobox $wv.rbxx -orient horizontal -labeltext \
                        "Display bool values as enums" -labelpos nw
        } {
                keep -cursor -background
        }
        pack $itk_component(wv_boolmode) -padx 4 -pady $pady -fill both
        $itk_component(wv_boolmode) add benum -text "Yes" -highlightthickness 1
        $itk_component(wv_boolmode) add nobenum -text "No" -highlightthickness 1
        $itk_component(wv_boolmode) select $Waves::OPTS(BoolDisplayMode)



        create_viewers
}

itcl::body options_dialog::create_viewers {} {
        set num 2
        set pady 2
        foreach i [Waves::get_supported_wave_viewers] {
                set name [Waves::get_waveviewer_name $i]

                add_checkbutton $wv c$num [string tolower $i] "$name" \
                    [list $this activate_viewer [string tolower $i]] $pady

                add_entryfield $wv wv[incr num 1] \
                    "[string tolower $i]\_command" "Command" $pady
                add_entryfield $wv wv[incr num 1] \
                        "[string tolower $i]\_options" "Options" $pady
                iwidgets::Labeledwidget::alignlabels \
                                $itk_component([string tolower $i]_command) \
                                $itk_component([string tolower $i]_options)
                lappend wv_com $itk_component([string tolower $i]_command) \
                                $itk_component([string tolower $i]_options)
                lappend wv_type $itk_component([string tolower $i])
        }
}

itcl::body options_dialog::add_entryfield {tab f name label {y 0}} {
        itk_component add $f {
                frame $tab.$f
        }
        pack $itk_component($f) -side top -fill both -pady $y
        itk_component add $name {
                iwidgets::entryfield $itk_component($f).$name \
                -labeltext $label -textbackground white \
                -labelpos w -command "$this invoke OK"
        } {
                keep -cursor -background
        }
        pack $itk_component($name) -fill x -expand true 
}

itcl::body options_dialog::add_browse_entryfield {tab f lname label cmd {y 0}} {
        itk_component add $f {
                frame $tab.$f 
        }
        pack $itk_component($f) -side top -fill both -pady $y
        itk_component add $lname {
                iwidgets::entryfield $itk_component($f).$lname\
                -labeltext $label -textbackground white -labelpos w \
                -command "$this invoke OK"
        } {
                keep -cursor -background
        }
        pack $itk_component($lname) -fill x -expand true -side left
        itk_component add but$f {
                button $itk_component($f).but$f -text "Browse..." -command $cmd
        }
        pack $itk_component(but$f) -side right
}

itcl::body options_dialog::add_separator {tab name} {
        canvas $tab.$name -width 570 -height 1
        $tab.$name create line 0 1 570 1 -fill black
        pack $tab.$name -pady 1
}

itcl::body options_dialog::add_checkbutton {tab f name text cmd {pady 1}} {
        itk_component add $f {
                frame $tab.$f 
        }
        pack $itk_component($f) -side top -fill both -pady $pady
        itk_component add $name {
                checkbutton $itk_component($f).$name -text $text
                # XXX should use a radio button image here
                #radiobutton $itk_component($f).$name -text $text -variable $name
        } {
                keep -cursor -background
        }
        $itk_component($name) configure -command \
                "$cmd; $itk_component($name) select"
        pack $itk_component($name) -padx 4 -pady $pady -fill both -side left
}

itcl::body options_dialog::add_togglebutton {tab f name text cmd {pady 5}} {
        itk_component add $f {
                frame $tab.$f 
        }
        pack $itk_component($f) -side top -fill both -pady $pady
        itk_component add $name {
                checkbutton $itk_component($f).$name -text $text 
        } {
                keep -cursor -background
        }
        $itk_component($name) configure -command \
                "$cmd"
        pack $itk_component($name) -padx 4 -pady $pady -fill both -side left
}

itcl::body options_dialog::activate_bsc_fields {} {
        foreach i $comp_type {
                $i deselect
        }
        foreach i $comp_cmake {
                $i configure -state disabled
        }
        foreach i $comp_cbsc {
                $i configure -state normal
        }
}

itcl::body options_dialog::activate_make_fields {} {
        foreach i $comp_type {
                $i deselect
        }
        foreach i $comp_cbsc {
                $i configure -state disabled
        }
        foreach i $comp_cmake {
                $i configure -state normal
        }
}

itcl::body options_dialog::activate_viewer {viewer} {
        foreach i $wv_type {
                $i deselect
        }
        foreach i $wv_com {
                $i configure -state disabled
        }
        $itk_component($viewer\_command) configure -state normal
        $itk_component($viewer\_options) configure -state normal
}

itcl::body options_dialog::activate_bluesim {} {
        if {[$lbsc_type get] != "bluesim"} {
                $lbsc_type select bluesim
        }
}

itcl::body options_dialog::activate_verilog {} {
        if {[$lbsc_type get] != "verilog"} {
                $lbsc_type select verilog
        }
}

itcl::body options_dialog::activate_link_bluesim {} {
        if {[.po get_link_type] == "bsc"} {
                [lindex $lnkbsc 5] configure -state disabled
                [lindex $lnkbsc 6] configure -state disabled
                [lindex $lnkbsc 4] configure -state normal
        }
        if {[$bsc_type get] != "bluesim"} {
                $bsc_type select bluesim
        }
}

itcl::body options_dialog::activate_link_verilog {} {
        if {[.po get_link_type] == "bsc"} {
                [lindex $lnkbsc 4] configure -state disabled
                [lindex $lnkbsc 5] configure -state normal
                [lindex $lnkbsc 6] configure -state normal
        }
        if {[$bsc_type get] != "verilog"} {
                $bsc_type select verilog
        }
}

itcl::body options_dialog::activate_link_bsc_fields {} {
        foreach i $lnk_type {
                $i deselect
        }
        foreach i $lnkmake {
                $i configure -state disabled
        }
        foreach i $lnkcust {
                $i configure -state disabled
        }
        foreach i $lnkbsc {
                $i configure -state normal
        }
        if {[$lbsc_type get] == "bluesim"} {
                [lindex $lnkbsc 5] configure -state disabled
                [lindex $lnkbsc 6] configure -state disabled
                [lindex $lnkbsc 4] configure -state normal
        } else {
                [lindex $lnkbsc 4] configure -state disabled
                [lindex $lnkbsc 5] configure -state normal
                [lindex $lnkbsc 6] configure -state normal
        }
}

itcl::body options_dialog::activate_link_make_fields {} {
        foreach i $lnk_type {
                $i deselect
        }
        foreach i $lnkbsc {
                $i configure -state disabled
        }
        foreach i $lnkcust {
                $i configure -state disabled
        }
        foreach i $lnkmake {
                $i configure -state normal
        }
}

itcl::body options_dialog::activate_custom_command_fields {} {
        foreach i $lnk_type {
                $i deselect
        }
        foreach i $lnkbsc {
                $i configure -state disabled
        }
        foreach i $lnkmake {
                $i configure -state disabled
        }
        foreach i $lnkcust {
                $i configure -state normal
        }
}

itcl::body options_dialog::activate_editor_fields {id} {
        foreach i $edt_type {
                $i deselect
        }
        foreach i $editors {
                $i configure -state disabled
        }
        [lindex $editors $id] configure -state normal
}

itcl::body options_dialog::add_dir {{dir ""}} {
        global env
        if {$dir != ""} {
                set s $dir
        } else {
                set s [select_dir 1] 
        }
        if {$s == ""} {
                return
        }
        set rs [commands::make_related_path $s]
        set as [commands::make_absolute_path $s]
        set ls [regsub -all $env(BLUESPECDIR) $as "%"]
        if {[lsearch [$plist get 0 end] $as] == -1 && \
            [lsearch [$plist get 0 end] $rs] == -1 && \
            [lsearch [$plist get 0 end] $ls] == -1} {
                if {$as != $ls} {
                        $plist insert end $ls
                } else {
                        $plist insert end $s
                }
                $plist see end
                $plist selection clear 0 end
                $plist selection set end
        }
}

itcl::body options_dialog::remove {} {
        global BSPEC
        if {[set c [$plist curselection]] != ""} {
                set p [$plist get $c $c]
                if {[lsearch $BSPEC(LIBRARIES) $p] == -1} {
                        $plist delete $c $c
                }
        }
}

itcl::body options_dialog::move_up {} {
        if {[set c [$plist curselection]] != 0 && \
                [set c [$plist curselection]] != ""} {
                set s [$plist get $c $c]
                $plist delete $c $c
                $plist insert [expr $c - 1] $s
                $plist selection set [expr $c - 1] [expr $c - 1]
                $plist see [expr $c - 1]
        }
}

itcl::body options_dialog::move_down {} {
        if {[set c [$plist curselection]] != [expr [$plist index end] - 1] &&\
               [set c [$plist curselection]] != ""} {
                set s [$plist get $c $c]
                $plist delete $c $c
                $plist insert [expr $c + 1] $s
                $plist selection set [expr $c + 1] [expr $c + 1]
                $plist see [expr $c + 1]
        }
}

itcl::body options_dialog::set_entry {n} {
        global BSPEC
        global env
        set s ""
        if { [regexp "dir" $n] } {
                set s [select_dir]
        } elseif { [regexp "make" $n] } {
                set s [select_makefile]
        } else {
                # set search path is needed to find the top file
                set_search_paths
                set t [select_top_file]
                if {$t != ""} {
                        set f [get_project_files]
                        set s [lindex [lindex $f [lsearch -regexp $f $t]] 0]
                        if { $s == "" } {
                                puts stderr "File $t is not found in the search path"
                        }
                }
        }
        set ent [lindex [lsearch -index 0 -inline -exact $blist $n] 1]
        if {$s != ""} {
                $ent delete 0 end
                $ent insert 0 $s
                $ent xview end
        }
}

itcl::body options_dialog::get_compiler_options {} {
        global PROJECT
#        $itk_component(bsc_type) select $PROJECT(COMP_BSC_TYPE)
        $itk_component(rts_options) insert 0 $PROJECT(COMP_RTS_OPTIONS)
        $itk_component(bsc_options) insert 0 $PROJECT(COMP_BSC_OPTIONS)

        $itk_component(cmake) insert 0 $PROJECT(MAKE_FILE)
        $itk_component(target) insert 0 $PROJECT(MAKE_TARGET)
        $itk_component(clean_targ) insert 0 $PROJECT(MAKE_CLEAN)
        $itk_component(fclean_targ) insert 0 $PROJECT(MAKE_FULLCLEAN)
        $itk_component(make_options) insert 0 $PROJECT(MAKE_OPTIONS)

        $itk_component(comp_type_$PROJECT(COMP_TYPE)) invoke
}

itcl::body options_dialog::get_link_sim_options {} {
        global PROJECT
        $itk_component(output_name) insert 0 $PROJECT(LINK_OUTNAME)
        $itk_component(output_dir) insert 0 $PROJECT(LINK_OUTDIR)
        $itk_component(link_bsc_options) insert 0 $PROJECT(LINK_BSC_OPTIONS)
        $itk_component(sim_run_options) insert 0 $PROJECT(RUN_OPTIONS)
        $ver_sim component entry insert 0 $PROJECT(SIM_NAME)
        $itk_component(sim_options) insert 0 $PROJECT(SIM_OPTIONS)

        $itk_component(lmake) insert 0 $PROJECT(LINK_MAKEFILE)
        $itk_component(link_target) insert 0 $PROJECT(LINK_TARGET)
        $itk_component(link_sim_target) insert 0 $PROJECT(LINK_SIM_TARGET)
        $itk_component(link_clean_target) insert 0 $PROJECT(LINK_CLEAN_TARGET)
        $itk_component(link_full_clean_target) insert 0 \
                $PROJECT(LINK_FULL_CLEAN_TARGET)
        $itk_component(link_options) insert 0 $PROJECT(LINK_MAKE_OPTIONS)

        $itk_component(link_command) insert 0 $PROJECT(LINK_COMMAND)
        $itk_component(sim_custom) insert 0 $PROJECT(SIM_CUSTOM_COMMAND)

        $itk_component(link_type_$PROJECT(LINK_TYPE)) invoke
        $itk_component(lbsc_type) select $PROJECT(COMP_BSC_TYPE)
}

itcl::body options_dialog::get_editor_options {} {
        global PROJECT
        global BSPEC
        foreach e $BSPEC(EDITORS) {
                $itk_component(edt_$e) insert 0 \
                        $PROJECT(EDITOR_[string toupper $e])
        }
        set e [string tolower $PROJECT(EDITOR_NAME)]
        if { [lsearch $BSPEC(EDITORS) $e] == -1 } {
                set e [lindex $BSPEC(EDITORS) end]
        }
        $itk_component(edt_type_$e) invoke
}

itcl::body options_dialog::get_viewer_options {} {
        global PROJECT
        $itk_component(wv_nonbsv_hier) insert 0 [Waves::get_nonbsv_hierarchy]
        $itk_component(wv_timeout) insert 0 [Waves::get_start_timeout]
        $itk_component(wv_close) select $PROJECT(VIEWER_CLOSE)
        $itk_component(wv_namemode) select $Waves::OPTS(ExtendNameMode)
        foreach i [Waves::get_supported_wave_viewers] {
                set opt [Waves::get_viewer_options $i]
                $itk_component([string tolower $i]_command) delete 0 end
                $itk_component([string tolower $i]_options) delete 0 end
                $itk_component([string tolower $i]_command) insert 0 \
                        [commands::get_tag_from_list $opt Command]
                $itk_component([string tolower $i]_options) insert 0 \
                        [commands::get_tag_from_list $opt Options]
        }
        $itk_component([string tolower [Waves::get_waveviewer]]) invoke
}

itcl::body options_dialog::get_files_options {} {
        global PROJECT
        $itk_component(top_file) insert 0 $PROJECT(TOP_FILE) 
        $itk_component(top_mod) insert 0 $PROJECT(TOP_MODULE) 

        $itk_component(vdir) insert 0 $PROJECT(COMP_VDIR) 
        $itk_component(bdir) insert 0 $PROJECT(COMP_BDIR)
        $itk_component(simdir) insert 0 $PROJECT(COMP_SIMDIR)
        $itk_component(info_dir) insert 0 $PROJECT(COMP_INFO_DIR)

        foreach i $PROJECT(PATHS) {
                $itk_component(slbox) insert end $i
        }

        $itk_component(include_patterns) insert 0 $PROJECT(INCLUDED_FILES) 
        $itk_component(exclude_patterns) insert 0 $PROJECT(EXCLUDED_FILES)
}

itcl::body options_dialog::get_project_files {} {
        global env
        set pfiles {"*.bsv" "*.bs"}
        set project_paths {}
        set project_files {}
        set files {}
        foreach s [$plist get 0 end] {
                foreach p $s {
                        lappend project_paths $p
                }
                set ldir [regsub -all "%" $project_paths $env(BLUESPECDIR)]
                foreach f $pfiles {
                        foreach d $ldir {
                                foreach i [lsort [glob -nocomplain \
                                                        -directory $d $f]] {
                                        lappend files $i
                                }
                        }
                }
                foreach i $files {
                        lappend project_files [list $i [file join \
                                [file tail [file dirname $i]] [file tail $i]]]
                }
        }
        return $project_files
}

itcl::body options_dialog::get_project_options {} {
        get_files_options
        get_compiler_options
        get_link_sim_options
        get_editor_options
        get_viewer_options
}

itcl::body options_dialog::set_file_options {} {
        commands::set_top_module [get_real_path_entry top_file] \
                                                [get_entry top_mod]
        set_search_paths
        commands::display_rules [get_entry include_patterns] \
                                [get_entry exclude_patterns]
        commands::package_refresh
	commands::set_flags_mode [get_entry flags_mode]
}

# Set the search paths based on contents of 
itcl::body options_dialog::set_search_paths {} {
        global PROJECT
        set PROJECT(PATHS) $PROJECT(COMP_BDIR)
        commands::set_search_paths [$plist get 0 end]
}

itcl::body options_dialog::set_compiler_options {} {
        global PROJECT
        commands::set_compilation_type [$this get_comp_type]
        commands::set_bsc_options [get bsc_type] [get_real_path_entry info_dir]\
                        [get_entry rts_options] [get_entry bsc_options]
        commands::set_compilation_results_location \
            [get_real_path_entry vdir] \
            [get_real_path_entry bdir] \
            [get_real_path_entry simdir]
        options_dialog::add_dir [get_real_path_entry bdir]

        commands::set_make_options [get_real_path_entry cmake] \
            [get_entry target] [get_entry clean_targ] \
            [get_entry fclean_targ] [get_entry make_options]
}

itcl::body options_dialog::set_link_sim_options {} {
        commands::set_link_type [$this get_link_type]
        if {[$this get_link_type] == "bsc"} {
                commands::set_link_bsc_options [get_entry output_name] \
                        [get_real_path_entry output_dir] \
                        [get_entry link_bsc_options]
                if {[$lbsc_type get] == "bluesim" } {
                        commands::set_bluesim_options \
                                [get_entry sim_run_options]
                } elseif {[$lbsc_type get] == "verilog"} {
                       commands::set_verilog_simulator [$ver_sim get] \
                               [get_entry sim_options]
                }
        } elseif {[$this get_link_type] == "make"} {
                commands::set_link_make_options [get_real_path_entry lmake] \
                        [get_entry link_target] [get_entry link_sim_target] \
                        [get_entry link_clean_target] \
                        [get_entry link_full_clean_target] \
                        [get_entry link_options] 
        } else {
                commands::set_link_custom_command [get_entry link_command]
                commands::set_sim_custom_command [get_entry sim_custom]
        }
}

itcl::body options_dialog::set_editor_options {} {
        set e [$this get_editor_type]
        commands::set_project_editor $e [get_entry edt_$e]
}

itcl::body options_dialog::set_viewer_options {} {
        set v [get_viewer_name]
        set com [get_entry [string tolower $v]\_command]
        set opt [get_entry [string tolower $v]\_options]
        commands::set_waveform_viewer $v $com $opt [get wv_close]
        commands::set_nonbsv_hierarchy [get_entry wv_nonbsv_hier]
        commands::set_waveform_naming_mode [get wv_namemode]
        commands::set_bool_display_mode [get wv_boolmode]
        commands::set_start_timeout [get_entry wv_timeout]
}

itcl::body options_dialog::set_project_options {} {
        set_compiler_options
        set_file_options
        set_link_sim_options
        set_editor_options
        set_viewer_options
        commands::change_menu_toolbar_state
        commands::set_project_options_in_interp
}

itcl::body options_dialog::check_dirs {dirs} {
        set r ""
        foreach d $dirs {
                if {![file isdirectory $d]} {
                        if {[regexp {\s} $d]} {
                                error_message "The directory name should not
                                        contain any spaces." \
                                        [string replace $this 0 1]
                                set r error
                        } elseif {[catch "file mkdir \"$d\"" err]} {
                                error_message $err [string replace $this 0 1]
                                puts stderr $err
                                set r error
                        } else {
                                error_message "The '$d' directory is created" \
                                        [string replace $this 0 1]
                                puts "The '$d' directory is created"
                        }
                } 
        }
        return $r
}

itcl::body options_dialog::check_bsc_options {} {
        set opt [get_entry bsc_options]
        if {$opt != "" && [catch "Bluetcl::flags set $opt" err]} {
                set m1 [lindex [split $err "\n"] 1]
                error_message "Error in compile options:\n$m1" \
                        [string replace $this 0 1]
                return error
        }
        if {[get_entry bsc_type] == "bluesim"} {
                if {[get_real_path_entry simdir] == ""} {
                        error_message "The Bluesim files location\n\
                                is not specified." [string replace $this 0 1]
                        return error
                }
                return [check_dirs [list [get_real_path_entry simdir] \
                        [get_real_path_entry bdir] \
                        [get_real_path_entry info_dir]]]
        } else {
                if {[get_real_path_entry vdir] == ""} {
                        error_message "The Verilog files location\n\
                                is not specified." [string replace $this 0 1]
                        return error
                }
                return [check_dirs [list [get_real_path_entry vdir] \
                        [get_real_path_entry bdir] \
                        [get_real_path_entry info_dir]]]
        }
}

itcl::body options_dialog::check_make_options {} {
        set cm [get_real_path_entry cmake]
        if {$cm == ""} {
                error_message "The M'akefile for compilation is not specified." \
                        [string replace $this 0 1]
                return error
        } elseif {![file exists $cm]} {
                error_message "The file $cm does not exist." \
                        [string replace $this 0 1]
                return error
        } elseif {[file isdirectory $cm]} {
                error_message "The file $cm is a directory." \
                        [string replace $this 0 1]
                        return error
        }
        return ""
}

itcl::body options_dialog::check_files_options {} {
        global BSPEC
        set file [get_real_path_entry top_file]
        if {$file == ""} {
#               do not error here since a new project may not have any files
                if {![ignore_warning "The top file is not specified." .po]} {
                        return error
                }
#               error_message "The top file is not specified."
#               return error
        } elseif {![file exists $file]} {
                if {![ignore_warning "The file '$file' does not exist. \n\
                                Should the '$file' file be created?" .po]} {
                        return error
                } else {
                        if {[catch "exec touch \"$file\"" err]} {
                                error_message $err [string replace $this 0 1]
                                puts stderr $err
                                return error
                        } else {
                                puts "The '$file' file is created."
                        }
                }
        } else {
                set af [commands::make_absolute_path $file]
                set rf [commands::make_related_path $file]
                set f [get_project_files]
                if {[lsearch -regexp $f $af] == -1 && \
                                        [lsearch -regexp $f $rf] == -1} {
                        error_message "The file '$file' is not a project\
                                file." [string replace $this 0 1]
                        return error
                }
        }
        if {[get_real_path_entry bdir] == ""} {
                error_message "The .bo/.ba files location\n\
                        is not specified." [string replace $this 0 1]
                return error
        }
        if {[get_real_path_entry info_dir] == ""} {
                error_message "The info files location is not specified." \
                        [string replace $this 0 1]
                return error
        }
        return ""
}

itcl::body options_dialog::check_compiler_options {} {
        if { [check_bsc_options] == "" } {
                if {[get_comp_type] == "make"} {
                        return [check_make_options]
                }
        }
        return ""
}

itcl::body options_dialog::check_link_bsc_options {} {
        global PROJECT
        set od [get_real_path_entry output_dir]
        if {$od == ""} {
                error_message "The linking output file directory is \
                        not specified." [string replace $this 0 1]
                return error
        } 
        check_dirs $od
        if {[get_entry output_name] == ""} {
                error_message "The linking output file name is not specified." \
                        [string replace $this 0 1]
                return error
        } 
        set f "$od/[get_entry output_name]"
        if {[file isdirectory $f]} {
                error_message "The linking output name should not \
                        be a directory." [string replace $this 0 1]
                return error
        } 
        set opt [get_entry link_bsc_options]
#         if {$opt != "" && [catch "Bluetcl::flags set $opt" err]} {
#                 error_message [lindex [split $err "\n"] 1]
#                 return error
#         }
        set vsim [$ver_sim get]
        if { [$lbsc_type get] == "verilog" } {
                if {[lsearch -exact [get_system_simulators] $vsim] == -1} {
                        set s [ignore_warning "\"$vsim\" is not a supported simulator" \
                                   [string replace $this 0 1]]
                        if { ! $s } { return error }
                }
        }
        return ""
}

itcl::body options_dialog::check_link_make_options {} {
        set lm [get_real_path_entry lmake]
        if {$lm == ""} {
                error_message "The Makefile for linking is not specified." \
                        [string replace $this 0 1]
                return error
        } elseif {![file exists $lm]} {
                error_message "The file $lm does not exist." \
                        [string replace $this 0 1]
                return error
        } elseif {[file isdirectory $lm]} {
                error_message "The file $lm is a directory." \
                        [string replace $this 0 1]
                return error
        }
        return ""
}

itcl::body options_dialog::check_custom_command {} {
        if {[get_entry link_command] == ""} {
                error_message "The custom command for linking is not\
                        specified." [string replace $this 0 1]
                return error
        }
        if {[get_entry sim_custom] == ""} {
                error_message "The custom command for simulating is \
                        not specified." [string replace $this 0 1]
                return error
        }
        return ""
}

itcl::body options_dialog::check_link_sim_options {} {
        set ltp [$this get_link_type]
        if {$ltp == "bsc"} {
                return [check_link_bsc_options]
        } elseif {$ltp == "make"} {
                return [check_link_make_options]
        } else {
                return [check_custom_command]
        }
}

itcl::body options_dialog::check_editor_options {} {
        set e [$this get_editor_type]
        if {[get_entry edt_$e] == ""} {
                error_message "The command to be executed for the editor\n\
                                is not specified." [string replace $this 0 1]
                return error
        }
        return ""
}

itcl::body options_dialog::check_project_options {} {
        if {[check_files_options] != ""} {
                return error
        }
        if {[check_compiler_options] != ""} {
                return error
        }
        if {[check_link_sim_options] != ""} {
                return error
        }
        if {[check_editor_options]!= ""} {
                return error
        }
        return ""
}

##
# @brief Opens the "Project->Options" dialog window on the Files tab
#
# @param tab id of the tab to be displayed
#
proc create_project_options {{tab 0}} {
        global BSPEC
        options_dialog .po 
        set g [split [winfo geometry $BSPEC(MAIN_WINDOW)] "+"]
        wm geometry .po "+[lindex $g 1]+[lindex $g 2]"
        wm minsize .po 600 650
        .po set_bindings
        .po buttonconfigure OK -command {
                if {[.po check_project_options] == ""} {
                        .po set_project_options
                        .po deactivate 1
                }
        }
        .po buttonconfigure Apply -command {
                if {[.po check_project_options] == ""} {
                        .po set_project_options
                        raise .po
                        focus -force .po
                }
        }
        .po buttonconfigure Save_Exit -text "Save and Close" -command {
                if {[.po check_project_options] == ""} {
                        .po set_project_options
                        commands::save_project
                        .po deactivate 1
                }
        }
        .po component tab select $tab
        .po activate
        itcl::delete object .po
}

## Local Variables:
## eval: (set (make-local-variable 'tcl-indent-level) 8)
## End:
