
##
# @file finddialog.tcl
#
# @brief Definition of finddialog window.
#

namespace eval base {

itk::usual finddialog {
            keep -background -cursor -foreground -selectcolor
}  

##
# @brief Definition of class finddialog
#
itcl::class finddialog {
        inherit iwidgets::Finddialog
        public {
                ##
                # @brief Searches errors
                #
                method find_error {}

                ##
                # @brief Searches warnings
                #
                method find_warning {}
        }
        constructor {args} {
                lappend args -textbackground white
                insert 1 Find_Error -text "Find Error" \
                        -command [itcl::code $this find_error]
                insert 2 Find_Warning -text "Find Warning" \
                        -command [itcl::code $this find_warning]
                eval itk_initialize $args
        }
        destructor {
        }
}

itcl::body base::finddialog::find_error {} {
        find "error"
}

itcl::body base::finddialog::find_warning {} {
        find "warning"
}
} 
# end of namespace
