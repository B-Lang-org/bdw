#
# Checkbox
# ----------------------------------------------------------------------
# Implements a checkbuttonbox.  Supports adding, inserting, deleting,
# selecting, and deselecting of checkbuttons by tag and index.
#
# ----------------------------------------------------------------------
#  AUTHOR: John A. Tucker                EMAIL: jatucker@spd.dsccc.com
#
# ----------------------------------------------------------------------
#            Copyright (c) 1997 DSC Technologies Corporation
# ======================================================================
# Permission to use, copy, modify, distribute and license this software 
# and its documentation for any purpose, and without fee or written 
# agreement with DSC, is hereby granted, provided that the above copyright 
# notice appears in all copies and that both the copyright notice and 
# warranty disclaimer below appear in supporting documentation, and that 
# the names of DSC Technologies Corporation or DSC Communications 
# Corporation not be used in advertising or publicity pertaining to the 
# software without specific, written prior permission.
# 
# DSC DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING 
# ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, AND NON-
# INFRINGEMENT. THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, AND THE
# AUTHORS AND DISTRIBUTORS HAVE NO OBLIGATION TO PROVIDE MAINTENANCE, 
# SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS. IN NO EVENT SHALL 
# DSC BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR 
# ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, 
# WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTUOUS ACTION,
# ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS 
# SOFTWARE.
# ======================================================================


#
# Use option database to override default resources of base classes.
#
option add *Scrolledcheckbox.labelMargin	10	widgetDefault
option add *Scrolledcheckbox.labelFont          "Helvetica 6" 
option add *Scrolledcheckbox.labelPos		nw	widgetDefault
option add *Scrolledcheckbox.borderWidth	2	widgetDefault
option add *Scrolledcheckbox.relief		groove	widgetDefault
option add *Scrolledcheckbox.vscrollmode	dynamic	widgetDefault
option add *Scrolledcheckbox.hscrollmode	none	widgetDefault

#
# Usual options.
#
itk::usual Scrolledcheckbox {
    keep -borderwidth -cursor -foreground -labelfont
}

# ------------------------------------------------------------------
#                            CHECKBOX
# ------------------------------------------------------------------
itcl::class base::Scrolledcheckbox {
    inherit iwidgets::Scrolledframe

    constructor {args} {}

    itk_option define -orient orient Orient vertical

    public {
      method add {tag args}
      method insert {index tag args}
      method insert_after {index tag args}
      method delete {index}
      method get {{index ""}}
      method index {index}
      method select {index}
      method deselect {index}
      method flash {index}
      method toggle {index}
      method buttonconfigure {index args}
      method select_all {}
      method deselect_all {}
      method get_buttons {}

  }

  private {

      method gettag {index}      ;# Get the tag of the checkbutton associated
                                 ;# with a numeric index

      variable _unique 0         ;# Unique id for choice creation.
      variable _buttons {}       ;# List of checkbutton tags.
      common buttonVar           ;# Array of checkbutton "-variables"
  }
}

#
# Provide a lowercased access method for the Scrolledcheckbox class.
#
proc ::base::scrolledcheckbox {pathName args} {
        uplevel ::base::Scrolledcheckbox $pathName $args
}

# ------------------------------------------------------------------
#                        CONSTRUCTOR
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::constructor {args} {
        bind $itk_component(canvas) <4> {
                if {!$tk_strictMotif} {
                        %W yview scroll -5 units
                }
        }
        bind $itk_component(canvas) <5> {
                if {!$tk_strictMotif} {
                        %W yview scroll 5 units
                }
        }
        bind $itk_component(sfchildsite) <4> [list $itk_component(canvas) yview scroll -5 units]
        bind $itk_component(sfchildsite) <5> [list $itk_component(canvas) yview scroll 5 units]
    eval itk_initialize $args
}

# ------------------------------------------------------------------
#                            OPTIONS
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# OPTION: -orient
#
# Allows the user to orient the checkbuttons either horizontally
# or vertically.  Added by Chad Smith (csmith@adc.com) 3/10/00.
# ------------------------------------------------------------------
itcl::configbody base::Scrolledcheckbox::orient {
  if {$itk_option(-orient) == "horizontal"} {
    foreach tag $_buttons {
      pack $itk_component($tag) -side left -anchor nw -padx 4 -expand 1
    }
  } elseif {$itk_option(-orient) == "vertical"} {
    foreach tag $_buttons {
      pack $itk_component($tag) -side top -anchor w -padx 4 -expand 0
    }
  } else {
    error "Bad orientation: $itk_option(-orient).  Should be\
      \"horizontal\" or \"vertical\"."
  }
}


# ------------------------------------------------------------------
#                            METHODS
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# METHOD: index index
#
# Searches the checkbutton tags in the checkbox for the one with the
# requested tag, numerical index, or keyword "end".  Returns the 
# choices's numerical index if found, otherwise error.
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::index {index} {
    if {[llength $_buttons] > 0} {
        if {[regexp {(^[0-9]+$)} $index]} {
            if {$index < [llength $_buttons]} {
                return $index
            } else {
                error "Scrolledcheckbox index \"$index\" is out of range"
            }

        } elseif {$index == "end"} {
            return [expr {[llength $_buttons] - 1}]

        } else {
            if {[set idx [lsearch $_buttons $index]] != -1} {
                return $idx
            }

            error "bad Scrolledcheckbox index \"$index\": must be number, end,\
                    or pattern"
        }

    } else {
        error "Scrolledcheckbox \"$itk_component(hull)\" has no checkbuttons"
    }
}

# ------------------------------------------------------------------
# METHOD: add tag ?option value option value ...?
#
# Add a new tagged checkbutton to the checkbox at the end.  The method 
# takes additional options which are passed on to the checkbutton
# constructor.  These include most of the typical checkbutton 
# options.  The tag is returned.
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::add {tag args} {
    itk_component add $tag {
        eval checkbutton "[childsite].cb[incr _unique]" \
            -variable [list [itcl::scope buttonVar($this,$tag)]] \
            -anchor w -justify left -highlightthickness 0 $args \
            -background white -font {"Helvetica 9"}
    } { 
      keep -command -disabledforeground -selectcolor -state
      ignore -highlightthickness -highlightcolor
        #rename -font -labelfont labelFont Font
        ignore -font
    }

    # Redraw the buttons with the proper orientation.
    if {$itk_option(-orient) == "vertical"} {
      pack $itk_component($tag) -side top -anchor w -padx 4 -expand 0
    } else {
      pack $itk_component($tag) -side left -anchor nw -expand 1
    }
    bind $itk_component($tag) <4> [list $itk_component(canvas) yview scroll -5 units]
    bind $itk_component($tag) <5> [list $itk_component(canvas) yview scroll 5 units]

    lappend _buttons $tag
    return $tag
}

# ------------------------------------------------------------------
# METHOD: insert index tag ?option value option value ...?
#
# Insert the tagged checkbutton in the checkbox just before the 
# one given by index.  Any additional options are passed on to the
# checkbutton constructor.  These include the typical checkbutton
# options.  The tag is returned.
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::insert {index tag args} {
    itk_component add $tag {
        eval checkbutton $itk_interior.cb[incr _unique] \
            -variable [list [itcl::scope buttonVar($this,$tag)]] \
            -anchor w \
            -justify left \
            -highlightthickness 0 \
            $args
    }  { 
      ignore -highlightthickness -highlightcolor
      rename -font -labelfont labelFont Font
    }

    set index [index $index]
    set before [lindex $_buttons $index]
    set _buttons [linsert $_buttons $index $tag]

    pack $itk_component($tag) -anchor w -padx 4 -before $itk_component($before)

    return $tag
}

# ------------------------------------------------------------------
# METHOD: insert_after index tag ?option value option value ...?
#
# Insert the tagged checkbutton in the checkbox just after the 
# one given by index.  Any additional options are passed on to the
# checkbutton constructor.  These include the typical checkbutton
# options.  The tag is returned.
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::insert_after {index tag args} {
    itk_component add $tag {
        eval checkbutton $itk_interior.cb[incr _unique] \
            -variable [list [itcl::scope buttonVar($this,$tag)]] \
            -anchor w -justify left -highlightthickness 0 $args \
            -background white -font {"Helvetica 9"}
    }  { 
      keep -command -disabledforeground -selectcolor -state
      ignore -highlightthickness -highlightcolor -font
      #rename -font -labelfont labelFont Font
    }


    set index [index $index]
    set after [lindex $_buttons $index]
    incr index
    set _buttons [linsert $_buttons $index $tag]

    pack $itk_component($tag) -anchor w -padx 4 -after $itk_component($after)

    return $tag
}

# ------------------------------------------------------------------
# METHOD: delete index
#
# Delete the specified checkbutton.
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::delete {index} {

    set tag [gettag $index]
    set index [index $index]
    destroy $itk_component($tag)
    set _buttons [lreplace $_buttons $index $index]

    if { [info exists buttonVar($this,$tag)] == 1 } {
	unset buttonVar($this,$tag)
    }
}

# ------------------------------------------------------------------
# METHOD: select index
#
# Select the specified checkbutton.
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::select {index} {
    set tag [gettag $index]
    #-----------------------------------------------------------
    # BUG FIX: csmith (Chad Smith: csmith@adc.com), 3/30/99
    #-----------------------------------------------------------
    # This method should only invoke the checkbutton if it's not
    # already selected.  Check its associated variable, and if
    # it's set, then just ignore and return.
    #-----------------------------------------------------------
    if {[set [itcl::scope buttonVar($this,$tag)]] == 
	[[component $tag] cget -onvalue]} {
      return
    }
    $itk_component($tag) invoke
}

# ------------------------------------------------------------------
# METHOD: select index
#
# Select the specified checkbutton.
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::select_all {} {
# set tag [gettag $index]
    #-----------------------------------------------------------
    # BUG FIX: csmith (Chad Smith: csmith@adc.com), 3/30/99
    #-----------------------------------------------------------
    # This method should only invoke the checkbutton if it's not
    # already selected.  Check its associated variable, and if
    # it's set, then just ignore and return.
    #-----------------------------------------------------------
    foreach tag $_buttons {
            $itk_component($tag) select
    }
    
#   if {[set [itcl::scope buttonVar($this,$tag)]] == 
#       [[component $tag] cget -onvalue]} {
#     return
#   }
#   $itk_component($tag) invoke
}

# ------------------------------------------------------------------
# METHOD: toggle index
#
# Toggle a specified checkbutton between selected and unselected
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::toggle {index} {
    set tag [gettag $index]
    $itk_component($tag) toggle
}

# ------------------------------------------------------------------
# METHOD: get
#
# Return the value of the checkbutton with the given index, or a
# list of all checkbutton values in increasing order by index.
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::get {{index ""}} {
    set result {}

    if {$index == ""} {
	foreach tag $_buttons {
	    if {$buttonVar($this,$tag)} {
		lappend result $tag
	    }
	}
    } else {
        set tag [gettag $index]
	set result $buttonVar($this,$tag)
    }

    return $result
}

# ------------------------------------------------------------------
# METHOD: deselect index
#
# Deselect the specified checkbutton.
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::deselect {index} {
    set tag [gettag $index]
    $itk_component($tag) deselect
}

# ------------------------------------------------------------------
# METHOD: deselect_all 
#
# Deselects all checkbuttons in the checkbox.
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::deselect_all {} {
    foreach tag $_buttons {
        $itk_component($tag) deselect
    }
}

# ------------------------------------------------------------------
# METHOD: flash index
#
# Flash the specified checkbutton.
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::flash {index} {
    set tag [gettag $index]
    $itk_component($tag) flash  
}

# ------------------------------------------------------------------
# METHOD: buttonconfigure index ?option? ?value option value ...?
#
# Configure a specified checkbutton.  This method allows configuration 
# of checkbuttons from the Scrolledcheckbox level.  The options may have any 
# of the values accepted by the add method.
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::buttonconfigure {index args} { 
    set tag [gettag $index]
    eval $itk_component($tag) configure $args
}

# ------------------------------------------------------------------
# METHOD: gettag index
#
# Return the tag of the checkbutton associated with a specified
# numeric index
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::gettag {index} {
    return [lindex $_buttons [index $index]]
}

# ------------------------------------------------------------------
# METHOD: get_buttons
#
# Return the buttons of the checkbutton
# ------------------------------------------------------------------
itcl::body base::Scrolledcheckbox::get_buttons {} {
    return $_buttons
}
