
##
# @file dialog.tcl
#
# @brief Definition of class dialog.
#

##
# Definition of namespace base
#
namespace eval base {

package require Bluetcl

##
# @brief Definition of class dialog
#
itcl::class dialog {
        inherit iwidgets::Dialog

        ##
        # @brief Adds a text label 
        #
        # @param n name of the component 
        # @param t text
        # @param f font 
        #
        method add_label {n t f}

        ##
        # @brief Adds checkbutton 
        #
        # @param f name of the frame 
        # @param b name of component
        # @param t text of the button  
        #
        method add_checkbutton {f b t}

        ##
        # @brief Adds a radio-button to the radio-box component
        #
        # @param radio_box name of the radio-box component
        # @param but name of the radio-button
        # @param text test of the radio-button  
        # @param cmd the command to be executed under the selection of
        # radio-button
        #
        method add_radiobutton {radio_box but text {cmd {}}}

        ##
        # @brief Adds a radio-box
        #
        # @param b name of the radio-box component
        # @param t label of the radio-box  
        #
        method add_radiobox {b t}

        ##
        # @brief Adds entryfield 
        #
        # @param f name of the frame 
        # @param n name of the entryfield 
        # @param l label of the entryfield 
        #
        method add_entryfield {f n l} 

        ##
        # @brief Inserts the specified string into entryfield 
        #
        # @param entryname name of the entryfield 
        # @param string the text to be inserted into entryfield 
        #
        method insert_in_entryfield {entryname string} 

        ##
        # @brief Adds entryfield with browse button
        #
        # @param f name of the frame
        # @param n name of the entryfield 
        # @param l label of the entryfield 
        # @param c command for buttonpress
        #
        method add_browse_entryfield {f n l c}

        ##
        # @brief Sets the bindings
        # 
        method set_bindings {} {
                set w [string replace $this 0 1]
                bind $w <Control-w> {
                        .[lindex [split %W .] 1] deactivate 0
                }
        }

        constructor {args} {
                lappend args -modality application
                default 0
                hide Apply
                hide Help
                set_bindings
                eval itk_initialize $args
        }

        destructor {
        }
}

itcl::body dialog::add_label {n t f} {
        itk_component add $n {
                label $itk_interior.$n -text $t -font $f -wraplength 15cm
        } 
        pack $itk_component($n) 
}

itcl::body dialog::add_checkbutton {f b t} {
        global checkvar
        itk_component add $f {
                frame $itk_interior.$f 
        }
        pack $itk_component($f) -side top -expand true -fill both
        itk_component add $b {
                checkbutton $itk_component($f).$b -text $t \
                        -variable checkvar
        }
        pack $itk_component($b) -side left 
        $itk_component($b) select
}

itcl::body dialog::add_radiobutton {radio_box but text {cmd {}}} {
        $itk_component($radio_box) add $but -text $text -command $cmd
}

itcl::body dialog::add_radiobox {b t} {
        itk_component add $b {
                iwidgets::radiobox $itk_interior.$b -orient vertical \
                        -labelpos nw -labeltext $t 
        } {
                keep -cursor -background
        }
        pack $itk_component($b) -padx 4 -pady 4 -fill both
}

itcl::body dialog::add_entryfield {f n l} {
        itk_component add $f {
                frame $itk_interior.$f
        }
        pack $itk_component($f) -side top -expand true -fill both
        itk_component add $n {
                iwidgets::entryfield $itk_component($f).$n \
                -labeltext $l -textbackground white -labelpos w \
                -command "$this invoke OK"
        } {
                keep -cursor -background
        }
        pack $itk_component($n) -fill x -expand true 
}

itcl::body dialog::insert_in_entryfield {entryname string} {
        $itk_component($entryname) insert 0 "$string "
}

itcl::body dialog::add_browse_entryfield {f n l c} {
        itk_component add $f {
                frame $itk_interior.$f 
        }
        pack $itk_component($f) -side top -expand true -fill both
        itk_component add $n {
                iwidgets::entryfield $itk_component($f).$n \
                -labeltext $l -textbackground white -labelpos w \
                -command "$this invoke OK"
        } {
                keep -cursor -background
        }
        pack $itk_component($n) -fill x -expand true -side left
        itk_component add but$f {
                button $itk_component($f).but$f -text "Browse..." -command $c
        }
        pack $itk_component(but$f) -side right
}
}

##
# @brief Opens the Save Current dialog
#
proc save_current {} {
        global BSPEC
        global PROJECT
        if {[winfo exists .sc]} {
                return
        }
        base::dialog .sc -title "BSC Workstation"
        .sc add_label t "Current project has not been saved.\n\
        Do you want to save it?" bscMessageFont
        .sc show Apply
        .sc buttonconfigure OK -text Save -command {
                .sc deactivate 1
        }
        .sc buttonconfigure Apply -text Discard -command {
                .sc deactivate 2
        }
        set g [split [winfo geometry $BSPEC(MAIN_WINDOW)] "+"]
        wm geometry .sc "+[lindex $g 1]+[lindex $g 2]"
        wm minsize .sc 350 150
        focus -force .sc
        set a [.sc activate]
        if {$a == 1} {
                commands::save_project
        }
        if {$a == 2} {
                set PROJECT(STATUS) saved
        }
        itcl::delete object .sc
}

##
# @brief Opens the Error Message dialog
#
# @param text the text to be displayed in the dialog
#
proc error_message {text {win ""}} {
        global BSPEC
        if {$win == ""} {
                set win $BSPEC(MAIN_WINDOW)
        }
        tk_messageBox -title "Error BSC Workstation" -icon error \
                -message $text -parent $win
}

##
# @brief Opens the Overwrite Project dialog
#
# @param p name of an existing project
#
proc overwrite_project {p} {
        global BSPEC
        base::dialog .s -title "BSC Workstation"
        set t "The project named $p already exists.\n\
        Do you want to overwrite it?"
        .s add_label t $t bscMessageFont
        focus -force .s
        set g [split [winfo geometry $BSPEC(MAIN_WINDOW)] "+"]
        wm geometry .s "+[lindex $g 1]+[lindex $g 2]"        
        wm minsize .s 350 150
        if {[.s activate]} {
                set r overwrite
        } else {
                set r ""
        }
        itcl::delete object .s
        return $r
}

##
# @brief Creates the "Help->About" dialog.
#
proc create_help_about_dialog {} {
        global BSPEC
        set  v [commands::version]
        set rel [lindex $v 0]
        set dat [lindex $v 1]
        set rev [lindex $v 2]
        base::dialog .h -title "About BSC Workstation"
        .h hide Cancel
        .h add_label l1 "BSC Workstation" bscMessageFontBold
        set t "\n"
        if {$rel != ""} {
            set t "${t}Version: $rel\n"
        }
        if {$dat != ""} {
            set t "${t}Date: $dat\n"
        }
        if {$rev != ""} {
            set t "${t}Revision: $rev\n"
        }
        if {$rev != "" || $rel != "" || $dat != ""} {
            set t "${t}\n"
        }
        set t "${t}(c) 2020 Bluespec Inc.\n All Rights Reserved."
        .h add_label l2 $t bscMessageFont
        set g [split [winfo geometry $BSPEC(MAIN_WINDOW)] "+"]
        wm geometry .h "+[lindex $g 1]+[lindex $g 2]"        
        wm minsize .h 300 200
        .h activate
        itcl::delete object .h 
}

##
# @brief Opens the Warning dialog
#
# @param text the warning
#
proc ignore_warning {text {win ""}} {
        global BSPEC
        if {$win == ""} {
                set win $BSPEC(MAIN_WINDOW)
        }
        set st [tk_messageBox -title "Warning!" -icon warning -type okcancel\
                -message $text -parent $win -minsize "320 100"]
        if {$st == "ok"} {
                return true
        } elseif {$st == "cancel"} {
                return false
        }
}

##
# @brief Creates the Status dialog
#
proc create_status_dialog {title text {win ""}} {
        global BSPEC
        if {$win == ""} {
                set win $BSPEC(MAIN_WINDOW)
        }
        tk_messageBox -title $title -icon info -message $text -parent $win \
                -minsize "320 100"
}

##
# @brief Creates the Package Search dialog which performes search through the
# package hierarchy
#
proc create_package_search_dialog {} {
        global BSPEC
        if {[winfo exists .sd]} {
                wm deiconify .sd 
                raise .sd
                focus -force .sd
                return
        }
        base::dialog .sd -title "Package Search"
        .sd configure -modality none
        .sd add_entryfield f ent Find:
        set g [split [winfo geometry $BSPEC(PACKAGE)] "+"]
        wm geometry .sd "+[lindex $g 1]+[lindex $g 2]"
        wm minsize .sd 250 100
        .sd buttonconfigure OK -text Next -command \
                {commands::search_in_packages [.sd component ent get] "Next"}
        .sd show Apply
        .sd buttonconfigure Apply -text Previous -command \
                {commands::search_in_packages [.sd component ent get] "Prev"}
        .sd buttonconfigure Cancel -command \
                {.sd deactivate 0; itcl::delete object .sd}
        .sd activate
}

##
# @brief 
#
#proc select_viewer {} {
#        global BSPEC
#        base::dialog .c -title "Attach Viewer"
#        .c add_radiobox rbox "Viewers"
#        set viewers [Waves::list_potential_viewers]
#        set idx 0
#        foreach i $viewers {
#            .c add_radiobutton rbox $idx "$i" 
#            incr idx
#        }
#        .c buttonconfigure OK -text Attach -command {
#                if {[.c component rbox get] == ""} {
#                        error_message "The viewer to attach is not selected"
#                } else {
#                        .c deactivate 1
#                }
#        }
#        focus -force .c
#        set g [split [winfo geometry $BSPEC(MODULE_BROWSER)] "+"]
#        wm geometry .c "+[lindex $g 1]+[lindex $g 2]"
#        wm minsize .c 200 130 
#        if {[.c activate]} {
#            set vidx [.c component rbox get]
#            set viewer [lindex $viewers $vidx]
#        } else {
#                set viewer ""
#        }
#        itcl::delete object .c
#        return $viewer
#}

proc editor_running_dialog {} {
        global PROJECT
        if {[winfo exists .sc]} {
                wm deiconify .sc 
                raise .sc
                focus -force .sc
                return
        }
        base::dialog .sc -title "BSC Workstation"
        .sc add_label t "Your editor is still running.\n\
        Do you still want to exit the workstation?" bscMessageFont
#        .sc show Apply
        .sc buttonconfigure OK -text Exit -command {
                .sc deactivate 1
        }
        wm minsize .sc 350 150
        focus -force .sc
        set a [.sc activate]
        itcl::delete object .sc
        if {$a == 1} {
            return true
        }
        return false
}


## Local Variables:
## eval: (set (make-local-variable 'tcl-indent-level) 8)
## End:
