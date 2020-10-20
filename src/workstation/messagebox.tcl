
##
# @file messagebox.tcl
#
# @brief Definition of messagebox window.
#

namespace eval base {

##
# @brief Definition of class messagebox
#
itcl::class messagebox {
        inherit iwidgets::Messagebox
        
        ##
        # @brief Search the contents of messages area for a specific string.
        #
        method find {}

        ##
        # @brief Adds message type 
        #
        # @param t Name of message type to be added
        # @param b Background color of message
        # @param f Foreground color of message
        #
        method add_type {t {b "white"} {f "black"} \
                             {font ""} } {
                if { $font == "" } { set font bscFixedFont }
                type add $t -background $b -foreground $f -font $font 
        }
        method issue_without_jump {string {type DEFAULT} args}
        constructor {args} {
                set stdargs [list -hscrollmode dynamic \
                                -labelpos n -visibleitems 80x10 \
                                -padx 0 -pady 0 -exportselection true \
                                -spacing3 1 -spacing2 2]
                component itemMenu delete 0 end 
                eval itk_initialize $stdargs $args
        }

        destructor {
        }
}

itcl::body base::messagebox::find {} {
        if {! [info exists itk_component(findd)]} {
                itk_component add findd {
                        base::finddialog $itk_interior.findd -title "Find"\
                                -textwidget $itk_component(text) 
                } 
        }
        $itk_component(findd) center $itk_component(text)
        $itk_component(findd) activate
}

itcl::body base::messagebox::issue_without_jump {string {type DEFAULT} args} {
    if {[lsearch $_types $type] == -1} {
        error "bad message type: \"$type\", use the type\
               command to create a new types"
    }
    set tag $this$type
    if {[$tag cget -show]} {
        $itk_component(text) configure -state normal
        set prevend [$itk_component(text) index "end - 1 chars"]
        set yview  [lindex [$itk_component(text) yview] 1]
        $itk_component(text) insert end "$string\n" $args
        $itk_component(text) tag add $type $prevend "end - 1 chars"
        if { $yview == 1.0 } {
                $itk_component(text) yview end
        }

        if {[$tag cget -bell]} {
            bell
        }
        $itk_component(text) configure -state disabled
    }
}
}
