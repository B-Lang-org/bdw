####################

proc which_bdw {} {
    global env

    if { [info exists BDW] && [file exists $BDW] } then {
        set bdw [absolute_filename $BDW]
    } elseif { [info exists env(BDW)] && [file exists $env(BDW)] } then {
        set bdw [absolute_filename $env(BDW)]
    } else {
        set bdw [which bdw]
    }
    if {$bdw == 0} then {
        perror "can't find bdw -- set BDW to /path/filename"
        exit 1
    }
    return $bdw
}

if { ! [info exists bdw] } then {
    set bdw [which_bdw]
}

####################

# worker bee
proc make_bdw_output_name { source } {
    set src [file tail $source]
    set filename "$src.bdw-out"
    return $filename
}

# worker bee
proc run_bdw {source} {
    global bdw
    global srcdir
    global subdir

    set here [absolute $srcdir]
    set bdw_path [file join $here $bdw]
    cd [file join $here $subdir]
    set output [make_bdw_output_name $source]
    set output2 ${output}.stderr-out
    verbose "Executing: $bdw $source $output >& output2" 4
    set status [exec_with_log "run_bdw" "$bdw $source $output >& $output2" 2]
    cd $here
    return [expr $status == 0]
}

# Do a bdw run, and report status
# E.g.   workstation test...
proc bdw_pass { source } {
    global xfail_flag

    set current_xfail $xfail_flag

    incr_stat "bdw_pass"

    if [run_bdw $source] then {
	pass "`$source' executes"
        return 1
    } else {
	fail "`$source' should execute"
    }
    return 0
}

# DO run and compare output
proc bdw_run_compare_pass { source {expected ""} {sedfilter ""} } {

    global env

    if { [info exists env(DISPLAY)] && $env(DISPLAY) != "" } {

        set stat [bdw_pass $source]

        if { $stat == 1 } {
            set output [make_bdw_output_name $source]

            set f1 "$sedfilter -e /^RESULT:/d"
            bdw_compare $output $expected $f1 NORESULT

            set f2 "$sedfilter -e /^WARNING:/d"
            bdw_compare $output $expected $f2 NOWARNING
        }
    }
}

# Compare tcl output after applying some sed filters
proc bdw_compare { output {expected ""} {sed {}} {suffix {"F"}} } {

    set filter "-e /^Welcome/d -e /^Version/d -e /^EDITOR_NAME/d -e /^SIMULATOR/d -e /^SIM_NAME/d"

    if {[string compare $expected ""] == 0} {
	set expected "$output.expected"
    }

    # Remove the bdw version header
    set ofiltered "$output.$suffix.filtered"
    sed $output $ofiltered "$filter $sed "

    set efiltered "$expected.$suffix.filtered"
    sed $expected $efiltered "$filter $sed "

    compare_file $ofiltered $efiltered "bdw_compare"

    #catch "exec rm -f $efiltered $ofiltered"
}

proc is_tcldot_available {} {
    global TCLDOT_AVAIL

    if { [info exists TCLDOT_AVAIL] } {

    } else {
        set width ""
        if { [info exists tcl_platform(wordSize)] && [$tcl_platform(wordSize) == 8] } {
                set width 64
        }

	# XXX This doesn't check that Tcldot can be loaded into bluetcl!
	# XXX It checks if tclsh with the following auto_path can load it.
	# XXX But bluetcl may be a different version, the auto_path may be
	# XXX created differently in the tcl application (see workstation.tcl
	# XXX and open_graph.tcl), and the user might have a .bluetclrc file
	# XXX that adds additional paths.
	#
        interp create interTCLDOT
	if { [which_os] == "Darwin" } {
	    interp eval interTCLDOT  lappend auto_path /usr/local/lib/graphviz
	} else {
	    interp eval interTCLDOT  lappend auto_path /usr/lib$width/tcltk/graphviz/tcl
	    interp eval interTCLDOT  lappend auto_path /usr/lib$width/tcltk/graphviz
	}
        set z [interp eval interTCLDOT catch {"package require Tcldot 2.21"} err]
        set err [interp eval interTCLDOT set x \$err]
        set TCLDOT_AVAIL [expr ! $z]
        if {$z} {
           note "TclDot is NOT available  -- $err"
        } else {
           note "TclDot is available"

        }
    }
    return $TCLDOT_AVAIL
}

####################
