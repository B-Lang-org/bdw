
##
# @file paned_window.tcl
#
# @brief Definition of the Panedwindow.
#

package require BDWIwidgets
namespace eval base {

itk::usual panedwindow {
    keep -background -cursor -sashcursor
}

##
# @brief Definition of class paned_window
# 
itcl::class panedwindow {
    #inherit ::iwidgets::Panedwindow
    # The local iwidigets renames Panedwindow
    inherit ::iwidgets::IPanedwindow

    constructor {args} {
            lappend args -sashindent 30 
            eval itk_initialize $args        
        }
}

}
