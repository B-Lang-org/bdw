
################################################################################
###
################################################################################

package require Unique
package require MathSupport

namespace eval Trace {

    namespace export \
        traceNew \
	traceSetFlags \
	traceAddFlags \
	traceRemoveFlags \
	traceCreateGroupEnd \
	signalCreate

    variable TR_HIGHLIGHT_B
    variable TR_HEX_B
    variable TR_DEC_B
    variable TR_BIN_B
    variable TR_OCT_B
    variable TR_RJUSTIFY_B
    variable TR_INVERT_B
    variable TR_REVERSE_B
    variable TR_EXCLUDE_B
    variable TR_BLANK_B
    variable TR_SIGNED_B
    variable TR_ASCII_B
    variable TR_COLLAPSED_B
    variable TR_FTRANSLATED_B
    variable TR_PTRANSLATED_B
    variable TR_ANALOG_STEP_B
    variable TR_ANALOG_INTERPOLATED_B
    variable TR_ANALOG_BLANK_STRETCH_B
    variable TR_REAL_B
    variable TR_ANALOG_FULLSCALE_B
    variable TR_ZEROFILL_B
    variable TR_ONEFILL_B
    variable TR_CLOSED_B
    variable TR_GRP_BEGIN_B
    variable TR_GRP_END_B

    variable TR_HIGHLIGHT
    variable TR_HEX
    variable TR_DEC
    variable TR_BIN
    variable TR_OCT
    variable TR_RJUSTIFY
    variable TR_INVERT
    variable TR_REVERSE
    variable TR_EXCLUDE
    variable TR_BLANK
    variable TR_SIGNED
    variable TR_ASCII
    variable TR_COLLAPSED
    variable TR_FTRANSLATED
    variable TR_PTRANSLATED
    variable TR_ANALOG_STEP
    variable TR_ANALOG_INTERPOLATED
    variable TR_ANALOG_BLANK_STRETCH
    variable TR_REAL
    variable TR_ANALOG_FULLSCALE
    variable TR_ZEROFILL
    variable TR_ONEFILL
    variable TR_CLOSED
    variable TR_GRP_BEGIN
    variable TR_GRP_END

################################################################################
###
################################################################################

proc trace_initialize {} {

    variable TR_HIGHLIGHT_B
    variable TR_HEX_B
    variable TR_DEC_B
    variable TR_BIN_B
    variable TR_OCT_B
    variable TR_RJUSTIFY_B
    variable TR_INVERT_B
    variable TR_REVERSE_B
    variable TR_EXCLUDE_B
    variable TR_BLANK_B
    variable TR_SIGNED_B
    variable TR_ASCII_B
    variable TR_COLLAPSED_B
    variable TR_FTRANSLATED_B
    variable TR_PTRANSLATED_B
    variable TR_ANALOG_STEP_B
    variable TR_ANALOG_INTERPOLATED_B
    variable TR_ANALOG_BLANK_STRETCH_B
    variable TR_REAL_B
    variable TR_ANALOG_FULLSCALE_B
    variable TR_ZEROFILL_B
    variable TR_ONEFILL_B
    variable TR_CLOSED_B
    variable TR_GRP_BEGIN_B
    variable TR_GRP_END_B

    variable TR_HIGHLIGHT
    variable TR_HEX
    variable TR_DEC
    variable TR_BIN
    variable TR_OCT
    variable TR_RJUSTIFY
    variable TR_INVERT
    variable TR_REVERSE
    variable TR_EXCLUDE
    variable TR_BLANK
    variable TR_SIGNED
    variable TR_ASCII
    variable TR_COLLAPSED
    variable TR_FTRANSLATED
    variable TR_PTRANSLATED
    variable TR_ANALOG_STEP
    variable TR_ANALOG_INTERPOLATED
    variable TR_ANALOG_BLANK_STRETCH
    variable TR_REAL
    variable TR_ANALOG_FULLSCALE
    variable TR_ZEROFILL
    variable TR_ONEFILL
    variable TR_CLOSED
    variable TR_GRP_BEGIN
    variable TR_GRP_END

    set bit 0

    set TR_HIGHLIGHT_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_HEX_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_DEC_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_BIN_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_OCT_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_RJUSTIFY_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_INVERT_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_REVERSE_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_EXCLUDE_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_BLANK_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_SIGNED_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_ASCII_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_COLLAPSED_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_FTRANSLATED_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_PTRANSLATED_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_ANALOG_STEP_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_ANALOG_INTERPOLATED_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_ANALOG_BLANK_STRETCH_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_REAL_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_ANALOG_FULLSCALE_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_ZEROFILL_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_ONEFILL_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_CLOSED_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_GRP_BEGIN_B $bit
    set bit [MathSupport::plus $bit 1]
    set TR_GRP_END_B $bit

    set TR_HIGHLIGHT            [expr 1 << $TR_HIGHLIGHT_B]
    set TR_HEX                  [expr 1 << $TR_HEX_B]
    set TR_ASCII                [expr 1 << $TR_ASCII_B]
    set TR_DEC                  [expr 1 << $TR_DEC_B]
    set TR_BIN                  [expr 1 << $TR_BIN_B]
    set TR_OCT                  [expr 1 << $TR_OCT_B]
    set TR_RJUSTIFY             [expr 1 << $TR_RJUSTIFY_B]
    set TR_INVERT               [expr 1 << $TR_INVERT_B]
    set TR_REVERSE              [expr 1 << $TR_REVERSE_B]
    set TR_EXCLUDE              [expr 1 << $TR_EXCLUDE_B]
    set TR_BLANK                [expr 1 << $TR_BLANK_B]
    set TR_SIGNED               [expr 1 << $TR_SIGNED_B]
    set TR_ASCII                [expr 1 << $TR_ASCII_B]
    set TR_COLLAPSED            [expr 1 << $TR_COLLAPSED_B]
    set TR_FTRANSLATED          [expr 1 << $TR_FTRANSLATED_B]
    set TR_PTRANSLATED          [expr 1 << $TR_PTRANSLATED_B]
    set TR_ANALOG_STEP          [expr 1 << $TR_ANALOG_STEP_B]
    set TR_ANALOG_INTERPOLATED  [expr 1 << $TR_ANALOG_INTERPOLATED_B]
    set TR_ANALOG_BLANK_STRETCH [expr 1 << $TR_ANALOG_BLANK_STRETCH_B]
    set TR_REAL                 [expr 1 << $TR_REAL_B]
    set TR_ANALOG_FULLSCALE     [expr 1 << $TR_ANALOG_FULLSCALE_B]
    set TR_ZEROFILL             [expr 1 << $TR_ZEROFILL_B]
    set TR_ONEFILL              [expr 1 << $TR_ONEFILL_B]
    set TR_CLOSED               [expr 1 << $TR_CLOSED_B]
    set TR_GRP_BEGIN            [expr 1 << $TR_GRP_BEGIN_B]
    set TR_GRP_END              [expr 1 << $TR_GRP_END_B]


}

trace_initialize

################################################################################
###
################################################################################

proc traceNew {} {
    set new [Unique::new_name "trace"]
    upvar $new TRACE
    traceCreate TRACE
    return $new
}

proc traceCreate {name} {
    upvar $name TRACE

    array set TRACE [list]
    set TRACE(signal)      ""
    set TRACE(signal_size)  0
    set TRACE(flags)        0
    set TRACE(lsb)          0
    set TRACE(size)         0
    set TRACE(text)        ""

    return $name
}

proc traceSetFlags {name flags} {
    upvar $name TRACE
    
    set TRACE(flags) $flags

    return $name
}

proc traceAddFlags {name flags} {
    upvar $name TRACE

    set pair [array get TRACE flags]
    set new [expr [lindex $pair 1] | $flags]

    set TRACE(flags) $new

    return $name
}

proc traceRemoveFlags {name flags} {
    upvar $name TRACE

    set pair [array get TRACE flags]
    set new [expr [lindex $pair 1] & ~$flags]

    set TRACE(flags) $new

    return $name
}

proc traceCreateGroupEnd {} {

    set new [Unique::new_name "trace"]
    upvar $new TRACE
    traceCreate TRACE
    array set TRACE [list text group_end]
    traceAddFlags TRACE [expr $Trace::TR_BLANK | $Trace::TR_GRP_END | $Trace::TR_COLLAPSED | $Trace::TR_CLOSED]
    return $new
}

proc signalCreate {name size} {
    set new [Unique::new_name "signal"]
    traceCreate $new
    upvar $new SIG
    array set SIG [list]
    set SIG(name) $name
    set SIG(size) $size
    return $new
}

}
package provide Trace 1.0 

################################################################################
###
################################################################################

