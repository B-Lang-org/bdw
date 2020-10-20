
##
# @file status_command_window.tcl
#
# @brief Definition of Status-command window.
#

global eval

set eval(text) ""
set eval(status) ""
set eval(current) -1
set eval(tab) new
set eval(count) 0
set eval(commands) ""
set eval(space) ""

##
# @brief Definition of class status_command_window
#
# status_command_window contains following components :
#       - Status window
#       - Command line
#       - Status bar
#
itcl::class status_command_window {
        #inherit iwidgets::Panedwindow
        # The local iwidigets renames Panedwindow
        inherit iwidgets::IPanedwindow

        ##
        # @brief Evaluate everything between limit and end as a Tcl command
        #
        proc eval_typed {}

        ##
        # @brief Evaluate a command and display its result
        #
        # @param c command to be executed
        #
        proc evaluate {c}

        ##
        # @brief setup the interp with statically loaded modules and source
        # standard BDW setup file
        #
        # @param s secondary interpreter
        #
        proc setup_interp_with_extensions {s}

        ##
        # @brief Create and initialize the secondary interpreter
        #
        # @param s secondary interpreter
        #
        proc sinterp_init {s}

        ##
        # @brief Adds project manipulation commands
        #
        # @param s secondary interpreter
        #
        proc add_project_commands {s}

        ##
        # @brief Adds file manipulation commands
        #
        # @param s secondary interpreter
        #
        proc add_file_commands {s}

        ##
        # @brief Adds build commands
        #
        # @param s secondary interpreter
        #
        proc add_build_commands {s}

        ##
        # @brief Adds window manipulation commands
        #
        # @param s secondary interpreter
        #
        proc add_window_commands {s}

        ##
        # @brief Adds analysis commands
        #
        # @param s secondary interpreter
        #
        proc add_analysis_commands {s}

        ##
        # @brief Adds help commands
        #
        # @param s secondary interpreter
        #
        proc add_help_commands {s}

        ##
        # @brief Adds waveform viewer commands
        #
        # @param s secondary interpreter
        #
        proc add_waveform_viewer_commands {s}

        ##
        # @brief Puts stdout and stderr into the text widget
        #
        # @param s secondary interpreter
        # @param a argument list
        #
        proc puts_alias {s a}

        ##
        # @brief Supports history for the command line
        #
        # @param c either next or previous
        #
        proc show_command {c}

        ##
        # @brief Supports prompt for the command line
        #
        proc switch_command {}

        ##
        # @brief Sets the prompt buffer
        #
        proc get_prompt_buffer {}

        ##
        # @brief Gets command line commands starting with the last word from
        # the specified command
        #
        # @param cmd the specified command
        #
        proc get_commands {cmd}

        ##
        # @brief Adds the specified "string file" file string to the prompt
        # buffer
        #
        # @param string the beggining of the command
        # @param file file name
        #
        proc add_file {string file}

        ##
        # @brief Gets files starting with the last word from the specified
        # command
        #
        # @param cmd the specified command
        #
        proc get_files {cmd}

        ##
        # @brief Displays help information
        #
        # @param c the command line command
        #
        proc display_help {{c ""}}

        ##
        # @brief Displays the specified information
        #
	# @param with_jump if true the view is scrolled to the end after
	# insertion
        # @param msg the message to be displayed
        #
        proc display_message {msg {with_jump true}}

        ##
        # @brief Opens a pipe which is writable; the read of the pipe
        #  sends to the status window
        #
        # @param closeProc is the proc called with the pipe is closed
        #  by the writer
        # @param type is the type of status message to be sent
        #
        proc open_writable_pipe {closeProc type}
        # returns 2 channel  stdout and stderr with better interleaeve
        proc open_writable_pipe_out_err {closeProc typeOut typeErr}

        proc set_result_font { {hide_or_show {"show"}} } {
                global eval
                if { [regexp "hide" $hide_or_show] } {
                        set newfont bscNULLFont
                        main_window::change_menu_status message hidemessages disabled
                        main_window::change_menu_status message showmessages normal
                        set res hide
                } else {
                        set newfont bscFixedFont
                        main_window::change_menu_status message hidemessages normal
                        main_window::change_menu_status message showmessages disabled
                        set res show
                }
                foreach t [list RESULT DEFAULT] {
                        $eval(status) type configure $t -font $newfont
                }
                return $res
        }

        private {
                ##
                # @brief Creates status window
                #
                method create_status_window {}

                ##
                # @brief Creates command line
                #
                method create_command_line {}
                method resize_event { type height width } 
        }

        constructor {args} {
                global eval
                lappend args -sashindent 30
                eval itk_initialize $args
                set eval(sinterp) [status_command_window::sinterp_init shell]
                create_status_window
                create_command_line
                fraction 75 25
                # final setup of the command interp
                status_command_window::load_cmd_history
                setup_interp_with_extensions $eval(sinterp)

        }

        destructor {
                status_command_window::save_cmd_history
        }
}


itcl::body status_command_window::puts_alias {s args} {
        global eval
	if {[llength $args] > 3} {
		error "invalid arguments"
	}
	set newline 0
        # note that the messagebox widget always inserts a newline so only
        # the __puts paths support this option
	if {[string match "-nonewline" [lindex $args 0]]} {
		set newline 1
		set args [lrange $args 1 end]
	}
	if {[llength $args] == 1} {
		set chan stdout
		set string [lindex $args 0]
	} elseif {[llength $args] == 2} {
		set chan [lindex $args 0]
		set string [lindex $args 1]
	} else {
		error "invalid arguments"
	}

	if [regexp (stdout|stderr) $chan] {
                if { $chan == "stderr" } { set ty ERROR } else { set ty RESULT }
		$eval(text) mark gravity limit right
                $eval(status) issue "$string" $ty
		$eval(text) see limit
		$eval(text) mark gravity limit left
                # interp eval $s __puts $chan [list $string]
	} else {
                if { $newline } {
	                interp eval $s __puts -nonewline $chan [list $string]
                } else {
	                interp eval $s __puts $chan [list $string]
                }
	}
}

itcl::body status_command_window::show_command {c} {
        global BSPEC
        global eval
        if {$c == "next"} {
                incr eval(current)
        }
        if {$c == "prev"} {
                set eval(current) [expr $eval(current) - 1]
        }
        $eval(text) delete limit end
        $eval(text) insert limit [lindex $BSPEC(HISTORY) $eval(current)] end
}


itcl::body status_command_window::switch_command {} {
        global eval
        if {$eval(tab) == "new"} {
                get_prompt_buffer
        }
        if {$eval(count) == [llength $eval(commands)]} {
                set eval(count) 0
        }
        if {$eval(commands) == ""} {
                return
        }
        $eval(text) delete limit end
        $eval(text) insert limit $eval(space) end
        $eval(text) insert end [lindex $eval(commands) $eval(count)] end
        incr eval(count)
}

itcl::body status_command_window::get_prompt_buffer {} {
        global eval
        set eval(space) ""
        set c [$eval(text) get limit end]
        while {[string index $c 0] == " "} {
                set c [string replace $c 0 0]
                append eval(space) " "
        }
        set cmd [string replace $c end end]
        set eval(commands) ""
        set eval(tab) ""
        set eval(count) 0
        get_commands $cmd
}

itcl::body status_command_window::get_commands {cmd} {
        global BSPEC
        global eval
        if {[llength $cmd] == 0} {
                set cmdlist [lsort [$eval(sinterp) eval info commands]]
                set nslist  [lsort [$eval(sinterp) eval namespace children]]
                set eval(commands) [concat $cmdlist $nslist]
        } elseif {[llength $cmd] == 1} {
                if {[string index $cmd end] == " "} {
                        get_files $cmd
                        return
                }
                set ns [namespace qualifiers $cmd]
                if { $ns != "" && [$eval(sinterp) eval namespace exists $ns] } {
                        set t [namespace tail $cmd]
                        set cmdlist [lsort [$eval(sinterp) eval info commands ${ns}::${t}*]]
                        set nslist  [lsort [$eval(sinterp) eval namespace children $ns ${t}*]]
                } elseif { [$eval(sinterp) eval namespace exists $cmd] } {
                        set cmdlist [lsort [$eval(sinterp) eval info commands ${cmd}::*]]
                        set nslist  [lsort [$eval(sinterp) eval namespace children $cmd *]]
                } else {
                        set cmdlist [lsort [$eval(sinterp) eval info commands ${cmd}*]]
                        set nslist  [lsort [$eval(sinterp) eval namespace children :: ${cmd}*]]
                }

                set eval(commands) [concat $cmdlist $nslist]
        } elseif {[llength $cmd] > 1} {
                get_files $cmd
        }
}

itcl::body status_command_window::add_file {string file} {
        global eval
        if {[file isdirectory $file]} {
                append file "\/"
        }
        lappend eval(commands) "$string$file"
}
itcl::body status_command_window::get_files {cmd} {
        global eval
        global BSPEC
        set file [string range $cmd [expr [string last " " $cmd] + 1] end]
        set s [string replace $cmd [expr [string last " " $cmd] + 1] end]
        if {$file == ""} {
                foreach i [glob -nocomplain -tails -directory [pwd] *] {
                        add_file $s $i
                }
        } elseif {[string index $file 0] == "-"} {
                foreach i $BSPEC(OPTIONS) {
                        set l [string length $file]
                        if {[string equal -length $l $i $file]} {
                                lappend eval(commands) "$s$i"
                        }
                }
        } else {
                foreach i [glob -nocomplain -path $file *] {
                        add_file $s $i
                }
        }
}

itcl::body status_command_window::evaluate {c} {
        global eval
        $eval(text) mark set insert end
        if [catch {$eval(sinterp) eval $c} result] {
                $eval(status) issue $result ERROR
        } else {
                $eval(status) issue $result RESULT
        }
        if {[$eval(text) compare insert != "insert linestart"]} {
                $eval(text) insert insert \n
        }
        $eval(text) insert insert $eval(prompt) prompt
        $eval(text) see insert
        $eval(text) mark set limit insert
}

itcl::body status_command_window::sinterp_init {s} {
	interp create $s
        interp eval  $s rename puts __puts
	interp alias $s puts {} status_command_window::puts_alias $s
        return $s
}

itcl::body status_command_window::setup_interp_with_extensions  {s} {
        global env
        # load statically linked packages and withdraw the tk window
        load "" Bluetcl $s
        interp eval $s package ifneeded Itcl [package require Itcl] \
                                                {{load {} Itcl ;}}
        interp eval $s package ifneeded Tk   [package require Tk] \
                                                {{load {} Tk ; wm withdraw .}}
        interp eval $s package ifneeded Itk  [package require Itk] \
                                                {{load {} Itk ;}}
        # Hook in sub interp to the ws interp
        interp eval $s set tcl_interactive 1
        interp eval $s set bscws_interp 1

        # provide a eval command into the main workstation interp
        interp alias $s bscws_eval {} interp eval {}
        interp eval $s source "$env(BLUESPECDIR)/tcllib/bluespec/bluespec.tcl"

        # Bring WS commands to the secondary interp
        interp eval $s "source  \"$env(BDWDIR)/tcllib/workstation/sinterp_namespace.tcl\""
        # source the user
        foreach fname [list bluespec_init.tcl] {
                if { [file readable $fname]} {
                        if { [catch "interp eval $s source \"$fname\"" err] } {
                                global errorInfo
                                __puts stderr "Error in startup script file: $fname"
                                __puts stdout $errorInfo
                                exit 1
                        }
                }
        }
}


itcl::body status_command_window::eval_typed {} {
        global eval
        global BSPEC
        global HELP
        set c [$eval(text) get limit end]
        $eval(text) mark set insert end
        $eval(text) insert insert \n
        if [info complete $c] {
                $eval(text) mark set limit insert
                set s $c
                if {[info exists HELP([lindex $c 0])]} {
                        set s [regsub -all "\\$" $c "\\$"]
                }
                evaluate $s
        }
        set c [string replace $c end end]
        if {$c != "" && $c != [lindex $BSPEC(HISTORY) end]} {
                lappend BSPEC(HISTORY) $c
        } else {
                set eval(current) [expr $BSPEC(CURRENT)]
                return
        }
        if {$c != "" && $BSPEC(CURRENT) < [expr $BSPEC(MAX_SIZE) - 1]} {
                incr BSPEC(CURRENT)
        }
        set eval(current) [expr $BSPEC(CURRENT)]
        if {[llength $BSPEC(HISTORY)] == $BSPEC(MAX_SIZE)} {
                set BSPEC(HISTORY) [lrange $BSPEC(HISTORY) 1 end]
        }
}

itcl::body status_command_window::create_status_window {} {
        global eval
        add "top" -margin 0 -minimum 50
        set p [childsite "top"]
        base::messagebox $p.mb -activeforeground blue -wrap char
        pack $p.mb -fill both -expand yes
        set eval(status) $p.mb
        $eval(status) add_type info white
        $eval(status) add_type INFO white blue
        $eval(status) add_type ERROR white red
        $eval(status) add_type WARNING white red
        $eval(status) add_type RESULT white black
        [$eval(status) gettext] tag raise sel
        # redirect stdout to this window
        if { ! [info exists __puts ] } {
            rename puts __puts
        }
        # the main interp redirects puts to the status window
        interp alias {} puts  {} status_command_window::puts_alias {}

        bind $eval(status) <Configure> +[itcl::code $this resize_event %T %h %w]
}

itcl::body status_command_window::resize_event { type height width } {
        # track end if the yiew include the end.
        if { [lindex [$::eval(status) component text yview] 1] == 1.0 } {
                after 100 $::eval(status) component text yview end
        }
}

itcl::body status_command_window::create_command_line {} {
        global eval
        global env
        add "bottom" -margin 0 -minimum 50
        set p [childsite "bottom"]
        iwidgets::scrolledtext $p.text -wrap char -textbackground white \
                -hscrollmode none -visibleitems 0x0 -textfont bscFixedFont \
                -spacing3 1
        pack $p.text -fill both -expand yes
        set eval(text) [$p.text component text]
        set eval(prompt) "# "
        $eval(text) tag configure prompt -underline true
        $eval(text) insert insert $eval(prompt) prompt
        $eval(text) mark set limit insert
        $eval(text) mark gravity limit left
        focus -force [$p.text component text]
        uplevel #0 "source \"$::env(BDWDIR)/tcllib/workstation/bindings.tcl\""
}

itcl::body status_command_window::display_help {{c ""}} {
        global eval
        global HELP

        if {$c == ""} {
                $eval(status) issue $HELP(help) INFO
                return
        }
        if {$c == "-list"} {
                set cmdlist [lsort [$eval(sinterp) eval SInterpUtils::getNamespaceCommands WS]]
                foreach i $cmdlist {
                        $eval(status) issue $i INFO
                }
                return
        }
	if {[info exists HELP($c)]} {
	        $eval(status) issue $HELP($c) INFO
	} else {
		puts stderr "Invalid command name '$c'.\n\
		Use 'help -list' command."
	}
}

itcl::body status_command_window::display_message {msg {with_jump true}} {
        global eval
	if {$with_jump} {
		$eval(status) issue "$msg" INFO
	} else {
		$eval(status) issue_without_jump "$msg" INFO
	}
}

# return a writable file opend via a named pipe
# When the channel is written, the results are presented to the status window
# When the channel is closed, the closeProc is called
itcl::body status_command_window::open_writable_pipe_out_err { closeProc typeOut typeErr} {
        global eval
        set fstdout [open_fifo]
        set fstderr [open_fifo]
        set stdoutChan  [lindex $fstdout 0]
        set stdoutName  [lindex $fstdout 1]
        set stderrChan  [lindex $fstderr 0]
        set stderrName  [lindex $fstderr 1]


        fileevent $stdoutChan readable [list status_command_window::readable_hook_dual $stdoutChan $stderrChan $typeOut $typeErr]
        fileevent $stderrChan readable [list status_command_window::readable_hook_dual $stdoutChan $stderrChan $typeOut $typeErr]

        # Track some status
        set eval([file join $stdoutChan "NAME"]) $stdoutName
        set eval([file join $stderrChan "NAME"]) $stderrName
        set eval([file join $stderrChan "CLOSE"]) $closeProc
        return [list $stdoutName $stderrName]
}

itcl::body status_command_window::open_writable_pipe { closeProc type } {
        global eval
        set f [open_fifo]
        set readFIFO  [lindex $f 0]
        set fifoName  [lindex $f 1]
        fileevent $readFIFO readable \
            [list status_command_window::readable_hook $readFIFO $type]
        # Track some status
        set eval([file join $readFIFO "NAME"]) $fifoName
        set eval([file join $readFIFO "CLOSE"]) $closeProc
        return $fifoName
}

# Open a named pipe which allows both read and
# write access.
# return the readChan and filename
proc status_command_window::open_fifo {} {
        global fifoID
        global env
        if {! [info exists fifoID] } { set fifoID 0 }
        incr fifoID
        if { [info exists env(TMP)] } { set tmp $env(TMP)
        } elseif { [info exists env(TEMP)] } { set tmp $env(TEMP)
        } else { set tmp /tmp }
        set fifoName [file join $tmp [format "fifo_%d_%d" [pid] $fifoID]]
        if {[catch "exec mkfifo $fifoName" err] } {
            puts stderr $err
            set readFIFO [open /dev/null {RDONLY NONBLOCK}]
        } else {
            set readFIFO [open $fifoName {RDONLY NONBLOCK}]
            fconfigure $readFIFO -blocking 0 -buffering line
        }
        return [list $readFIFO $fifoName]
}


proc status_command_window::readable_hook_dual { stdoutChan stderrChan typeOut typeErr } {
        global eval
        set lc1 0
        set more true
        while { $more } {
                set more false
                # empty stderr channel
                while { [gets $stderrChan line] >= 0 } {
                        set more true
                        $eval(status) issue_without_jump "$line" $typeErr
                        commands::display_command_results "$typeErr: $line"
                        incr lc1
                        if { $lc1 > 1000 } {
                                set lc1 0
                                update idletasks
                        }
                }
                if { [gets $stdoutChan line] >= 0 } {
                        set more true
                        $eval(status) issue_without_jump "$line" $typeOut
                        commands::display_command_results "$typeOut: $line"
                        incr lc1
                        if { $lc1 > 1000 } {
                                set lc1 0
                                return
                        }
                }
        }
        if { [eof $stderrChan] && [eof $stdoutChan] } {
                set closeProc $eval([file join $stderrChan "CLOSE"])
                if { $closeProc != "" } {
                        catch "$closeProc"
                }
                close $stderrChan
                close $stdoutChan
                set fileName $eval([file join $stdoutChan "NAME"])
                if { $fileName != "" } {
                        catch "exec rm -f \"$fileName\"" unused
                }
                set fileName $eval([file join $stderrChan "NAME"])
                if { $fileName != "" } {
                        catch "exec rm -f \"$fileName\"" unused
                }
                commands::unregisterPid $fileName
                #Unset the hooks
                unset eval([file join $stderrChan "CLOSE"])
                unset eval([file join $stderrChan "NAME"])
                unset eval([file join $stdoutChan "NAME"])
        }
}


proc status_command_window::readable_hook { chan type } {
        global eval
        set lc1 0
        set lc2 0
        while { [gets $chan line] >= 0 } {
                $eval(status) issue_without_jump "$line" $type
                # output 1 line at a time in trace mode to prevent race conditions
                if { [commands::display_command_results "$type: $line"] } { break }
                incr lc1
                incr lc2
                ## Allow other update tasks if this is a big chunk
                if { $lc1 > 1000 } {
                        set lc1 0
                        update idletasks
                }
                if { $lc2 > 5000 } {
                        update
                        return
                }
        }
        if {[fblocked $chan] } {
                return
        }
        if {[eof $chan]} {
                set closeProc $eval([file join $chan "CLOSE"])
                if { $closeProc != "" } {
                        catch "$closeProc"
                }
                close $chan
                set fileName $eval([file join $chan "NAME"])
                if { $fileName != "" } {
                        catch "exec rm -f \"$fileName\"" unused
                }
                #Unset the hooks
                unset eval([file join $chan "CLOSE"])
                unset eval([file join $chan "NAME"])
                commands::unregisterPid $fileName
        }
}


proc status_command_window::load_cmd_history {} {
        global BSPEC
        global env
        global eval

        proc safe_load_history {} {
                global BSPEC
                global env
                global eval
                set hfile [open $env(HOME)/.bdw/history.lst r]
                set BSPEC(HISTORY) [read -nonewline $hfile]
                catch "close  $hfile"
                set BSPEC(CURRENT) [llength $BSPEC(HISTORY) ]
                set eval(current)  $BSPEC(CURRENT)
                set eval(count)    [expr $BSPEC(CURRENT) + 1]
        }
        if { [catch "safe_load_history"  err] } {
                set BSPEC(HISTORY) [list]
                set BSPEC(CURRENT) 0
                set eval(current)  $BSPEC(CURRENT)
                set eval(count)    [expr $BSPEC(CURRENT) + 1]
        } else {
        }

}

proc status_command_window::save_cmd_history {} {
        global BSPEC
        global env
        set l [llength $BSPEC(HISTORY)]
        if {$l > $BSPEC(MAX_SIZE)} {
                set s [expr $l - $BSPEC(MAX_SIZE)]
                set BSPEC(HISTORY) [lrange $BSPEC(HISTORY) $s end]
        }
        if {! [catch "open $env(HOME)/.bdw/history.lst w" hfile] } {
                puts $hfile $BSPEC(HISTORY)
                catch [close  $hfile]
        }
}


## Local Variables:
## eval: (set (make-local-variable 'tcl-indent-level) 8)
## End:
