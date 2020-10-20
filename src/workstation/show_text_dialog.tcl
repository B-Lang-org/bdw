
##
# @file show_text_dialog.tcl
#
# @brief Definition of the Properties dialog window.
#

##
# @brief Defintion of class show_text_dialog 
#
itcl::class show_text_dialog {
        inherit iwidgets::Dialog

        itk_option define -graph graphwindow GraphWindow {}
        itk_option define -file bvifile BviFile {}

        ##
        # @brief Sets the settings
        #
        # @param file the shown file name
        #
        method refresh {file}

        ##
        # @brief Sets the settings
        #
        method get_label {} {
                return [string trim [$itk_component(text) get 0.0 end]]
        }

        private {
                ##
                # @brief Adds a frame  
                #
                # @param f the frame for the frame
                # @param name the frame name
                # @param x the frame horizontal distance from other widgets
                # @param y the frame vertical distance from other widgets
                # @param side the frame placement
                # @param exp boolean variable to expand the widget the or not
                #
                method add_frame {f name {x 0} {y 0} {side "top"} {exp "false"}}

                ##
                # @brief Adds a scrolledtext
                #
                # @param f the frame for the frame
                # @param name the frame name
                # @param label the label for the scrolledtext
                #
                method add_scrolledtext {f name label} 

                ##
                # @breif Creates the Checkboxes
                #
                method create_window {}

                ##
                # @breif Sets the numbering for text frame
                #
                method set_numbering {}

                ##
                # @brief Sets the bindings for Show BVI File dialog
                # 
                method set_show_bvi_binding {}

                ##
                # @brief Sets the bindings for Filter dialog of Graph Window 
                # 
                method set_bindings {} {
                       set w [string replace $this 0 1]
                       bind $w <Control-w> {
                                itcl::delete object .[lindex [split %W .] 1]
                       }
                }

        }

        constructor {args} {
                lappend args -modality application -height 255 -width 450
                hide Help
                hide Apply
                create_window
                set_bindings
                eval itk_initialize $args
                if {$itk_option(-graph) != ""} {
                        $itk_component(text) insert end [$itk_option(-graph) \
                        get_label]
                } elseif {$itk_option(-file) != ""} {
                        buttonconfigure Cancel -text Close
                        pack $itk_component(text) -side right
                        add_scrolledtext $itk_component(tfr) number " "
                        pack $itk_component(number) -side left
                        refresh $itk_option(-file)
                } 
                $itk_component(text) configure -textbackground white
        }

        destructor {}
}

itcl::body show_text_dialog::refresh {file} {
        $itk_component(text) configure -state normal
        $itk_component(text) clear
        $itk_component(text) import $file
        $itk_component(text) configure -state disabled -labeltext $file
        set itk_option(-file) $file
        set_numbering
}

itcl::body show_text_dialog::set_numbering {} {
        $itk_component(number) configure -state normal
        $itk_component(number) clear 
        set c [expr [lindex [split [$itk_component(text) index end] .] 0] - 1]
        for {set i 1} {$i <= $c} {incr i} {
                $itk_component(number) insert end "$i\n"
        }
        $itk_component(number) configure -state disabled \
                -textbackground grey -selectforeground black -width 50
        set_show_bvi_binding
}

itcl::body show_text_dialog::set_show_bvi_binding {} {
        bind [$itk_component(text) component vertsb] <ButtonRelease-1> {
                set w [regsub "vertsb" %W "clipper.text"]
                set c [expr [lindex [split [$w index end] .] 0] - 1]
                for {set i 0} {$i <= $c} {incr i} {
                        if {[$w bbox "$i.0"] != ""} {
                                [regsub "cnv" $w "number"] yview "$i.0"
                                $w yview "$i.0"
                                break
                        }
                }
        }
        bind [$itk_component(text) component vertsb] <B1-Motion> {
                set w [regsub "vertsb" %W "clipper.text"]
                set c [expr [lindex [split [$w index end] .] 0] - 1]
                for {set i 0} {$i <= $c} {incr i} {
                        if {[$w bbox "$i.0"] != ""} {
                                [regsub "cnv" $w "number"] yview "$i.0"
                                $w yview "$i.0"
                                break
                        }
                }
        }
        bind [$itk_component(text) component text] <4> {
                [regsub "cnv" %W "number"] yview scroll -50 pixels
        }
        bind [$itk_component(text) component text] <5> {
                [regsub "cnv" %W "number"] yview scroll 50 pixels
        }
        bind [$itk_component(number) component text] <4> {
                [regsub "number" %W "cnv"] yview scroll -50 pixels
        }
        bind [$itk_component(number) component text] <5> {
                [regsub "number" %W "cnv"] yview scroll 50 pixels
        }
}

itcl::body show_text_dialog::add_frame {f name {x 0} {y 0} {side "top"} \
                                                                {exp "false"}} {
       itk_component add $name {
               frame $f.$name -takefocus 0
       }
       pack $itk_component($name) -fill both -expand $exp \
               -padx $x -pady $y -side $side
}

itcl::body show_text_dialog::add_scrolledtext {f name label} {
        itk_component add $name {
                iwidgets::scrolledtext $f.$name \
                        -hscrollmode none -vscrollmode none \
                        -labeltext $label -labelpos nw -spacing3 1 -wrap none
        } {
                keep -textbackground
        }
        pack $itk_component($name) -fill both -expand false
        $itk_component($name) clear
}

itcl::body show_text_dialog::create_window {} {
        add_frame $itk_interior tfr 0 0 top true
        itk_component add text {
                iwidgets::scrolledtext $itk_component(tfr).cnv \
                        -hscrollmode static -vscrollmode dynamic \
                        -labeltext "Graph label" -labelpos nw \
                        -spacing3 1 -wrap none
        } {
                keep -textbackground
        }
        pack $itk_component(text) -fill both -expand true
        $itk_component(text) clear
}

##
# @brief Creates the "Rename Graph" dialog
#
# @param graph the graph window
#
proc create_rename_graph_dialog {graph} {
        show_text_dialog .rg -title "Rename Graph" -graph $graph
        .rg buttonconfigure OK -text Rename -command {
                [.rg cget -graph] redraw_label [.rg get_label]
                .rg deactivate 1
        }
        wm geometry .rg "460x170+530+250"
        wm minsize .rg 460 170
        .rg activate
        itcl::delete object .rg
}

##
# @brief Creates the "Show BVI File" dialog
#
# @param file the BVI file name
#
proc create_bvi_show_dialog {file} {
        global BSPEC
        if {[winfo exists .sbvi]} {
                focus -force .sbvi
                raise .sbvi
                .sbvi refresh $file
        } else {
                show_text_dialog .sbvi -title "Show BVI File" -graph "" \
                        -file $file
                .sbvi configure -modality none
                set g [split [winfo geometry $BSPEC(IMPORT_BVI)] "+"]
                wm geometry .sbvi "750x600+[lindex $g 1]+[lindex $g 2]"
                wm minsize .sbvi 740 170
                .sbvi activate
                .sbvi show Apply
                .sbvi buttonconfigure Apply -text Refresh -command {
                        $BSPEC(IMPORT_BVI) action_show 
                }
                .sbvi buttonconfigure OK -text Compile -command {
                        commands::compile_file [.sbvi cget -file]
                }
                .sbvi buttonconfigure Cancel -command {
                        itcl::delete object .sbvi
                }
                if {$BSPEC(BUILDPID) != ""} {
                        .sbvi buttonconfigure OK -state disabled 
                }
                wm protocol .sbvi WM_DELETE_WINDOW "itcl::delete object .sbvi"
        }
}

