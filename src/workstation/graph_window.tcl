
##
# @file graph_window.tcl
#
# @brief Definition of class graph_window.
#

##
# @brief Definition of class graph_window
# 
#catch "itcl::delete class graph_window" 
itcl::class graph_window {
        inherit itk::Toplevel 

        itk_option define -dotgraph dotgraph Dotgraph {}

        ##
        # @brief The id of the graph 
        #
        variable graph ""
        # An Array of attributes to all graph reconstruction
        variable Originalgraph

        ##
        # @brief The text label of the graph 
        #
        variable graph_label ""

        ##
        # @brief The list of graph nodes
        #
        variable nodes_list ""

        ##
        # @brief The list of graph edges
        #
        variable edges_list ""

        variable zdepth 1.0
        variable idle {}
        variable last_scale 0
        variable scale_factor 1.25
        # Zoom = scale_factor ** scale

        method get_graph {} { return $graph }

        ##
        # @brief Zooms in/out the graph appearance
        #
        # @param fact the scale of zoom
        #
        method zoom {fact} 

        ##
        # @brief Updates the graph appearance(font size, etc.) according to the
        # zoom action
        #
        method zoomupdate {} 

        ##
        # @brief Updates the state of zoom buttons
        #
        method check_button_state {} 

        ##
        # @brief Zooms in/out the graph appearance
        #
        # @param f the scale of zoom
        #
        method scale_zoom {f} 

        ##
        # @brief Changes the position of the scale
        #
        # @param fact the scale of zoom
        #
        method change_scale {fact} {
                set f [$itk_component(mscale) get]
                set f [expr $f +  $fact]
                $itk_component(mscale) set $f
        }

        ##
        # @brief Close the Graph window
        #
        method close_graph_window {} { 
                destroy [string replace $this 0 1]
        }
        
        ##
        # @brief Function to be called when selecting tab
        #
        # @param t the number of the tab
        #
        method select_tab {t} {
                if {$t == 0} {
#                        pack $itk_component(nodes_show_connections)
                        $itk_component(nodes_show_connections) configure \
                                -state normal
                } elseif {$t == 1} {
#                        pack forget $itk_component(nodes_show_connections)
                        $itk_component(nodes_show_connections) configure \
                                -state disabled
                }
        } 

        ##
        # @breif Selects all nodes/egdes
        #
        method rules_select_all {} {
                if {[$itk_component(tab) view] == 0} {
                        $itk_component(nodes) select_all
                } elseif {[$itk_component(tab) view] == 1} {
                        $itk_component(edges) select_all
                }
        }

        ##
        # @breif Clears all nodes/edges
        #
        method rules_clear_all {} {
                if {[$itk_component(tab) view] == 0} {
                        $itk_component(nodes) deselect_all
                } elseif {[$itk_component(tab) view] == 1} {
                        $itk_component(edges) deselect_all
                }
        }

        ##
        # @breif Selects nodes/edges which match the filter
        #
        method rules_select_match {}

        ##
        # @breif Clears nodes/edges which match the filter
        #
        method rules_clear_match {} 

        ##
        # @breif Selects all nodes connected to the currently connected node
        #
        method nodes_show_connections {}

        ##
        # @breif Creates the new graph using the selected nodes/edges
        #
        method new_graph {}
        method copy_selected_graph {}

        ##
        # @brief Redraws the graph using lists of new nodes and edges
        #
        method redraw {} 

        ##
        # @brief Opens Rename Graph dialog
        #
        method rename {} { 
                create_rename_graph_dialog $this
        }

        ##
        # @brief Opens Rename Graph dialog
        #
        method export {}

        ##
        # @brief Gets the label from an existing graph
        #
        # @return the graph label or empty string
        #
        method get_label {} {
                set l ""
                if {[lsearch [$graph listattributes] label] != -1} {
                        set l [lindex [$graph queryattributes label] 0]
                }
                return $l
        }

        ##
        # @brief Redraws graph label
        #
        # @param label the graph label
        #
        method redraw_label {label} {
                if {$label == "" && [get_label] == ""} {
                        return
                }
                set graph_label $label
                $itk_component(canvas) delete all
                $graph setattributes label $label
                eval [$graph render $itk_component(canvas) NEATO]
        }

        ##
        # @breif Returns the list of node names
        #
        method get_nodes {} {
                set nodes {}
                foreach i [$itk_component(nodes) get] {
                        lappend nodes [lindex $nodes_list $i]
                }
                return $nodes
        }

        ##
        # @breif Returns the list of edge names
        #
        method get_edges {} {
                set edges {}
                foreach i [$itk_component(edges) get] {
                        set n [split [lindex $edges_list $i] "->"]
                        if {[lsearch [get_nodes] [lindex $n 2]] != -1 && \
                                [lsearch [get_nodes] [lindex $n 0]] != -1} {
                                lappend edges [lindex $edges_list $i]
                        }
                }
                return $edges
        }

        private {

                variable left_pane ""
                variable right_pane ""

                ##
                # @brief Creates the menubar
                #
                method create_menubar {}

                ##
                # @brief Creates the menu items
                #
                method create_menuitems {}

                ##
                # @brief Creates the paned windows
                #
                method create_panes {}

                ##
                # @brief Creates the Nodes and Edges tabs
                #
                method create_tabnotebook {}

                ##
                # @brief Creates the Select/Clear All and Add Adjacent buttons
                #
                method create_select_buttons {}

                ##
                # @brief Creates the nodes/edges filters
                #
                method create_filter {}

                ##
                # @brief Creates the New, Redraw, Hide buttons
                #
                method create_new_redraw_buttons {}

                ##
                # @brief Creates the canvas
                #
                method create_canvas {}

                ##
                # @brief Reads the graph from the file or already existing
                # graph
                #
                method read_graph {}
                
                ##
                # @brief Configures the commands to be executed under buttons
                #
                method configure_items {}
                
                ##
                # @brief Gets the nodes and edges from an existing graph
                #
                method get_nodes_edges_list {}

                ##
                # @brief Sets the bindings for Graph Window 
                # 
                method set_bindings {}

                ##
                # @breif Adds nodes to the checkbox in the Nodes tab
                #
                method add_nodes {} {
                        set node_id 0
                        foreach i $nodes_list {
                                $itk_component(nodes) add $node_id -text $i 
                                incr node_id
                        }
                        $itk_component(nodes) select_all
                }

                ##
                # @breif Adds edges to the checkbox in the Edges tab
                #
                method add_edges {} {
                        set edge_id 0
                        foreach i $edges_list {
                                $itk_component(edges) add $edge_id -text $i 
                                incr edge_id
                        }
                        $itk_component(edges) select_all
                }

        }

        constructor {args} {}

        destructor {
                if {[winfo exists .rg] && [string equal $this \
                                                [.rg cget -graph]]} {
                        .rg deactivate 0
                }
        }
}

itcl::body graph_window::constructor {args} {
        set zdepth 1.0
        set stdargs [list -textbackground white]
        create_menubar
        create_panes
        eval itk_initialize $stdargs $args
        read_graph
        configure_items
        set_bindings
}

itcl::body graph_window::create_menubar {} {
        itk_component add mframe {
                frame $itk_interior.frame
        }
        pack $itk_component(mframe) -fill x 
        itk_component add menu {
                base::menubar $itk_component(mframe).menu \
                        -helpvariable helpVar -cursor ""
        } {
                keep -activebackground
        }
        create_menuitems
        itk_component add mscale {
                scale $itk_component(mframe).scale -orient horizontal \
                        -length 250 -from -10 -to 10 \
                        -showvalue false -command {}
        }
        pack $itk_component(mscale) -fill x -side right -expand false
}

itcl::body graph_window::create_menuitems {} {
        $itk_component(menu) add menubutton view -text "View" \
                -underline 0 -menu {
                        options -tearoff false 
                        command export -label "Export..." -underline 0 \
                                -helpstr  "Writes the graph in a \
                                specified format" -state normal 
                        command filter -label "Show Filter" -underline 0 \
                                -helpstr  "Shows the filter side-bar" \
                                -state disabled 
                        command close -label "Close" -underline 0 \
                                -helpstr  "Close Graph Window" -state normal \
                                -accelerator Ctrl-w
                }
        $itk_component(menu) add menubutton zoom -text "Zoom" \
                -underline 0 -menu {
                        options -tearoff false 
                        command zoom_in -label "Zoom in" -underline 5 \
                                -helpstr  "Zoom in" -state normal \
                                -accelerator Ctrl-Shift-z
                        command zoom_out -label "Zoom out" -underline 5 \
                                -helpstr  "Zoom out" -state normal \
                                -accelerator Ctrl-z
                }
        pack $itk_component(menu) -fill x -side left
}

itcl::body graph_window::create_panes {} {
        itk_component add gpane {
                base::panedwindow $itk_interior.gpane -orient vertical
        }
        $itk_component(gpane) add "left" -margin 0 -minimum 20
        set left_pane [$itk_component(gpane) childsite "left"]
        $itk_component(gpane) add "right" -margin 0 -minimum 80
        set right_pane [$itk_component(gpane) childsite "right"]
        $itk_component(gpane) fraction 20 80
        create_tabnotebook
        create_filter
        create_select_buttons
        create_new_redraw_buttons
        create_canvas
        pack $itk_component(gpane) -padx 0 -pady 0 -fill both -expand yes \
                -side top
}

itcl::body graph_window::create_tabnotebook {} {
        itk_component add tab {
                base::tabnotebook $left_pane.tab -bevelamount 2 \
                        -pady 2 -padx 5 -tabpos n -equaltabs true
        } {
                keep -cursor -background
        }
        pack $itk_component(tab) -fill both -expand yes -side top
        set node_tab [$itk_component(tab) add_label "Nodes" \
                "$this select_tab 0"]
        itk_component add nodes {
                base::scrolledcheckbox $node_tab.nodes -canvbackground white \
                                -hscrollmode static -vscrollmode dynamic 
        }
        pack $itk_component(nodes) -side top -expand true -fill both
        set edge_tab [$itk_component(tab) add_label "Edges" \
                "$this select_tab 1"]
        itk_component add edges {
                base::scrolledcheckbox $edge_tab.edges -canvbackground white \
                                -hscrollmode static -vscrollmode dynamic
        } 
        pack $itk_component(edges) -side top -expand true -fill both
}

itcl::body graph_window::create_filter {} {
        set t $left_pane
        set pady 0
        itk_component add rules_filter_entry {
                iwidgets::entryfield $t.efentry -labeltext "Filter regex" \
                        -textbackground white -labelpos w
        } {
                keep -cursor -background
        }
        pack $itk_component(rules_filter_entry) -padx 10 -pady $pady
        itk_component add node_filter_but {
                frame $t.nfilter_but
        }
        pack $itk_component(node_filter_but) -fill x  -pady $pady
        itk_component add rules_clear_match {
                button $itk_component(node_filter_but).clear -text \
                        "Clear matching" -width 13 -command \
                        [list $this rules_clear_match]
        }
        pack $itk_component(rules_clear_match) -padx 10 -pady $pady
        itk_component add rules_select_match {
                button $itk_component(node_filter_but).select -text \
                        "Select matching" -width 13 -command \
                        [list $this rules_select_match]
        }
        pack $itk_component(rules_select_match) -padx 10  -pady $pady
}

itcl::body graph_window::create_select_buttons {} {
        set pady 0
        itk_component add node_buttons {
                frame $left_pane.buts
        }
        pack $itk_component(node_buttons) -fill x -pady $pady
        itk_component add rules_select_all {
                button $itk_component(node_buttons).select -text "Select All" \
                        -command [list $this rules_select_all] -width 13
        }
        pack $itk_component(rules_select_all) -padx 10 -pady $pady
        itk_component add rules_clear_all {
                button $itk_component(node_buttons).clear -text "Clear All" \
                        -command [list $this rules_clear_all] -width 13 
        }
        pack $itk_component(rules_clear_all) -padx 10 -pady $pady
        itk_component add nodes_show_connections {
                button $itk_component(node_buttons).show -text \
                        "Add Adjacent" -width 13 -command \
                        [list $this nodes_show_connections]
        }
        pack $itk_component(nodes_show_connections)
}

itcl::body graph_window::create_new_redraw_buttons {} {
        set pady 0
        itk_component add nrframe {
                frame $left_pane.nrfr
        }
        pack $itk_component(nrframe) -fill x -pady $pady
        itk_component add new_but {
               button $itk_component(nrframe).new_but \
                -text "New" -width 13 -command {}
        } 
        pack $itk_component(new_but) -padx 10 -pady $pady
        itk_component add redraw_but {
                button $itk_component(nrframe).redraw_but \
                -text "Redraw" -width 13 -command {}
        } 
        pack $itk_component(redraw_but) -padx 10 -pady $pady
        itk_component add rename_but {
                button $itk_component(nrframe).rename_but \
                -text "Rename..." -width 13 -command "$this rename"
        } 
        pack $itk_component(rename_but) -padx 10 -pady $pady
        itk_component add hide_but {
                button $itk_component(nrframe).hide_but \
                -text "Hide" -width 13 -command \
                "pack forget $left_pane; $itk_component(gpane) fraction 0 100; \
                $itk_component(menu) menuconfigure .view.filter -state normal"
        } 
        pack $itk_component(hide_but) -padx 10 -pady $pady
}

itcl::body graph_window::create_canvas {} {
        itk_component add canvas {
                iwidgets::scrolledcanvas $right_pane.cnv \
                        -hscrollmode dynamic -vscrollmode dynamic 
        } {
                keep -textbackground
        }
        pack $itk_component(canvas) -fill both -expand true
}

itcl::body graph_window::configure_items {} {
        $itk_component(menu) menuconfigure .view.close -command \
                [list $this close_graph_window]
        $itk_component(mscale) set 0
        set last_scale 0
        $itk_component(mscale) configure -command [list $this scale_zoom]
        $itk_component(menu) menuconfigure .view.export -command "$this export"
        $itk_component(menu) menuconfigure .view.filter -command \
                "pack $left_pane -fill both -expand yes -side left; \
                $itk_component(gpane) fraction 20 80; \
                $itk_component(menu) menuconfigure .view.filter -state disabled"
        $itk_component(menu) menuconfigure .zoom.zoom_in \
                -command "$this change_scale 1"
        $itk_component(menu) menuconfigure .zoom.zoom_out \
            -command "$this change_scale -1"
        $itk_component(new_but) configure -command [list $this new_graph] 
        $itk_component(redraw_but) configure -command [list $this redraw]
        $itk_component(tab) configure -width 200 -height 250
        $itk_component(tab) select 0
        $itk_component(tab) configure -tabpos n
}

itcl::body graph_window::read_graph {} {
        if {[file exists $itk_option(-dotgraph)]} {
                set f [open $itk_option(-dotgraph) r]
                set graph [dotread $f]
        } else {
                set graph $itk_option(-dotgraph)
        }
        get_nodes_edges_list
        add_nodes
        add_edges
        set graph_label [get_label]
        eval [$graph render $itk_component(canvas) NEATO]
}

itcl::body graph_window::get_nodes_edges_list {} {
        set nodes_list {}
        set edges_list {}
        foreach i [$graph listnodes] {
                set nn [$i showname]
                lappend nodes_list $nn
                set Originalgraph($nn,name) "$nn"
                set Originalgraph($nn,attr) "[$i queryattributevalues [$i listattributes]]"
        }
        foreach i [$graph listedges] {
                set nn [$i showname]
                lappend edges_list $nn
                set n [split $nn "->"]
                set from  [lindex $n 0]
                set to    [lindex $n end]
                set Originalgraph($nn,from) "$from"
                set Originalgraph($nn,to) "$to"
                set Originalgraph($nn,attr) "[$i queryattributevalues [$i listattributes]]"
        }
}

itcl::body graph_window::rules_select_match {} {
        set n [$itk_component(rules_filter_entry) get]
        if {[$itk_component(tab) view] == 0} { 
                if {$n != "" && $n != "\\" && $n != "\[\]" && \
                                ![catch "regexp -all -- $n $nodes_list"]} {
                        foreach i [lsearch -all -regexp $nodes_list $n] {
                                $itk_component(nodes) select $i
                        }
                }
        } elseif {[$itk_component(tab) view] == 1} { 
                if {$n != "" && $n != "\\" && $n != "\[\]" && \
                                ![catch "regexp -all -- $n $edges_list"]} {
                        foreach i [lsearch -all -regexp $edges_list $n] {
                                $itk_component(edges) select $i
                        }
                }
        }
}

itcl::body graph_window::rules_clear_match {} {
        set n [$itk_component(rules_filter_entry) get]
        if {[$itk_component(tab) view] == 0} { 
                if {$n != "" && $n != "\\" && $n != "\[\]" && \
                                ![catch "regexp -all -- $n $nodes_list"]} {
                        foreach i [lsearch -all -regexp $nodes_list $n] {
                                $itk_component(nodes) deselect $i
                        }
                }
        } elseif {[$itk_component(tab) view] == 1} { 
                if {$n != "" && $n != "\\" && $n != "\[\]" && \
                                ![catch "regexp -all -- $n $edges_list"]} {
                        foreach i [lsearch -all -regexp $edges_list $n] {
                                $itk_component(edges) deselect $i
                        }
                }
        }
}

itcl::body graph_window::set_bindings {} {
        set w [string replace $this 0 1]
        bind $w <Control-w> {
                destroy .[lindex [split %W .] 1]
        }
        bind $w <Control-Z> {
                .[lindex [split %W .] 1] change_scale +1
        }
        bind $w <Control-z> {
                .[lindex [split %W .] 1] change_scale -1
        }
        if {"x11" eq [tk windowingsystem]} {
                bind [$itk_component(canvas) component canvas] <4> {
                        if {!$tk_strictMotif} {
                                %W yview scroll -5 units
                        }
                }
                bind [$itk_component(canvas) component canvas] <5> {
                        if {!$tk_strictMotif} {
                                %W yview scroll 5 units
                        }
                }
        }
}

itcl::body graph_window::new_graph {} {
        set g [copy_selected_graph]
        create_new_graph_window $g
}

itcl::body graph_window::copy_selected_graph  {} {
        set g [dotnew digraphstrict LR label $graph_label]
        foreach i [get_nodes] {
                set nn [$g addnode $Originalgraph($i,name)]
                eval $nn setattributes  $Originalgraph($i,attr)
        }
        foreach i [get_edges] {
                set ne [$g addedge $Originalgraph($i,from) $Originalgraph($i,to)]
                eval $ne setattributes  $Originalgraph($i,attr)
        }
        return $g
}

itcl::body graph_window::redraw {} {
        $itk_component(canvas) delete all
        set zdepth 1.0
        $itk_component(mscale) set 0
        set last_scale 0

        set g [copy_selected_graph]
        $graph delete
        set graph $g

        eval [$graph render $itk_component(canvas) NEATO]
        $itk_component(menu) menuconfigure .zoom.zoom_in -state normal
        $itk_component(menu) menuconfigure .zoom.zoom_out -state normal
}

itcl::body graph_window::zoom {fact} {
        set c $itk_component(canvas)
        set x [$c canvasx [expr {[winfo pointerx $c] - [winfo rootx $c]}]]
        set y [$c canvasy [expr {[winfo pointery $c] - [winfo rooty $c]}]]
        $c scale all $x $y $fact $fact
        set zdepth [expr {$zdepth * $fact}]
        after cancel $idle
        set idle [after idle "$this zoomupdate"]
        set f [expr ( log($zdepth) / log($scale_factor) ) ]
        $itk_component(mscale) set $f
        set last_scale $f 
        check_button_state
}

itcl::body graph_window::zoomupdate {} {
        set c $itk_component(canvas)
        foreach {i} [$c find all] {
                if { ! [string equal [$c type $i] text]} {continue}
                set fontsize 0
                foreach {tag} [$c gettags $i] {
                        scan $tag {_f%d} fontsize
                        scan $tag "_t%\[^\0\]" text
                }
                set font [$c itemcget $i -font]
                if {!$fontsize} {
                        set text [$c itemcget $i -text]
                        set fontsize [lindex $font 1]
                        $c addtag _f$fontsize withtag $i
                        $c addtag _t$text withtag $i
                }
                set newsize [expr {int($fontsize * $zdepth)}]
                if {abs($newsize) >= 4} {
                        $c itemconfigure $i \
                                -font [lreplace $font 1 1 $newsize] \
                                -text $text
                } {
                        $c itemconfigure $i -text {}
                }
        }
        set bbox [$c bbox all]
        if {[llength $bbox]} {
                $c configure -scrollregion $bbox
        } {
                $c configure -scrollregion [list -4 -4 \
                        [expr {[winfo width $c]-4}] \
                        [expr {[winfo height $c]-4}]]
        }
}

itcl::body graph_window::check_button_state {} {
        $itk_component(menu) menuconfigure .zoom.zoom_in -state normal
        $itk_component(menu) menuconfigure .zoom.zoom_out -state normal
        if { [$itk_component(mscale) cget -to] <=  [$itk_component(mscale) get] } {
                 $itk_component(menu) menuconfigure .zoom.zoom_in -state disabled
        }
        if { [$itk_component(mscale) cget -from] >=  [$itk_component(mscale) get] } {
                $itk_component(menu) menuconfigure .zoom.zoom_out -state \
                    disabled
        }
}

itcl::body graph_window::scale_zoom {f} {
        $this zoom [expr pow($scale_factor, $f - $last_scale)]
}

itcl::body graph_window::nodes_show_connections {} {
        $itk_component(edges) deselect_all
        set nod {}
        foreach n [$this get_nodes] { 
                foreach e [lsearch -all -regexp $edges_list $n] {
                        $itk_component(edges) select $e
                        set t [split [lindex $edges_list $e] "->"]
                        if {[lindex $t 0] == $n} {
                                set nd [lindex $t 2]
                        } else {
                                set nd [lindex $t 0]
                        }
                        lappend nod [lsearch -all $nodes_list $nd]
                }
        }
        foreach n $nod {
                $itk_component(nodes) select $n
        }
}

itcl::body graph_window::export {} {
        global PROJECT
#        set formats [list ps mif hpgl plain dot gif ismap]
        set formats [list dot fig gif mif png pic plain ps svg]
        if {[set e [create_export_graph_dialog $itk_option(-dotgraph) \
                                                        $formats]] != ""} {
                for {set i 0} {$i <= [llength $formats]} {incr i} {
                        if {[lindex [lindex $e 1] $i] == "1"} {
                                puts "Created $PROJECT(DIR)/[lindex $e \
                                        0].[lindex $formats $i] file"
                                set t [open "$PROJECT(DIR)/[lindex $e \
                                        0].[lindex $formats $i]" a+]
                                $graph write $t "[lindex $formats $i]"
                                close $t
                        }
                }
        }
}

##
# @brief Creates the Graph window
#
# @param dotfile the path of the .dot file
# @param title the title of the window 
#
proc create_graph_window {dotfile title} {
        global BSPEC
        set g [file tail [file rootname $dotfile]]
        graph_window .$g -dotgraph $dotfile -title $title
        wm geometry .$g 800x610+530+250
        wm minsize .$g 800 610
        lappend BSPEC(GRAPHS) .$g
}

##
# @brief Creates a New Graph window
#
# @param dotgraph the new graph id
#
proc create_new_graph_window {dotgraph} {
        global BSPEC
        set ng ".gr$BSPEC(NEW_GRAPH_ID)"
        graph_window $ng -dotgraph $dotgraph -title "New Graph" 
        wm geometry $ng 800x610+530+250
        wm minsize $ng 800 610
        lappend BSPEC(GRAPHS) $ng
        incr BSPEC(NEW_GRAPH_ID)
}

## Local Variables:
## eval: (set (make-local-variable 'tcl-indent-level) 8)
## End:
