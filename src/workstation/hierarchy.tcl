
##
# @file hierarchy.tcl
#
# @brief Definition of class hierarchy.
#

namespace eval base {

        itcl::class hierarchy {
        inherit iwidgets::Hierarchy

        itk_option define -selectonemorecommand selectonemoreCommand Command {}
        itk_option define -selectmanymorecommand \
                selectmanymoreCommand Command {}
        itk_option define -postselectcommand postselectCommand Command {}
        itk_option define -texttags textTags TextTags {}

        protected {
                method _isInternalTag {tag}
        }

        private {
                variable _first_select ""
                method _configureTags {}
        }

        ##
        # @brief Adds an action to the item pop-up menu
        #
        # @param n name of the menu action
        # @param c command for the action
        #
        method add_itemmenu {n c} {
                $this component itemMenu add command -label $n -command $c              }

        ##
        # @brief Adds a separator to the item pop-up menu
        #
        method add_separator {} {
                $this component itemMenu add separator
        }

        ##
        # @brief Adds an action to the background pop-up menu
        #
        # @param n name of the menu action
        # @param c command for the action
        #
        method add_bgmenu {n c} {
                $this component bgMenu add command -label $n -command $c
        }

        ##
        # @brief Selects an item at the coordinate (x,y) relative to the widget
        # and adds/removes it from the current selection (doesn't clear current
        # selection) (bound to <Control-Button-1>)
        #
        # @param x the x coordinate of the selection
        # @param y the y coordinate of the selection
        # @param option the option name -selectcommand or -selectonemorecommand
        #
        method select_one_or_more {x y option}

        ##
        # @brief Selects an item at the coordinate (x,y) relative to the
        # widget and adds a set of nodes to the current selection (doesn't
        # clear current selection) (bound to <Shift-B1-Motion>)
        #
        # @param x the x coordinate of the selection
        # @param y the y coordinate of the selection
        #
        method select_more {x y}

        ##
        # @brief Performs any cleanup/bookkeeping functions after the selection
        # has been updated (bound to <ButtonRelease-1>)
        #
        method post_select

        ##
        # @brief Select a node based on id rather than x y position.
        #
        # @param node the node id
        # @param s the selection status
        #
        method select_node {node s}

        ##
        # @brief Return a list of nodes between the two nodes (inclusive).
        #
        # @param node_0 the first node
        # @param node_1 the other node
        #
        method get_range {node_0 node_1}

        method arrow_move {direction}

        method set_bindings {}

	constructor {args} {
	    set default_args [list -vscrollmode static \
				   -hscrollmode dynamic -tabs 15 \
                                  -spacing3 1 -font bscTextFont \
                                  -visibleitems 5x5]
	    set all_args [concat $default_args $args]
	    set_bindings
	    _configureTags
	    eval itk_initialize $all_args
        }

        destructor {
        }
}

# ------------------------------------------------------------------
#                             OPTIONS
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# OPTION: -selectforeground
#
# Redefine this to add piggyback code for texttag values
# ------------------------------------------------------------------
itcl::configbody iwidgets::Hierarchy::selectforeground {
    ## Original code
    $itk_component(list) tag configure hilite \
            -foreground $itk_option(-selectforeground)
    ## Piggyback code
    proc valid_tag {tag_name} {
	set used_tags [list hilite lowlite info]
	if {[lsearch $used_tags $tag_name] == -1} {
	    return 1
	}
	return 0
    }
    set texttags [list]
    catch {set texttags $itk_option(-texttags)}
    foreach pair $texttags {
	set tag_name  [lindex $pair 0]
	set tag_value [lindex $pair 1]
        set cmd "$itk_component(list) tag configure $tag_name $tag_value"
	eval $cmd
    }
    # raise priority of hilite tag so that its colors dominate
    tag raise hilite
}

# ----------------------------------------------------------------------
# PROTECTED METHOD (could be proc?): _isInternalTag tag
#
# Redefine  _isInternalTag to support additional text tags. Used
# internally to indicate tags not to used for user callback commands
# ----------------------------------------------------------------------
itcl::body hierarchy::_isInternalTag {tag} {
        set texttags [list]
        catch {set texttags $itk_option(-texttags)}

        foreach pair $texttags {
                set tag_name [lindex $pair 0]
                if {$tag_name == $tag} {
                        return 1
                }
        }
        set ii [expr {[lsearch -exact \
                                {info hilite lowlite unknown} $tag] != -1}]
        return $ii
}

# ----------------------------------------------------------------------
# PRIVATE METHOD: _configureTags
#
# Redefine _configureTags to support additional text tags. This method
# resets the hilite, lowlite, info, and added text tags.
# ----------------------------------------------------------------------
itcl::body hierarchy::_configureTags {} {
        tag configure hilite -background $itk_option(-selectbackground) \
                        -foreground $itk_option(-selectforeground)
        tag configure lowlite -background $itk_option(-markbackground) \
                -foreground $itk_option(-markforeground)
        tag configure info -font $itk_option(-font) -spacing1 6
        proc valid_tag {tag_name} {
                set used_tags [list hilite lowlite info]
                if {[lsearch $used_tags $tag_name] == -1} {
                        return 1
                }
                return 0
        }
        set texttags [list]
        catch {set texttags $itk_option(-texttags)}
        foreach pair $texttags {
                set tag_name  [lindex $pair 0]
                set tag_value [lindex $pair 1]
                set cmd "tag configure $tag_name $tag_value"
                eval $cmd
        }
        # raise priority of hilite tag so that its colors dominate
        tag raise hilite
}

itcl::body hierarchy::select_one_or_more {x y option} {
        if {$itk_option($option) != {}} {
                if {[set seltags [$itk_component(list) \
                                tag names @$x,$y]] != {}} {
                        set node [lindex $seltags end]
                        if {[lsearch $seltags "hilite"] == -1} {
                                set selectstatus 0
                        } else {
                                set selectstatus 1
                        }
                        set cmd $itk_option($option)
                        regsub -all {%n} $cmd [lindex $node end] cmd
                        regsub -all {%s} $cmd $selectstatus cmd
                        uplevel #0 $cmd
                        if {$selectstatus} {
                        # already selected, thus it will be unselected
                                set _first_select ""
                        } else {
                                set _first_select "$node [selection get]"
                        }
                }
                return
        }
}

itcl::body hierarchy::select_more {x y} {
        if {$itk_option(-selectmanymorecommand) != {}} {
                if {[set seltags [$itk_component(list) \
                                tag names @$x,$y]] != {}} {
                        set node [lindex $seltags end]
                        if {[lsearch $seltags "hilite"] == -1} {
                                set selectstatus 0
                        } else {
                                set selectstatus 1
                        }
                        if {$_first_select == ""} {
                                set cmd $itk_option(-selectcommand)
                                regsub -all {%n} $cmd [lindex $node end] cmd
                                regsub -all {%s} $cmd $selectstatus cmd
                                set _first_select "$node [selection get]"
                        } else {
                                set nodes [get_range $node \
                                        [lindex $_first_select 0]]
                                set nodes "$nodes $_first_select"
                                set cmd $itk_option(-selectmanymorecommand)
                                regsub -all {%n} $cmd $nodes cmd
                        }
                        uplevel #0 $cmd
                }
                return
        }
}

itcl::body hierarchy::post_select {} {
        if {$itk_option(-postselectcommand) != {}} {
                set cmd $itk_option(-postselectcommand)
                uplevel #0 $cmd
        }
}

itcl::body hierarchy::select_node {node s} {
        if {$itk_option(-selectcommand) != {}} {
                set cmd $itk_option(-selectcommand)
                regsub -all {%n} $cmd $node cmd
                regsub -all {%s} $cmd $s cmd
                uplevel #0 $cmd

                if {[selection get] != ""} {
                        set _first_select [selection get]
                }
        }
}

itcl::body hierarchy::get_range {node_0 node_1} {
        set node_0_found 0
        set node_1_found 0
        set nodes [list]
        set done 0
        foreach node [get_displayed_nodes] {
                if {$node == $node_0} { set node_0_found 1 }
                if {$node == $node_1} { set node_1_found 1 }
                if {($node_0_found || $node_1_found) && !$done} {
                        lappend nodes $node
                }
                if {$node_0_found && $node_1_found} {set done 1}
        }
        if {$node_0_found && $node_1_found} {return $nodes}
        if {$node_0_found} {return [list $node_0]}
        if {$node_1_found} {return [list $node_1]}
        return [list]

}

itcl::body hierarchy::arrow_move {direction} {
    catch {
        set all_nodes [get_displayed_nodes]
        set nodes [selection get]
        if {$nodes == ""} {
                set node [lindex $all_nodes 0]
                        select_node $node 0
                        post_select
                        return
        }
        set node [lindex $nodes 0]
        selection clear
        switch -exact -- $direction {
                "left" {
                        if {[expanded $node]} {
                                # node is expanded, collapse
                                collapse $node
                                select_node $node 0
                        } else {
                                # node is collapsed, move to parent
                                set p [_getParent $node]
                                if {$p != ""} {
                                        select_node $p 0
                                } else {
                                        bell
                                                select_node $node 0
                                }
                        }
                }
                "right" {
                        if {[expanded $node]} {
                                # node is expanded, move to first child
                                set children [_contents $node]
                                if {$children == ""} {
                                        bell
                                                select_node $node 0
                                } else {
                                        select_node [lindex $children 0] 0
                                }
                        } else {
                                # node is collapsed, expand
                                expand $node
                                set children [_contents $node]
                                if {$children == ""} { bell }
                                select_node $node 0
                        }
                }
                "up" {
                        set index [lsearch -exact $all_nodes $node]
                        set index [expr $index - 1]
                        if { $index >= 0 } {
                                select_node [lindex $all_nodes $index] 0
                        } else {
                                bell
                                        select_node $node 0
                        }
                    see $node:start
                }
                "down" {
                        set index [lsearch -exact $all_nodes $node]
                        set index [expr $index + 1]
                        if { $index < [llength $all_nodes] } {
                                select_node [lindex $all_nodes $index] 0
                        } else {
                                bell
                                        select_node $node 0
                        }
                    see $node:start
                }
        }
        post_select
    }
}

itcl::body hierarchy::set_bindings {} {
    bind $itk_component(list) <Button-1> \
        [itcl::code $this select_one_or_more %x %y "-selectcommand"]
    bind $itk_component(list) <Control-1> \
        [itcl::code $this  select_one_or_more %x %y "-selectonemorecommand"]
    bind $itk_component(list) <Shift-Button-1> \
        [itcl::code $this select_more %x %y]
    bind $itk_component(list) <Shift-B1-Motion>  \
        [itcl::code $this select_more %x %y]
    bind $itk_component(list) <ButtonRelease-1> \
        [itcl::code $this post_select]
    bind $itk_component(list) <Button-2> \
        [itcl::code $this select_one_or_more %x %y "-selectonemorecommand"]
    bind $itk_component(list) <B2-Motion> \
        [itcl::code $this select_more %x %y]
    bind $itk_component(list) <ButtonRelease-2> \
        [itcl::code $this post_select]

    bind $itk_component(hull) <Right> \
        [itcl::code $this arrow_move right]

    bind $itk_component(hull) <Left> \
        [itcl::code $this arrow_move left]

    bind $itk_component(hull) <Down> \
        [itcl::code $this arrow_move down]

    bind $itk_component(hull) <Up> \
        [itcl::code $this arrow_move up]

    bind $itk_component(hull) <Next> \
            [itcl::code $this yview scroll 1 page]
    bind $itk_component(hull) <Prior> \
            [itcl::code $this yview scroll -1 page]

    catch {
        bind $itk_component(hull) <KP_Right> \
            [itcl::code $this arrow_move right]
    }

    catch {
        bind $itk_component(hull) <KP_Left> \
            [itcl::code $this arrow_move left]
    }

    catch {
        bind $itk_component(hull) <KP_Down> \
            [itcl::code $this arrow_move down]
    }

    catch {
        bind $itk_component(hull) <KP_Up> \
            [itcl::code $this arrow_move up]
    }

    catch {
        bind $itk_component(hull) <KP_Next> \
            [itcl::code $this yview scroll 1 page]
    }
    catch {
        bind $itk_component(hull) <KP_Prior> \
            [itcl::code $this yview scroll -1 page]
    }

    bind $itk_component(hull) <Home> \
            [itcl::code $this yview 0]
    bind $itk_component(hull) <End> \
            [itcl::code $this yview end]

    catch {
        bind $itk_component(hull) <KP_Home> \
            [itcl::code $this yview 0]
    }
    catch {
        bind $itk_component(hull) <KP_End> \
            [itcl::code $this yview end]
    }

}

}
