
##
# @file project_top_file_dialog.tcl
#
# @brief Definition of "Project->Top File" dialog window.
#

##
# @brief Defintion of class top_file_dialog
#
itcl::class top_file_dialog {
        inherit base::dialog

        ##
        # @brief The name of "Top File" entry 
        #
        common ent ""

        ##
        # @brief Checks the settings
        #
        method check_settings {}

        ##
        # @brief Gets the settings
        #
        method get_settings {}

        ##
        # @brief Sets value for the specified browse_entry
        #
        # @param n the name of the component
        #
        proc set_entry {n}

        private {
                ##
                # @brief Returns the value of the specified entry component
                #
                # @param ent the name of the entry component
                #
                method get_entry {ent} {
                        return [commands::extract_spaces \
                                [$itk_component($ent) get]]
                }
        }

        constructor {args} {
                global PROJECT
                lappend args -modality application
                hide Help
                hide Apply
                base::dialog::add_browse_entryfield f1 file "Top file" \
                {top_file_dialog::set_entry file}
                base::dialog::add_entryfield f2 module "Top module"
                $itk_component(file) insert 0 $PROJECT(TOP_FILE)
                $itk_component(module) insert 0 $PROJECT(TOP_MODULE)
                iwidgets::Labeledwidget::alignlabels $itk_component(file) \
                                                     $itk_component(module)
                set ent $itk_component(file)
                eval itk_initialize $args
        }
        destructor {
        }
}

itcl::body top_file_dialog::check_settings {} {
        global BSPEC
        set f [commands::extract_spaces [get_entry file]]
        if {$f == ""} {
                error_message "The top file is not specified." \
                        [string replace $this 0 1]
                return error
        }
        if {![file exists $f]} {
                error_message "The file '$f' does not exist." \
                        [string replace $this 0 1]
                return error
        }
        set af [commands::make_absolute_path $f]
        set rf [commands::make_related_path $f]
        if {[lsearch -regexp $BSPEC(FILES) $af] == -1 && \
            [lsearch -regexp $BSPEC(FILES) $rf] == -1} {
                error_message "The file '$f' is not a project file." \
                        [string replace $this 0 1]
                return error
        }
        return ""
}

itcl::body top_file_dialog::get_settings {} {
        commands::set_top_module [get_entry file] [get_entry module]
        commands::change_menu_toolbar_state
}

itcl::body top_file_dialog::set_entry {n} {
        global BSPEC
        set s [select_top_file]
        if {$s != ""} {
                $ent delete 0 end
                $ent insert 0 [lindex [lindex $BSPEC(FILES) \
                        [lsearch -regexp $BSPEC(FILES) $s]] 0]
        }
        $ent xview end
}

##
# @brief Opens the "Project->Top File..." dialog
#
proc create_project_top_file {} {
        top_file_dialog .ptf -title "Top File/Module" 
        .ptf buttonconfigure OK -command {
                if {[.ptf check_settings] == ""} {
                        .ptf deactivate 1
                }
        }
        focus -force .ptf
        set g [split [winfo geometry .po "+"]
        wm geometry .ptf "+[lindex $g 1]+[lindex $g 2]"
        wm minsize .ptf 400 135
        if {[.ptf activate]} {
                .ptf get_settings
        } 
        itcl::delete object .ptf
}

