# A communications channel to a tcl interp using named pipes

namespace eval EvalPipe {

    variable fifoName
    variable fifoNameOut
    variable fifoInHandle
    variable fifoOutHandle

    proc start {pid} {
        variable fifoName
        variable fifoNameOut
        variable fifoInHandle
        variable fifoOutHandle

        set fifoName /tmp/gtkwavefifoIn_$pid
        set fifoNameOut /tmp/gtkwavefifoOut_$pid

        file delete -force $fifoName
        if {[catch "exec mkfifo -m 700 $fifoName" err] } {
            puts stderr $err
            exit 1
        }
        if { [catch "open $fifoName {RDONLY NONBLOCK}"  fifoInHandle] } {
            puts stderr "Error: $fileHandle"
            exit 1
        }
        fconfigure $fifoInHandle -blocking 0 -buffering line


        ## Channel back to Client (BDW)
        file delete -force $fifoNameOut
        if {[catch "exec mkfifo -m 700 $fifoNameOut" err] } {
            puts stderr $err
            exit 1
        }

        if {[catch "open $fifoNameOut {NONBLOCK RDWR}" fifoOutHandle] } {
            puts stderr $fifoOutHandle
            exit 1
        }
        fconfigure $fifoOutHandle -blocking 0 -buffering line


        # attach a fileevent when infifo becomes readable
        fileevent $fifoInHandle readable [namespace code readeval]
    }


    proc readeval {} {
        variable fifoName
        variable fifoNameOut
        variable fifoInHandle
        variable fifoOutHandle

        puts "read event"
        while {[gets $fifoInHandle line] > 0 } {
            puts "Got: $line"
            if { [catch $line err] } {
                puts "Caught error $err"
                puts $fifoOutHandle [list 1 $err]
            } else {
                puts "returing: 0 $err"
                puts $fifoOutHandle [list 0 $err]
            }
        }
        if { [eof $fifoInHandle] } {
            puts "Closing $fifoName"
            close $fifoInHandle
            close $fifoOutHandle
            catch "file delete -force $fifoName"
            catch "file delete -force $fifoNameOut"
        }
    }
}


EvalPipe::start [pid]

