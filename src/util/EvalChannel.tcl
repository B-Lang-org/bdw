
namespace eval ::EvalChannel {

    namespace export \
        openEvalChannel \
        channel_handler

proc openEvalChannel {file_name} {

    catch "exec rm -f $file_name" err

    set chan [open_fifo $file_name]

    fileevent $chan readable [list ::EvalChannel::channel_handler $chan $file_name]

}

################################################################################
### Private
################################################################################

proc open_fifo {file_name} {

    if {[catch "exec mkfifo $file_name" err] } {
        puts stderr $err
        set chan [open /dev/null {RDONLY NONBLOCK}]
    } else {
        set chan [open $file_name {RDONLY NONBLOCK}]
        fconfigure $chan -blocking 0 -buffering line
    }

    return $chan
}

proc channel_handler {chan file_name} {

    set line_count 0
    while { [gets $chan line] >= 0 } {
	set code [catch {uplevel 1 $line} err]
	if {$code > 0 } {
	    puts stderr $err
	}
        incr line_count
	if {$line_count > 500} {
	    set line_count 0
	    update idletasks
	}
    }

    close $chan
    ::EvalChannel::openEvalChannel $file_name

}

}

package provide EvalChannel 1.0


