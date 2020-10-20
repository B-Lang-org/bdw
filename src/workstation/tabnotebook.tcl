
##
# @file tabnotebook.tcl
#
# @brief Definition of class tabnotebook.
#

namespace eval base {

##
# @brief Definition of class tabnotebook
#
itcl::class tabnotebook {
        inherit iwidgets::Tabnotebook

        ##
        # @brief Adds a label
        #
        # @param l label of the tab
        # @param c command to be executed when selecting the tab
        #
        method add_label {l {c ""}} {
                $this add -label $l -command $c
        }       

        constructor {args} {
            set stdargs [list -width 300 -height 200 -angle 10\
                             -bevelamount 2 -margin 2 -tabborders false -pady 2 -padx 2\
                             -borderwidth 0  -gap overlap \
                             -tabborders yes -raiseselect yes  ]
            eval itk_initialize $stdargs $args
        }

        destructor {
        }
}
}
