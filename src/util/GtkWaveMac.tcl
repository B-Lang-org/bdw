# MAC extension to the GtkWaveSupport package.
# This package  overwrite some commands from the original package
package require GtkWaveSupport

# Known limitations
# Attach does not work
# fifo files may not be removed properly
# GTKWave server exits on close

namespace eval GtkWaveSupport {
    variable fifoInName "/tmp/gtkwavefifoIn"
    variable fifoInHandle ""
    variable fifoOutName "/tmp/gtkwavefifoOut"
    variable fifoOutHandle ""

    proc send_to_gtkwave {cmd var} {
        variable fifoInHandle
        variable fifoOutHandle

        #puts "Sending: $cmd"
        puts $fifoInHandle $cmd
        if {[gets $fifoOutHandle line]} {
            set val [lassign $line stat]
        } else {
            set val ""
            set stat 1
        }
        uplevel 1 [list set $var $val]
        return $stat
    }

    proc check_communications {} {
        variable fifoInHandle
        variable fifoOutHandle

        if {  $fifoInHandle == "" } { return 0 }
        if {  $fifoOutHandle == "" } { return 0 }
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

        append options " -T [file join $::env(BDWDIR) tcllib util gtkwave_eval.tcl]"

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
        if { [catch "exec [join $cmd { }] < /dev/null  >& $logdir/$logfile &" err] } {
            set msgs [list "Could not start waveform viewer." \
        		  "Please check your options and path." \
        		  "Command: [join $cmd { }] >& $logdir/$logfile." \
        		  "additional message: $err"]
            error [join $msgs "\n"]
        } else {
            set gGtkWaveExec [file tail $command]
            setup_fifos $err $timeout
        }
        return "GTKWave_MAC"

    }

    # We need to wait for the fifos to open
    proc setup_fifos {pid timeout} {
        variable gGtkWavePid
        variable fifoInHandle
        variable fifoOutHandle
        variable fifoInName
        variable fifoOutName
        set gGtkWavePid $pid

        set fIName ${fifoInName}_${gGtkWavePid}
        set fOName ${fifoOutName}_${gGtkWavePid}
        for {set i 0} { $i < $timeout } { incr i } {
            if { [expr [file exists $fOName] && [file exists $fIName]] } {


                set fifoInHandle  [open $fIName {RDWR NONBLOCK}]
                fconfigure $fifoInHandle -blocking 0 -buffering line

                set fifoOutHandle [open $fOName {RDONLY NONBLOCK}]
                fconfigure $fifoOutHandle -blocking 0 -buffering line

                return $pid
            }
            after 1000
        }
        set msg [list "Could not start waveform viewer." \
                     "Please check your options and path." \
                     "Please start communicaton script" ]

        set gGtkWavePid 0
        error [join $msg "\n"]
    }


    proc attach_viewer { app } {
        if { [regexp {.*_([0-9]+)$} $app x pid] } {
            setup_fifos $pid 10
        }
        return 0
    }

    proc list_potential_viewers {} {
        return [list]
        set fifos [glob -nocomplain /tmp/gtkwavefifoIn*]
        set ret [list]
        foreach f $fifos {
            if { [regexp {.*_([0-9]+)$} $f x id] } {
                lappend ret gtkmac_$id
            }
        }
        return $ret
    }
    proc check_running {} {
        return [check_communications]
    }

    proc close_viewer {} {
        variable gGtkWavePid
        variable fifoInHandle
        variable fifoOutHandle
        variable fifoInName
        variable fifoOutName

	send_to_gtkwave "exit" ignore

        close $fifoInHandle
        close $fifoOutHandle
        set fifoInHandle ""
        set fifoOutHandle ""
        

        set fIName ${fifoInName}_${gGtkWavePid}
        set fOName ${fifoOutName}_${gGtkWavePid}

        file delete -force $fIName
        file delete -force $fOName
        set gGtkWavePid ""
    }
}

package provide  GtkWaveMac 1.0
