
##
# @file project_back_up_dialog.tcl
#
# @brief Definition of the Properties dialog window.
#

##
# @brief Defintion of class options_dialog
#
itcl::class back_up_dialog {
        inherit iwidgets::Dialog

        ##
        # @brief The name of "Files from Search Path" entry
        #
        common spath ""

        ##
        # @brief Activates/deactivates the "Files from Search Path entry if 
        # Search Path checkbutton is selected/deselected
        #
        proc activate_spath {}

        ##
        # @brief Sets the settings
        #
        method set_settings {}

        ##
        # @brief Gets the current settings
        #
        method get_settings {}

        ##
        # @brief Checks  the current settings
        #
        method check_settings {}

        ##
        # @brief Gets the selected files to backup
        #
        method get_files {} {
                global in_file
                global pr_dir
                global s_path
                return [list $in_file $pr_dir $s_path]
        }


        private {
                ##
                # @breif Creates the entryfields
                #
                method add_entry {frame name label}

                ##
                # @breif Creates the label
                #
                method create_label {}

                ##
                # @breif Creates the Checkbutton
                #
                method add_checkbutton {f name text {cmd ""}}

                ##
                # @breif Creates the Checkboxes
                #
                method create_window {}

                ##
                # @brief Sets the bindings for Filter dialog of Graph Window 
                # 
                method set_bindings {} {
                       set w [string replace $this 0 1]
                       bind $w <Control-w> {
                               .[lindex [split %W .] 1] deactivate 0
                       }
                }

        }

        constructor {args} {
                lappend args -modality application -height 255 -width 450
                hide Help
                hide Apply
                set_bindings
                create_window
                eval itk_initialize $args
        }

        destructor {
        }
}

itcl::body back_up_dialog::create_window {} {
        itk_component add frame {
                frame $itk_interior.fr
        }
        pack $itk_component(frame) -fill both -expand true
        add_entry e1 out "Output file name"
        add_entry e2 options "Options for tar"
        add_entry e3 spath_files "Files from Search Path"
        iwidgets::Labeledwidget::alignlabels $itk_component(out) \
                        $itk_component(options) $itk_component(spath_files)
        create_label
        add_checkbutton c1 in_file "Input files" 
        add_checkbutton c2 pr_dir "Project directory" 
        add_checkbutton c3 s_path "Search Path" "back_up_dialog::activate_spath"
        set spath $itk_component(spath_files)
        get_settings
}

itcl::body back_up_dialog::add_entry {fr name label} {
        itk_component add $fr {
                frame $itk_component(frame).$fr
        }
        pack $itk_component($fr) -side top -fill both
                itk_component add $name {
                        iwidgets::entryfield $itk_component($fr).$name \
                                -labeltext $label -textbackground white \
                                -labelpos w -command "$this invoke OK"
                } {
                        keep -cursor -background
                }
        pack $itk_component($name) -fill x -pady 2
}

itcl::body back_up_dialog::create_label {} {
        itk_component add fr {
                frame $itk_component(frame).fr
        }
        pack $itk_component(fr) -fill x -pady 3 
        label $itk_component(fr).lb -text "Files to include"
        pack $itk_component(fr).lb -fill x -pady 3 -side left
}

itcl::body back_up_dialog::add_checkbutton {f name text {cmd ""}} {
        itk_component add $f {
                frame $itk_component(frame).$f
        }
        pack $itk_component($f) -side top -fill both -pady 1
        itk_component add $name {
                checkbutton $itk_component($f).$name -text $text 
        } {
                keep -cursor -background
        }
        if {$cmd != ""} {
                $itk_component($name) configure -command "$cmd"
        }
        pack $itk_component($name) -padx 15 -pady 1 -fill both -side left
}

itcl::body back_up_dialog::set_settings {} {
        global PROJECT
        commands::project_backup [$itk_component(out) get] [$this get_files] \
                [$itk_component(options) get] [$itk_component(spath_files) get]
}

itcl::body back_up_dialog::get_settings {} {
        global PROJECT
        $itk_component(out) clear
        $itk_component(options) clear
        $itk_component(spath_files) clear
        $itk_component(out) insert 0 $PROJECT(NAME).tgz
        $itk_component(options) insert 0 "-z" 
        $itk_component(spath_files) insert 0 ".bsv"
        $itk_component(in_file) deselect 
        $itk_component(pr_dir) deselect 
        $itk_component(s_path) deselect 
        $itk_component(spath_files) configure -state disabled
}

itcl::body back_up_dialog::check_settings {} {
        global PROJECT
        set sel 0
        foreach f [$this get_files] {
                if {$f == 1} {
                        set sel 1
                }
        }
        if {$sel == 0} {
                error_message "The files for back-up are not specified" \
                        [string replace $this 0 1]
                return error
        }
        return ""
}

itcl::body back_up_dialog::activate_spath {} {
        global s_path
        if {$s_path} {
                $spath configure -state normal
        } else {
                $spath configure -state disabled
        }
}

##
# @brief Creates the "Project Backup" dialog
#
proc create_back_up_dialog {} {
        global BSPEC
        back_up_dialog .bckup -title "Project Backup" 
        .bckup buttonconfigure OK -text Create -command {
                if {[.bckup check_settings] == ""} {
                        .bckup set_settings
                        .bckup deactivate 1
                }
        }
        set g [split [winfo geometry $BSPEC(MAIN_WINDOW)] "+"]
        wm geometry .bckup "+[lindex $g 1]+[lindex $g 2]"
        wm minsize .bckup 450 265
        .bckup activate
        itcl::delete object .bckup
}
