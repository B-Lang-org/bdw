
##
# @file toolbar.tcl
#
# @brief Definition of class toolbar.
#

namespace eval base {

itcl::class toolbar {
        inherit iwidgets::Toolbar

        ##
        # @brief Adds a tool-bar button
        #
        # @param n Name of button
        # @param h Help string
        # @param i Associated image
        # @param b Balloon string
        # @param c Command to be executed
        # @param s state of the button active/disabled
        #
        method add_button {n h i b c {s "disabled"}} {
                global BSPEC
                add button $n -helpstr $h -image [image create photo \
                        -file [file join $BSPEC(IMAGEDIR) $i]] -height 25 \
                        -width 25 -balloonstr $b -command $c -state $s
        }

        method add_separator {x {width 8} {height 20} {relief sunken} {background #100842}} {
            add frame $x \
                -borderwidth 3 -width $width -height $height \
		-relief $relief -background $background
            $this.$x configure 
        }

        ##
        # @brief Changes the tool-bar button's state
        #
        # @param ind index of the button
        # @param st state
        #
        method change_state {ind st} {
                foreach i $ind {
                        itemconfigure $i -state $st
                }
        }

        constructor {} {
                eval itk_initialize [list -helpvariable statusVar \
                        -orient horizontal \
                        -state disabled]
        }

        destructor {
                destroy $this
        }
}
}
