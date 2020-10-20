
##
# @file build_skeleton_dialog.tcl
#
# @brief Definition of the Build Skeleton dialog window.
#

##
# @brief Defintion of class build_skeleton_dialog
#
itcl::class build_skeleton_dialog {
        inherit iwidgets::Dialog

        ##
        # @brief Sets the settings
        #
        method set_settings {}

        ##
        # @brief Gets the current settings
        #
        method get_settings {}

        ##
        # @brief Gets the current selected interface
        #
        method get_selection {}

        ##
        # @brief 
        #
        method check_settings {}

        ##
        # @brief Sets packages list
        #
	method set_package_interface {}

        ##
        # @brief Sets the settings
        #
        method deselect_node {}

        private {
                ##
                # @breif Creates the dialog window
                #
                method create_window {}

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
                method add_frame {f name {x 0} {y 0} {side "top"} {exp "true"}}

                ##
                # @brief Adds a label
                #
                # @param f the frame for the label
                # @param name the label name
                # @param label the text of the label
                # @param x the label horizontal distance from other widgets
                # @param y the label vertical distance from other widgets
                # @param side the label placement
                # @param exp boolean variable to expand the widget or not
                #
                method add_label {f name label {x 0} {y 0} \
                        {side "top"} {exp "false"}}

                ##
                # @brief Adds an scrolledlistbox   
                #
                # @param f the frame for scrolledlistbox
                # @param name the scrolledlistbox name
                # @param width the scrolledlistbox width
                # @param height the scrolledlistbox height
                # @param exp boolean variable to expand the widget or not
                # @param dcmd the scrolledlistbox double click command
                #
                method add_scrolledlistbox {f name width height \
							{exp "true"} {dcmd ""}}

                ##
                # @brief Gets the interface names and inserts into the list 
                #
                # @param package the package name
                #
                method get_interfaces {package}

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
                create_window
                set_bindings
                set_settings
        }

        destructor {}
}

itcl::body build_skeleton_dialog::create_window {} {
        add_frame $itk_interior fr
        add_frame $itk_component(fr) lfr 0 0 left
        add_label $itk_component(lfr) llb "Package"
	add_scrolledlistbox $itk_component(lfr) lslb 200 300 true \
		"$this deselect_node"
        add_frame $itk_component(fr) rfr 0 0 right
        add_label $itk_component(rfr) rlb "Interface"
	add_scrolledlistbox $itk_component(rfr) rslb 200 300 true \
                "$this invoke OK"
	set_package_interface
}

itcl::body build_skeleton_dialog::add_scrolledlistbox {f name width height \
							{exp "true"} {dcmd ""}} {

	itk_component add $name {
			iwidgets::scrolledlistbox $f.$name -width $width \
				-height $height -dblclickcommand $dcmd
	}
	pack $itk_component($name) -fill both -expand $exp
}

itcl::body build_skeleton_dialog::add_frame {f name {x 0} {y 0} {side "top"} \
                                                        {exp "true"}} {
        itk_component add $name {
                frame $f.$name
        }
        pack $itk_component($name) -fill both -expand $exp \
                        -padx $x -pady $y -side $side
}

itcl::body build_skeleton_dialog::add_label {f name label {x 0} {y 0} \
                                        {side "top"} {exp "false"}} {
        itk_component add $name {
                label $f.$name -text $label
        }
        pack $itk_component($name) -fill both -expand $exp \
                        -padx $x -pady $y -side $side
}

itcl::body build_skeleton_dialog::get_settings {} {
}

itcl::body build_skeleton_dialog::set_settings {} {
}

itcl::body build_skeleton_dialog::deselect_node {} {
        .bsk configure -cursor watch
        update
	set p [$itk_component(lslb) getcurselection]
        if {[catch "Bluetcl::bpackage load $p" log]} {
                puts stderr "\n$log"
                set log [list]
        } else {
                commands::display_command_results $log
        }
	foreach p $log {
                get_interfaces $p
	}
        .bsk configure -cursor {}
        update
}

itcl::body build_skeleton_dialog::get_interfaces {package} {
        foreach a [Bluetcl::defs type $package] {
                set c [catch {Bluetcl::type constr $a} lo]
                if {$c == 0} {
                        catch {Bluetcl::type full $lo} list
                        if {[lindex $list 0] == "Interface"} {
                                set n $lo
                                set t [$itk_component(rslb) get 0 end] 
                                if {[lsearch $t $n] == -1} {
                                        $itk_component(rslb) insert end $n
                                }
                         }
                }
        }
}

itcl::body build_skeleton_dialog::set_package_interface {} {
	global PROJECT
	global env
	set plist ""
	foreach i [regsub -all "%" $PROJECT(PATHS) "$env(BLUESPECDIR)"] {
		set f [lsort [glob -nocomplain -directory $i *.bo]]
		if {$f == ""} {
			continue
		}
		foreach i $f {
			lappend plist [file rootname [file tail $i]]
		}
		lappend plist "--------------------"
	}
	foreach i $plist {
		$itk_component(lslb) insert end $i
	}
        foreach p [Bluetcl::bpackage list] {
                get_interfaces $p
        }
}

itcl::body build_skeleton_dialog::get_selection {} {
	return [$itk_component(rslb) getcurselection]
}

itcl::body build_skeleton_dialog::check_settings {} {
        set ls [$itk_component(lslb) getcurselection]
        set rs [$itk_component(rslb) getcurselection]
        if {$rs != ""} {
                return 1
        } elseif {$ls != ""} {
                deselect_node
                return 0
        }
        error_message "There is no item selected" ".bsk"
	return 0 
}

##
# @brief Creates the "Build Skeleton" dialog
#
proc create_build_skeleton_dialog {title} {
        global BSPEC
        global PROJECT
        build_skeleton_dialog .bsk 
        .bsk buttonconfigure OK -command {
                if {[.bsk check_settings]} {
			.bsk deactivate 1
		}
        }
        set g [split [winfo geometry $BSPEC(IMPORT_BVI)] "+"]
        wm geometry .bsk "410x430+[lindex $g 1]+[lindex $g 2]"
	wm title .bsk $title
        wm minsize .bsk 400 420
        if {[.bsk activate]} {
                set it [.bsk get_selection]
                set s [lindex [split $it :] end]
        } else {
                set s ""
        }
        itcl::delete object .bsk
        return $s
}
