##
# @file import_bvi_wizard.tcl
#
# @brief Definition of the Import BVI Wizard window.
#

##############################################################################
#################### Setting values into the wizard fields ###################
##############################################################################

itcl::body import_bvi_wizard::set_add_verilog_input_field \
                                                {id name type range parent} {
        if {$parent != ""} {
                focus [$itk_component(vi_$name\_ent_$id) component entry]
                set fr $itk_component(vi_$name\_fr_$id)
                pack $fr -after $itk_component($parent)
                set verilog_input [linsert $verilog_input [expr \
                [lsearch $verilog_input $parent] +1] "vi_$name\_fr_$id"]
        } else {
                if {$type == "clock"} {
                        $itk_component(vi_$name\_rb_$id) select 0
                } elseif {$type == "clock_gate"} {
                        $itk_component(vi_$name\_rb_$id) select 1
                } elseif {$type == "reset"} {
                        $itk_component(vi_$name\_rb_$id) select 2
                } else {
                        $itk_component(vi_$name\_rb_$id) select 3
                }
                lappend verilog_input "vi_$name\_fr_$id"
                $itk_component(vi_$name\_ent_$id) insert 0 $name
                $itk_component(vi_$name\_ent_$id) configure -state disabled
                $itk_component(vi_$name\_rent_$id) insert 0 $range
                $itk_component(vi_$name\_rent_$id) configure -state disabled
        }
}

itcl::body import_bvi_wizard::set_add_verilog_output_field \
                                                {id name type range parent} {
        if {$parent != ""} {
                focus [$itk_component(vo_$name\_ent_$id) component entry]
                set fr $itk_component(vo_$name\_fr_$id)
                pack $fr -after $itk_component($parent)
                set verilog_output [linsert $verilog_output [expr \
                [lsearch $verilog_output $parent] +1] "vo_$name\_fr_$id"]
        } else {
                if {$type == "clock"} {
                        $itk_component(vo_$name\_rb_$id) select 0
                } elseif {$type == "clock_gate"} {
                        $itk_component(vo_$name\_rb_$id) select 1
                } elseif {$type == "reset"} {
                        $itk_component(vo_$name\_rb_$id) select 2
                } elseif {$type == "registered"} {
                        $itk_component(vo_$name\_rb_$id) select 3
                } else {
                        $itk_component(vo_$name\_rb_$id) select 4
                }
                lappend verilog_output "vo_$name\_fr_$id"
                $itk_component(vo_$name\_ent_$id) insert 0 $name
                $itk_component(vo_$name\_ent_$id) configure -state disabled
                $itk_component(vo_$name\_rent_$id) insert 0 $range
                $itk_component(vo_$name\_rent_$id) configure -state disabled
        }
}

itcl::body import_bvi_wizard::set_add_verilog_inout_field \
                                                {id name range parent} {
        if {$parent != ""} {
                focus [$itk_component(vio_$name\_entv_$id) component entry]
                set fr $itk_component(vio_$name\_fr_$id)
                pack $fr -after $itk_component($parent)
                set verilog_inout [linsert $verilog_inout [expr \
                [lsearch $verilog_inout $parent] +1] "vio_$name\_fr_$id"]
        } else {
                lappend verilog_inout "vio_$name\_fr_$id"
                $itk_component(vio_$name\_entv_$id) insert 0 $name
                $itk_component(vio_$name\_entv_$id) configure -state disabled
                $itk_component(vio_$name\_entr_$id) insert 0 $range
                $itk_component(vio_$name\_entr_$id) configure -state disabled
        }
}

itcl::body import_bvi_wizard::set_bluespec_module_name {name} {
        $itk_component(bmn) clear 
        $itk_component(bmn) insert 0 $name
}

itcl::body import_bvi_wizard::set_bluespec_interface_name {name} {
        $itk_component(bmi) clear
        $itk_component(bmi) insert 0 $name
}

itcl::body import_bvi_wizard::set_interface_type {type screen} {
        if {$screen == "bmfr"} {
                if {$type == "dfm"} {
                        $itk_component(bmb_bt) configure -state disabled
                } elseif {$type == "ue"} {
                        $itk_component(bmb_bt) configure -state normal
                }
        } elseif {$screen == "mpfr"} {
                if {$type == "dfm"} {
                        $itk_component(bmirb) select 0
                        $itk_component(mpb_bt) configure -state disabled
                        $itk_component(build_skelet) configure -state disabled
                        $itk_component(auto_create) configure -state normal
                } elseif {$type == "ue"} {
                        $itk_component(bmirb) select 1
                        $itk_component(mpb_bt) configure -state normal
                        $itk_component(build_skelet) configure -state normal
                        $itk_component(auto_create) configure -state disabled
                }
        }
}

itcl::body import_bvi_wizard::set_subinterface_type {type id} {
        if {$type == "dfm"} {
                $itk_component(mb_subbsk_bt_$id) configure -state disabled
                $itk_component(bmb_sirb_mb_bt_$id) configure -state disabled
        } elseif {$type == "ue"} {
                $itk_component(mb_subbsk_bt_$id) configure -state normal
                $itk_component(bmb_sirb_mb_bt_$id) configure -state normal
        }
}

itcl::body import_bvi_wizard::set_bluespec_package_import_list {name} {
	global PROJECT
	global env
	set plist ""
	foreach i [regsub -all "%" $PROJECT(PATHS) "$env(BLUESPECDIR)"] {
		set f [lsort [glob -nocomplain -directory $i *.bo]]
		if {$f == ""} {
			continue
		}
		foreach i $f {
			lappend plist [file rootname [file tail $i]]
		}
		lappend plist "--------------------"
	}
	foreach i $plist {
                $itk_component($name).[regsub "_fr_" $name "_cmb_"] \
                        insert list end $i
	}
        focus [$itk_component($name).[regsub "_fr_" $name "_cmb_"] \
                component entry]
}

itcl::body import_bvi_wizard::set_bluespec_input_clock_field \
                                                {fr frt name id parent} {
        set frb [regsub "_frt_" $frt "_frb_"]
        set clock ""
        set clock_gate ""
        foreach l [get_verilog_input] {
                if {[lindex $l 2] == "clock"} {
                        lappend clock [lindex $l 0]
                } elseif {[lindex $l 2] == "clock_gate"} {
                        lappend clock_gate [lindex $l 0]
                }
        }
        foreach c [lsort $clock] {
                $frt.bic_$name\_vccmb_$id insert list end $c
        }
        $frt.bic_$name\_vccmb_$id insert list end "no_clock"
        $frt.bic_$name\_vccmb_$id insert list end "/* empty */"
        foreach cg [lsort $clock_gate] {
                $frb.bic_$name\_vcgcmb_$id insert list end $cg
        }
        $frb.bic_$name\_vcgcmb_$id insert list end "/* empty */"
        if {[lsearch $clock $name] != -1} {
                $frt.bic_$name\_vccmb_$id insert entry end $name
        }
        if {$parent != ""} {
                pack $fr -after $parent
        } else {
                $itk_component(bic_$name\_ent_$id) insert 0 clk_$name
        }
        # readonly
        $frt.bic_$name\_vccmb_$id configure -editable readonly \
                -selectioncommand "$this empty_combobox \
                $frt.bic_$name\_vccmb_$id"
        $frb.bic_$name\_vcgcmb_$id configure -editable readonly \
                -selectioncommand "$this empty_combobox \
                $frb.bic_$name\_vcgcmb_$id"
        focus [$itk_component(bic_$name\_ent_$id) component entry]
}

itcl::body import_bvi_wizard::set_bluespec_input_clock_default {name} {
        foreach i $bluespec_input_clock {
                if {[$itk_component([regsub "_fr_" $i "_frt_"]).[regsub \
                                "_fr_" $i "_vccmb_"] \
                        get] == $name} {
                        $itk_component([regsub "_fr_" $i "_frr_"]).[regsub \
                                "_fr_" $i "_chb_"] select
                }
        }
}

itcl::body import_bvi_wizard::select_default_clock {} {
        foreach i $bluespec_input_clock {
                $itk_component([regsub "_fr_" $i "_frr_"]).[regsub "_fr_" \
                        $i "_chb_"] deselect
        }
}

itcl::body import_bvi_wizard::set_bluespec_input_reset_field \
                                                {fr frt name id parent} {
        set frb [regsub "_frt_" $frt "_frb_"]
        set reset ""
        foreach l [get_verilog_input] {
                if {[lindex $l 2] == "reset"} {
                        lappend reset [lindex $l 0]
                }
        }
        foreach r [lsort $reset] {
                $frt.bir_$name\_vrcmb_$id insert list end $r
        }
        $frt.bir_$name\_vrcmb_$id insert list end "no_reset"
        $frt.bir_$name\_vrcmb_$id insert list end "/* empty */"
        if {[lsearch $reset $name] != -1} {
                $frt.bir_$name\_vrcmb_$id insert entry end $name
        }
        if {$parent != ""} {
                pack $fr -after $parent
        } elseif {[lsearch $reset $name] == -1} {
                $itk_component(bir_$name\_ent_$id) insert 0 $name
        } else {
                $itk_component(bir_$name\_ent_$id) insert 0 rst_$name
        }
        $frt.bir_$name\_vrcmb_$id configure -editable readonly \
                -selectioncommand "$this empty_combobox \
                $frt.bir_$name\_vrcmb_$id"
        set ent [$frb.bir_$name\_bccmb_$id get]
        $frb.bir_$name\_bccmb_$id clear
        set count 0
        foreach bc [lsort -index 0 [get_bluespec_input_clock]] {
                incr count
                $frb.bir_$name\_bccmb_$id insert list end [lindex $bc 0]
        }
        if {$count == 1} {
                $frb.bir_$name\_bccmb_$id insert entry 0 [lindex [lindex \
                        [get_bluespec_input_clock] 0] 0]
        } else {
                $frb.bir_$name\_bccmb_$id insert entry 0 $ent
        }
        $frb.bir_$name\_bccmb_$id configure -editable readonly
        focus [$itk_component(bir_$name\_ent_$id) component entry]
}

itcl::body import_bvi_wizard::set_bluespec_inout_field {name id parent} {
        set p bi_$name\_fr_$id
        if {$parent != ""} {
                pack $itk_component($p) -after $parent
        }
        set_bluespec_inout_verilog_port $p
        set_bluespec_inout_bluespec_clock $p
        set_bluespec_inout_bluespec_reset $p
        focus [$itk_component($p).bi_$name\_ivpcmb_$id component entry]
}

itcl::body import_bvi_wizard::set_bluespec_input_reset {} {
        foreach p $bluespec_input_reset {
                set count 0
                set cmb $itk_component([regsub "_fr_" $p "_frb_"]).[regsub \
                        "_fr_" $p "_bccmb_"]
                set ent [$cmb get]
                $cmb clear
                foreach bc [lsort -index 0 [get_bluespec_input_clock]] {
                        incr count
                        $cmb insert list end [lindex $bc 0]
                }
                if {$count == 1} {
                        $cmb insert entry 0 [lindex [lindex \
                                [get_bluespec_input_clock] 0] 0]
                } else {
                        $cmb insert entry 0 $ent
                }
                $cmb configure -editable readonly
        }
}

# set the verilog parameter in the BDW module window.
# used for testing/debug
itcl::body import_bvi_wizard::set_parameter_expression {parameter expression} {
        set fr bpb_${parameter}_entbe_0
        if { [info exist itk_component($fr) ] } {
                set c $itk_component($fr)
                $c insert 0 $expression
        } else {
                error "No such parameter name: $parameter"
        }
}

itcl::body import_bvi_wizard::set_bluespec_inout_verilog_port {p} {
        set count 0
        set ent [$itk_component($p).[regsub "_fr_" $p "_ivpcmb_"] get]
        $itk_component($p).[regsub "_fr_" $p "_ivpcmb_"] clear
        foreach i [lsort -index 0 [get_verilog_inout]] {
                $itk_component($p).[regsub "_fr_" $p "_ivpcmb_"] insert list \
                        end [lindex $i 0]
                incr count
        }
        if {$count == 1} {
                $itk_component($p).[regsub "_fr_" $p "_ivpcmb_"] insert entry \
                        0 [lindex [lindex [get_verilog_inout] 0] 0]
        } else {
                $itk_component($p).[regsub "_fr_" $p "_ivpcmb_"] insert entry \
                        0 $ent
        }
        $itk_component($p).[regsub "_fr_" $p "_ivpcmb_"] configure \
                -editable readonly
}

itcl::body import_bvi_wizard::set_bluespec_inout_bluespec_clock {p} {
        set count 0
        set ent [$itk_component($p).[regsub "_fr_" $p "_ibccmb_"] get]
        $itk_component($p).[regsub "_fr_" $p "_ibccmb_"] clear
        foreach i [lsort -index 0 [get_bluespec_input_clock]] {
                $itk_component($p).[regsub "_fr_" $p "_ibccmb_"] insert list \
                        end [lindex $i 0]
                incr count
        }
        if {$count == 1} {
                $itk_component($p).[regsub "_fr_" $p "_ibccmb_"] insert entry \
                        0 [lindex [lindex [get_bluespec_input_clock] 0] 0]
        } else {
                $itk_component($p).[regsub "_fr_" $p "_ibccmb_"] insert entry \
                        0 $ent
        }
        $itk_component($p).[regsub "_fr_" $p "_ibccmb_"] configure \
                -editable readonly
}

itcl::body import_bvi_wizard::set_bluespec_inout_bluespec_reset {p} {
        set count 0
        set ent [$itk_component($p).[regsub "_fr_" $p "_ibrcmb_"] get]
        $itk_component($p).[regsub "_fr_" $p "_ibrcmb_"] clear
        foreach i [lsort -index 0 [get_bluespec_input_reset]] {
                $itk_component($p).[regsub "_fr_" $p "_ibrcmb_"] insert list \
                        end [lindex $i 0]
                incr count
        }
        if {$count == 1} {
                $itk_component($p).[regsub "_fr_" $p "_ibrcmb_"] insert entry \
                        0 [lindex [lindex [get_bluespec_input_reset] 0] 0]
        } else {
                $itk_component($p).[regsub "_fr_" $p "_ibrcmb_"] insert entry \
                        0 $ent
        }
        $itk_component($p).[regsub "_fr_" $p "_ibrcmb_"] configure \
                -editable readonly
}

itcl::body import_bvi_wizard::set_bluespec_inout {} {
        foreach p $bluespec_inout {
                set_bluespec_inout_verilog_port $p
                set_bluespec_inout_bluespec_clock $p
                set_bluespec_inout_bluespec_reset $p
        }
}

itcl::body import_bvi_wizard::set_bluespec_input_reset_default {name} {
        foreach i $bluespec_input_reset {
                if {[$itk_component([regsub "_fr_" $i "_frt_"]).[regsub \
                                "_fr_" $i "_vrcmb_"] get] == $name} {
                        $itk_component([regsub "_fr_" $i "_frr_"]).[regsub \
                                "_fr_" $i "_chb_"] select
                }
        }
}

itcl::body import_bvi_wizard::select_default_reset {} {
        foreach i $bluespec_input_reset {
                $itk_component([regsub "_fr_" $i "_frr_"]).[regsub "_fr_" \
                        $i "_chb_"] deselect
        }
}

itcl::body import_bvi_wizard::set_bluespec_module_window {} {
        set bluespec_parameter_binding ""
        foreach i [get_verilog_parameter] {
                add_bluespec_parameter_binding [lindex $i 0]
        }
        foreach i $bluespec_input_clock {
                set vccmb $itk_component([regsub "_fr_" $i "_frt_"]).[regsub \
                        "_fr_" $i "_vccmb_"]
                set vcgcmb $itk_component([regsub "_fr_" $i "_frb_"]).[regsub \
                        "_fr_" $i "_vcgcmb_"]
                set e1 [$vccmb get]
                set e2 [$vcgcmb get]
                $vccmb clear
                $vcgcmb clear
                foreach c [get_verilog_input] {
                        if {[lindex $c 2] == "clock"} {
                                $vccmb insert list end [lindex $c 0]
                        } elseif {[lindex $c 2] == "clock_gate"} {
                                $vcgcmb insert list end [lindex $c 0]
                        }
                }
                $vccmb insert list end "no_clock"
                $vccmb insert list end "/* empty */"
                $vcgcmb insert list end "/* empty */"
                $vccmb insert entry 0 $e1
                $vcgcmb insert entry 0 $e2
        }
        foreach i $bluespec_input_reset {
                set vrcmb $itk_component([regsub "_fr_" $i \
                        "_frt_"]).[regsub "_fr_" $i "_vrcmb_"]
                set e [$vrcmb get]
                $vrcmb clear
                foreach c [get_verilog_input] {
                        if {[lindex $c 2] == "reset"} {
                                $vrcmb insert list end [lindex $c 0]
                        }
                }
                $vrcmb insert list end "no_reset"
                $vrcmb insert list end "/* empty */"
                $vrcmb insert entry 0 $e
        }
        foreach i $bluespec_parameter_binding_temp {
                destroy $itk_component($i)
        }
        set_bluespec_inout
        set bluespec_parameter_binding_temp ""
}

itcl::body import_bvi_wizard::set_bluespec_module_values {} {
        set bluespec_parameter_binding ""
        set bluespec_input_clock ""
        set bluespec_input_reset ""
        foreach i [get_verilog_parameter] {
                add_bluespec_parameter_binding [lindex $i 0]
        }
        foreach i [get_verilog_input] {
                if {[lindex $i 2] == "clock"} {
                        add_bluespec_input_clock_field [lindex $i 0]
                }
        }
        set bool 1
        foreach i [get_verilog_input] {
                if {[lindex $i 2] == "reset"} {
                        set bool 0
                        add_bluespec_input_reset_field [lindex $i 0]
                }
        }
        if {$bool} {
                add_bluespec_input_reset_field rst
        }
        $itk_component(bmn) insert 0 "mk[get_verilog_module_name]"
}

itcl::body import_bvi_wizard::set_method_port_interface_size {parent type \
                                                        action frame} {
        if {$frame == ""} {
                set id [lindex [split $parent _] end]
                set frame $itk_component(mb_subi_propagate_$id)
                set level [get_propagate_level "mb_subi_propagate_$id"]
                set dif 36
        } elseif {$frame == $itk_component(mpi_propagate_0)} {
                set level 0
                set dif 20
        } else {
                set id [lindex [split $frame _] end]
                set level [get_propagate_level "mb_subi_propagate_$id"]
                set dif 20
        }
        set level [expr $dif + $level * $dif]
        switch $type {
                port {
                        set size 141
                        set height [expr [$frame cget -height] $action $size]
                }
                method {
                        set size 201
                        set height [expr [$frame cget -height] $action $size]
                }
                interface {
                        set size 316
                        set height [expr [$frame cget -height] $action $size]
                }
                default {
                        set height [$frame cget -height]
                }
        }
        set width [expr $current_width - $level]
        $frame configure -width $width -height $height
}

itcl::body import_bvi_wizard::set_method_port_window {} {
        if {[$itk_component(bmirb) get] == "bmirdfm"} {
                $itk_component(mb_rb) select 0
        } else {
                $itk_component(mb_rb) select 1
        }
        $itk_component(mpi) clear
        $itk_component(mpi) insert 0 [get_bluespec_interface_name]
        foreach i $port_binding {
                set cmb $itk_component($i).[regsub "_fr_" $i "_pbecmb_"]
                set v [$cmb get]
                $cmb clear list
                foreach l [get_bluespec_parameter_binding] {
                        $cmb insert list end [lindex $l 1]
                }
                $cmb insert entry end $v
        }
        foreach i $method_bindings {
                set id [lindex [split [lindex $i 0] "_"] end]
                set_method_binding_settings $id
                set name [lindex $i 2]
                set f [$itk_component(mb_avmsfr_$id) childsite]
                foreach a $METHOD_BINDING_ARGS($f) {
			set cmb $itk_component($a).[join [lreplace \
                                [split $a _] end-1 end-1 vncmb] "_"]
                        set e [$cmb get]
                        $cmb clear
                        foreach p [get_verilog_input] {
                                if {[lindex $p 2] != "clock" && \
                                        [lindex $p 2] != "reset"} {
                                        set l [format "%s /* %s */" \
                                                [lindex $p 0] [lindex $p 1]]
                                        $cmb insert list end $l
                                }
                        }
                        $cmb insert entry end $e
                        set list [get_verilog_input]
                        if {[lsearch -index 0 $list $name] != -1} {
                                set ent $itk_component([regsub "_$name\_fr_" \
                                        $a "_$name\_ent_"])
                                set e [$ent get]
                                $ent clear 
                                $ent insert end $e
                        }
                }
        }
}

itcl::body import_bvi_wizard::set_value_method_default {name id} {
        set output [get_verilog_output]
        set param [get_verilog_parameter]
        set fields [lsearch -inline -index 0 $output $name]
        set range [create_bsv_type [lindex $fields 1]]
        if {[lindex $fields 1] == "0 : 0"} {
                $itk_component(mb_rtrsfr_$id).mb_returnp_cmb_$id component \
                        entry insert 0 $name
        } else {
                $itk_component(mb_rtrsfr_$id).mb_returnp_cmb_$id component \
                        entry insert 0 [format "%s /* %s */" $name \
                        [lindex $fields 1]]
        }
        $itk_component(mb_returnt_ent_$id) clear
        $itk_component(mb_returnt_ent_$id) insert 0 $range
}

itcl::body import_bvi_wizard::set_method_default_clock_reset {id} {
        set dc [get_bluespec_input_clock_default]
        if {$dc != "no_clock"} {
                $itk_component(mb_cbrbfr_$id).mb_clock_cmb_$id clear entry
                $itk_component(mb_cbrbfr_$id).mb_clock_cmb_$id \
                        component entry insert 0 $dc
        }
        set dr [get_bluespec_input_reset_default]
        if {$dr != "no_reset"} {
                $itk_component(mb_cbrbfr_$id).mb_reset_cmb_$id clear entry
                $itk_component(mb_cbrbfr_$id).mb_reset_cmb_$id \
                        component entry insert 0 $dr
        }
}

itcl::body import_bvi_wizard::set_method_binding_settings {id} {
        set co $itk_component(mb_enrefr_$id)
        set c [$co.mb_enable_cmb_$id get]
        $co.mb_enable_cmb_$id clear
        foreach i [get_verilog_input] {
                if {[lindex $i 2] != "clock" && [lindex $i 2] != "reset" && \
                                [lindex $i 1] == "0 : 0"} {
                        $co.mb_enable_cmb_$id insert list end [lindex $i 0]
                }
        }
        $co.mb_enable_cmb_$id sort ascending
        $co.mb_enable_cmb_$id insert list end "always enabled"
        $co.mb_enable_cmb_$id insert entry end $c

        set c [$co.mb_ready_cmb_$id get]
        $co.mb_ready_cmb_$id clear
        foreach i [get_verilog_output] {
                if {[lindex $i 2] != "clock" && [lindex $i 2] != "reset" && \
                                [lindex $i 1] == "0 : 0"} {
                        $co.mb_ready_cmb_$id insert list end [lindex $i 0]
                }
        }
        $co.mb_ready_cmb_$id sort ascending
        $co.mb_ready_cmb_$id insert list end "always ready"
        $co.mb_ready_cmb_$id insert entry end $c

        set cr $itk_component(mb_rtrsfr_$id)
        set c [$cr.mb_returnp_cmb_$id get]
        $cr.mb_returnp_cmb_$id clear
        foreach i [get_verilog_output] {
                if {[lindex $i 2] != "clock" && [lindex $i 2] != "reset"} {
                        if {[lindex $i 1] == "0 : 0"} {
                                $cr.mb_returnp_cmb_$id insert list end \
                                        [lindex $i 0]
                        } else {
                                $cr.mb_returnp_cmb_$id insert list end [format \
                                      "%s /* %s */" [lindex $i 0] [lindex $i 1]]
                        }
                }
        }
        $cr.mb_returnp_cmb_$id sort ascending
        $cr.mb_returnp_cmb_$id insert entry end $c

	set cb $itk_component(mb_cbrbfr_$id)
        set c [$cb.mb_clock_cmb_$id get]
        $cb.mb_clock_cmb_$id clear
        foreach i [get_bluespec_input_clock] {
                $cb.mb_clock_cmb_$id insert list end [lindex $i 0]
        }
	$cb.mb_clock_cmb_$id sort ascending
	$cb.mb_clock_cmb_$id insert list end "noClock"
	$cb.mb_clock_cmb_$id insert entry end $c

        set c [$cb.mb_reset_cmb_$id get]
        $cb.mb_reset_cmb_$id clear
        foreach i [get_bluespec_input_reset] {
                $cb.mb_reset_cmb_$id insert list end [lindex $i 0]
        }
	$cb.mb_reset_cmb_$id sort ascending
	$cb.mb_reset_cmb_$id insert list end "noReset"
	$cb.mb_reset_cmb_$id insert entry end $c
}

itcl::body import_bvi_wizard::set_create_method_bindings {id name parent type} {
        if {$name == ""} {
                set name "unknown"
        	set text "method "
        } else {
                set cs [$itk_component(mb_avmsfr_$id) childsite]
                if {$type == "action"} {
                        set list [get_verilog_input]
                        if {[lsearch -index 0 $list $name] != -1} {
                                set fields [lsearch -inline -index 0 \
                                        $list $name]
                                set r [create_bsv_type [lindex $fields 1]]
                                if {$r == "Bool"} {
                                        $itk_component(mb_enrefr_$id).mb_enable_cmb_$id clear entry
                                        $itk_component(mb_enrefr_$id).mb_enable_cmb_$id insert entry end $name
                                } else {
                                        add_method_binding_args_field $cs $name
                                }
                        }
                }
        	set text "method $name"
	}
        set ch $itk_component(port_meth_ifc)
        if {$type == "action"} {
                $itk_component(mb_method_name_$id) insert 0 i
                set text "[lindex $text 0] i[lindex $text 1]"
        } elseif {$type == "value"} {
                $itk_component(mb_method_name_$id) insert 0 o
                set text "[lindex $text 0] o[lindex $text 1]"
        }
        insert_method_after_parent $id $text $parent $name
        if {$name == "unknown"} {
                $ch select mb_mb_ch_$id
        } else {
                $ch deselect mb_mb_ch_$id
        }
        if {$name != "unknown"} {
                $itk_component(mb_method_name_$id) insert end $name
        }
        $ch buttonconfigure mb_mb_ch_$id -command "$this \
        show_method_port_ifc mb_mb_ch_$id mb_mb_fr_$id method_bindings $parent"
        $itk_component(mp_addmeth_bt) configure -state normal
}

itcl::body import_bvi_wizard::set_create_interface_bindings {id name parent} {
        if {$name == ""} {
                set name "unknown"
        	set text "interface "
        } else {
        	set text "interface $name"
	}
        set ch $itk_component(port_meth_ifc)
        if {$parent != ""} {
                set n [$itk_component([regsub "_fr_" $parent "_name_"]) get]
                if {$n != ""} {
                        $itk_component(mb_subi_name_$id) insert 0 $n\_
                        set text "[lindex $text 0] $n\_[lindex $text 1]"
                }
        }
        insert_interface_after_parent $id $text $parent
        if {$name == "unknown"} {
                $ch select mb_subi_ch_$id
        } else {
                $ch deselect mb_subi_ch_$id
        }
        $ch buttonconfigure mb_subi_ch_$id -command "$this \
        show_method_port_ifc mb_subi_ch_$id mb_subi_fr_$id interface_binding \
                $parent"
        $itk_component(mp_addmeth_bt) configure -state normal
}

itcl::body import_bvi_wizard::select_all_bindings {} {
        start_process
        set ifc $interface_binding
        set list [$itk_component(port_meth_ifc) get]
        $itk_component(port_meth_ifc) select_all
        foreach i [$itk_component(port_meth_ifc) get_buttons] {
                if {[lsearch $list $i] == -1} {
                        set c [regsub "_ch_" $i "_fr_"]
                        set id [lsearch -index 0 $ifc $c]
                        if {$id != -1} {
                                set parent [lindex [lindex $ifc $id] 1]
                                if {$parent != "no_parent"} {
                                        set_method_port_interface_size $parent \
                                                "interface" "+" ""
                                } else {
                                        set_method_port_interface_size "" \
                                                "interface" "+" \
                                                $itk_component(mpi_propagate_0)
                                }
                        } else {
                                set parent ""
                                foreach i $ifc {
                                        set id [lsearch $ifc $i]  
                                        if {[set ind [lsearch $i $c]] != -1} {
                                                set parent [lindex [lindex \
                                                      $ifc $id] 0]
                                                break
                                        }
                                }
                                if {$parent != ""} {
                                        set_method_port_interface_size $parent \
                                                "method" "+" ""
                                } else {
                                        set_method_port_interface_size "" \
                                                "method" "+" \
                                                $itk_component(mpi_propagate_0)
                                }
                        }
                        pack $itk_component($c) -expand true -fill both
                }
        }
        finish_process
}

itcl::body import_bvi_wizard::hide_unused_ports {} {
        set frac [$itk_component(mppane) fraction] 
        set pmif [lindex $frac 0]
        if {$pmif == 0} {
                $itk_component(mppane) fraction 0 100 0
        } else {
                $itk_component(mppane) fraction $pmif [expr 100 - $pmif] 0
        }
}

itcl::body import_bvi_wizard::calculate_unused_ports {all_ports} {
        set input_list [lindex $all_ports 0]
        set output_list [lindex $all_ports 1]
        set inout_list [lindex $all_ports 2]
        foreach l [get_method_binding] {
                if {[set ind [lsearch $input_list [lindex $l 3]]] != -1} {
                        set input_list [lreplace $input_list $ind $ind]
                }
                foreach a [lindex $l 9] {
                        set arg [lindex [lindex $a 1] 0]
                        if {[set ind [lsearch $input_list $arg]] != -1} {
                                set input_list [lreplace $input_list $ind $ind]
                        }
                }
                if {[set ind [lsearch $output_list [lindex $l 4]]] != -1} {
                        set output_list [lreplace $output_list $ind $ind]
                }
                if {[set ind [lsearch $output_list [lindex [lindex $l \
                                                                6] 0]]] != -1} {
                        set output_list [lreplace $output_list $ind $ind]
                }
        }
        foreach l [get_port_binding] {
                if {[set ind [lsearch $input_list [lindex [lindex $l \
                                0] 0]]] != -1} {
                        set input_list [lreplace $input_list $ind $ind]
                }
        }
        foreach l [get_interface_binding] {
                if {[set ind [lsearch $inout_list [lindex $l 1]]] != -1} {
                        set inout_list [lreplace $inout_list $ind $ind]
                }
        }
        return [list $input_list $output_list $inout_list]
}

itcl::body import_bvi_wizard::show_unused_inputs_outputs_inouts {list} {
        set input_list [lindex $list 0]
        set output_list [lindex $list 1]
        set inout_list [lindex $list 2]
        if {[llength $input_list] != 0} {
                $itk_component(mp_up_slb) insert end \
                        "----------------------------------------"
                $itk_component(mp_up_slb) insert end "--unused input port(s)--"
                $itk_component(mp_up_slb) insert end \
                        "----------------------------------------"
        }
        foreach i [lsort $input_list] {
                $itk_component(mp_up_slb) insert end $i
        }
        if {[llength $output_list] != 0} {
                $itk_component(mp_up_slb) insert end \
                        "------------------------------------------"
                $itk_component(mp_up_slb) insert end "--unused output port(s)--"
                $itk_component(mp_up_slb) insert end \
                        "------------------------------------------"
        }
        foreach o [lsort $output_list] {
                $itk_component(mp_up_slb) insert end $o
        }
        if {[llength $inout_list] != 0} {
                $itk_component(mp_up_slb) insert end \
                        "----------------------------------------"
                $itk_component(mp_up_slb) insert end "--unused inout port(s)--"
                $itk_component(mp_up_slb) insert end \
                        "----------------------------------------"
        }
        foreach io [lsort $inout_list] {
                $itk_component(mp_up_slb) insert end $io
        }
}

itcl::body import_bvi_wizard::show_number_methods_subinterfaces {} {
        set mb_count 0
        set subi_count 0
        foreach i [$itk_component(port_meth_ifc) get_buttons] {
                switch [lindex [split $i _] 1] {
                        mb {incr mb_count}
                        subi {incr subi_count}
                }
        }
        $itk_component(mp_up_slb) insert end "--methods--" 
        $itk_component(mp_up_slb) insert end $mb_count
        $itk_component(mp_up_slb) insert end "--subinterfaces--" 
        $itk_component(mp_up_slb) insert end $subi_count 
}

itcl::body import_bvi_wizard::show_hierarchy_ports {} {
        set frac [$itk_component(mppane) fraction]
        set sif [lindex $frac 2]
        if {$sif == 0} {
                $itk_component(mppane) fraction 15 85 0
        } else {
                $itk_component(mppane) fraction 15 [expr 100 - $sif - 15] $sif
        }
}

itcl::body import_bvi_wizard::show_info_field {} {
        $itk_component(mp_up_slb) delete 0 end

        set all_ports [get_all_verilog_ports]
        set list [calculate_unused_ports $all_ports]
        show_unused_inputs_outputs_inouts $list
        show_number_methods_subinterfaces

        set frac [$itk_component(mppane) fraction]
        set pmif [lindex $frac 0]
        if {$pmif == 0} {
                $itk_component(mppane) fraction 0 85 15
        } else {
                $itk_component(mppane) fraction $pmif [expr 100 - $pmif - 15] 15
        }
}

itcl::body import_bvi_wizard::deselect_all_bindings {} {
        start_process
        set ifc $interface_binding
        foreach i [$itk_component(port_meth_ifc) get] {
                set c [regsub "_ch_" $i "_fr_"]
                set id [lsearch -index 0 $ifc $c]
                if {$id != -1} {
                        set parent [lindex [lindex $ifc $id] 1]
                        if {$parent != "no_parent"} {
                                set_method_port_interface_size $parent \
                                        "interface" "-" ""
                        } else {
                                set_method_port_interface_size "" "interface" \
                                        "-" $itk_component(mpi_propagate_0)
                        }
                } else {
                        set parent ""
                        foreach i $ifc {
                                set id [lsearch $ifc $i]  
                                if {[set ind [lsearch $i $c]] != -1} {
                                        set parent [lindex [lindex $ifc $id] 0]
                                        break
                                }
                        }
                        if {$parent != ""} {
                                set_method_port_interface_size $parent \
                                        "method" "-" ""
                        } else {
                                set_method_port_interface_size "" "method" "-" \
                                        $itk_component(mpi_propagate_0)
                        }
                }
                pack forget $itk_component($c)
        }
        $itk_component(port_meth_ifc) deselect_all
        finish_process
}

itcl::body import_bvi_wizard::delete_method_port_interface {but} {
        set ch $itk_component(port_meth_ifc)
        $ch delete $but
        set c [regsub "_ch_" $but "_fr_"]
        switch [lindex [split $but _] 1] {
                port {
                        delete_field method_port_bindings $c "port"
                        set_method_port_interface_size "" "port" "-" \
                                $itk_component(mpi_propagate_0) 
                }
                subi {
                        remove_subinterface_from_list $c
                }
                mb {
                        remove_method_from_list $c
                }
        }
}

itcl::body import_bvi_wizard::remove_given_binding {but} {
        set ch $itk_component(port_meth_ifc)
        set x [expr [$ch component $but cget -padx] + 15]
        set new_x $x
        set list [$ch get_buttons]
        for {set i [expr [lsearch $list $but] + 1]} {$i < [llength $list]} \
                                                                {incr i} {
                set b [lindex $list $i]
                set bx [$ch component $b cget -padx]
                if {$bx == $x || $bx == $new_x} {
                        delete_method_port_interface $b
                } else {
                        set new_x [expr $new_x + 15]
                        if {$bx == $new_x} {
                                delete_method_port_interface $b
                        } else {
                                break
                        }
                }
        }
        delete_method_port_interface $but
}

itcl::body import_bvi_wizard::hide_bindings {} {
        set frac [$itk_component(mppane) fraction] 
        set sif [lindex $frac 2]
        if {$sif == 0} {
                $itk_component(mppane) fraction 0 100 0
        } else {
                $itk_component(mppane) fraction 0 [expr 100 - $sif] $sif
        }
}

itcl::body import_bvi_wizard::remove_bindings {} {
        start_process
        foreach i [lreverse [$itk_component(port_meth_ifc) get]] {
                remove_given_binding $i
        }
        finish_process
}

itcl::body import_bvi_wizard::set_combinational_path_window {} {
        foreach i $combinational_path_input {
                for {set id 1} {$id < [llength $i]} {incr id} {
                        set fr [lindex $i $id]
                        set cmb $itk_component($fr).[regsub "_fr_" $fr "_cmb_"]
                        set e [$cmb get]
                        $cmb clear
                        foreach v [get_verilog_input] {
                                $cmb insert list end [lindex $v 0]
                        }
                        $cmb insert entry 0 $e
                }
        }
        foreach i $combinational_path_output {
                for {set id 1} {$id < [llength $i]} {incr id} {
                        set fr [lindex $i $id]
                        set cmb $itk_component($fr).[regsub "_fr_" $fr "_cmb_"]
                        set e [$cmb get]
                        $cmb clear
                        foreach v [get_verilog_output] {
                                $cmb insert list end [lindex $v 0]
                        }
                        $cmb insert entry 0 $e
                }
        }
}

itcl::body import_bvi_wizard::set_new_annotation {n1 n2 id} {
	set name sa_$n1\_$n2
        set frame $itk_component($name\_fr_$id).$name\_cmb_$id
        set new [$frame get]
        if {$new == ""} {
                error_message "\"$n1\" and \"$n2\" methods\
                        annotation is not specified" $win
                focus [$frame component entry]
                return
        }
        if {[lsearch $sched_annotation_list $new] == -1} {
                error_message "Wrong annotation \"$new\" specified for\
                        \"$n1\" and \"$n2\" methods" $win
                $frame clear entry
                focus [$frame component entry]
                return
        }
}

itcl::body import_bvi_wizard::set_scheduling_annotation_window {} {
        set scheduling_annotation ""
        array set  [namespace current]::SCHED_ANNOTATION ""
        destroy $itk_component(safr)
        add_frame $itk_component(frame) safr
        generate_scheduling_annotations
        create_scheduling_annotation_window_left
        add_scrolledframe $itk_component(safr) sa_sfr "Scheduling annotations" \
                left 5 0 true
        pack $itk_component(sa_sfr) -ipady 223
}

itcl::body import_bvi_wizard::set_finish_numbering {} {
        $itk_component(fsnf) configure -state normal
        $itk_component(fsnf) clear 
        set c [expr [lindex [split [$itk_component(fstf) index end] .] 0] - 1]
        for {set i 1} {$i <= $c} {incr i} {
                $itk_component(fsnf) insert end "$i\n"
        }
        $itk_component(fsnf) configure -state disabled \
                -textbackground grey -selectforeground black -width 50
        set w [$itk_component(fstf) component text]
        set c [expr [lindex [split [$w index end] .] 0] - 1]
        for {set i 0} {$i <= $c} {incr i} {
                if {[$w bbox "$i.0"] != ""} {
                        [regsub "frtf.fstf" $w "fltf.fsnf"] yview "$i.0"
                        $w yview "$i.0"
                        break
                }
        }
        set_show_number_binding
}

itcl::body import_bvi_wizard::set_finish_window {} {
        set f [$itk_component(save_to_file) get]
        if {$f == ""} {
                set f "bsv[get_bluespec_module_name]\.bsv"
        }
        $itk_component(save_to_file) clear
        $itk_component(save_to_file) insert 0 $f

        $itk_component(fstf) clear
        $itk_component(fstf) import [get_bluespec_module_name].bsv
}

itcl::body import_bvi_wizard::set_save_file_location {name} {
	$itk_component(save_to_file) clear
	$itk_component(save_to_file) insert 0 $name
}

itcl::body import_bvi_wizard::set_interface {{id ""}} {
        set t ""
        if {$id != ""} {
                set ent mb_subi_type_$id
                set t "Sub "
        } elseif {$current_screen == "mpfr"} {
                set ent "mpi"
        } elseif {$current_screen == "bmfr"} {
                set ent "bmi"
        }
        if {[set i [create_build_skeleton_dialog "Set $t\Interface"]] == ""} {
                return
        }
        $itk_component($ent) clear
        $itk_component($ent) insert 0 $i
}

itcl::body import_bvi_wizard::set_cmb_bindings {cmb} {
        bind [$cmb component entry] <Control-n> {+
                if {[%W get] == "/* empty */"} {
                        set cmb [join [lreplace [split %W .] end-1 end] .]
                        $cmb configure -editable yes
                        $cmb clear entry
                        $cmb configure -editable readonly
                }
        }
        bind [$cmb component entry] <Control-p> {+
                if {[%W get] == "/* empty */"} {
                        set cmb [join [lreplace [split %W .] end-1 end] .]
                        $cmb configure -editable yes
                        $cmb clear entry
                        $cmb configure -editable readonly
                }
        }
        bind [$cmb component entry] <Up> {+
                if {[%W get] == "/* empty */"} {
                        set cmb [join [lreplace [split %W .] end-1 end] .]
                        $cmb configure -editable yes
                        $cmb clear entry
                        $cmb configure -editable readonly
                }
        }
        bind [$cmb component entry] <Down> {+
                if {[%W get] == "/* empty */"} {
                        set cmb [join [lreplace [split %W .] end-1 end] .]
                        $cmb configure -editable yes
                        $cmb clear entry
                        $cmb configure -editable readonly
                }
        }
}

##############################################################################
################### Getting values from the wizard fields ####################
##############################################################################

itcl::body import_bvi_wizard::get_compile_id {} {
        if {$current_screen == "ffr"} {
                return $itk_component(compile)
        }
        return ""
}

itcl::body import_bvi_wizard::get_tab_index {l1} {
        switch [lindex [split $l1 "_"] 1] {
                parameter {return 0}
                input {return 1}
                output {return 2}
                inout {return 3}
        }
}

itcl::body import_bvi_wizard::get_port_frame {list name} {
        set t ""
        if {$list == "verilog_parameter" || $list == "verilog_inout"} {
                set t "v"
        }
        eval set list $$list
        foreach i $list {
                set n [$itk_component([regsub "_fr_" $i "_ent$t\_"]) get]
                if {$name == $n} {
                        return $itk_component([regsub "_fr_" $i "_ent$t\_"])
                }
        }
}

itcl::body import_bvi_wizard::get_verilog_module_name {} {
        return [string trim [$itk_component(vofr).vomn get]]
}

itcl::body import_bvi_wizard::get_verilog_parameter {} {
        set list {}
        foreach p $verilog_parameter {
		set temp {}
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_entv_"]) get]]
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_entr_"]) get]]
                lappend list $temp
        }
        return $list
}

itcl::body import_bvi_wizard::get_verilog_input {} {
        set list {}
        foreach p $verilog_input {
		set temp {}
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_ent_"]) get]]
                set t [string trim [$itk_component([regsub "_fr_" $p \
                        "_rent_"]) get]]
                if {$t == ""} {
                        set t "0 : 0"
                }
                lappend temp $t
                set rbox [$itk_component([regsub "_fr_" $p "_rb_"]) get]
                lappend temp [regsub "vi_" $rbox ""]
                lappend list $temp
        }
        return $list
}

itcl::body import_bvi_wizard::get_verilog_output {} {
        set list {}
        foreach p $verilog_output {
		set temp {}
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_ent_"]) get]]
                set t [string trim [$itk_component([regsub "_fr_" $p \
                        "_rent_"]) get]]
                if {$t == ""} {
                        set t "0 : 0"
                }
                lappend temp $t
                set rbox [$itk_component([regsub "_fr_" $p "_rb_"]) get]
                lappend temp [regsub "vo_" $rbox ""]
                lappend list $temp
        }
        return $list
}

itcl::body import_bvi_wizard::get_verilog_inout {} {
        set list {}
        foreach p $verilog_inout {
		set temp {}
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_entv_"]) get]]
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_entr_"]) get]]
                lappend list $temp
        }
        return $list
}

itcl::body import_bvi_wizard::get_all_verilog_ports {} {
        set input_list {}
        set output_list {}
        set inout_list {}
        foreach i [get_verilog_input] {
                if {[lindex $i 2] != "clock" && [lindex $i 2] != "reset"} {
                        lappend input_list [lindex $i 0]
                }
        }
        foreach i [get_verilog_output] {
                if {[lindex $i 2] != "clock" && [lindex $i 2] != "reset"} {
                        lappend output_list [lindex $i 0]
                }
        }
        foreach i [get_verilog_inout] {
                        lappend inout_list [lindex $i 0]
        }
        return [list $input_list $output_list $inout_list]
}

itcl::body import_bvi_wizard::get_bluespec_module_name {} {
        return [string trim [$itk_component(bmn) get]]
}

itcl::body import_bvi_wizard::get_bluespec_interface_type {} {
        return [$itk_component(bmirb) get]
}

itcl::body import_bvi_wizard::get_bluespec_interface_name {} {
        return [string trim [$itk_component(bmi) get]]
}

itcl::body import_bvi_wizard::get_bluespec_package_import {} {
        set list {}
        foreach p $bluespec_package_import {
                lappend list [string trim [$itk_component($p).[regsub "_fr_" \
                        $p "_cmb_"] get]]
        }
        return $list
}

itcl::body import_bvi_wizard::get_bluespec_provisos {} {
        set list {}
        foreach p $bluespec_provisos {
                lappend list [string trim [$itk_component([regsub "_fr_" $p \
                        "_ent_"]) get]]
        }
        return $list
}

itcl::body import_bvi_wizard::get_bluespec_module_args {} {
        set list {}
        foreach p $bluespec_module_args {
                set temp {}
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_entt_"]) get]]
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_entn_"]) get]]
                lappend list $temp
        }
        return $list
}

itcl::body import_bvi_wizard::get_bluespec_parameter_binding {} {
        set list {}
        foreach p $bluespec_parameter_binding {
                set temp {}
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_entvp_"]) get]]
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_entbe_"]) get]]
                lappend list $temp
        }
        return $list
}

itcl::body import_bvi_wizard::get_bluespec_input_clock {} {
        set list {}
        foreach p $bluespec_input_clock {
                set temp {}
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_ent_"]) get]]
                lappend temp [string trim [$itk_component([regsub "_fr_" $p "_frt_"]).[regsub "_fr_" $p "_vccmb_"] get]]
                lappend temp [string trim [$itk_component([regsub "_fr_" $p "_frb_"]).[regsub "_fr_" $p "_vcgcmb_"] get]]
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_eent_"]) get]]
                lappend list $temp
        }
        return $list
}

itcl::body import_bvi_wizard::get_bluespec_input_clock_default {} {
        set ic "no_clock"
        foreach p $bluespec_input_clock {
                set chbox [regsub "_fr_" $p "_chb_"]
                global $chbox
                eval set c $$chbox
                if {$c == 1} {
                        set ic [string trim [$itk_component([regsub "_fr_" $p \
                                "_ent_"]) get]]
                        return $ic
                }
        }
        return $ic
}

itcl::body import_bvi_wizard::get_bluespec_input_reset {} {
        set list {}
        foreach p $bluespec_input_reset {
                set temp {}
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_ent_"]) get]]

                set vr [string trim [$itk_component([regsub "_fr_" \
                        $p "_frt_"]).[regsub "_fr_" $p "_vrcmb_"] get]]
                if {$vr == ""} {
                        set vr "/* empty */"
                }
                lappend temp $vr
                lappend temp [string trim [$itk_component([regsub "_fr_" \
                        $p "_frb_"]).[regsub "_fr_" $p "_bccmb_"] get]]
                lappend temp [string trim [$itk_component([regsub "_fr_" $p \
                        "_eent_"]) get]]
                lappend list $temp
        }
        return $list
}

itcl::body import_bvi_wizard::get_bluespec_input_reset_default {} {
        set ir "no_reset"
        foreach p $bluespec_input_reset {
                set chbox [regsub "_fr_" $p "_chb_"]
                global $chbox
                eval set c $$chbox
                if {$c == 1} {
                        set ir [string trim [$itk_component([regsub "_fr_" \
                                $p "_ent_"]) get]]
                        return $ir
                }
        }
        return $ir
}

itcl::body import_bvi_wizard::get_bluespec_inout {} {
        set list {}
        foreach p $bluespec_inout {
                set temp {}
                lappend temp [string trim [$itk_component($p).[regsub "_fr_" \
                        $p "_ivpcmb_"] get]]
                lappend temp [string trim [$itk_component($p).[regsub "_fr_" \
                        $p "_ibccmb_"] get]]
                lappend temp [string trim [$itk_component($p).[regsub "_fr_" \
                        $p "_ibrcmb_"] get]]
                lappend temp [string trim [$itk_component([regsub "_fr_" \
                        $p "_ieent_"]) get]]
                lappend list $temp
        }
        return $list
}

itcl::body import_bvi_wizard::get_current_method_id {mn} {
        foreach c $method_bindings {
                set c [lindex $c 0]
                set m $itk_component([regsub "_mb_fr_" $c "_method_name_"])
                if {[$m get] == $mn} {
                        return [lindex [split $c _] end]
                }
        }
}

itcl::body import_bvi_wizard::get_method_binding {} {
	set list {}
	foreach m $method_bindings {
                set m [lindex $m 0]
		set t {}
		set id [lindex [split $m "_"] end]
		lappend t $m 
		lappend t [string trim [$itk_component(mb_method_name_$id) get]]
		lappend t [string trim [$itk_component(mb_method_type_rb_$id) \
                        get]]
		lappend t [string trim \
                        [$itk_component(mb_enrefr_$id).mb_enable_cmb_$id get]]
		lappend t [string trim \
                        [$itk_component(mb_enrefr_$id).mb_ready_cmb_$id get]]
		lappend t [string trim [$itk_component(mb_returnt_ent_$id) get]]
		lappend t [string trim \
                        [$itk_component(mb_rtrsfr_$id).mb_returnp_cmb_$id get]]
		lappend t [string trim \
                        [$itk_component(mb_cbrbfr_$id).mb_clock_cmb_$id get]]
		lappend t [string trim \
                        [$itk_component(mb_cbrbfr_$id).mb_reset_cmb_$id get]]
		set arg_list {}
		set cs [$itk_component(mb_avmsfr_$id) childsite]
		foreach a $METHOD_BINDING_ARGS($cs) {
			set arg {}
			lappend arg [string trim [$itk_component([join \
                                [lreplace [split $a _] end-1 end-1 ent] "_"]) \
                                get]]
			lappend arg [string trim [$itk_component($a).[join \
                                [lreplace [split $a _] end-1 end-1 vncmb] "_"] \
                                get]]
			lappend arg_list $arg
		}
		lappend t $arg_list
		lappend list $t
	}
	return $list
}

itcl::body import_bvi_wizard::get_method_parent {fr} {
        set parent [lindex [lindex $method_bindings [lsearch -index 0 \
                $method_bindings $fr]] 1]
        if {$parent == "no_parent"} {
                return ""
        } else {
                set parent [$itk_component([regsub "_fr_" $parent \
                        "_name_"]) get]
                return "$parent\_"
        }
}

itcl::body import_bvi_wizard::get_port_value {exp} {
        set param [get_verilog_parameter]
        set i [lindex [lindex $param [lsearch -index 0 $param $exp] 1]]
        if {$i == ""} {
                set exp [split $exp "-"]
                foreach e $exp {
                        set e [string trim $e]
                        if {[string is integer $e] == 0} {
                                if {[lsearch -index 0 $param $e] == -1} {
                                        error_message "Undefined parameter\
                                                $e." $win
                                        return "error"
                                }
                                append i "[get_port_value $e] - "
                        } else {
                                append i "$e - "
                        }
                }
                set i [string replace $i end-1 end]
        }
        return $i
}

itcl::body import_bvi_wizard::get_port_binding {} {
        set list {}
        foreach p $port_binding {
                set temp {}
                lappend temp [$itk_component($p).[regsub "_fr_" $p "_pbvcmb_"] \
                        get]
                lappend temp [$itk_component($p).[regsub "_fr_" $p "_pbecmb_"] \
                        get]
                lappend list $temp
        }
        return $list
}

itcl::body import_bvi_wizard::get_interface_binding {} {
        set list {}
        foreach p $interface_binding {
		set temp {}
                set p [lindex $p 0]
                lappend temp $p
                lappend temp [$itk_component([regsub "_fr_" $p "_name_"]) get]
                lappend temp [$itk_component([regsub "_fr_" $p "_type_"]) get]
                lappend list $temp
        }
        return $list
}

itcl::body import_bvi_wizard::get_interface_name {} {
        return [$itk_component(mpi) get]
}

itcl::body import_bvi_wizard::get_propagate_level {frame} {
        return [lindex [lindex $propagate_list [lsearch -index 0 \
                $propagate_list $frame]] 1]
}

itcl::body import_bvi_wizard::get_loaded_interfaces {} {
        set list {}
        foreach p [Bluetcl::bpackage list] {
                foreach a [Bluetcl::defs type $p] {
                        set c [catch {Bluetcl::type constr $a} lo]
                        if {$c == 0} {
                                catch {Bluetcl::type full $lo} il
                                if {[lindex $il 0] == "Interface"} {
                                        set n $lo
                                        if {[lsearch $list $n] == -1} {
                                                lappend list $n
                                        }
                                 }
                        }
                }
        }
        return $list
}

itcl::body import_bvi_wizard::get_combinational_path_input_output {} {
        set list {}
	foreach i $combinational_path_input {
		set p [lindex $i 0]
		set p [regsub "_input_scfr_" $p "_output_scfr_"]
		set ind [lsearch -index 0 $combinational_path_output $p]
		set l [lindex $combinational_path_output $ind]
		for {set ini 1} {$ini < [llength $i]} {incr ini} {
			for {set j 1} {$j < [llength $l]} {incr j} {
				set temp {}
				set fr [lindex $i $ini]
				lappend temp [$itk_component($fr).[regsub \
					"_fr_" $fr "_cmb_"] get]
				set fr [lindex $l $j]
				lappend temp [$itk_component($fr).[regsub \
					"_fr_" $fr "_cmb_"] get]
				lappend list $temp
			}
		}
	}
        return $list
}

itcl::body import_bvi_wizard::get_scheduling_annotation_current_page {action {type 1}} {
        # Get and Check regular expression filters
        set es1 [$itk_component(filterm1) component entry]
        if { [catch "$this check_regexp $es1" pat1] } { return }

        set es2 [$itk_component(filterm2) component entry]
        if { [catch "$this check_regexp $es2" pat2] } { return }

        set m1 [lsearch -regexp -inline -all $methodlist $pat1]
        set m2 [lsearch -regexp -inline -all $methodlist $pat2]

        set matches [list]
        foreach a $m1 {
                foreach b $m2 {
                        foreach k [list $a,$b $b,$a] {
                                set M($k) 1
                        }
                }
        }
        foreach p $methodpairs {
                if { [info exists M($p)] } {
                        lappend matches $p
                }
        }

        set cs1 [$itk_component(pages) childsite]
        set pagenum [$cs1.page get]
        set pagesize [$cs1.lpp get]
        set limit [expr ([llength $matches] + $pagesize -1) / $pagesize ]
        if {$type} {
                set pagenum [expr $pagenum $action 1]
        }
        if {$pagenum > $limit || $pagenum == ""} {
                set pagenum 1
        } elseif {$pagenum == 0} {
                set pagenum $limit
        }
        $cs1.page clear
        $cs1.page insert entry end $pagenum
        for {set i 1} {$i <= $limit} {incr i} {
                $cs1.page insert list end $i
        }
        set page [lrange $matches [expr $pagesize * ($pagenum -1)] \
                                   [expr ($pagesize * $pagenum) -1]]

        set TotalPairs    [llength $methodpairs]
        set FilteredPairs [llength $matches]
        set TotalPages    $limit

        # enable disable prev/next buttons 
        set s normal
        if {$pagenum == 1} { set s disable }
        $itk_component(prevp) configure -state $s

        set s normal
        if {$pagenum == $limit} { set s disable }
        $itk_component(nextp) configure -state $s

        return $page
}

itcl::body import_bvi_wizard::get_scheduling_annotation {} {
        set list {}
        foreach p $scheduling_annotation {
		set temp {}
		lappend temp [$itk_component([regsub "_fr_" $p "_lent_"]) get]
		lappend temp [$itk_component([regsub "_fr_" $p "_rent_"]) get]
		set an [$itk_component($p).[regsub "_fr_" $p "_cmb_"] get]
                lappend temp $an
		lappend list $temp
        }
        return $list
}

itcl::body import_bvi_wizard::get_save_file_location {} {
	return [$itk_component(save_to_file) get]
}

itcl::body import_bvi_wizard::get_interface_last_checkbutton {list} {
        if {[llength $list] == 2} {
                return [regsub "_fr_" [lindex $list 0] "_ch_"]
        }
        set l [lindex $list end]
        if {[set ind [lsearch -index 0 $interface_binding $l]] != -1} {
                set l [get_interface_last_checkbutton [lindex \
                        $interface_binding $ind]]
        }
        return [regsub "_fr_" $l "_ch_"]
}


##############################################################################
########################## Checking the conditions ###########################
##############################################################################

itcl::body import_bvi_wizard::is_verilog_module_name_empty {} {
        if {[get_verilog_module_name] == ""} {
                error_message "The module name is not specified." $win
                focus [$itk_component(vofr).vomn component entry]
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_verilog_port_specify {list} {
	if {[llength [get_[lindex $list 1]]] == 0 || \
                [llength [get_[lindex $list 2]]] == 0} {
                if {[llength [get_[lindex $list 3]]] == 0} {
                        error_message "There is no port specified." $win
                        return -code return 0
                }
	}
}

itcl::body import_bvi_wizard::is_verilog_port_name_duplicated {ti1 list sl} {
        set l1 [lindex $list $ti1]
        for {set ti2 $ti1} {$ti2 < [llength $list]} {incr ti2} {
                set l2 [lindex $list $ti2]
                set d [check_duplicate_name $l1 $l2]
                set t1 [string totitle [lindex [split $l1 "_"] 1]]
                set t2 [string totitle [lindex [split $l2 "_"] 1]]
                if {$d != ""} {
                        if {$l1 == $l2} {
                                error_message "\"$d\" port name is duplicated\
                                        in $t1 tab." $win
                                $itk_component(votab) select $sl
                                focus [[get_port_frame $l1 $d] component entry]
                                return -code return 0

                        } else {
                                error_message "\"$d\" port name is duplicated\
                                        in $t1 and $t2 tabs." $win
                                $itk_component(votab) select $sl
                                focus [[get_port_frame $l1 $d] component entry]
                                return -code return 0
                        }
                }
        }
}

itcl::body import_bvi_wizard::is_verilog_ports_specified {i t1 sl l1} {
        if {[lindex $i 0] == ""} {
                if {$t1 == "Parameters"} {
                        error_message "The name for parameter is not specified\
                                in $t1 tab." $win
                } else {
                        error_message "The name for port is not specified in\
                                $t1 tab." $win
                }
                $itk_component(votab) select $sl
                focus [[get_port_frame $l1 ""] component entry]
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_verilog_port_value_specified {i t1 sl l1} {
        set n [lindex $i 0]
        if {[lindex $i 1] == ""} {
                if {$t1 == "Parameters"} {
                        error_message "The value for $n parameter is not\
                                specified in $t1 tab." $win
                } else {
                        error_message "The range for $n port is not specified\
                                in $t1 tab." $win
                }
                $itk_component(votab) select $sl
                focus [[get_port_frame $l1 $n] component entry]
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_verilog_port_range_correct {p l1 sl i} {
        set n [lindex $i 0]
        if {[string is integer $p] == 0} {
                if {[set p [get_port_value $p]] == "error"} {
                        $itk_component(votab) select $sl
                        focus [[get_port_frame $l1 $n] component entry]
                        return -code return 0
                }
        }
        return $p
}

itcl::body import_bvi_wizard::is_verilog_port_set_correct {h l i l1 sl t1} {
        set n [lindex $i 0]
        set t [lindex $i 2]
        if {$t == "clock" || $t == "reset"} {
                if {[expr $h - $l + 1] != "1"} {
                        error_message "The [lindex $i 0] port can not be set\
                                as $t in $t1 tab." $win
                        $itk_component(votab) select $sl
                        focus [[get_port_frame $l1 $n] component entry]
                        return -code return 0
                }
        }
}

itcl::body import_bvi_wizard::check_verilog_module_window {{type 0}} {
	set list [list verilog_parameter verilog_input verilog_output \
	                                                        verilog_inout]
        is_verilog_module_name_empty
        is_verilog_port_specify $list
	for {set ti1 0} {$ti1 < [llength $list]} {incr ti1} {
		set l1 [lindex $list $ti1]
                set sl [get_tab_index $l1]
                set t1 "[string totitle [lindex [split $l1 "_"] 1]]s"
                is_verilog_port_name_duplicated $ti1 $list $sl
		foreach i [get_$l1] {
                        is_verilog_ports_specified $i $t1 $sl $l1
                        is_verilog_port_value_specified $i $t1 $sl $l1
                        if {$t1 == "Input" || $t1 == "Output"} {
                                set h [lindex [split [lindex $i 1] ":"] 0]
                                set h [is_verilog_port_range_correct $h \
                                        $l1 $sl $i]
                                set l [lindex [split [lindex $i 1] ":"] 1]
                                set l [is_verilog_port_range_correct $l $l1 \
                                        $sl $i]
                                is_verilog_port_set_correct $h $l $i $l1 $sl $t1
                        }
		}
	}
        print_status $type
	return 1
}

itcl::body import_bvi_wizard::is_bluespec_module_name_correct {} {
        set module_name [get_bluespec_module_name]
        if {$module_name == ""} {
                error_message "The module name is not specified." $win
                focus [$itk_component(bmn) component entry]
                return -code return 0
        }
        if {![check_valid_name $module_name]} {
                error_message "\"$module_name\" is not a valid module name." \
                        $win
                focus [$itk_component(bmn) component entry]
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_bluespec_interface_type_correct {} {
        set ifc [get_bluespec_interface_name]
        if {$ifc == ""} {
                error_message "The interface type is not specified." $win
                focus [$itk_component(bmi) component entry]
                return -code return 0
        }
        if {[string is lower [string index $ifc 0]]} {
                error_message "The interface type should begin with upper case\
                        letter." $win
                focus [$itk_component(bmi) component entry]
                return -code return 0
        }
        if {![check_valid_name $ifc]} {
                error_message "\"$ifc\" is not a valid interface type." $win
                focus [$itk_component(bmi) component entry]
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_bluespec_package_import_correct {} {
        foreach i [get_bluespec_package_import] {
                if {$i == ""} {
                        error_message "There is an empty \"Package import\"\
                                field." $win
                        foreach pi $bluespec_package_import {
                                set frame $itk_component($pi).[regsub "_fr_" \
                                        $pi "_cmb_"]
                                if {[$frame get] == ""} {
                                        break
                                }
                        }
                        focus [$frame component entry]
                        return -code return 0
                }
        }
}

itcl::body import_bvi_wizard::is_bluespec_provisos_correct {} {
        foreach i [get_bluespec_provisos] {
                if {$i == ""} {
                        error_message "There is an empty \"Provisos\" field." \
                                $win
                        foreach pr $bluespec_provisos {
                                set frame $itk_component([regsub "_fr_" $pr \
                                        "_ent_"])
                                if {[$frame get] == ""} {
                                        break
                                }
                        }
                        focus [$frame component entry]
                        return -code return 0
                }
        }
}

itcl::body import_bvi_wizard::is_bluespec_module_args_correct {} {
        foreach i [get_bluespec_module_args] {
                if {[lindex $i 0] == ""} {
                        error_message "The argument type is not specified in\
                                \"Bluespec module arguments\" field." $win
                        foreach at $bluespec_module_args {
                                set frame $itk_component([regsub "_fr_" $at \
                                        "_entt_"])
                                if {[$frame get] == ""} {
                                        break
                                }
                        }
                        focus [$frame component entry]
                        return -code return 0
                } elseif {[lindex $i 1] == ""} {
                        error_message "The argument name is not specified in\
                                \"Bluespec module arguments\" field." $win
                        foreach at $bluespec_module_args {
                                set frame $itk_component([regsub "_fr_" $at \
                                        "_entn_"])
                                if {[$frame get] == ""} {
                                        break
                                }
                        }
                        focus [$frame component entry]
                        return -code return 0
                }
        }
}

itcl::body import_bvi_wizard::is_bluespec_parameter_correct {} {
        foreach i [get_bluespec_parameter_binding] {
                if {[lindex $i 1] == ""} {
                        error_message "The BSV expression for\
                                \"[lindex $i 0]\" Verilog parameter is not\
                                specified in Parameter Binding tab." $win
                        foreach p $bluespec_parameter_binding {
                                set frame $itk_component([regsub "_fr_" $p \
                                        "_entbe_"])
                                if {[$frame get] == ""} {
                                        break
                                }
                        }
                        focus [$frame component entry]
                        $itk_component(bmtab) select 0
                        return -code return 0
                }
        }
}

itcl::body import_bvi_wizard::is_bluespec_clock_reset_inout_correct {} {
        if {![check_bluespec_input_clock_reset clock]} {
                return -code return 0
        }
        if {![check_bluespec_input_clock_reset reset]} {
                return -code return 0
        }
        if {![check_bluespec_inout]} {
                return -code return 0
        }
}

itcl::body import_bvi_wizard::check_bluespec_module_window {{type 0}} {
        is_bluespec_module_name_correct
        is_bluespec_interface_type_correct
        is_bluespec_package_import_correct
        is_bluespec_provisos_correct
        is_bluespec_module_args_correct
        is_bluespec_parameter_correct
        is_bluespec_clock_reset_inout_correct
        print_status $type
	return 1
}

itcl::body import_bvi_wizard::check_duplicate_name {name1 name2} {
        foreach i [get_$name1] {
		set c 0
		set i [lindex $i 0]
		foreach j [get_$name2] {
			set j [lindex $j 0]
			if {$i == $j} {
				incr c
			}
			if {$name1 == $name2} {
				if {$c >= 2} {
					return $i
				}
			} else {
				if {$c >= 1} {
					return $i
				}
			}
		}
	}
	return ""
}

itcl::body import_bvi_wizard::check_valid_name {name} {
        set verilog_keyword {Action ActionValue BVI C CF SB SBR action xnor \
        endaction actionvalue endactionvalue ancestor begin bit case endcase \
        clocked_by default default_clock default_reset dependencies deriving \
        determines else enable enum export for function endfunction if module \
        ifc_inout import inout input_clock input_reset instance endinstance \
        interface endinterface let match matches method endmethod endmodule \
        numeric output_clock output_reset package endpackage path port always \
        provisos reset_by return rule endrule rules endrules same_family union \
        schedule struct tagged type typeclass endtypeclass typedef new alias \
        extends always_comb nor extern always_ff noshowcancelled final nmos \
        always_latch not first_match and notif0 assert notif1 force expect \
        assert_strobe null foreach assign forever assume output fork unsigned \
        automatic forkjoin before packed end parameter generate endgenerate \
        bind pmos genvar bins posedge highz0 binsof primitive endprimitive \
        highz1 priority break program endprogram iff buf property endproperty \
        ifnone bufif0 protected ignore_bins bufif1 pull0 illegal_bins byte int \
        pull1 pulldown incdir casex pullup include casez pulsestyle_onevent \
        initial cell pulsestyle_ondetect chandle pure input class endclass xor \
        rand inside clocking endclocking randc cmos randcase config while tran \
        endconfig randsequence integer const rcmos constraint real intersect \
        context realtime join continue ref join_any cover join_none valueof do \
        covergroup endgroup release large coverpoint repeat liblist cross void \
        library deassign rnmos local rpmos localparam defparam rtran logic var \
        design rtranif0 longint disable rtranif1 macromodule dist reg scalared \
        sequence endsequence medium edge shortint modport shortreal negedge or \
        showcancelled nand event time signed vectored timeprecision small task \
        virtual timeunit solve specify endspecify wait tranif0 specparam table \
        wait_order tranif1 static wand tri string weak0 tri0 strong0 weak1 use \
        tri1 strong1 triand wildcard trior super wire trireg supply0 with this \
        supply1 within endtable wor unique endtask valueOf throughout}
        foreach i $verilog_keyword {
                if {$i == $name} {
                        return 0
                }
        }
        return 1
}

itcl::body import_bvi_wizard::is_bluespec_input_clock_reset_port_empty {i \
                                                                type list ti} {
        set title "[string totitle $type]s"
        if {[lindex $i 0] == ""} {
                error_message "The BSV $type is not specified\
                        in Input $title tab." $win
                foreach c $list {
                        set frame $itk_component([regsub "_fr_" $c \
                                "_ent_"])
                        if {[$frame get] == ""} {
                                break
                        }
                }
                focus [$frame component entry]
                $itk_component(bmtab) select $ti 
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_bluespec_input_clock_reset_duplicated {i \
                                                                type list ti} {
        set title "[string totitle $type]s"
        set n1 [lindex $i 0]
        set bool 0
        foreach l [get_bluespec_input_$type] {
                set n2 [lindex $l 0]
                if {$n1 == $n2} {
                        incr bool
                }
                if {$bool == 2} {
                        error_message "The $n1 BSV $type is duplicated in\
                                Input $title tab." $win
                        foreach c $list {
                                set frame $itk_component([regsub "_fr_" $c \
                                        "_ent_"])
                                if {[$frame get] == $n1} {break}
                        }
                        focus [$frame component entry]
                        $itk_component(bmtab) select $ti 
                        return -code return 0
                }
        }
}

itcl::body import_bvi_wizard::is_bluespec_input_clock_reset_port_lower {i \
                                                                type list ti} {
        set title "[string totitle $type]s"
        if {[string is upper [string index [lindex $i 0] 0]]} {
                error_message "The BSV $type should begin with lower\
                        case letter in Input $title tab." $win
                foreach c $list {
                        set frame $itk_component([regsub "_fr_" $c \
                                "_ent_"])
                        if {[$frame get] == [lindex $i 0]} {
                                break
                        }
                }
                focus [$frame component entry]
                $itk_component(bmtab) select $ti 
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_bluespec_input_clock_verilog_port_specified {i\
                                                                type list ti} {
        set title "[string totitle $type]s"
        if {[lindex $i 1] == "" && [lindex $i 2] != "" && $type == "clock"} {
                error_message "The Verilog clock for \"[lindex $i 0]\"\
                        is not specified in Input $title tab." $win
                foreach c $list {
                        set frame $itk_component([regsub "_fr_" \
                                $c "_frt_"]).[regsub "_fr_" $c "_vccmb_"]
                        if {[$frame get] == [lindex $i 0]} {
                                break
                        }
                }
                focus [$frame component entry]
                $itk_component(bmtab) select $ti 
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_bluespec_input_reset_bclock_specified {i \
                                                                type list ti} {
        set title "[string totitle $type]s"
        if {[lindex $i 2] == "" && $type == "reset"} {
                error_message "The Bluespec clock for \"[lindex $i 0]\"\
                        is not specified in Input $title tab." $win
                foreach c $list {
                        set frame $itk_component([regsub "_fr_" $c \
                                "_frb_"]).[regsub "_fr_" $c "_bccmb_"]
                        if {[$frame get] == ""} {
                                break
                        }
                }
                focus [$frame component entry]
                $itk_component(bmtab) select $ti 
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_bluespec_input_clock_reset_expr_specified {i \
                                                                type list ti} {
        set title "[string totitle $type]s"
        if {[lindex $i 3] == ""} {
                error_message "The Expression for \"[lindex $i 0]\"\
                        is not specified in Input $title tab." $win
                foreach c $list {
                        set frame $itk_component([regsub "_fr_" $c \
                                "_eent_"])
                        if {[$frame get] == ""} {
                                break
                        }
                }
                focus [$frame component entry]
                $itk_component(bmtab) select $ti 
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_bluespec_input_clock_reset_expr_lower {i \
                                                                type list ti} {
        set title "[string totitle $type]s"
        if {[string is upper [string index [lindex $i 3] 0]]} {
                error_message "The Expression should begin with lower\
                        case letter in Input $title tab." $win
                foreach c $list {
                        set frame $itk_component([regsub "_fr_" $c \
                                "_eent_"])
                        if {[$frame get] == [lindex $i 3]} {
                                break
                        }
                }
                focus [$frame component entry]
                $itk_component(bmtab) select $ti 
                return -code return 0
        }
}

itcl::body import_bvi_wizard::check_bluespec_input_clock_reset {type} {
        switch $type {
                clock {set ti 1}
                reset {set ti 2}
        }
        set list bluespec_input_$type
        eval set list $$list
        foreach i [get_bluespec_input_$type] {
                is_bluespec_input_clock_reset_port_empty $i $type $list $ti
                is_bluespec_input_clock_reset_duplicated $i $type $list $ti
                is_bluespec_input_clock_reset_port_lower $i $type $list $ti
                is_bluespec_input_clock_verilog_port_specified $i $type $list \
                        $ti
                is_bluespec_input_reset_bclock_specified $i $type $list $ti
                is_bluespec_input_clock_reset_expr_specified $i $type $list $ti
                is_bluespec_input_clock_reset_expr_lower $i $type $list $ti
        }
        return 1
}

itcl::body import_bvi_wizard::is_bluespec_inout_verilog_port_correct {i} {
        if {[lindex $i 0] == ""} {
                error_message "The Verilog port is not specified in Inout\
                        tab." $win
                foreach c $bluespec_inout {
                        set frame $itk_component($c).[regsub "_fr_" $c \
                                "_ivpcmb_"]
                        if {[$frame get] == ""} {
                                break
                        }
                }
                focus [$frame component entry]
                $itk_component(bmtab) select 3
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_bluespec_inout_bluespec_clock_correct {i} {
        if {[lindex $i 1] == ""} {
                error_message "The Bluespec clock for \"[lindex $i 0]\" inout\
                        port is not specified in Inout tab." $win
                foreach c $bluespec_inout {
                        set frame $itk_component($c).[regsub "_fr_" $c \
                                "_ibccmb_"]
                        if {[$frame get] == ""} {
                                break
                        }
                }
                focus [$frame component entry]
                $itk_component(bmtab) select 3
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_bluespec_inout_bluespec_reset_correct {i} {
        if {[lindex $i 2] == ""} {
                error_message "The Bluespec reset for \"[lindex $i 0]\" inout\
                        port is not specified in Inout tab." $win
                foreach c $bluespec_inout {
                        set frame $itk_component($c).[regsub "_fr_" $c \
                                "_ibrcmb_"]
                        if {[$frame get] == ""} {
                                break
                        }
                }
                focus [$frame component entry]
                $itk_component(bmtab) select 3
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_bluespec_inout_expression_specified {i} {
        if {[lindex $i 3] == ""} {
                error_message "The Expression for \"[lindex $i 0]\" inout port\
                        is not specified in Inout tab." $win
                foreach c $bluespec_inout {
                        set frame $itk_component([regsub "_fr_" $c \
                                "_ieent_"])
                        if {[$frame get] == ""} {
                                break
                        }
                }
                focus [$frame component entry]
                $itk_component(bmtab) select 3
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_bluespec_inout_expression_valid {i} {
        if {[string is upper [string index [lindex $i 3] 0]]} {
                error_message "The Expression should begin with lower case\
                        letter in Inout tab." $win
                foreach c $bluespec_inout {
                        set frame $itk_component([regsub "_fr_" $c \
                                "_ieent_"])
                        if {[$frame get] == [lindex $i 3]} {
                                break
                        }
                }
                focus [$frame component entry]
                $itk_component(bmtab) select 3
                return -code return 0
        }
}

itcl::body import_bvi_wizard::check_bluespec_inout {} {
        foreach i [get_bluespec_inout] {
                is_bluespec_inout_verilog_port_correct $i
                is_bluespec_inout_bluespec_clock_correct $i
                is_bluespec_inout_bluespec_reset_correct $i
                is_bluespec_inout_expression_specified $i
                is_bluespec_inout_expression_valid $i
        }
        return 1
}

itcl::body import_bvi_wizard::is_method_port_interface_type_correct {} {
        set ifc_name [get_interface_name]
        $itk_component(bmi) clear
        $itk_component(bmi) insert 0 $ifc_name
        if {$ifc_name == ""} {
                error_message "The interface type is not specified." $win
                focus [$itk_component(mpi) component entry]
                return -code return 0
        }
        if {[string is lower [string index $ifc_name 0]]} {
                error_message "The interface type should begin with upper case\
                        letter." $win
                focus [$itk_component(mpi) component entry]
                return -code return 0
        }
        if {![check_valid_name $ifc_name]} {
                error_message "\"$ifc_name\" is not a valid interface name." \
                        $win
                focus [$itk_component(mpi) component entry]
                return -code return 0
        }
}

itcl::body import_bvi_wizard::is_method_port_subinterface_specify {i} {
        if {[lindex $i 1] == ""} {
                error_message "The name for Subinterface is not specified." $win
                foreach c $interface_binding {
                        set c [lindex $c 0]
                        set frame $itk_component([regsub "_fr_" $c "_name_"])
                        if {[$frame get] == ""} {
                                break
                        }
                }
                focus [$frame component entry]
                return -level 2 -code return 0
        }
}

itcl::body import_bvi_wizard::is_method_port_subinterface_correct {i} {
        if {[string is lower [string index [lindex $i 2] 0]]} {
                error_message "The Subinterface type should begin with upper\
                        case letter." $win
                foreach c $interface_binding {
                        set c [lindex $c 0]
                        set frame $itk_component([regsub "_fr_" $c "_type_"])
                        if {[$frame get] == [lindex $i 2]} {
                                break
                        }
                }
                focus [$frame component entry]
                return -level 2 -code return 0
        }
}

itcl::body import_bvi_wizard::is_method_port_subinterface_type_specify {i} {
        if {[lindex $i 2] == ""} {
                error_message "The type for \"[lindex $i 1]\" Subinterface is\
                        not specified." $win
                foreach c $interface_binding {
                        set c [lindex $c 0]
                        set frame $itk_component([regsub "_fr_" $c "_type_"])
                        if {[$frame get] == ""} {
                                break
                        }
                }
                focus [$frame component entry]
                return -level 2 -code return 0
        }
}

itcl::body import_bvi_wizard::is_method_port_subinterface_duplicated {i ifc} {
        set p1 [lindex [lindex $interface_binding [lsearch -index 0 \
                $interface_binding [lindex $i 0]]] 1]
        set list [lsearch -index 1 -all $ifc [lindex $i 1]]
        set bool 0
        if {[llength $list] > 1} {
                foreach id $list {
                        set fr2 [lindex [lindex $ifc $id] 0]
                        set p2 [lindex [lindex $interface_binding [lsearch \
                                -index 0 $interface_binding $fr2]] 1]
                        if {$p1 == $p2} {
                                incr bool
                        }
                        if {$bool == 2} {
                                error_message "\"[lindex $i 1]\" interface\
                                        name is duplicated." $win
                                set frame $itk_component([regsub "_fr_" $fr2 \
                                        "_name_"])
                                focus [$frame component entry]
                                return -level 2 -code return 0
                        }
                }
        }
}

itcl::body import_bvi_wizard::is_method_port_subinterface_type_correct {} {
        set ifc [get_interface_binding]
        foreach i $ifc {
                is_method_port_subinterface_specify $i
                is_method_port_subinterface_type_specify $i
                is_method_port_subinterface_correct $i
                is_method_port_subinterface_duplicated $i $ifc
        }
}

itcl::body import_bvi_wizard::is_method_name_specify {mn} {
        if {$mn == ""} {
                error_message "The method name is not specified." $win
                foreach c $method_bindings {
                        set c [lindex $c 0]
                        set frame $itk_component([regsub "_mb_fr_" $c \
                                "_method_name_"])
                        if {[$frame get] == ""} {
                                break
                        }
                }
                focus [$frame component entry]
                return -level 2 -code return 0
        }
}

itcl::body import_bvi_wizard::is_method_name_correct {mn} {
        if {[string is upper [string index $mn 0]]} {
                error_message "The method name should begin with lower case\
                        letter." $win
                foreach c $method_bindings {
                        set c [lindex $c 0]
                        set frame $itk_component([regsub "_mb_fr_" $c \
                                "_method_name_"])
                        if {[$frame get] == $mn} {
                                break
                        }
                }
                focus [$frame component entry]
                return -level 2 -code return 0
        }
}

itcl::body import_bvi_wizard::is_method_type_specify {i mn} {
        if {[lindex $i 2] == ""} {
                error_message "The type for method \"$mn\" is not specified." \
                        $win
                foreach c $method_bindings {
                        set c [lindex $c 0]
                        set frame $itk_component([regsub "_mb_fr_" $c \
                                "_method_name_"])
                        if {[$frame get] == $mn} {
                                break
                        }
                }
                focus [$frame component entry]
                return -level 2 -code return 0
        }
}

itcl::body import_bvi_wizard::is_method_return_signal_correct {i} {
        set type [lindex $i 2]
        if {[lindex $i 2] == "action"} {
                return
        }
        set mn [lindex $i 1]
        set rs [lindex [lindex $i 6] 0]
        set vop [get_verilog_output]
        if {[lsearch -index 0 $vop $rs] == -1} {
                error_message "The $rs Return signal for method \"$mn\" is not\
                        valid verilog output port." $win
                foreach c $method_bindings {
                        set id [lindex [split [lindex $c 0] "_"] end]
                        set frame \
                                $itk_component(mb_rtrsfr_$id).mb_returnp_cmb_$id
                        if {[string trim [$frame get]] == $rs} {
                                break
                        }
                }
                focus [$frame component entry]
                return -level 2 -code return 0
        }
}

itcl::body import_bvi_wizard::is_method_args_bsv_type_specify {a mn} {
        if {[lindex $a 0] == ""} {
                error_message "The BSV type for method \"$mn\" is not\
                        specified." $win
                foreach c $method_bindings {
                        set c [lindex $c 0]
                        set frame $itk_component([regsub \
                                "_mb_fr_" $c "_method_name_"])
                        if {[$frame get] == $mn} {
                                set id [lindex [split $c _] end]
                                set cs [$itk_component(mb_avmsfr_$id) childsite]
                                foreach a $METHOD_BINDING_ARGS($cs) {
                                        set a $itk_component([join [lreplace \
                                             [split $a _] end-1 end-1 ent] "_"])
                                        if {[$a get] == ""} {break}
                                }
                                if {[$a get] == ""} {break}
                        }
                }
                focus [$a component entry]
                return -level 3 -code return 0
        }
}

itcl::body import_bvi_wizard::is_method_args_name_specify {a mn} {
        if {[lindex $a 1] == ""} {
                error_message "The Verilog name for method \"$mn\" is not\
                        specified." $win
                foreach c $method_bindings {
                        set c [lindex $c 0]
                        set frame $itk_component([regsub \
                                "_mb_fr_" $c "_method_name_"])
                        if {[$frame get] == $mn} {
                                set id [lindex [split $c _] end]
                                set cs [$itk_component(mb_avmsfr_$id) childsite]
                                foreach a $METHOD_BINDING_ARGS($cs) {
                                        set a $itk_component($a).[join \
                                                [lreplace [split $a _] end-1 \
                                                end-1 vncmb] "_"]
                                        if {[$a get] == ""} {break}
                                }
                                if {[$a get] == ""} {break}
                        }
                }
                focus [$a component entry]
                return -level 3 -code return 0
        }
}

itcl::body import_bvi_wizard::is_method_args_correct {args mn} {
        foreach a $args {
                is_method_args_bsv_type_specify $a $mn
                is_method_args_name_specify $a $mn
        }
}

itcl::body import_bvi_wizard::is_method_enable_specify {i en mn vinp id} {
        if {[lindex $i 2] == "action"} {
                if {$en == ""} {
                       error_message "The \"Enable\" field for method \"$mn\"\
                               is not specified." $win
                       set frame $itk_component(mb_enrefr_$id).mb_enable_cmb_$id
                       focus [$frame component entry]
                       return -level 2 -code return 0
                } elseif {[lsearch -index 0 $vinp $en] == -1 \
                                       && $en != "always enabled"} {
                       error_message "\"$en\" specified as Enable in method\
                               \"$mn\" is not a verilog input port." $win
                       set frame $itk_component(mb_enrefr_$id).mb_enable_cmb_$id
                       focus [$frame component entry]
                       return -level 2 -code return 0
                }
        }
}

itcl::body import_bvi_wizard::is_method_args_name_correct {args vinp mn} {
        foreach vn $args {
                set vn [lindex [lindex $vn 1] 0]
                if {$vn != "" && [lsearch -index 0 $vinp $vn] == -1} {
                        error_message "\"$vn\" specified as Verilog name in\
                               method \"$mn\" is not a verilog input port." $win
                        foreach c $method_bindings {
                                set c [lindex $c 0]
                                set frame $itk_component([regsub \
                                        "_mb_fr_" $c "_method_name_"])
                                if {[$frame get] == $mn} {
                                        set id [lindex [split $c _] end]
                                        set cs [$itk_component(mb_avmsfr_$id) \
                                        childsite]
                                        foreach a $METHOD_BINDING_ARGS($cs) {
                                                set a $itk_component($a).[join \
                                                        [lreplace [split $a _] \
                                                        end-1 end-1 vncmb] "_"]
                                                if {[lindex [$a get] 0] == \
                                                        $vn} {break}
                                        }
                                        if {[lindex [$a get] 0] == $vn} {break}
                                }
                        }
                        focus [$a component entry]
                        return -level 2 -code return 0
                }
        }
}

itcl::body import_bvi_wizard::is_method_name_duplicated {fr mlist mn} {
        set bool 0
        set p1 [get_method_parent $fr]
        foreach j $mlist {
                set p2 [get_method_parent [lindex $j 0]]
                if {$mn == [lindex $j 1] && $p1 == $p2} {
                        incr bool
                }
                if {$bool == 2} {
                        error_message "The method name \"$mn\" is duplicated."\
                                $win
                        foreach c $method_bindings {
                                set c [lindex $c 0]
                                set frame $itk_component([regsub \
                                        "_mb_fr_" $c "_method_name_"])
                                if {[$frame get] == $mn} {
                                        break
                                }
                        }
                        focus [$frame component entry]
                        return -level 2 -code return 0
                }
        }
}

itcl::body import_bvi_wizard::is_methods_args_enables_same {vn mlist mn} {
        foreach j $mlist {
                if {[lindex $j 3] == $vn} {
                        error_message "\"$vn\" port used as \"Enable\" in\
                        method \"[lindex $j 1]\" is already used in method\
                        \"$mn\" as \"Verilog name\"." $win
                        foreach c $method_bindings {
                                set c [lindex $c 0]
                                set frame $itk_component([regsub "_mb_fr_" $c \
                                        "_method_name_"])
                                if {[$frame get] == $mn} {
                                        set id [lindex [split $c _] end]
                                        set cs [$itk_component(mb_avmsfr_$id) \
                                                childsite]
                                        foreach a $METHOD_BINDING_ARGS($cs) {
                                                set a $itk_component($a).[join \
                                                        [lreplace [split $a _] \
                                                        end-1 end-1 vncmb] "_"]
                                                if {[$a get] == $vn} {break}
                                        }
                                        if {[$a get] == $vn} {break}
                                }
                        }
                        focus [$a component entry]
                        return -level 3 -code return 0
                }
        }
}

itcl::body import_bvi_wizard::is_methods_args_duplicated {vn mlist mn} {
        set bool 0
        foreach j $mlist {
                foreach vn2 [lindex $j 9] {
                        set vn2 [lindex $vn2 1]
                        if {$vn2 == $vn} {incr bool}
                        if {$bool == 2} {
                                error_message "\"$vn2\" port used as \"Verilog\
                                        name\" in method \"[lindex $j 1]\" is\
                                        already used in method \"$mn\" as\
                                        \"Verilog name\"." $win
                                foreach c $method_bindings {
                                        set c [lindex $c 0]
                                        set frame $itk_component([regsub \
                                                "_mb_fr_" $c "_method_name_"])
                                        if {[$frame get] == $mn} {
                                                set id [lindex [split $c _] end]
                                                set cs \
                                                [$itk_component(mb_avmsfr_$id) \
                                                childsite]
                                                foreach a \
                                                $METHOD_BINDING_ARGS($cs) {
                                                        set a \
                                                        $itk_component($a).[join \
                                                        [lreplace [split $a _] \
                                                        end-1 end-1 vncmb] "_"]
                                                        if {[$a get] == $vn} {
                                                                break
                                                        }
                                                }
                                                if {[$a get] == $vn} {break}
                                        }
                                }
                                focus [$a component entry]
                                return -level 3 -code return 0
                        }
                }
        }
}

itcl::body import_bvi_wizard::is_methods_args_ports_bindings_same {vn mn} {
        foreach p [get_port_binding] {
                if {[lindex $p 0] == $vn} {
                        error_message "\"$vn\" port used in port \"[lindex $p \
                                0]\" is already used in method \"$mn\" as\
                                \"Verilog name\"." $win
                        foreach c $method_bindings {
                                set c [lindex $c 0]
                                set frame $itk_component([regsub "_mb_fr_" $c \
                                        "_method_name_"])
                                if {[$frame get] == $mn} {
                                        set id [lindex [split $c _] end]
                                        set cs [$itk_component(mb_avmsfr_$id) \
                                                childsite]
                                        foreach a $METHOD_BINDING_ARGS($cs) {
                                                set a $itk_component($a).[join \
                                                        [lreplace [split $a _] \
                                                        end-1 end-1 vncmb] "_"]
                                                if {[$a get] == $vn} {break}
                                        }
                                        if {[$a get] == $vn} {break}
                                }
                        }
                        focus [$a component entry]
                        return -level 3 -code return 0
                }
        }
}

itcl::body import_bvi_wizard::is_method_ports_duplicated {args mlist mn} {
        foreach vn $args {
                set vn [lindex $vn 1]
                is_methods_args_enables_same $vn $mlist $mn
                is_methods_args_duplicated $vn $mlist $mn
                is_methods_args_ports_bindings_same $vn $mn
        }
}

itcl::body import_bvi_wizard::is_method_port_methods_correct {} {
        set mlist [get_method_binding]
        set vinp [get_verilog_input]
        foreach i $mlist {
                set fr [lindex $i 0]
                set mn [lindex $i 1]
                set en [lindex $i 3]
                set args [lindex $i 9]
                is_method_name_specify $mn
                is_method_name_correct $mn
                is_method_type_specify $i $mn
                is_method_return_signal_correct $i
                is_method_args_correct $args $mn
                set id [get_current_method_id $mn]
                is_method_enable_specify $i $en $mn $vinp $id
                is_method_args_name_correct $args $vinp $mn 
                is_method_name_duplicated $fr $mlist $mn
                is_method_ports_duplicated $args $mlist $mn
        }
}

itcl::body import_bvi_wizard::is_port_binding_verilog_name_specify {i} {
        if {[lindex [lindex $i 0] 0] == ""} {
                error_message "The verilog name in Port bindings field\
                        is not specified." $win
                foreach p $port_binding {
                        set frame $itk_component($p).[regsub "_fr_" $p \
                                "_pbvcmb_"]
                        if {[$frame get] == ""} {
                                break
                        }
                }
                focus [$frame component entry]
                return -level 2 -code return 0
        }
}

itcl::body import_bvi_wizard::is_port_binding_verilog_name_correct {i vinp} {
        if {[lsearch -index 0 $vinp [lindex [lindex $i 0] 0]] == -1} {
                error_message "The \"[lindex [lindex $i 0] 0]\" specified as\
                        verilog name in Port bindings field is not a verilog\
                        input port." $win
                foreach p $port_binding {
                        set frame $itk_component($p).[regsub "_fr_" $p \
                                "_pbvcmb_"]
                        if {[$frame get] == [lindex $i 0]} {
                                break
                        }
                }
                focus [$frame component entry]
                return -level 2 -code return 0
        }
}

itcl::body import_bvi_wizard::is_port_binding_bsv_expression_specify {i} {
        if {[lindex $i 1] == ""} {
                error_message "The BSV expression for \"[lindex [lindex $i \
                        0] 0]\" verilog name in Port bindings field is not\
                        specified." $win
                foreach p $port_binding {
                        set frame $itk_component($p).[regsub "_fr_" $p \
                                "_pbecmb_"]
                        if {[$frame get] == ""} {
                                break
                        }
                }
                focus [$frame component entry]
                return -level 2 -code return 0
        }
}

itcl::body import_bvi_wizard::is_port_binding_correct {} {
        set vinp [get_verilog_input]
        set p [get_port_binding]
        foreach i $p {
                is_port_binding_verilog_name_specify $i
                is_port_binding_verilog_name_correct $i $vinp
                is_port_binding_bsv_expression_specify $i
        }
}

itcl::body import_bvi_wizard::check_method_port_window {{type 0}} {
        is_method_port_interface_type_correct
        is_method_port_subinterface_type_correct
        is_method_port_methods_correct
        is_port_binding_correct
        print_status $type
	return 1
}

itcl::body import_bvi_wizard::is_combinational_path_input_output_specify \
                                                                        {list} {
	foreach i $list {
                if {[lindex $i 0] == ""} {
			error_message "There is an empty input field." $win
                        foreach i $combinational_path_input {
                                set i [lindex $i 1]
                                set frame $itk_component($i).[regsub "_fr_" \
                                        $i "_cmb_"]
                                if {[$frame get] == ""} {break}
                        }
                        focus [$frame component entry]
			return -code return 0
                } elseif {[lindex $i 1] == ""} {
			error_message "There is an empty output field." $win
                        foreach o $combinational_path_output {
                                set o [lindex $o 1]
                                set frame $itk_component($o).[regsub "_fr_" \
                                        $o "_cmb_"]
                                if {[$frame get] == ""} {break}
                        }
                        focus [$frame component entry]
			return -code return 0
                }
        }
}

itcl::body import_bvi_wizard::is_combinational_path_input_output_duplicated \
                                                                        {list} {
        foreach i $list {
                if {[llength [lsearch -all $list $i ]] > 1} {
                        error_message "The input [lindex $i 0] - output \
                                [lindex $i 1] combination is duplicated." $win
			return -code return 0
                }
        }
}

itcl::body import_bvi_wizard::check_combinational_path_window {{type 0}} {
        set list [get_combinational_path_input_output]
        is_combinational_path_input_output_specify $list
        is_combinational_path_input_output_duplicated $list
        print_status $type
	return 1
}

itcl::body import_bvi_wizard::is_scheduling_annotation_specify {} {
	foreach p $methodpairs {
                lassign [split $p ,] m1 m2
                set an [subst $[namespace current]::SCHED_ANNOTATION($p)]
		if {$an == ""} {
			error_message "\"$m1\" and \"$m2\" methods\
				annotation is not specified" $win
                        return -code return 0
		}
                if {[lsearch $sched_annotation_list $an] == -1} {
			error_message "Wrong annotation \"$an\" specified for\
                                \"$m1\" and \"$m2\" methods" $win
                        return -code return 0
                }
	}
}

itcl::body import_bvi_wizard::check_scheduling_annotation_window {{type 0}} {
        is_scheduling_annotation_specify
        print_status $type
	return 1
}

itcl::body import_bvi_wizard::check_finish_window {{type 0}} {
        if {[get_save_file_location] == ""} {
                error_message "The file name is not specified." $win
                focus [$itk_component(save_to_file) component entry]
                return 0
        }
	return 1
}

##############################################################################
############################ Verilog file reading ###########################
##############################################################################

itcl::body import_bvi_wizard::reset_wizard {} {
        array set METHOD_BINDING_ARGS ""

        set list "bluespec_package_import bluespec_provisos \
                bluespec_module_args bluespec_parameter_binding \
                bluespec_input_clock bluespec_input_reset bluespec_inout \
                bluespec_parameter_binding_temp method_bindings \
                interface_binding port_binding method_port_bindings \
                combinational_path combinational_path_input \
                combinational_path_output scheduling_annotation"
        foreach l $list {
                set $l ""
        }
        foreach s $screens {
                if {$s == "vfr"} {
                        remove_param_input_output
                } else {
                        destroy $itk_component($s)
                }
        }
        set screens "vfr"
}

itcl::body import_bvi_wizard::open_verilog {v} {
        start_process
        if {$v} {
                set types {{{Verilog files} {.v}} {{All files} {*}}}
                if {[set f [tk_getOpenFile -minsize "350 200" \
                                -title "Read Verilog" -parent $win\
                                -filetypes $types]] != ""} {
                        reset_wizard
                        read_verilog $f
                }
        } else {
                set types {{{Verilog info files} {.vinfo}} {{All files} {*}}}
                if {[set f [tk_getOpenFile -minsize "350 200" \
                                -title "Read From File" -parent $win\
                                -filetypes $types]] != ""} {
                        reset_wizard
                        read_from_file $f
                }
        }
        finish_process
}

itcl::body import_bvi_wizard::read_verilog {file} {
        set fp [open $file "r"]
        set lines ""
        while {[gets $fp line] >= 0} {
                # remove line comments and tick commands
                regsub  {//(?:.*)} $line {} line
                regsub {`(define|undef|ifdef|ifndef|endif|else|elsif|timescale|include|resetall)(?:.*)} $line {} line
                append lines $line " "
        }
        ::close $fp
        # remove multi-line comments
        regsub -all -line {/\*[^\*]\*/} $lines {} lines
        # remove tasks (which have inputs and outputs)
        # do only the first module
        # TODO: ask for module name
        regsub -all -line {endmodule.+$} $lines {} lines
        regsub -all -line {task(.+)endtask} $lines {} lines
        regsub -all -line {function(.+)endfunction} $lines {} lines
    
        set cmds [split $lines ";"]
        find_param_input_output $cmds
}

itcl::body import_bvi_wizard::find_param_input_output {cmds} {
        set verilog_inputs ""
        set verilog_outputs ""
        set verilog_inouts ""
        set verilog_parameters ""
        set verilog_module_name ""
        # find all the input/output pins
        foreach cmd $cmds {
                if {[regexp {^(?:\s*)(module)([^;]+)} $cmd match ss dd]} {
                        set verilog_module_name [lindex [split $dd "("] 0]
                        commands::display_command_results \
                                "module : $verilog_module_name"
                }
                if {[regexp {^(?:\s*)(input|output|inout|parameter)(?:\M)(?:\s+)(.*)} $cmd match \
                                                                dir line]} {
                        # parse bit range (presume it's been preparsed so this is a number)
                        if {[regexp {\[(\d+)\s*:\s*(\d+)\s*\]\s*(.+)} $line match h l data]} {
                                set size [expr $h - $l + 1]
                        } elseif {[regexp {\[(.*):(.*)\]\s*(.+)} $line match h l n]} {
                                set size -1
                                set data $n
                        } else {
				set h 0
				set l 0
                                set size 1
                                set data $line
                        }
                        if { $data == "" } {
                                puts stderr "Error reading verilog near line:\
                                        $line"
                                continue
                        }
                        # get list of pins, create entry for each pin
                        foreach item [split $data ","] {
				set temp {}
                                set temp [string trim $item]
				lappend temp "$h : $l"
                                switch $dir {
                                        input {
                                                commands::display_command_results "$dir: $temp"
                                                lappend verilog_inputs $temp
                                        }
                                        output {
                                                commands::display_command_results "$dir: $temp"
                                                lappend verilog_outputs $temp
                                        }
                                        inout {
                                                commands::display_command_results "$dir: $temp"
                                                lappend verilog_inouts $temp
                                        }
                                        parameter {
                                                set splts [split $item "="]
                                                set name \
                                                [string trim [lindex $splts 0]]
                                                set range \
                                                [string trim [lindex $splts 1]]
                                                commands::display_command_results "$dir: $name $range"
                                                lappend verilog_parameters \
                                                        "$name $range"
                                        }
                                }
                        }
                }
        }
        fill_param_input_output $verilog_module_name $verilog_inputs \
                $verilog_outputs $verilog_parameters $verilog_inouts
}

itcl::body import_bvi_wizard::fill_param_input_output {vname vinp vout vparam \
                                                                vinout} {
        $itk_component(vofr).vomn insert list end $vname
        $itk_component(vofr).vomn component entry insert 0 [lindex $vname 0]
        foreach i $vinp {
                if {[regexp -line {(clock|^clk)} [string tolower $i] match]} {
                        add_verilog_input_field [lindex $i 0] "" "clock" \
				[lindex $i 1]
                } elseif {[regexp -line {(^rst|reset)} [string tolower $i] \
                                                                match]} {
                        add_verilog_input_field [lindex $i 0] "" "reset" \
				[lindex $i 1]
                } else {
                        add_verilog_input_field [lindex $i 0] "" "" \
				[lindex $i 1]
                }
        }
        foreach i $vout {
                add_verilog_output_field [lindex $i 0] "" "" [lindex $i 1]
        }
        foreach i $vparam {
                add_verilog_parameter_field [lindex $i 0] "" [lindex $i 1]
        }
        foreach i $vinout {
                add_verilog_inout_field [lindex $i 0] "" [lindex $i 1] 
        }
}

itcl::body import_bvi_wizard::read_from_file {file} {
        set fp [open $file "r"]
        set lines ""
        while {[gets $fp line] >= 0} {
                set lines "$lines\n$line"
        }
        ::close $fp
        foreach c [split $lines ";"] {
                set t0 [lindex $c 0]
                set t1 [lindex $c 1]
                set t2 [lindex $c 2]
                set t3 [lindex $c 3]
                switch $t0 {
                        parameter {add_verilog_parameter_field $t1 "" $t2}
                        input {add_verilog_input_field $t1 "" $t3 $t2}
                        output {add_verilog_output_field $t1 "" $t3 $t2}
                        inout {add_verilog_inout_field $t1 "" $t2}
                        module {
                                $itk_component(vofr).vomn insert list end $t1
                                $itk_component(vofr).vomn component entry \
                                        insert 0 $t1
                        }
                } 
        }
}

itcl::body import_bvi_wizard::remove_param_input_output {} {
        $itk_component(vofr).vomn clear
        foreach i $verilog_parameter {
                delete_field verilog_parameter $i
        }
        foreach i $verilog_input {
                delete_field verilog_input $i
        }
        foreach i $verilog_output {
                delete_field verilog_output $i
        }
        foreach i $verilog_inout {
                delete_field verilog_inout $i
        }
}

itcl::body import_bvi_wizard::save_list_to_file {} {        
        start_process
        if {![check_verilog_module_window]} {
                return
        }
        set name [get_verilog_module_name]
        set types {{{Verilog info files} {.vinfo}} {{All files} {*}}}
        if {[set f [tk_getSaveFile -minsize "350 200" \
                        -title "Save List To File" -parent $win \
                        -filetypes $types \
                        -initialfile $name\_verilog.vinfo]] == ""} {
                return
        }
        if {[file isfile $f]} {
                file delete -force $f
        }
        set id [open $f a+]
        puts $id "module $name;"
        foreach i [get_verilog_parameter] {
                puts $id "parameter $i;"
        }
        foreach i [get_verilog_input] {
                puts $id "input $i;"
        }
        foreach i [get_verilog_output] {
                puts $id "output $i;"
        }
        foreach i [get_verilog_inout] {
                puts $id "inout $i;"
        }
        ::close $id
        finish_process
}

##############################################################################
############################# BVI code generation ############################
##############################################################################

itcl::body import_bvi_wizard::build_output_string {} {
        set module [get_bluespec_module_name]
        set f $module\.bsv
        file delete -force $f
        if {$current_screen == "ffr"} {
                if {[set f [get_save_file_location]] == ""} {
                        set f $module\.bsv
                } else {
                        file delete -force $f
                }
        }
        set id [open $f a+]
        puts $id [get_output_header]
        foreach ip [get_bluespec_package_import] {
                puts $id "import $ip\::*;"
        }
        if {[get_bluespec_interface_type] == "bmirdfm"} {
                write_interface_into_file $id
        }
        write_import_bvi_into_file $id
        ::close $id
}

proc import_bvi_wizard::get_output_header { } {
        global env
        set u ""
        if { [info exists env(USER)] } { set u $env(USER) }
        join \
                [list \
                "// Bluespec wrapper, created by Import BVI Wizard"  \
                "// Created on: [clock format [clock seconds]]" \
                "// Created by: $u" \
                "// BDW version: [commands::version]" \
                "\n" \
                ] "\n"
}

itcl::body import_bvi_wizard::write_interface_into_file {id} {
        set ifc_list [configure_interface_list]
        set ifc_name [get_bluespec_interface_name]
        set g [get_interface_binding]
        set child_ifc ""
        set prov_ifc ""
        foreach p [get_bluespec_provisos] {
                append prov_ifc "type [lindex $p 0], "
        }
        if {[set prov_ifc [string replace $prov_ifc end-1 end]] == ""} {
                set prov_ifc ""
        } else {
                set prov_ifc "#($prov_ifc)"
        }
        puts $id "interface $ifc_name;"
        if {$current_screen != "bmfr"} {
                foreach o [get_verilog_output] {
                        if {[lindex $o 2] == "clock"} {
                                puts $id "\tinterface Clock bsv_[lindex $o 0];"
                        } elseif {[lindex $o 2] == "reset"} {
                                puts $id "\tinterface Reset bsv_[lindex $o 0];"
                        }
                }
                foreach ind [lsearch -index 1 -all $ifc_list no_parent] {
                        set l [lindex $ifc_list $ind]
                        set i [lindex $g [lsearch -index 0 $g [lindex $l 0]]]
                        puts $id "\tinterface [lindex $i 2] [lindex $i 1];"
                        lappend child_ifc [lindex $i 0]
                }
                foreach ind [lsearch -index 1 -all $method_bindings no_parent] {
                        set l [lindex $method_bindings $ind]
                        write_methods_into_interface [lindex $l 0] $id
                }
        }
        puts $id "endinterface"
        write_subinterface_into_interface $child_ifc $id 
}

itcl::body import_bvi_wizard::write_subinterface_into_interface {p_ifc id} {
        if {$p_ifc == ""} {
              return 
        }
        set ifc_list [configure_interface_list]
        set g [remove_interface_from_imported_package]
        set p_ifc [remove_leaf_interface $p_ifc]
        set plist ""
        foreach p $p_ifc {
                set index [lindex [split $p _] end]
                if {[$itk_component(mb_sirb_$index) get] != \
                                "bmb_sirb_mirdfm_$index"} {
                        continue
                }
                set l [lindex $ifc_list [lsearch -index 0 $ifc_list $p]]
                set i [lindex $g [lsearch -index 0 $g [lindex $l 0]]]
                if {[llength $l] == 2} {
                        break
                }
                puts $id "\ninterface [lindex $i 2];"
                set ind 2 
                while {$ind < [llength $l]} {
                        set lind [lindex $l $ind]
                        if {[lindex [split $lind _] 1] == "subi"} {
                                set i [lindex $g [lsearch -index 0 $g $lind]]
                                puts $id "\tinterface [lindex $i 2] [lindex \
                                        $i 1];"
                                lappend plist $lind 
                        } elseif {[lindex [split $lind _] 1] == "mb"} {
                                write_methods_into_interface $lind $id
                        }
                        incr ind
                }
                puts $id "endinterface"
        }
        write_subinterface_into_interface $plist $id
}

itcl::body import_bvi_wizard::write_import_bvi_into_file {id} {
        set module [get_bluespec_module_name]
        set ifc_name [get_bluespec_interface_name]
        set module_args [get_bluespec_module_args]
        set param [get_bluespec_parameter_binding]
        set prov ""
        set prov_name ""
        foreach p [get_bluespec_provisos] {
                append prov_name "[lindex $p 0], "
                append prov "$p, "
        }
        set prov [string replace $prov end-1 end]
        set prov_name [string replace $prov_name end-1 end]
        puts $id "\nimport \"BVI\" [get_verilog_module_name] ="
        if {$module_args != ""} {
                set margs "#([join $module_args ,\ ])"
        } else {
                set margs ""
        }
        if {$prov_name != ""} {
                set prname "#($prov_name)"
        } else {
                set prname ""
        }
        set ifc_name [regsub -all "type " $ifc_name ""]
        set ifc_name [regsub -all "numeric " $ifc_name ""]
        if {$prov != ""} {
                puts $id "module $module $margs ($ifc_name)"
                puts $id "\tprovisos($prov);"

        } else {
                puts $id "module $module $margs ($ifc_name);"
        }
#        foreach ma $module_args {
#                puts $id "\tparameter [lindex $ma 1] = [lindex $ma 1]"
#        }
        if {$param != ""} {
                puts $id ""
                foreach p $param {
                        puts $id "\tparameter [lindex $p 0] = [lindex $p 1];"
                }
        }
        write_default_clock_reset_into_import_bvi $id
        write_input_clock_into_import_bvi $id
        write_input_reset_into_import_bvi $id
        write_inout_into_import_bvi $id
        write_interface_method_into_import_bvi $id
        write_combinational_path_into_file $id
        write_scheduling_annotation_into_file $id
        puts $id "endmodule"
}

itcl::body import_bvi_wizard::write_interface_method_into_import_bvi {id} {
        if {$current_screen == "bmfr"} {
                return
        }
        puts $id ""
        set ifc_list [configure_interface_list]
        set ifc ""
        foreach ind [lsearch -index 1 -all $ifc_list no_parent] {
                lappend ifc [lindex [lindex $ifc_list $ind] 0]
        }
        foreach ind [lsearch -index 1 -all $method_bindings no_parent] {
                set l [lindex $method_bindings $ind]
                write_methods_into_import_bvi [lindex $l 0] $id
        }
        write_subinterface_into_import_bvi $ifc $id 
        write_port_bindings_into_import_bvi $id 
}

itcl::body import_bvi_wizard::write_combinational_path_into_file {id} {
        set list [list cpfr safr ffr]
        if {[lsearch $list $current_screen] == -1} {
                return
        }
        if {[get_combinational_path_input_output] == ""} {
                return
        }
        puts $id ""
	foreach i [get_combinational_path_input_output] {
                puts $id "\tpath ([lindex $i 0], [lindex $i 1]);"
        }
}

itcl::body import_bvi_wizard::write_scheduling_annotation_into_file {id} {
        puts $id ""
        set list [list safr ffr]
        if {[lsearch $list $current_screen] == -1} {
                return
        }
        foreach i $methodpairs {
                lassign [split $i ,] a0 a1
                set an [subst $[namespace current]::SCHED_ANNOTATION($i)]
                if {$an == "SA" || $an == "SAR"} {
                        puts $id "\tschedule $a1 [regsub A $an B] $a0;"
                } else {
                        puts $id "\tschedule $a0 $an $a1;"
                }
        }
}

itcl::body import_bvi_wizard::remove_interface_from_imported_package {} {
        set ifc [get_interface_binding]
        foreach p [get_bluespec_package_import] {
                if {[catch "Bluetcl::bpackage load $p" log]} {
                        puts stderr "\n$log"
                        continue
                }
                foreach pckg $log {
                        #foreach a [Bluetcl::defs all $pckg] 
                        #        #set a [lindex [split $a "::"] 2]
                        #        set lo ""
                        #        set c [catch "Bluetcl::type constr $a" lo]
                        foreach a [Bluetcl::defs type $pckg] {
                                set c [catch {Bluetcl::type constr $a} lo]
                                if {$c == 0} {
                                        set list [Bluetcl::type full $lo]
                                        if {[lindex $list 0] == "Interface"} {
                                                set n [lindex $list 1]
                                                set n [lindex [split $n "::"] 2]
                                                if {[set l [lsearch -index 2 \
                                                        $ifc $n]] != -1} {
                                                        set ifc [lreplace $ifc $l $l]
                                                }
                                         }
                                }
                        }
                }
        }
        return $ifc
}

itcl::body import_bvi_wizard::remove_leaf_interface {list} {
        set l ""
        foreach i $list {
                set ind [lsearch -index 0 $interface_binding $i]
                if {[llength [lindex $interface_binding $ind]] > 2} {
                        lappend l $i
                }
        }
        return $l
}

itcl::body import_bvi_wizard::write_methods_into_interface {mname id} {
        set gm [get_method_binding]
        set m [lindex $gm [lsearch -index 0 $gm $mname]]
        set n [lindex $m 2]
        set args ""
        foreach i [lindex $m end] {
                set type [lindex $i 0]
                set name [string tolower [lindex [lindex $i 1] 0]]
                set rnge [lindex $i 1]
                lappend args "$type $name"
        }
        set args [join $args ", "]
        if {[lindex $m 3] == "always enabled" && \
                                        [lindex $m 4] == "always ready"} {
                puts $id "\t(*always_ready , always_enabled*)"
        } elseif {[lindex $m 3] == "always enabled"} {
                puts $id "\t(*always_ready*)"
        } elseif {[lindex $m 4] == "always ready"} {
                puts $id "\t(*always_enabled*)"
        }
        if {$n == "value"} {
                puts $id "\tmethod [lindex $m 5] [lindex $m 1] ($args);"
        } elseif {$n == "action_value"} {
                puts $id "\tmethod ActionValue #( [lindex $m 5] ) \
                        [lindex $m 1] ($args);"
        } elseif {$n == "action"} {
                puts $id "\tmethod Action [lindex $m 1] ($args);"
        }
}

itcl::body import_bvi_wizard::write_port_bindings_into_import_bvi {id} {
        set port [get_port_binding]
        foreach p $port {
                puts $id "\tport [lindex $p 0] = [lindex $p 1];"
        }
}

itcl::body import_bvi_wizard::write_subinterface_into_import_bvi {p_ifc id} {
        if {$p_ifc == ""} {
              return 
        }
        set ifc_list [configure_interface_list]
        set g [get_interface_binding]
        set p_ifc [remove_leaf_interface $p_ifc]
        set plist ""
        foreach p $p_ifc {
                set l [lindex $ifc_list [lsearch -index 0 $ifc_list $p]]
                set i [lindex $g [lsearch -index 0 $g [lindex $l 0]]]
                if {[llength $l] == 2} {
                        break
                }
                puts $id "\n\tinterface [lindex $i 2] [lindex $i 1];"
                set ind 2 
                while {$ind < [llength $l]} {
                        set lind [lindex $l $ind]
                        if {[lindex [split $lind _] 1] == "subi"} {
                                set i [lindex $g [lsearch -index 0 $g $lind]]
                                puts $id "\t\tinterface [lindex $i 2] [lindex \
                                        $i 1];"
                                lappend plist $lind 
                        } elseif {[lindex [split $lind _] 1] == "mb"} {
                                write_methods_into_import_bvi $lind $id "\t"
                        }
                        incr ind
                }
                puts $id "\tendinterface"
        }
        if {$plist != ""} {
                write_subinterface_into_import_bvi $plist $id
        }
}

itcl::body import_bvi_wizard::write_methods_into_import_bvi \
                                                        {mname id {tab ""}} {
        set gm [get_method_binding]
        set m [lindex $gm [lsearch -index 0 $gm $mname]]
        set args ""
        foreach i [lindex $m end] {
                set vlname [lindex [lindex $i 1] 0]
                set range  [lrange [lindex $i 1] 1 end]
                regsub -all { } $range {} range
                lappend args "$vlname $range"
        }
        set args [join $args ", "]
        set mname [lindex $m 1]
        set enr "$mname ($args)\n\t\t"
        if {[set enbl [lindex $m 3]] == "always enabled"} {
                set enbl "(*inhigh*)$mname\_enable"
        }
        if {[set rd [lindex $m 4]] == "always ready"} {
                set rd ""
        }
        if {$enbl != ""} {
                set enr "$enr enable($enbl)"
        }
        if {$rd != ""} {
                set enr "$enr ready($rd)"
        }
        if {[lindex $m 7] != ""} {
                set enr "$enr clocked_by([lindex $m 7])"
        }
        if {[lindex $m 8] != ""} {
                set enr "$enr reset_by([lindex $m 8])"
        }
        if {[lindex $m 2] == "action"} {
                puts $id "$tab\tmethod $enr;"
        } else {
                puts $id "$tab\tmethod [lindex $m 6] $enr;"
        }
}

itcl::body import_bvi_wizard::write_default_clock_reset_into_import_bvi {id} {
        puts $id ""
        set dc [get_bluespec_input_clock_default]
        puts $id "\tdefault_clock $dc;"
        set dr [get_bluespec_input_reset_default]
        puts $id "\tdefault_reset $dr;"
}

itcl::body import_bvi_wizard::write_input_clock_into_import_bvi {id} {
        puts $id ""
        foreach clock [get_bluespec_input_clock] {
                if {[lindex $clock 1] != "" && [lindex $clock 2] != ""} {
                        set string "\tinput_clock [lindex $clock 0] \([lindex \
                                $clock 1], [lindex $clock 2]\) "
                } elseif {[lindex $clock 1] != "" && [lindex $clock 2] == ""} {
                        set string "\tinput_clock [lindex $clock 0] \([lindex \
                                $clock 1]\) "
                } elseif {[lindex $clock 1] == "" && [lindex $clock 2] == ""} {
                        set string "\tinput_clock [lindex $clock 0] \(\) "
                }
                if {[lindex $clock 3] == "exposeCurrentClock"} {
                        set string "$string <- [lindex $clock 3];"
                } else {
                        set string "$string = [lindex $clock 3];"
                }
                puts $id $string
        }
}

itcl::body import_bvi_wizard::write_input_reset_into_import_bvi {id} {
        foreach reset [get_bluespec_input_reset] {
                set string "\tinput_reset [lindex $reset 0] \([lindex \
                        $reset 1]\) clocked_by\([lindex $reset 2]\) "
                if {[lindex $reset 3] == "exposeCurrentReset"} {
                        set string "$string <- [lindex $reset 3];"
                } else {
                        set string "$string = [lindex $reset 3];"
                }
                puts $id $string
        }
}

itcl::body import_bvi_wizard::write_inout_into_import_bvi {id} {
        puts $id ""
        foreach inout [get_bluespec_inout] {
                puts $id "\tinout [lindex $inout 0] clocked_by \([lindex \
                        $inout 1]\) reset_by \([lindex $inout 2]\) = [lindex \
                        $inout 3];"
        }
}

##############################################################################
############################## Action commands ###############################
##############################################################################

itcl::body import_bvi_wizard::compile_file {} {
        set file [get_save_file_location]
        if {$file == ""} {
                set file "[get_bluespec_module_name].bsv"
        }
        $itk_component(fstf) export $file
        commands::compile_file $file
}

itcl::body import_bvi_wizard::start_process {} {
        global BSPEC
        $BSPEC(IMPORT_BVI) configure -cursor watch
}

itcl::body import_bvi_wizard::finish_process {} {
        global BSPEC
        $BSPEC(IMPORT_BVI) configure -cursor {}
}

itcl::body import_bvi_wizard::refresh_wizard_size {} {
        global BSPEC
        if {$current_screen != "mpfr"} {
                return
        }
        set frac [lindex [$itk_component(mppane) fraction] 1]
        set new_width [lindex [split [wm geometry $BSPEC(IMPORT_BVI)] x] 0]
        set new_width [expr $frac*$new_width/100]
        if {$new_width == $current_width} {
                return
        }
        set current_width $new_width
        foreach i $propagate_list {
                set_method_port_interface_size "" "" "" \
                        $itk_component([lindex $i 0])
        }
}

itcl::body import_bvi_wizard::action_close {} {
        wm withdraw $itk_interior
}

itcl::body import_bvi_wizard::action_cancel {} {
        wm deiconify $itk_interior
        raise $itk_interior
        if {![ignore_warning "Do you really want to cancel the wizard ?\n\
                All information will be lost." $win]} {
                return 0
        }
        if {[winfo exists .sbvi]} {
                 itcl::delete object .sbvi
        }
        itcl::delete object $win
        return 1
}

itcl::body import_bvi_wizard::action_next {} {
        start_process
	if {[action_check]} {
		switch $current_screen {
			vfr {create_bluespec_module_window next}
			bmfr {create_method_port_window next}
			mpfr {create_combinational_path_window next}
			cpfr {create_scheduling_annotation_window next}
			safr {
                                build_output_string
                                create_finish_window next
                        }
                        ffr {action_close}
		}
	}
        finish_process
}

itcl::body import_bvi_wizard::action_back {} {
        start_process
        switch $current_screen {
		bmfr {create_verilog_module_window back}
		mpfr {create_bluespec_module_window back}
		cpfr {create_method_port_window back}
		safr {create_combinational_path_window back}
		ffr {create_scheduling_annotation_window back}
        }
        finish_process
}

itcl::body import_bvi_wizard::action_switch {scr} {
        if {$scr == $current_screen} {
                return
        }
        switch $scr {
		vfr {create_verilog_module_window back}
		bmfr {create_bluespec_module_window next}
		mpfr {create_method_port_window next}
		cpfr {create_combinational_path_window next}
		safr {create_scheduling_annotation_window next}
                ffr {create_finish_window next}
        }
}

itcl::body import_bvi_wizard::action_check {{type 0}} {
        start_process
        set result ""
        switch $current_screen {
                vfr  {set result [check_verilog_module_window $type]}
                bmfr {set result [check_bluespec_module_window $type]}
                mpfr {set result [check_method_port_window $type]}
                cpfr {set result [check_combinational_path_window $type]}
                safr {set result [check_scheduling_annotation_window $type]}
                ffr  {set result [check_finish_window $type]}
        }
        finish_process
        return $result
}

itcl::body import_bvi_wizard::action_show {} {
        if {$current_screen == "vfr"} {
                return
        }
        if {$current_screen == "ffr"} {
                set file [get_save_file_location]
                if {$file == ""} {
                        set file "[get_bluespec_module_name].bsv"
                }
                $itk_component(fstf) export $file
                create_bvi_show_dialog $file
        } elseif {[action_check]} {
                build_output_string
                set file "[get_bluespec_module_name].bsv"
                create_bvi_show_dialog $file
        }
}

itcl::body import_bvi_wizard::auto_create_from_verilog {} {
        start_process
        rebuild_method_port_binding

        set ch $itk_component(mpi_propagate_0)
        foreach i [get_verilog_input] {
                if {[lindex $i 2] != "clock" && [lindex $i 2] != "reset"} {
                        create_method_bindings_frame $ch [lindex $i 0] action
                }
        }
        foreach i [get_verilog_output] {
                if {[lindex $i 2] != "clock" && [lindex $i 2] != "reset"} {
                        create_method_bindings_frame $ch [lindex $i 0] value
                }
        }
        foreach i [get_verilog_inout] {
                create_interface_bindings_frame $ch [lindex $i 0]
        }
        finish_process
}

itcl::body import_bvi_wizard::build_skeleton {frame {parent ""} {cis ""}} {
        start_process
        global BSPEC
        set list [get_loaded_interfaces]
        if {$parent != ""} {
                set siid [lindex [split $parent "_"] end]
                set ent "mb_subi_type_$siid"
                set i [$itk_component($ent) get]
        } else {
                set i [get_interface_name]
                set ent "mpi"
        }
        if {[lsearch $list $i] == -1} {
                if {[set i [create_build_skeleton_dialog \
                        "Build Skeleton"]] == ""} {
                        finish_process
                        return
                } else {
                        $itk_component($ent) clear
                        $itk_component($ent) insert 0 $i
                }
        }
        if { [Bluetcl::bpackage list] == "" } {
                set msg [list \
                             "Packages must be loaded for build skeleton\
                             operation" \
                             "use package browser or" \
                             "WS::Analysis::load_package <package_name>" \
                             "to load package from the workstation" ]
                error_message [join $msg " "] $BSPEC(IMPORT_BVI)
                return 
        }
        if { [catch {Bluetcl::type full $i} ifc] } {
                set msg [list \
                             "Invalid interface type $i" \
                             "or appropriate package has not been loaded $i" \
                             "\n$ifc" ]
                error_message [join $msg " "] $BSPEC(IMPORT_BVI)
                return  
        }
        set ch $itk_component(port_meth_ifc)
        if {$parent == ""} {
                rebuild_method_port_binding
        } else {
                set ind [lsearch -index 0 $interface_binding $parent]
                set list [lindex $interface_binding $ind]
                for {set i 2} {$i < [llength $list]} {incr i} {
                        remove_given_binding [regsub "_fr_" [lindex $list \
                                $i] "_ch_"]
                }
        }
        set cs $itk_component($frame)
        foreach mi [lindex [lsearch -index 0 -inline $ifc members] 1] {
                if {[lindex $mi 0] == "method"} {
                        set type [lindex [lindex $mi 1] 0]
                        set name [lindex [lindex $mi 1] 1]
                        set arg  [lindex [lindex $mi 1] 2]
                        create_method_bindings_frame $cs $name $type \
                                $parent $arg
                }
                if {[lindex $mi 0] == "interface"} {
                        set name [lindex [lindex $mi 1] 0]
                        create_interface_bindings_frame $cs $name $parent
                }
        }
        finish_process
}

##############################################################################
############################ Setting the bindings ############################
##############################################################################

itcl::body import_bvi_wizard::set_name_bindings {fr} {
        bind [$itk_component($fr) component entry] <KeyRelease> {
                global BSPEC
                set l [split [lindex [split %W .] end-2] _]
                $BSPEC(IMPORT_BVI) update_method_ifc_list_name [lindex $l 3] \
                        [lindex $l 1]
        }
}

itcl::body import_bvi_wizard::set_binding_for_pane {id} {
        set w [$itk_component(ipane_$id) get_sash 1]
        bind $w <B1-Motion> {+
                set w [join [lreplace [split %W .] end end] .]
                set p1 [lindex [$w get_fraction] 1]
                set temp ""
                set l [lreverse [split $w .]]
                foreach i $l {
                       if {[lindex [split $i _] end-1] != "propagate"} {
                               set temp $temp.$i
                       } else {
                               set length [expr [string length \
                                       $temp] - 1]
                               set fr [string replace $w \
                                       end-$length end]
                               break
                       }
                }
                if {$p1 == 1.0} {
                        set old_y [lindex [pack info $w] [expr [lsearch \
                                -exact [pack info $w] -ipady] + 1]]
                        set new_y [expr $old_y + 1]
                        pack $w -ipady $new_y
                        $w fraction 100 0 
                        set height [expr [$fr cget -height] + 2]
                        $fr configure -height $height

                } else {
                        set height [expr [$fr cget -height] - 2]
                        $fr configure -height $height
                }
        }
        bind $w <B1-ButtonRelease-1> {+
                set w [join [lreplace [split %W .] end end] .]
                set p1 [lindex [$w get_fraction] 1]
                if {$p1 != 1.0} {
                        set old_y [lindex [pack info $w] [expr [lsearch \
                                -exact [pack info $w] -ipady] + 1]]
                        set new_y [expr $old_y * $p1]
                        pack $w -ipady $new_y
                        $w fraction 100 0 
                }
        }
}

itcl::body import_bvi_wizard::set_bindings {name} {
        bind $itk_component($name) <Return> {
                %W invoke
        }

}

itcl::body import_bvi_wizard::set_wizard_bindings {} {
        global BSPEC
        set w $BSPEC(IMPORT_BVI)
        bind $w <Alt-S> {
                $BSPEC(IMPORT_BVI) action_show 
        }
        bind $w <Alt-C> {
                $BSPEC(IMPORT_BVI) action_check 1
        }
        bind $w <Alt-Key-Left> {
                $BSPEC(IMPORT_BVI) action_back 
        }
        bind $w <Alt-Key-Right> {
                if {[$BSPEC(IMPORT_BVI) get_current_screen] != "ffr"} {
                        $BSPEC(IMPORT_BVI) action_next
                }
        }
        bind $w <Control-w> {
                $BSPEC(IMPORT_BVI) action_cancel
        }
        bind $w <Control-W> {
                $BSPEC(IMPORT_BVI) action_cancel
        }
        bind $w <Configure> {
                $BSPEC(IMPORT_BVI) refresh_wizard_size
        }
}

itcl::body import_bvi_wizard::set_show_number_binding {} {
        bind [$itk_component(fstf) component vertsb] <ButtonRelease-1> {
                set w [regsub "vertsb" %W "clipper.text"]
                set c [expr [lindex [split [$w index end] .] 0] - 1]
                for {set i 0} {$i <= $c} {incr i} {
                        if {[$w bbox "$i.0"] != ""} {
                                [regsub "frtf.fstf" $w "fltf.fsnf"] yview "$i.0"
                                $w yview "$i.0"
                                break
                        }
                }
        }
        bind [$itk_component(fstf) component vertsb] <B1-Motion> {
                set w [regsub "vertsb" %W "clipper.text"]
                set c [expr [lindex [split [$w index end] .] 0] - 1]
                for {set i 0} {$i <= $c} {incr i} {
                        if {[$w bbox "$i.0"] != ""} {
                                [regsub "frtf.fstf" $w "fltf.fsnf"] yview "$i.0"
                                $w yview "$i.0"
                                break
                        }
                }
        }
        bind [$itk_component(fstf) component text] <4> {
                [regsub "frtf.fstf" %W "fltf.fsnf"] yview scroll -50 pixels
        }
        bind [$itk_component(fstf) component text] <5> {
                [regsub "frtf.fstf" %W "fltf.fsnf"] yview scroll 50 pixels
        }
        bind [$itk_component(fsnf) component text] <4> {
                [regsub "fltf.fsnf" %W "frtf.fstf"] yview scroll -50 pixels
        }
        bind [$itk_component(fsnf) component text] <5> {
                [regsub "fltf.fsnf" %W "frtf.fstf"] yview scroll 50 pixels
        }
        bind [$itk_component(fstf) component text] <KeyRelease> {
                global BSPEC
                $BSPEC(IMPORT_BVI) set_finish_numbering
        }
}

##############################################################################
############################## Analysis actions ##############################
##############################################################################

itcl::body import_bvi_wizard::empty_combobox {cmb} {
        if {[$cmb get] == "/* empty */"} {
                $cmb configure -editable yes
                $cmb clear entry
                $cmb configure -editable readonly
        }
}

itcl::body import_bvi_wizard::configure_interface_list {} {
        set ifc_list $interface_binding
        foreach i $ifc_list {
                if {[llength $i] != 2} {
                        foreach s $i {
                                set l [lsearch -index 0 $ifc_list $s]
                                if {$l != -1 && \
                                        [llength [lindex $ifc_list $l]] == 2} {
                                        set ifc_list [lreplace $ifc_list $l $l]
                                }
                        }
                }
        }
        return $ifc_list
}

itcl::body import_bvi_wizard::show_method_port_ifc {bt pa list {f ""}} {
        if {$f != ""} {
                set fr $itk_component([regsub "_fr_" $f "_propagate_"])
        } else {
                set fr $itk_component(mpi_propagate_0)
        }
        set id [lindex [split $pa "_"] 3]
        set pid $id
        set wi [join [regsub $pid [split $pa "_"] [incr id]] "_"]
        while {[eval lsearch -index 0 $$list $wi] != -1 && \
                        ![winfo ismapped $itk_component($wi)]} {
                set wi [join [regsub $pid [split $pa "_"] [incr id]] "_"]
        }
        if {[$itk_component(port_meth_ifc) get $bt]} {
                if {[eval lsearch -index 0 $$list $wi] != -1 && \
                               [winfo ismapped $itk_component($wi)]} {
                        pack $itk_component($pa) -before $itk_component($wi) \
                               -fill both -expand true
                } else {
                        pack $itk_component($pa) -expand true -fill both
                }
                set action "+"
        } else {
                pack forget $itk_component($pa)
                set s [eval lindex $$list [eval lsearch -index 0 $$list $pa]]
                if {[llength $s] > 2 && $list != "method_bindings"} {
                        for {set i 2} {$i < [llength $s]} {incr i} {
                                set p [lindex $s $i]
                                pack forget $itk_component($p)
                                set c [regsub "_fr_" $p "_ch_"]
                                $itk_component(port_meth_ifc) deselect $c
                        }
                }
                set action "-"
        }
        switch $list {
                method_port_bindings {
                        set_method_port_interface_size "" port $action $fr
                }
                method_bindings {
                        set_method_port_interface_size "" method $action $fr
                }
                interface_binding {
                        set_method_port_interface_size "" interface $action $fr
                }
        }
}

itcl::body import_bvi_wizard::method_binding_enable {name id} {
        set er $itk_component(mb_enrefr_$id)
        set rts $itk_component(mb_rtrsfr_$id) 
        $er.mb_enable_cmb_$id configure -state disabled 
        $itk_component(mb_returnt_ent_$id) configure -state disabled
        $rts.mb_returnp_cmb_$id configure -state disabled
        switch $name {
                action {
                        $er.mb_enable_cmb_$id configure -state normal
                }
                action_value {
                        $er.mb_enable_cmb_$id configure -state normal
                        $itk_component(mb_returnt_ent_$id) configure \
                                -state normal
                        $rts.mb_returnp_cmb_$id configure -state normal
                }
                value {
                        $itk_component(mb_returnt_ent_$id) configure \
                                -state normal
                        $rts.mb_returnp_cmb_$id configure -state normal
                }
        }
}

itcl::body import_bvi_wizard::update_method_ifc_list_name {id type} {
        if {$type == "method"} {
                set text [$itk_component(mb_method_name_$id) get]
                set ind [lsearch -index 0 $method_bindings mb_mb_fr_$id]
                set method_bindings [lreplace $method_bindings $ind $ind \
                        [lreplace [lindex $method_bindings $ind] 2 2 $text]]
                $itk_component(port_meth_ifc) buttonconfigure mb_mb_ch_$id \
                        -text "method $text"
        } elseif {$type == "subi"} {
                set text [$itk_component(mb_subi_name_$id) get]
                $itk_component(port_meth_ifc) buttonconfigure mb_subi_ch_$id \
                        -text "interface $text"
        }
}

itcl::body import_bvi_wizard::save_now {{s "false"}} {
        if {[check_finish_window]} {
                $itk_component(next) configure -text "Close" -state normal
                $itk_component(fstf) export [get_save_file_location]
                file delete -force [get_bluespec_module_name].bsv
                if {$s} {
                        create_status_dialog "Save File Status" \
                                "The information is saved in\
                                [get_save_file_location] file" $win
                }
        }
}

itcl::body import_bvi_wizard::select_file {} {
        set type {{{Bsv files} {.bsv} }}
        set s [tk_getSaveFile -minsize "350 200" -title "Select File" \
                                -filetypes $type -parent $win]
        if {$s != ""} {
                $itk_component(save_to_file) clear 
                $itk_component(save_to_file) insert end $s
        }
}

itcl::body import_bvi_wizard::open_wizard_menu {} {
        change_menu_status wizard "vmo bmd mpb cp sa finish" disabled
        foreach s $screens {
                switch $s {
                	vfr  {set s "vmo"}
                	bmfr {set s "bmd"}
                	mpfr {set s "mpb"}
                	cpfr {set s "cp"}
                	safr {set s "sa"}
                	ffr  {set s "finish"}
                }
		change_menu_status wizard $s normal
        }
}

itcl::body import_bvi_wizard::hide_screens {{frame ""} {action ""}} {
        $itk_component(back) configure -state disabled
        $itk_component(next) configure -state disabled
        foreach f $screens {
                pack forget $itk_component($f)
        }
        if {$frame != ""} {
		if {$action == "back"} {
			return 2
		} elseif {$action == "next"} {
			if {[info exists itk_component($frame)]} {
                                return 1
			}
		}
        }
	return 0
}

itcl::body import_bvi_wizard::choose_default_annotation {l id1 id2} {
        set m1list [lindex $l [lsearch -index 0 $l mb_mb_fr_$id1]]
        set m2list [lindex $l [lsearch -index 0 $l mb_mb_fr_$id2]]
        if {[lindex $m1list 7] != [lindex $m2list 7]} {
                return "CF"
        }
	set t1 [lindex $m1list 2]
	set t2 [lindex $m2list 2]
	if {$t1 == "value"} {
		if {$t2 == "value"} {
			return "CF"
		} elseif {$t2 == "action" || $t2 == "action_value"} {
			return "SB"
		}
	} elseif {$t1 == "action"} {
		if {$t2 == "action"} {
	                if {[lindex $m1list 1] == [lindex $m2list 1]} {
        			return "C"
                        } else {
        			return "CF"
                        }
		} elseif {$t2 == "action_value"} {
			return "C"
		} elseif {$t2 == "value"} {
			return "SA"
		}
	} elseif {$t1 == "action_value"} {
		if {$t2 == "action_value" || $t2 == "action"} {
			return "C"
		} elseif {$t2 == "value"} {
			return "SA"
		}
	}
}

itcl::body import_bvi_wizard::insert_method_after_parent {id text parent name} {
        set ch $itk_component(port_meth_ifc)
        if {$parent != ""} {
                lappend method_bindings "mb_mb_fr_$id $parent $name"
                set pnum [lsearch -index 0 $interface_binding $parent]
                set pind [lindex $interface_binding $pnum]
                set ppid [lindex [split $parent _] end]
                set x [expr [$ch component mb_subi_ch_$ppid cget -padx] + 15]
                set pap [get_interface_last_checkbutton $pind]
                $ch insert_after $pap mb_mb_ch_$id \
                        -padx $x -pady 2 -text $text \
                        -highlightthickness 1 -highlightbackground white
                set interface_binding [lreplace $interface_binding $pnum $pnum \
                        "$pind mb_mb_fr_$id"]
        } else {
                lappend method_bindings "mb_mb_fr_$id no_parent $name"
                $ch add mb_mb_ch_$id -padx 0 -pady 2 -text $text \
                        -highlightthickness 1 -highlightbackground white
        }
}

itcl::body import_bvi_wizard::insert_interface_after_parent {id text parent} {
        set ch $itk_component(port_meth_ifc)
        if {$parent != ""} {
                lappend interface_binding "mb_subi_fr_$id $parent"
                set pnum [lsearch -index 0 $interface_binding $parent]
                set pind [lindex $interface_binding $pnum]
                set ppid [lindex [split $parent _] end]
                set x [expr [$ch component mb_subi_ch_$ppid cget -padx] + 15]
                set pap [get_interface_last_checkbutton $pind]
                $ch insert_after $pap mb_subi_ch_$id \
                        -padx $x -pady 2 -text $text \
                        -highlightthickness 1 -highlightbackground white
                set interface_binding [lreplace $interface_binding $pnum $pnum \
                        "$pind mb_subi_fr_$id"]
        } else {
                lappend interface_binding "mb_subi_fr_$id no_parent"
                $ch add mb_subi_ch_$id -padx 0 -pady 2 -text $text \
                        -highlightthickness 1 -highlightbackground white
        }
}

itcl::body import_bvi_wizard::change_menu_status {m n st} {
        foreach i $n {
                 $this component menu set_state $m $i $st
        }
}

itcl::body import_bvi_wizard::print_status {type} {
        if {$type} {
                create_status_dialog "Check Status" "All information looks\
                        correct" $win
        }
}

# Check a regular expression and report an error dialog is the pattern is invalid
# otherwise return the pattern
itcl::body import_bvi_wizard::check_regexp { entry } {
        set exp [$entry get]
        if { [catch {regexp $exp Teststring} err] } {
                $entry configure -background yellow
                error_message "Could not compile regular expression:\n$exp" $::BSPEC(IMPORT_BVI)
                error "Bad regexp"
        } else {
                $entry configure -background white
        }
        return $exp
}

proc import_bvi_wizard::create_bsv_type { range } {
        regsub -all {[\ ]} $range "" range
        # Default range when not given
        if { $range == "0:0" } {
            return Bool
        }
        # strictly numeric
        if { [regexp {^\s*(\d+)\s*:\s*(\d+)\s*$} $range a h l] } {
            set sz [expr $h - $l + 1]
            return "Bit#($sz)"
        }
        # special case of n-1:0
        if { [regexp {^(\w+)\s*-\s*1\s*:\s*0\s*$} $range a h] } {
                set h [string tolower $h]
                return "Bit#($h)"
        }
        # otherwise create a type variable from the range
        regsub -all {[ \-+*`()]+} $range "_" s1
        regsub -all {:} $s1 "_to_" sub
        return "t_$sub"
}

########################## Create the wizard window ###########################

proc create_import_bvi_wizard_window {} {
        global BSPEC
        global PROJECT
        import_bvi_wizard $BSPEC(IMPORT_BVI) -title "Import BVI Wizard" 
        wm geometry $BSPEC(IMPORT_BVI) $PROJECT(WIZARD_PLACEMENT) 
        wm minsize $BSPEC(IMPORT_BVI) 950 650
}

## Local Variables:
## eval: (set (make-local-variable 'tcl-indent-level) 8)
## End:
