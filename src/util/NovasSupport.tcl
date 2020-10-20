
package require MathSupport 
package require SignalTypes
package require TypeSupport
package require Unique
package require ViewerCommon
package require utils
package require NovasSupportSendSignal
namespace eval NovasSupport {

    namespace export \
        send_typed_signal_to_novas 

    namespace import ::NovasSupportSendSignal::*

################################################################################
### package Variables
################################################################################

    variable gNovasAPIString     ""
    variable  gNovasSignalsString ""
    variable  gNovasProcName ""

    variable gZow 
    array set gZow [list]




################################################################################
###
################################################################################


proc send_to_novas {{direct 1} cmd} {

    variable ::ViewerCommon::gEvalMode

    if {!$::ViewerCommon::gEvalMode} {
	return "xxx"
    }

    variable gNovasProcName 
    variable gNovasAPIString

    if {$direct} {
        #puts stderr "Sending to Novas: $gNovasProcName -> $cmd"
	catch {send $gNovasProcName $cmd} value
        #puts stderr "return val: $value"
    } else {

	set gNovasAPIString "$gNovasAPIString$cmd; "
	set value "buffered"

    }

    return $value

}

proc send_buffer_to_novas {} {

    variable  gNovasProcName 
    variable gNovasAPIString

    catch {send $gNovasProcName $gNovasAPIString} value
    set gNovasAPIString ""

    return $value

}

proc check_communications {} {
    variable gNovasProcName
    set status true
    set cmd  wvGetCurrentWindow

    set msg "Unable to communicate with Novas"
    if { [catch {send $gNovasProcName $cmd} value] } {
        if { [regexp "insecure" $value] } {
            append msg \n "You must run \"xhost -\" to allow"
            append msg \n "communication between BDW and Novas" \n
        }
        append msg \n $value
        set status false
        bgerror $msg
    }

    # Check that /tmp can be used for file communications
    set testname "[Unique::create_temp_file_name].test"
    proc opentestfile { name } {
        set fd [open $name w]
        puts $fd [pid]
        close $fd
    }
    if { [catch {opentestfile $testname} val] } {
        append msg \n "BDW is unable to write test file"
        append msg \n "$testname."
        append msg \n "set BLUESPECTMP to a writable directory."
        append msg \n \n $val
        bgerror $msg
        return 0
    }

    set cmd "file exists $testname"
    if { [catch {send $gNovasProcName $cmd} value] || $value == 0 } {
            append msg \n "Novas is unable to read the test file"
            append msg \n "$testname."
            append msg \n "set BLUESPECTMP to a shared directory."
            bgerror $msg
            return 0
        }
        return 1
}




################################################################################
###
################################################################################

proc send_buffered_rc_cmd {} {

    variable ::NovasSupportSendSignal::gNovasRCFileStream
    variable ::NovasSupportSendSignal::gNovasDeleteList 
    variable ::NovasSupportSendSignal::rc_file_name
    variable ::NovasSupportSendSignal::no_add

    set value [close $gNovasRCFileStream]

#    puts "START LOAD"
    set value [send_to_novas 1 "wvRestoreSignal $rc_file_name"]
#    puts "LOAD COMPLETE"

    set rc_file_name [create_temp_file_name]
    set gNovasRCFileStream [open $rc_file_name w]

    if {$gNovasDeleteList != {}} {
#        puts "DELETING $gNovasDeleteList"
	set value [send_to_novas 1 "wvDeleteSignal $gNovasDeleteList"]
    }
    set gNovasDeleteList [list]
    set no_add 1

    return $value

}

################################################################################
###
################################################################################

proc create_novas_signal {signal} {

    set sig $signal

    regsub {[ \t]+$} $sig {} sig

    set sig \{$sig\}
    
    return $sig

}


proc create_tag_signal {signal_name signal_select num explicitFileStream} {

    set base_name [new_name]
    set cmd "addExprSig -b 1 $base_name (\"$signal_select\" == $num) ? \"$signal_name\" : 'bx\n"
    send_rc_cmd $cmd $explicitFileStream

    return $base_name

}

proc novas_cmd_monitor {chan file_name} {

    variable gZow
    variable ::NovasSupportSendSignal::no_add

    set line_count 0
    while { [gets $chan line] >= 0 } {

	if {[regexp wvExpandBus $line]} {

#	    bell

	    regsub wvExpandBus $line "" arguments
	    set children [send_to_novas 1 "wvGetSelectedSignals"]

	    regsub -all  " \/" $children "\} \{\/" children_inner
	    set children  \{$children_inner\}
#	    puts "CHILDREN $children"
#	    puts "ARGS $arguments"

	    if {[llength $children] == 1} {
		set key [create_signal_key $children_inner]
		set pair [array get gZow $key]

		if {$pair != ""} {
		    set values [lindex $pair 1]
		    set type_name [lindex $values 0]
		    set name      [lindex $values 1]
		    set suffix    [lindex $values 2]
		    set lsb       [lindex $values 3]
		    set depth     [lindex $values 4]

		    set no_add 1
  		    set signal_name \
  			[send_one_level_typed_signal_to_novas \
  			     $type_name $name $suffix $lsb $depth]
		    send_buffered_rc_cmd

		    set value [send_to_novas 0 "wvSelectSignal $arguments"]
		    set value [send_to_novas 0 "wvCollapseBus"]
		    set value [send_to_novas 0 "wvSelectSignal \{$signal_name\}"]
		    set value [send_to_novas 0 "wvSetPosition  $arguments"]
		    set value [send_to_novas 0 "wvMoveSelected"]
		    set value [send_to_novas 0 "wvSelectSignal $arguments"]
		    set value [send_to_novas 0 "wvCut"]
		    set value [send_to_novas 0 "wvSelectSignal $arguments"]
		    set value [send_to_novas 0 "wvExpandBus"]

		    send_buffer_to_novas

		}
	    }
	}

        incr line_count
	if {$line_count > 500} {
	    set line_count 0
	    update idletasks
	}
    }
}

################################################################################
###
################################################################################
# TODO clean vcd file

# start $command
# interface to Waves::
proc start_viewer { command options timeout } {
    variable gNovasProcName
    package require Tk
    set tkname [join [list [guess_command $command] [pid]] "_"]
    set gNovasProcName $tkname 

    set logfile [guess_log_file $command]
    catch "exec rm -f $logfile"

    ## Set some environment variables
    set cmd "setenv NO_MDA_RANGE 1;"
    lappend cmd "setenv NOVAS_ETC_DIR $::env(BDWDIR)/tcllib/novas/etc;"

    lappend cmd $command
    lappend cmd "-tkName $tkname"

    if { $options != "" } {
        lappend cmd $options
    }

    if { [catch "exec csh -c \"[join $cmd " "]\" &" err] } {
        set msgs [list "Could not start waveform viewer." \
                      "Please check your options and path." \
                      "Command: [join $cmd { }]" \
                      "additional message: $err"] 
        error [join $msgs "\n"]
    } else {
        
    }
    
    wait_for_running_nWave $command  $tkname $logfile [join $cmd " "] $timeout
    initializeViewer
    raise_window 
    return $gNovasProcName
}

proc guess_command { command } {
    if { [regexp -nocase "verdi" $command] } {
        set cmd "verdi"
    } elseif { [regexp -nocase "debussy" $command] } {
        set cmd "debussy"
    } else {
        set cmd "nWave"
    }
    return $cmd
}

proc guess_log_file { command } {
    set cmd [guess_command $command]
    set log "${cmd}Log/turbo.log"
    return $log
}

proc check_running { } {
    variable gNovasProcName
    package require Tk
    if { $gNovasProcName == "" } {
        return false 
    } elseif { [lsearch [winfo interp] $gNovasProcName] < 0} {
        return false 
    } else {
        return true 
    }
    
}

# assumes that file exists
proc load_dump_file { filename } {
    check_open_nwave
    if { [file extension $filename] != ".fsdb" } {
        # not an fsdb file
        set fsdb [join [list [file rootname $filename] fsdb] "."]
        send_to_novas 1 "wvConvertFile -o $fsdb $filename"
    } else {
        set fsdb $filename 
    }

    reset_for_new_file
    if { $fsdb != 0 } {
	send_to_novas 1 {set status [catch {Blue::isLoaded} err]; if {[set status]} { lappend auto_path $env(NOVAS_ETC_DIR); package require Blue}}
        set fsdb [send_to_novas 1 "wvOpenFile $fsdb" ]
        send_to_novas 1 "wvZoomAll"
    } 
    raise_window 
    return [expr {$fsdb != 0}]

}

proc reload_dump_file { filename } {
    check_open_nwave
    if { [file extension $filename] != ".fsdb" } {
        # not an fsdb file
        set fsdb [join [list [file rootname $filename] fsdb] "."]
        send_to_novas 1 "wvConvertFile -o $fsdb $filename"
    }

    reset_for_new_file
    send_to_novas 1 {Blue::waveReloadFile}
    raise_window 
}

# returns nothing or throws an error if the nWave is not running
proc  wait_for_running_nWave { command tkname logfile fullcmd timeout } {
    # timeout in seconds to 250 ms wait times
    set ctimeout [expr $timeout * 4]
    set f1 ""
    set f2 ""

    # Look for log file
    for {set i 0} {$i < $ctimeout} {incr i} {
        set appList [winfo interp]
        if {[lsearch $appList $tkname] >= 0}  {
            set f1 $appList
            break
        }
        update 
        after 250
        if { [file exists $logfile] } {
            set f1 "logfile exists"
            break
        }
    }

    # Now wait for tk socket to open
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

# Waves interface
proc attach_viewer { pid } {
    variable gNovasProcName
    package require Tk

    if { $pid == "" && $gNovasProcName != "" } {
        puts stderr "detaching from $gNovasProcName"
        set gNovasProcName ""
        return true
    } elseif { $pid == "" } {
        puts stderr "Nothing to detach from"
        return true
    } elseif { [lsearch [winfo interp] $pid] >= 0 } {
        set gNovasProcName $pid
	initializeViewer
        puts stderr "attaching to $gNovasProcName"
        raise_window
        return true
    } else {
        puts stderr "Could not attach to application $pid"
        return false
    }
}

# list of candidate viewer to attach
# Waves interface
proc list_potential_viewers { } {
    set viewers [list nWave debussy verdi]
    package require Tk
    set vreg [join $viewers "|"]

    set ret [list]
    foreach i [winfo interp] {
        if { [regexp -nocase $vreg $i] == 1 } {
            lappend ret $i
        }
    }
    return $ret
}

proc reset_for_new_file {} {
    variable ::NovasSupportSendSignal::gNovasSignals 
    array unset gNovasSignals
}

# Check that an nWave window is open (for debussy)
# and open it if it isn't
proc check_open_nwave {} {
    set wins [send_to_novas 1 wvGetAllWindows]
    if { [llength $wins] == 0 } {
        send_to_novas 1 wvCreateWindow
    }
}

# Waves interface
proc close_viewer {} {
    variable gNovasProcName 
    send_to_novas 1 "wvExit"    
    set gNovasProcName ""
}

proc raise_window {} {
    set win [send_to_novas 1 "wvGetCurrentWindow"]
    send_to_novas 1 "wvRaiseWindow  -win $win"
}

proc notSupported { } {
    set level [info level]
    puts stderr "[info level [expr $level - 1]] : Not supported"
}

proc isDumpFileLoaded {} {
    set ret [send_to_novas 1 wvGetActiveFile]
    if { $ret == "" } { 
        return false 
    } 
    return true 
}

proc guessVersion {} {
    variable gNovasProcName 
    set value [catch {send $gNovasProcName "wvRestoreMarker"} msg]

    if {$value} {
	return "2008"
    }

    return "2010"
}

proc initializeViewer {} {

    variable ::NovasSupportSendSignal::gDoDeletes
    variable ::NovasSupportSendSignal::signal_prev

    set ::NovasSupportSendSignal::signal_prev ""

    set version [guessVersion]
    if {$version == 2008} {
	set ::NovasSupportSendSignal::gDoDeletes true
    } else {
	set ::NovasSupportSendSignal::gDoDeletes false
    }
}

}

package provide NovasSupport 1.0 

