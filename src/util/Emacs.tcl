
namespace eval ::Emacs {

    package require Unique
    package require MathSupport
    package require EvalChannel

    namespace export \
	isRunning \
	jumpToPosition \
	quit \
	start

################################################################################
###
################################################################################

variable emacsVersion    0
variable emacsClientExec emacsclient
variable emacsPid        -1

################################################################################
### Exported procedures
################################################################################

proc start {window_name {iconic ""}} {

    global env
    global PROJECT
    variable emacsVersion
    variable emacsPid

    # set the exec during each start
    set emacsExec       [lindex $PROJECT(EDITOR_EMACS) 0]
    set emacsArgs        [utils::tail $PROJECT(EDITOR_EMACS)]
    set init_file $env(BDWDIR)/tcllib/emacs/emacs_init.el
    set uid [Unique::uid]
    if {![file exists $init_file]} {
	puts "INIT is $init_file"

    } else {

	set version_string [getEmacsVersionString $emacsExec]
	set emacsVersion [getEmacsVersion $version_string]
	set window_name "$window_name ($version_string)"

	if {$iconic == ""} {

	    set emacsPid [eval exec $emacsExec -l $init_file -title \"$window_name\" $emacsArgs &]

	} else {

	    set emacsPid [eval exec $emacsExec -l $init_file -title \"$window_name\" $emacsArgs &]
	}

	set server_file [format "/tmp/emacs%d/server-%d" $uid $emacsPid]

	set count 0

	while {![file exists $server_file] && ($count < 300)} {
	    after 50
	    set count [expr $count + 1]
	}

	emacsStartEvalChannel
	return $emacsPid

    }
}

proc quit {} {
    sendToEmacs "(progn (raise-frame) (save-buffers-kill-emacs))"
}

proc isRunning {} {

    variable emacsPid

    if {($emacsPid > 0) && [Unique::process_exists $emacsPid]} {
	return 1
    }
    return 0

}

proc jumpToPosition {position} {

    set save_cmd [Emacs::createSaveStateCmd $position]
    set jump_cmd [Emacs::createJumpToPositionCmd $position]
    sendToEmacs "(progn $save_cmd (raise-frame) $jump_cmd)"
    sendToEmacs "(ws-init)"
}


################################################################################
### Private procedures
################################################################################

proc emacsStartEvalChannel {} {

    set name [Unique::create_temp_file_name]
    EvalChannel::openEvalChannel $name
    sendToEmacs "(setq *ws-tcl-channel* \"$name\")"

}

proc sendToEmacs {eval_string} {

    variable emacsPid
    sendToEmacsWithPid $emacsPid $eval_string

}

proc sendToEmacsWithPid {emacs_pid eval_string} {

    variable emacsClientExec
    variable emacsVersion
    set nowait "-n"
    if {$emacsVersion == 22} {
	set nowait ""
    }
    set socket [format "/tmp/emacs%d/server-%d" [Unique::uid] $emacs_pid]
    if {$emacsVersion == 24} {
	exec "$emacsClientExec-24" -s $socket $nowait -e "$eval_string"
    } else {
	exec  $emacsClientExec     -s $socket $nowait -e "$eval_string"
    }
}

proc createJumpToPositionCmd {position} {

    set filename   [lindex $position 0]
    set code       [lindex $filename 0]
    set line       [lindex $position 1]
    set column     [MathSupport::max [expr [lindex $position 2] - 1] 0]
    set text_begin [toLispBool 0]

    if {$code == 0} {
	set cmd $filename
    } else {
	set cmd "(ws-goto-position-and-grab-mouse \"$filename\" $line $column $text_begin)"
    }
    return $cmd
}

proc createSaveStateCmd {position} {

    set filename   [lindex $position 0]
    set code       [lindex $filename 0]
    set line       [lindex $position 1]
    set column     [MathSupport::max [expr [lindex $position 2] - 1] 0]
    set text_begin [toLispBool 0]

    if {$code == 0} {
	set cmd $filename
    } else {
	set cmd "(ws-save-state \"$filename\" $line $column $text_begin)"
    }
    return $cmd
}

proc toLispBool {value} {
    if {$value == 0} {
	return "nil"
    }
    return "t"
}

proc getEmacsVersionString { emacsExec } {
    
    set value [exec $emacsExec -version]
    regsub "\n.*" $value "" value
    return $value

}

proc getEmacsVersion {version_string} {

    set value $version_string
    regsub "\\..*" $value "" value
    regsub "GNU Emacs " $value "" value
    return $value

}

################################################################################
###
################################################################################

}

package provide Emacs 1.0
