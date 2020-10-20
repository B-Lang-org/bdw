
namespace eval ::Blue {

variable gAliasMap
array set gAliasMap []

variable do_debug
set do_debug 0

################################################################################
###
################################################################################

variable selectSignal
variable selectGroup
variable selectAll
variable selectPos

################################################################################
### Novas does not fully support composite signals.  These signals are
### however used extensively in Bluespec generated waveforms.
###
### When saving .rc files using the default Novas behavior,
### information is lost about composite waveforms. They thus cannot be
### reloaded succesfully.
###
### This code collects needed signal info when loading a .rc file. The
### info is saved and then later added to the output when new .rc
### files are created.
################################################################################

proc analyzeRC {num file_name} {

    variable gAliasMap
    variable do_debug

    set status [catch {set fp [open $file_name r]} err]

    if {$status} {
	puts $err
	return 1
    }

    set scope ""

    set children_current [list]
    set alias_current 0

    while { [gets $fp line] >= 0 } {

	## ALIAS comment inserted in Bluespec-created .rc files
	if {[regexp "^\\s*;\\s*ALIAS\\s*(\\S*)" $line matched alias]} {
 	    set alias_current $alias
	    addRCInfo $num $line
	    continue
	}

	## Blank line
	if {[regexp "^\\s*;.*" $line]} {
	    continue
	}

	## addSignal using a full path.  Update the value of the "current" scope
	if {[regexp "^\\s*addSignal.*\\s+/(.*/)(\[^/\]+)$" $line matched path name]} {
	    set scope "/$path"
	    continue
	}

	## addSignal without a full path.
	if {[regexp "^\\s*addSignal\\s+\-holdScope\\s+(.*)\\s*$" $line matched name]} {
	    continue
	}

	if {[regexp "^\\s*addRenameSig" $line]} {
	    addRCInfo $num $line
	    continue
	}

	## Add bus member
	if {[regexp "^\\s*userBusMem" $line]} {
	    addRCInfo $num $line
	    continue
	}

	## Create bus signal
	if {[regexp "^\\s*saveRunSig " $line]} {
	    addRCInfo $num "$line\n"
	}

	## Add Composite member. Keep track of associated alias (if any)
	if {[regexp "^\\s*userCompositeMem" $line]} {
	    lappend children_current $alias_current
	    set alias_current 0
	    addRCInfo $num $line
	    continue
	}

	## Create composite signal.  Save alias info for members
	if {[regsub "^\\s*saveRunCompositeSig " $line "" name]} {
	    set local_name [string trim $name {\"}]
	    set composite_name "$scope$local_name"
	    set key [create_signal_key $composite_name]
	    array set gAliasMap [list $key $children_current]
	    set children_current [list]
	    addRCInfo $num "$line\n"
	    continue
	}
    }

    close $fp
    return 0;
}

################################################################################
### This code sniffs the nWave.cmd file and as certain commands occur,
### collects information and/or executes workaround code
################################################################################

proc start_monitor {} {

    variable do_debug

    set log_file "[sysGetLogDir]/nWave.cmd"

    if {[file exists $log_file]} {
	if {$do_debug} {puts $log_file}
	cmdlog_monitor $log_file
    }
}

proc cmdlog_monitor {file_name} {

    variable do_debug

    set line_count 0

    set status [catch {set fp [open $file_name r]} err]

    if {$status} {
	puts $err
	return 1
    }

    Blue::cmdlog_handle $fp

    return 0
}

proc cmdlog_handle {fp} {

    variable selectSignal
    variable selectGroup
    variable selectPos
    variable gAliasMap
    variable do_debug

    set line_count 0
    set prefix ""

    while { [gets $fp line] >= 0 } {

	## If a command is on multiple lines, paste it all together first
	if {[string range $line end end] == "\\"} {
	    set prefix "$prefix[string range $line 0 end-1]"
	    continue
	}

	set line "$prefix$line"
	set prefix ""

	## Keep track of selected signals
	if {[regexp "wvSelectSignal.*\\((.*)\\).*" $line matched pair]} {
	    if {$do_debug} {puts "SELECT! $pair"}
	    set selectGroup [lindex $pair 0]
	    set selectPos   [lindex $pair 1]
	    set selectSignal [wvGetSelectedPureSignals]
	}

	if {[regexp "^\\s*wvRestoreSignal\\s+-win\\s+(\\S+)\\s+.*\"(.*)\".*" $line matched win_name rc_file]} {
	    set num [namespace eval :: set ignore $win_name]
	    analyzeRC $num $rc_file
	    if {[is_temp_file $rc_file]} {
		file delete $rc_file
	    }
        }

	if {[regexp wvExpandBus $line]} {
	    if {$do_debug} {puts "Expand! $selectSignal"}
	    if {$do_debug} {puts "Expand! $selectGroup $selectPos"}
	    set key [create_signal_key $selectSignal]
	    set alias_info [array get gAliasMap $key]
	    if {$alias_info != {}} {
		set pos [expr $selectPos + 1]

		set alias_list [lindex $alias_info 1]
		foreach alias $alias_list {
		    if {$alias != 0} {
			wvSetAliasTable -global -signal "\($selectGroup $pos\)" -table $alias
		    }
		    incr pos
		}
	    }
	}

	if {[regexp "wvResizeWindow\\s+-win\\s+(\\S+)\\s+" $line matched win_name]} {
	    set num [namespace eval :: set ignore $win_name]
	    windowInit $num
	}

	if {[regexp "wvClearAll\\s+-win\\s+(\\S+)\\s*" $line matched win_name]} {
	    set num [namespace eval :: set ignore $win_name]
	    resetRCInfo $num
	    
	}

	## An .rc file has been saved, need to "process" it so it includes all required composite info
	if {[regexp "^\\s*wvSaveSignal\\s+-win\\s+(\\S+)\\s+.*\"(.*)\".*" $line matched win_name rc_file]} {
	    set num [namespace eval :: set ignore $win_name]
	    processRC $num $rc_file
	}

	incr line_count
	if {$line_count > 500} {
	    set line_count 0
	    update 
	}
    }

    after 100 Blue::cmdlog_handle $fp
}

################################################################################
###
################################################################################

proc guessVersion {} {
    set value [catch {wvRestoreMarker} msg]

    if {$value} {
	return "2008"
    }
    return "2010"
}

proc rcHasHidden {} {
    set value [catch {wvRestoreMarker} msg]

    if {$value} {
	return 0
    }
    return 1
}

################################################################################
###
################################################################################

if {[rcHasHidden]} {

    proc waveReloadFile {} {
	
	set file_name [wvGetActiveFileName]
	set num [wvGetCurrentWindow]
	if {$file_name != ""} {
	    
	    if {[getRCInfo $num] == ""} {
		
		wvReloadFile
		
	    } else {
		
		set tmp_file [temp_file_name "reload"]
		wvSaveSignal -win $num $tmp_file
		wvClearAll -win $num
		
		wvCloseFile $file_name
		wvOpenFile -win $num $file_name

		after 50 [list wvRestoreSignal -win $num $tmp_file]

	    }
	}
    }

} else {

    proc waveReloadFile {} {

	wvReloadFile
    }

}
    
################################################################################
### Code that modifies a created .rc file to included add info
### required to successfully recreate composite waveforms.
################################################################################

proc processRC {num file_name} {

    if {[getRCInfo $num] == ""} {
	return 0
    }

    set tmp_file [temp_file_name "rc"]

    set status [catch {set in_fp  [open $file_name r]} err]

    if {$status} {
	puts $err
	return 1
    }

    set status [catch {set out_fp [open $tmp_file w]} err]

    if {$status} {
	puts $err
	return 1
    }

    puts $out_fp "\n;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n;;; Start of Bluespec-Specific RC Information  [clock format [clock seconds]]\n;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n"

    puts $out_fp [getRCInfo $num]

    puts $out_fp "\n;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n;;; End of Bluespec-Specific RC Information\n;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n"

    set blank  false
    set repeat false
    set scope ""

    set one_sig ""
    set first true

    while { [gets $in_fp line] >= 0 } {
	
	if {[regexp "^.*Start of Bluespec-Specific RC Information" $line]} {
	    set repeat true
	    break
	}

	if {[regexp "^\\s*$" $line]} {
	    set blank true
	    continue
	}

	if {[regexp "^\\s*addRenameSig\\s+.*\"(.*)\".*" $line matched orig]} {
	    set one_sig $orig
	    continue
	}

	if {[regexp "^\\s*addRenameSig" $line]}            { continue }
	if {[regexp "^\\s*;\\s*addRenameSig" $line]}       { continue }
	if {[regexp "^\\s*;\\s*rename signal list" $line]} { continue }

	if {[regexp "^\\s*userBusMem" $line]}              { continue }
	if {[regexp "^\\s*;\\s*userBusMem" $line]}         { continue }
	if {[regexp "^\\s*saveRunSig" $line]}              { continue }
	if {[regexp "^\\s*;\\s*saveRunSig" $line]}         { continue }


	if {$blank} {
	    puts $out_fp "\n"
	    set blank false
	}

	if {[regexp "^\\s*addSignal.*\\s+/(.*/)(\[^/\]+)$" $line matched path name]} {
	    set scope "/$path"
	    puts $out_fp $line
	    continue

	}

	if {[regexp "^\\s*addSignal.*$" $line matched]} {
	    set mod ""
	    regsub  -all {\-holdScope }  $line $scope mod
	    puts $out_fp $mod
	    continue
	}

	puts $out_fp $line

    }

    close $in_fp
    close $out_fp

    ## Don't process a file twice
    if {!$repeat} {

	set status [catch {exec mv $tmp_file $file_name} err]

	if {$status} {
	    puts $err
	    return 1
	}
    }

    return 0
}

proc temp_file_name {prefix} {

    return "[sysGetLogDir]/\.$prefix\_tmp_[pid]"

}

proc is_temp_file {name} {

    if {[regexp "^\\s*[sysGetLogDir]/\..*_tmp_[pid]$" $name]} {
	return true
    }

    return false
}

################################################################################
###
################################################################################

proc addRCInfo {num line} {

    set set_name "rcSet_$num"
    variable $set_name
    set info_name "rcInfo_$num"
    variable $info_name

    set hit {}

    if {[regexp addRenameSig $line]} {
	
 	set key [create_signal_key $line]
 	set hit [array get $set_name $key]
	
 	if {$hit == {}} {
 	    array set $set_name [list $key 1]
 	    set $info_name "[set $info_name]$line\n"
 	}
    } else {
	set $info_name "[set $info_name]$line\n"
    }
}

proc resetRCInfo {num} {

    set set_name "rcSet_$num"
    variable $set_name
    array unset $set_name
    array set $set_name []

    set info_name "rcInfo_$num"
    variable $info_name
    set $info_name ""

}

proc getRCInfo {num} {

    set info_name "rcInfo_$num"
    variable $info_name

    return [set $info_name]

}

proc windowInit {num} {

    set set_name "rcSet_$num"
    variable $set_name

    if {![info exists $set_name]} {

	wvSaveSignalRC -win $num -aliastable -createbus -renamedsig
	resetRCInfo $num

    }
}

################################################################################
### Some utility functions
################################################################################

proc isLoaded {} {
    return 1;
}

proc create_signal_key {signal_name} {


    regsub  -all { }  $signal_name "_" key
    regsub  -all {\"} $key         "_" key
    regsub  -all {\[} $key         "|" key
    regsub  -all {\]} $key         "|" key

    return $key
}

proc is_composite {name} {
    return [regexp "\[+\]" $name]
}

################################################################################
###
################################################################################

}

if {[Blue::rcHasHidden]} {
    ## Start the nWave.cmd sniffer
    Blue::start_monitor
    puts "\nNovas loading Bluespec-specific support code from: [info script]"
} else {
    puts "\nNovas loading Bluespec-specific support code from: [info script]"
    puts "Features are not being used since this is a pre-2010 version of nWave"
}


package provide Blue 1.0
