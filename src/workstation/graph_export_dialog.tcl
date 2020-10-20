
##
# @file graph_export_dialog.tcl
#
# @brief Definition of the Properties dialog window.
#

##
# @brief Defintion of class graph_export_dialog
#
itcl::class graph_export_dialog {
        inherit iwidgets::Dialog

        itk_option define -graphfilename graphfilename GraphFilename {}
        itk_option define -formats formats Formats {}

        ##
        # @brief A list of available graph formats for export
        #
        variable formats ""

        ##
        # @brief Sets the settings
        #
        method set_settings {}

        ##
        # @brief Gets the current settings
        #
        method get_settings {}

        ##
        # @brief Gets the selected files
        #
        method get_formats {} {
                set f {}
                foreach i $formats {
                        global format_$i
                        eval lappend f $[list format_$i]
                }
                return $f
        }

        private {
                ##
                # @breif Creates the dialog window
                #
                method create_window {}

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
                lappend args -modality application
                hide Help
                hide Apply
                eval itk_initialize $args
                set formats $itk_option(-formats)
                create_window
                set_bindings
                set_settings
        }

        destructor {}
}

itcl::body graph_export_dialog::create_window {} {
        itk_component add frame {
                frame $itk_interior.fr
        }
        pack $itk_component(frame) -fill both -expand true
        add_entry e1 out "Output file name"
        create_label
        set id 0
        foreach i $formats {
                add_checkbutton c$id format_$i "$i"
                incr id
        }
}

itcl::body graph_export_dialog::add_entry {fr name label} {
        itk_component add $fr {
                frame $itk_component(frame).$fr
        }
        pack $itk_component($fr) -side top -fill both
                itk_component add $name {
                        iwidgets::entryfield $itk_component($fr).$name \
                                -labeltext $label -textbackground white \
                                -labelpos nw -command "$this invoke OK"
                } {
                        keep -cursor -background
                }
        pack $itk_component($name) -fill x -pady 2
}

itcl::body graph_export_dialog::create_label {} {
        itk_component add fr {
                frame $itk_component(frame).fr
        }
        pack $itk_component(fr) -fill x
        label $itk_component(fr).lb -text "Available formats"
        pack $itk_component(fr).lb -fill x -side left
}

itcl::body graph_export_dialog::add_checkbutton {f name text {cmd ""}} {
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
        pack $itk_component($name) -padx 10 -pady 0 -fill both -side left
}

itcl::body graph_export_dialog::get_settings {} {
        return [list [$itk_component(out) get] [$this get_formats]]
}

itcl::body graph_export_dialog::set_settings {} {
        $itk_component(out) clear
        set f [file rootname [file tail $itk_option(-graphfilename)]]
        $itk_component(out) insert 0 $f
        foreach i $formats {
                $itk_component(format_$i) deselect 
        }
}

##
# @brief Creates the "Export Graph" dialog
#
# @param file the graph file name
# @param format the file formats for graph export
#
proc create_export_graph_dialog {file format} {
        graph_export_dialog .exg -title "Export Graph" -graphfilename $file \
                -formats $format
        .exg buttonconfigure OK -text Export -command {
                set sel 0
                foreach f [.exg get_formats] {
                        if {$f == 1} {
                                set sel 1
                        }
                }
                if {$sel == 0} {
                        error_message "The file formats are not specified" .exg
                        return 
                }
                .exg deactivate 1
        }
        wm geometry .exg "210x360+530+250"
        wm minsize .exg 180 360
        if {[.exg activate]} {
                set e [.exg get_settings]
        } else {
                set e ""
        }
        itcl::delete object .exg
        return $e
}
