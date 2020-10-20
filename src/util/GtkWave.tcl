
package require MathSupport
package require Trace
package require TypeSupport
package require Unique
package require ViewerCommon

namespace eval GtkWaveSupport {

    namespace export \
        send_typed_signal_to_gtkwave

    namespace import ::MathSupport::*
    namespace import ::Trace::*
    namespace import ::TypeSupport::*
    namespace import ::ViewerCommon::*
    namespace import ::Unique::*

    variable gGtkWavePid       -1
    variable gGtkWaveExec      ""

    ################################################################################
    ###
    ################################################################################

    variable sav_file_name ""
    variable gGtkWaveSavFileStream
    variable gGtkWaveFlags ""

    proc send_sav_cmd {cmd {fileStream ""}} {

	variable sav_file_name
	variable gGtkWaveSavFileStream
	variable gGtkWaveFlags
        
        if {$fileStream eq ""} {
            if {$sav_file_name == "" } {
                set sav_file_name "[Unique::create_temp_file_name].sav"
                set gGtkWaveSavFileStream [open $sav_file_name w]
                set gGtkWaveFlags 0
            }
            set fileStream $gGtkWaveSavFileStream
        }
        modeEval {puts $fileStream $cmd}
	set value "buffered"

	return $value

    }

    proc send_buffered_sav_cmd {} {

	variable sav_file_name
	variable gGtkWaveSavFileStream
	variable gGtkWaveFlags

	if {$sav_file_name == ""} {
	    return true
	}

	close $gGtkWaveSavFileStream
	set value [load_file $sav_file_name]
	set sav_file_name "[Unique::create_temp_file_name].sav"
	set gGtkWaveSavFileStream [open $sav_file_name w]
	set gGtkWaveFlags 0

	return $value
    }

    ################################################################################
    ###
    ################################################################################

    proc send_to_gtkwave {cmd var} {

	variable gGtkWavePid
	variable gGtkWaveExec
	variable ::ViewerCommon::gEvalMode

	set interpreter_id "$gGtkWaveExec\_$gGtkWavePid"

	set res 0;
	set value "noop"

	if {$::ViewerCommon::gEvalMode} {
#	    puts stderr "Sending to GtkWave: $gGtkWavePid -> $cmd"
	    set res [catch {send $interpreter_id $cmd} value]
#	    puts stderr "return val: $value"
	}

	uplevel 1 [list set $var $value]

	return $res

    }
    proc check_communications {} {
	variable gGtkWavePid
	variable gGtkWaveExec
        set cmd "gtkwave::presentWindow"
	set interpreter_id "$gGtkWaveExec\_$gGtkWavePid"

        set msg "Unable to communicate with GtkWave"
        if { [catch {send $interpreter_id $cmd} value] } {
            if { [regexp "insecure" $value] } {
                append msg \n "You must run \"xhost -\" to allow" 
                append msg \n "communication between BDW and GtkWave" \n
            }
            append msg  \n $value
            bgerror $msg
            return 0
        }
        # Check that /tmp can be used for file communications
        set testname "[Unique::create_temp_file_name].test"
        proc opentestfile { name } {
            set fd [open $name w]
            puts $fd [pid]
            close $fd
        }
        if { [catch {opentestfile $testname} val] } {
            append msg \n "BDW is unable to open a test file"
            append msg \n "$testname."
            append msg \n "set BLUESPECTMP to a writable directory."
            append msg \n \n $val
            bgerror $msg
            return 0
        }

        set cmd "file exists $testname"
        if { [catch {send $interpreter_id $cmd} value] || $value == 0 } {
            append msg \n "GtkWave is unable to open the test file"
            append msg \n "$testname."
            append msg \n "set BLUESPECTMP to a shared directory."
            bgerror $msg
            return 0
        }
        return 1
    }


    proc start_viewer { command options timeout } {

	variable gGtkWavePid
	variable gGtkWaveExec
        package require Tk
	set cmd $command
	set logdir gtkwave
	set logfile log
	set result 1

	if { [catch "exec mkdir -p $logdir" err] } {
	    set msgs [list "Could not create directory: $logdir." \
			  "Please check your file permissions." \
			  "additional message: $err"]
	    error [join $msgs "\n"]
	}

	if { $options != "" } {
	    lappend cmd $options
	}

        # read from /dev/null into  gtkwaves interp
	if { [catch "exec [join $cmd { }] < /dev/null >& $logdir/$logfile &" err] } {
	    set msgs [list "Could not start waveform viewer." \
			  "Please check your options and path." \
			  "Command: [join $cmd { }] >& $logdir/$logfile." \
			  "additional message: $err"]
	    error [join $msgs "\n"]
	} else {
	    set gGtkWavePid $err
	    set gGtkWaveExec [file tail $command]
            set tkname [join [list $gGtkWaveExec $gGtkWavePid] _]
            wait_for_running $command  $tkname $logfile [join $cmd " "] $timeout

	}
	return $tkname
    }

    proc wait_for_running { command tkname logfile fullcmd timeout } {
        # timeout in seconds to 250 ms wait times
        set ctimeout [expr $timeout * 4]
        set f1 ""
        set f2 ""

        # If the license check fails, then this will fail as well
        set ctimeout [expr $timeout * 4]
        for {set i 0} {$i < $ctimeout} {incr i} {
            set appList [winfo interp]
            if {[lsearch $appList $tkname] >= 0} {
                set f2 $appList
                break
            }
            update
            after 250
        }

        set appList [winfo interp]
        if {[lsearch $appList $tkname] < 0} {
            if { [file exists $logfile] } {
                set msg [list "There was some trouble running $command." \
                             "Check the file $logfile for more infomation." \
                             "If the application has started, please try to \"attach\" to application or start again." \
                             "TK sockets: $appList"]
            } else {
                set msg [list "Could not start waveform viewer." \
                             "Please check your options and path." \
                             "Command: $fullcmd" ]
            }
            error [join $msg "\n"]
        }
    }

    proc attach_viewer { app } {
	variable gGtkWavePid
        variable gGtkWaveExec
        package require Tk
        if { $app == "" && $gGtkWavePid != -1 } {
            puts stderr "detaching from $gGtkWavePid"
            set gGtkWavePid -1
            return true 
        } 
        if { [lsearch [winfo interp] $app] >= 0 } {
            if { [regexp {(.*)_([0-9]+)$} $app x appName pid] } {
                set gGtkWavePid $pid
                set gGtkWaveExec $appName
                puts stderr "attaching to $app"
                raise_window 
                return true 
            }
        }
        puts stderr "Could not attach to application $app"
        return false 
    }

    proc check_running {} {
	variable gGtkWavePid
	variable gGtkWaveExec
        package require Tk
	set app "$gGtkWaveExec\_$gGtkWavePid"

        return [expr [lsearch [winfo interp] $app] >= 0 ]
    }

    # assumes that file exists
    proc load_file { filename } {
	set result [send_to_gtkwave "gtkwave::loadFile $filename" value]
	if {$result == 0} {
	    raise_window
	    return true
	}
	return false
    }

    proc load_dump_file { filename } {
	return [load_file $filename]
    }

    proc reload_dump_file {} {
	set result [send_to_gtkwave "gtkwave::reLoadFile" value]
	if {$result == 0} {
	    raise_window
	    return true
	}
	return false
    }

    proc raise_window {} {
	return [send_to_gtkwave "gtkwave::presentWindow" ignore]
    }

    proc show_last_signal {} {
	return [send_to_gtkwave "gtkwave::showSignal 1000 0" ignore]
    }

    proc reset_for_new_file {} {
	# noop for now
    }

    proc list_potential_viewers { } {
        package require Tk
	set viewers [list gtkwave gtkx]
	set vreg [join $viewers "|"]

	set ret [list]
	foreach i [winfo interp] {
	    if { [regexp -nocase $vreg $i] == 1 } {
		lappend ret $i
	    }
	}
	return $ret
    }

    proc close_viewer {} {
	return [send_to_gtkwave "exit" ignore]

    }

    proc isDumpFileLoaded {} {
	set result [send_to_gtkwave "gtkwave::getDumpType" value]
	if { $result == 0  && ![string match -nocase "*UNKNOWN*" $value ] } {
	    return true
	}
	return false
    }

    ################################################################################
    ###
    ################################################################################

    proc send_typed_signal_to_gtkwave {type_name name suffix_ lsb \
					   {depth 0} {send_as_bits 0} {extend_names 0} \
                                           {bool_as_enum 1} {fileStream ""}} {

	set size 0

	if {$extend_names} {
            #we do not need to pass fileStream to get_typed_signal_size_gtkwave because
            #it calls send_typed_signal_to_gtkwave_inner with gEvalMode==0 (so modeEval prevents output)
	    set size [get_typed_signal_size_gtkwave \
			  $type_name $name $suffix_ $lsb $depth $send_as_bits $extend_names $bool_as_enum]
	}

	send_typed_signal_to_gtkwave_inner \
	    $type_name $name $suffix_ $lsb $depth $send_as_bits $size $bool_as_enum $fileStream

    }


    proc send_typed_signal_to_gtkwave_inner {type_name signal suffix_ lsb {depth 0} {send_as_bits 0} {len_min 0} {bool_as_enum 1} {fileStream ""}} {

	variable ::ViewerCommon::delim_body
	variable ::ViewerCommon::delim_last
	upvar $signal SIG

	set delim  $::ViewerCommon::delim_body
	set suffix [cleanup_suffix $suffix_]
	set delim_first ""

	set type_name [cleanUpType $type_name]

	set details [SignalTypes::getTypeDetails $type_name]

	set flavor [SignalTypes::extractFlavor $details]
	set size   [SignalTypes::extractSize   $details]

	if {!$bool_as_enum && $type_name == "Bool"} {
	    set flavor "BASIC"
	}

	if {[array exists SIG]} {
	    set pair [array get SIG name]
	    set name [lindex $pair 1]
	    set pair [array get SIG size]
	    set signal_size [lindex $pair 1]
	    set signal SIG
	} else {
	    set name $signal
	    set signal_size $size
	    set signal [signalCreate $name $signal_size]
	}

	if {$size == 0} { return "" }

	if {$send_as_bits} {
	    set traceName [traceNew]
	    set alias [extendName $name $len_min]
	    if {$size > 1} {
		set alias [create_signal_name $alias 0 $size]
	    }
	    array set $traceName [list signal      $name]
	    array set $traceName [list signal_size $signal_size]
	    array set $traceName [list size $size]
	    traceAddFlags $traceName [expr $Trace::TR_HEX | $Trace::TR_RJUSTIFY]
	    send_sav_cmd [create_trace_cmd $traceName $alias {}] $fileStream
	    return $name
	}

	if {$type_name == "real"} {
	    set traceName [traceNew]
	    set alias [extendName $name $len_min]
	    if {$size > 1} {
		set alias [create_signal_name $alias 0 $size]
	    }
	    array set $traceName [list signal      $name]
	    array set $traceName [list signal_size $signal_size]
	    array set $traceName [list size $size]
	    traceAddFlags $traceName [expr $Trace::TR_ANALOG_STEP | $Trace::TR_RJUSTIFY | $Trace::TR_ANALOG_FULLSCALE]
	    send_sav_cmd [create_trace_cmd $traceName $alias {}] $fileStream
	    return $name
	}

	set type_label [getBriefType $type_name]

	set type_suffix "&\[$type_label\]"

	if {($flavor == "STRUCT") || ($flavor == "TAGGEDUNION")} {

	    set fields [SignalTypes::extractFields $details]

	    set just_one false
	    if {[llength $fields] == 1} {
		set just_one true
	    }

	    set type_suffix " \[+\]&\[$type_label\]"
	}

	if {$suffix != "" } {

	    set new_name "$name$delim_first$suffix$type_suffix"

	} else {

	    set new_name "$name$type_suffix"
	}

	regsub  {.*\/} $new_name "" local_name
	set prefix [string trim $new_name $local_name]

	switch $flavor {
	    ENUM {
		set members [SignalTypes::extractMembers $details]

		set traceName [traceNew]
		set alias [extendName $new_name $len_min]
		array set $traceName [list signal      $name]
		array set $traceName [list signal_size $signal_size]
		array set $traceName [list lsb $lsb]
		array set $traceName [list size $size]
		traceAddFlags $traceName [expr $Trace::TR_HEX | $Trace::TR_RJUSTIFY]
		send_sav_cmd [create_trace_cmd $traceName $alias $members] $fileStream
		return $alias
	    }
	    STRUCT {

		set suffix2 [nextSuffix $suffix]

		set count 1
		set field_count [count_real_fields $fields]

		set traceName [traceNew]
		set alias [extendName $new_name $len_min]
		array set $traceName [list signal      $name]
		array set $traceName [list signal_size $signal_size]
		array set $traceName [list lsb $lsb]
		array set $traceName [list size $size]
		traceAddFlags $traceName [expr $Trace::TR_HEX | $Trace::TR_RJUSTIFY]
		traceAddFlags $traceName [expr $Trace::TR_GRP_BEGIN | $Trace::TR_CLOSED]

		set cmd [create_trace_cmd $traceName $alias {}]
		send_sav_cmd $cmd $fileStream

		foreach field $fields {
		    set field_name [lindex $field 0]
		    set field_type [lindex $field 1]
		    set field_lsb  [lindex $field 3]
		    set field_size [lindex $field 2]

		    if {$field_size > 0 } {

			set last 0
			if {$count == $field_count} {
			    set last 1
			    set zow $::ViewerCommon::delim_last
			} else {
			    set zow $delim
			}
			set suf $field_name
			if {$suffix2 != "" } {
			    set suf $suffix2$zow$field_name
			} else {
			    set suf $suffix2$zow$field_name
			}
			send_typed_signal_to_gtkwave_inner \
			    $field_type \
			    $signal \
			    $suf \
			    [plus [max 0 $lsb] $field_lsb] \
			    [expr $depth + 1] \
			    0 \
			    $len_min \
			    $bool_as_enum \
                            $fileStream
		    }
		    incr count
		}
		set traceName [traceCreateGroupEnd]
		set cmd [create_trace_cmd $traceName "" {}]
		send_sav_cmd $cmd $fileStream

		return $alias
	    }
	    TAGGEDUNION {

		set suffix2 [nextSuffix $suffix]

		set count 1
		set field_count [count_real_fields $fields]

		set traceName [traceNew]
		set alias [extendName $new_name $len_min]
		array set $traceName [list signal      $name]
		array set $traceName [list signal_size $signal_size]
		array set $traceName [list lsb $lsb]
		array set $traceName [list size $size]
		traceAddFlags $traceName [expr $Trace::TR_HEX | $Trace::TR_RJUSTIFY]
		traceAddFlags $traceName [expr $Trace::TR_GRP_BEGIN | $Trace::TR_CLOSED]

		set cmd [create_trace_cmd $traceName $alias {}]

		################################################################################
		### Add the tag field
		################################################################################

		if {!$just_one} {
		    
		    set select_msb [expr [max 0 $lsb] + [expr $size - 1]]
		    set select_lsb 0
		    
		    # calulate lsb for "select" field
		    foreach field $fields {
			set field_lsb  [plus [max 0 $lsb] [lindex $field 3]]
			set field_size [lindex $field 2]
			set field_msb  [expr $field_lsb + [expr $field_size - 1]]
			set select_lsb [max $select_lsb [expr $field_msb + 1]]
		    }
		    
		    set select_size [expr [expr $select_msb - $select_lsb] + 1]
		    
		    if {[isScalarType $type_name]} {
			
		    }
		    
		    # add one field for an "enum" display
		    set field_name "tag"
		    set suf $field_name
		    
		    set suf $suffix2$delim$field_name
		    
		    set added_name "$name$suf&\[$type_label\]"
		    
		    set members [SignalTypes::extractMembers $details]
		    
		    set traceName [traceNew]
		    set alias [extendName $added_name $len_min]
		    array set $traceName [list signal      $name]
		    array set $traceName [list signal_size $signal_size]
		    array set $traceName [list lsb $select_lsb]
		    array set $traceName [list size $select_size]
		    traceAddFlags $traceName [expr $Trace::TR_HEX | $Trace::TR_RJUSTIFY]

		    set cmd "$cmd\n[create_trace_cmd $traceName $alias $members]"

		}

		################################################################################
		###
		################################################################################

		send_sav_cmd $cmd $fileStream

		foreach field $fields {
		    set field_name [lindex $field 0]
		    set field_type [lindex $field 1]
		    set field_lsb  [lindex $field 3]
		    set field_size [lindex $field 2]

		    if {$field_size > 0 } {

			set last 0
			if {$count == $field_count} {
			    set last 1
			    set zow $::ViewerCommon::delim_last
			} else {
			    set zow $delim
			}
			set suf $field_name
			if {$suffix2 != "" } {
			    set suf $suffix2$zow$field_name
			} else {
			    set suf $suffix2$zow$field_name
			}
			if {$just_one} {
			    set suf $suffix2
			}
			send_typed_signal_to_gtkwave_inner \
			    $field_type \
			    $signal \
			    $suf \
			    [plus [max 0 $lsb] $field_lsb] \
			    [expr $depth + 1] \
			    0 \
			    $len_min \
			    $bool_as_enum \
                            $fileStream
			    
		    }
		    incr count
		}
		set traceName [traceCreateGroupEnd]
		set cmd [create_trace_cmd $traceName "" {}]
		send_sav_cmd $cmd $fileStream

		return $alias
	    }
	    default {
		set traceName [traceNew]
		set alias [extendName $new_name $len_min]
		array set $traceName [list signal      $name]
		array set $traceName [list signal_size $signal_size]
		array set $traceName [list lsb $lsb]
		array set $traceName [list size $size]
		traceAddFlags $traceName [expr $Trace::TR_HEX | $Trace::TR_RJUSTIFY]
		send_sav_cmd [create_trace_cmd $traceName $alias {}] $fileStream
		return $new_name

	    }
	}
    }

################################################################################
###
################################################################################

proc create_trace_cmd {tracename alias members} {

    upvar $tracename TRACE

    set pair [array get TRACE signal]
    set signal [lindex $pair 1]

    set pair [array get TRACE signal_size]
    set signal_size [lindex $pair 1]

    set pair [array get TRACE lsb]
    set lsb [lindex $pair 1]

    set pair [array get TRACE size]
    set size [lindex $pair 1]

    set pair [array get TRACE flags]
    set flags [lindex $pair 1]

    if {$members != {}} {
	set flags [expr $flags | $Trace::TR_PTRANSLATED]
	if {$size == 1} {
	    set members "$members $members"
	}
    }

    set cmd [create_flags_cmd $flags]
    set cmd "$cmd[create_enum_cmd $members]"

    set is_blank [expr ($flags & $Trace::TR_BLANK) != 0]

    if {$is_blank} {
	set pair [array get TRACE text]
	set text [lindex $pair 1]

	set cmd "$cmd\-$text"

	return $cmd;
    }

    set full_name $signal
    if {$signal_size > 1} {
	set full_name [create_signal_name $full_name 0 $signal_size]
    }

    if {$lsb == -1 || ($lsb == 0 && $size == $signal_size)} {
	set nm $full_name
	set fnm [toGtkWaveFormat $full_name]
	set cmd "$cmd[create_alias_cmd $nm $alias]"
	if {$size == 1 && $members != {}} {
	    set cmd "$cmd\#\{$fnm\}"
	    set cmd "$cmd $fnm"
	    set cmd "$cmd $fnm"
	} else {
	    set cmd "$cmd$fnm"
	}
    } else {
	if {$size > 1} {
	    set signal_name [create_signal_name $signal $lsb $size]
	    set nm $signal_name
	    set fnm [toGtkWaveFormat $nm]
	    set cmd "$cmd[create_alias_cmd $nm $alias]\#\{$fnm\}"
	    set fnm [toGtkWaveFormat $full_name]
	    set bcmd ""
	    for {set i 0} {$i < $size} {incr i} {
		set pos [expr $signal_size - ($lsb + $i + 1)]
		set bcmd " \($pos\)$fnm$bcmd"
	    }
	    set cmd "$cmd$bcmd"
	} else {
	    set nm $full_name
	    set fnm [toGtkWaveFormat $full_name]
	    set cmd "$cmd[create_alias_cmd $nm $alias]"
	    set pos [expr $signal_size - ($lsb + 1)]
	    if {$members != {}} {
		set cmd "$cmd\#\{$fnm\}"
		set cmd "$cmd \($pos\)$fnm"
		set cmd "$cmd \($pos\)$fnm"
	    } else {
		set cmd "$cmd\($pos\)$fnm"
	    }
	}
    }

    return $cmd

}

proc create_alias_cmd {name alias} {

    set cmd ""

    if {$alias != "" && $alias != $name} {
	set alias [toGtkWaveFormat $alias]
	set cmd "+{$alias} "
    }

    return $cmd
}

proc create_enum_cmd {members} {

    set cmd ""
    if {$members != {}} {
	set cmd [sprintf "^>1 enum %s\n" $members]
    }

    return $cmd

}

proc toGtkWaveFormat {signal_name} {

    set new [string trimleft $signal_name \/]
    set new [string map {\/ .} $new]

    return $new
}

proc create_flags_cmd {flags} {

    variable gGtkWaveFlags

    set gGtkWaveFlags $flags

    return [sprintf "@%x\n" $flags]

}

################################################################################
###
################################################################################

proc get_typed_signal_size_gtkwave {type_name name suffix_ lsb {depth 0} {send_as_bits 0} {extend_names 0} {bool_as_enum 1}} {

    variable ::ViewerCommon::gCurrentMax
    variable ::ViewerCommon::gEvalMode
    variable gGtkWaveSizes

    set pos [string last "/" $name]
    set prefix [string range $name 0 $pos]
    set suffix [string range $name [expr $pos + 1] end]

    set length [string length $suffix]

    set key "$type_name$suffix_$send_as_bits"

    set value [array get gGtkWaveSizes $key]

    if {$value != ""} {
  	return [expr [lindex $value 1] + $length]
    }

    set orig $::ViewerCommon::gEvalMode

    set ::ViewerCommon::gEvalMode   0
    set ::ViewerCommon::gCurrentMax 0

    send_typed_signal_to_gtkwave_inner \
	$type_name "x" $suffix_ $lsb $depth $send_as_bits $extend_names $bool_as_enum

    set ::ViewerCommon::gEvalMode $orig

    set value [expr $::ViewerCommon::gCurrentMax - 1]

    array set gGtkWaveSizes [list $key $value]

    return [expr $value + $length]
}
}

package provide GtkWaveSupport 1.0
