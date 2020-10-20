
package require MathSupport
package require Functional

namespace eval ::TypeSupport {


    namespace export \
        create_signal_name \
        cleanUpType \
        stripOuterType \
        correct_primitive_names \
        getBriefType \

    namespace import ::MathSupport::*

    proc create_signal_name {name lsb size} {
        if { $lsb == -1 } {
            return $name
        }
        return "$name\[[plus $lsb [plus $size -1]]:$lsb\]"
    }

################################################################################
### Remove ActionValue from type name
################################################################################

    proc cleanUpType {type_name} {
        set length [string length $type_name]
        set type_name [stripOuterType "ActionValue" $type_name]
        
        set modified [expr [string length $type_name] != $length]
        
        if $modified {
            return [cleanUpType $type_name]
        }
        return $type_name
    }

################################################################################
### turns Maybe#(Bit#(2)) to Bit#(2) for instance
################################################################################

    proc stripOuterType {outer_name type_name} {
        set length [string length $type_name]

        regsub "^$outer_name\#" $type_name "" type_name
        
        set modified [expr [string length $type_name] != $length]
        
        if $modified {
            
            regsub {^[ \t]*\(} $type_name "" type_name
            regsub {\)[ \t]*$} $type_name "" type_name
            return [stripOuterType $outer_name $type_name]
            
        }
        return $type_name
    }

################################################################################
### Create a brief user-useful version of the type (for display for instance).
################################################################################

    proc getBriefType {type_name} {
        
        regsub  -all {[^ \(\)]*::} $type_name "" type_name
        regsub  {\#.*} $type_name "" brief_name
        
        if {($brief_name == "Bit") || ($brief_name == "Int") || ($brief_name == "UInt")} {
            set brief_name $type_name
        }
	
	if {$brief_name == "Maybe" || $brief_name == "Vector"} {
	    ## in this case do some real work ...
	    set list_expr [type_to_list $type_name]
	    set result    [list_to_type [type_brief $list_expr]]
## Remove spaces?	    
##	    regsub -all " " $result "" result
	    return $result
	}
        
        return $brief_name 
        
    }

################################################################################
###
################################################################################

    proc type_to_list {expression} {
	regsub -all "," $expression "" mod
	regsub -all "\(\[A-Za-z0-9\]+\)#\\(" $mod "\{\\1 " mod
	regsub -all "\\)" $mod "\}" mod
	if {[llength $mod] == 1} {
	    set mod [lindex $mod 0]
	}
	return $mod
    }
    
    proc list_to_type {list_expr} {
	if {[llength $list_expr] == 1} {
	    return [lindex $list_expr 0]
	}
	set type [lindex $list_expr 0]
	set args  [::Functional::map list_to_type [lrange $list_expr 1 end]]
	set cargs [::Functional::map add_comma $args]
	
	regsub -all "\{" $cargs "" cargs
 	regsub -all "\}" $cargs "" cargs
	
	set result "$type\#\($cargs\)"
	
 	regsub -all ",\\)" $result "\)" result
	
	return $result
    }
    
    proc add_comma {expression} {
	return "$expression,"
    }

    proc type_brief {list_expr} {
        
	set brief [lindex $list_expr 0]
        
	if {($brief == "Bit") || ($brief == "Int") || ($brief == "UInt")} {
	    set brief $list_expr
	}
	
	if {$brief == "Maybe"} {
	    set inner_types  [lrange $list_expr 1 end]
	    set mapped [::Functional::map type_brief $inner_types]
	    return "Maybe $mapped"
	}
	
	if {$brief == "Vector"} {
	    set inner_types  [lrange $list_expr 1 end]
	    set mapped [::Functional::map type_brief $inner_types]
	    return "Vector $mapped"
	}
	
	return $brief
    }

################################################################################
###
################################################################################

    # returns a list of signal and type for the hierarchy level
    proc getPortTypesForInstance { instKind module inst } {
        switch $instKind {
            "Primitive"   { 
                set ports [Bluetcl::submodule porttypes $module]
                set detail [findKey $inst $ports]
                return [lindex [findKey ports $detail] 1]
            }
            "Synthesized" { return [Bluetcl::module porttypes $module]}
            default       { return [list] }
        }
    }


    proc findKey { key ls } {
        foreach l $ls {
            if { $key == [lindex $l 0] } {
                return $l
            }
        }
        return [list]
    }

    #Waveform viewers use slightly different names for things
    proc correct_primitive_names { module tsigs } {
        switch -regexp $module {
            {^CRegN|^CRegA|^CRegUN} {
                set tsigs [correct_inlined_creg_names $tsigs]
            }
            {RegN$|RegA$|RegUN$} {
                set tsigs [correct_inlined_reg_names $tsigs]
            }
            {CrossingRegN$|CrossingRegA$|CrossingRegUN$|RegAligned$} {
                set tsigs [correct_inlined_reg_names $tsigs 1]
            }
            {^Probe$}  {
                set tsigs [correct_inlined_probe_names $tsigs]
            }
            {^CrossingBypassWire$|^BypassWire$|^RWire$} {
                set tsigs [correct_inlined_rwire_names $tsigs]
            }
            {^RWire0$} {
                set tsigs [correct_inlined_rwire0_names $tsigs]
            }
            {^RegFile$|^RegFileLoad$} {
                set tsigs [correct_regfile_names $tsigs]
            }
            {^SyncFIFO} {
                set tsigs [correct_syncfifo_names $tsigs]
            }
            default {}
        }
        set tsigs [fix_remove_dollar $tsigs]
        return $tsigs
    }

    proc correct_inlined_reg_names { tsigs {cross_reg 0}} {
        set bluesim [isBlueSim]
        set notinlined 0
	if { [regexp "no-inline-reg"  [get_module_flag inline-reg]] || ($cross_reg && [regexp "no-inline-cross"  [get_module_flag inline-cross]])} {
	    set notinlined 1
	}
        set ret [list]
        if { $bluesim } {
            foreach ts $tsigs {
                set t [lindex $ts 0]
                set s [lindex $ts 1]
                if { [regsub {/Q_OUT$} $s "" ns] } {
                    # grab the module name
                    set nm $ns
                } else {
                    continue
                }
                lappend ret [list $t $ns]
            }
        } else {
            if { $notinlined } {
                set ret $tsigs
            } else {
                foreach ts $tsigs {
                    set t [lindex $ts 0]
                    set s [lindex $ts 1]
                    if { [regsub {/Q_OUT$} $s "" ns] } {
                        # grab the module name
                        set nm $ns
                    } elseif { [regsub {/D_IN$} $s {$D_IN} ns] } {
                    } elseif { [regsub {/EN$} $s {$EN} ns] } {
                    } elseif { [regexp {CLK|RST} $s] } {
                        # ignore clock and resets, they are not there!
                        continue
                    } else {
                        set ns $s
                    }
                    lappend ret [list $t $ns]
                }
            }
        }
        return $ret
    }

    proc correct_inlined_creg_names { tsigs } {
        set bluesim [isBlueSim]
        set notinlined 0
	if { [regexp "no-inline-creg"  [get_module_flag inline-creg]] } {
	    set notinlined 1
	}
        set ret [list]
        if { $bluesim || $notinlined } {
	    set ret $tsigs
	} else {
	    # some of these may not exist unless -keep-inlined-boundaries was used
	    foreach ts $tsigs {
		set t [lindex $ts 0]
		set s [lindex $ts 1]
		if { [regsub {/Q_OUT_0$} $s "" ns] } {
		} elseif { [regsub {/Q_OUT_(.)$} $s {$port\1__read} ns] } {
		} elseif { [regsub {/D_IN_(.)$} $s {$port\1__write_1} ns] } {
		} elseif { [regsub {/EN_(.)$} $s {$EN_port\1__write} ns] } {
		} else {
		    # ignore clock and resets, they are not there!
		    continue
		}
		lappend ret [list $t $ns]
	    }
        }
        return $ret
    }

    proc correct_inlined_probe_names { tsigs } {
        set bluesim [isBlueSim]
        set ret [list]
        foreach ts $tsigs {
            set t [lindex $ts 0]
            set s [lindex $ts 1]
            if { [regsub {/PROBE$} $s {$PROBE} ns] } {
            } elseif {[regsub {/PROBE_VALID$} $s {$PROBE_VALID} ns] } {
                if { $bluesim } { continue }
            } elseif { [regexp {CLK} $s] } {
                continue
            } else {
                set ns $s
            }
            lappend ret [list $t $ns]
        }
        return $ret
    }

    proc correct_inlined_rwire_names { tsigs } {
        set notinlined [regexp "no-inline-rwire"  [get_module_flag inline-rwire]]
        set bluesim [isBlueSim]
        set ret [list]
        foreach ts $tsigs {
            set t [lindex $ts 0]
            set s [lindex $ts 1]
            if { $bluesim && [regsub {/WGET$} $s {} ns] } {

            } elseif { $bluesim } {
                continue ;
            } elseif { [regsub {/WGET$} $s {$wget} ns] } {
                if { $notinlined } { set ns $s }
            } elseif { [regsub {/WHAS$} $s {$whas} ns] } {
                if { $notinlined } { set ns $s }
            } elseif { [regexp {/CLK$|/WVAL$|/WSET$} $s] } {
                continue
            } else {
                set ns $s
            }
            lappend ret [list $t $ns]
        }
        return $ret
    }

    proc correct_inlined_rwire0_names { tsigs } {
        set bluesim [isBlueSim]
        set notinlined [regexp "no-inline-rwire"  [get_module_flag inline-rwire]]
        set ret [list]
        foreach ts $tsigs {
            set t [lindex $ts 0]
            set s [lindex $ts 1]
            if { $bluesim && [regsub {/WHAS$} $s {} ns] } {

            } elseif { [regsub {/WHAS$} $s {$whas} ns] } {
                if { $notinlined } { set ns $s }
            } elseif { [regexp {/WVAL$|/WSET$} $s] } {
                continue
            } else {
                set ns $s
            }
            lappend ret [list $t $ns]
        }
        return $ret
    }

    proc correct_regfile_names { tsigs } {
        set bluesim [isBlueSim]
        if { $bluesim } {
            # Regfiles are not dumped in Bluesim
            # bs_prim_mod_regfile.h
            set ret [list]
        } else {
            set ret $tsigs
        }
        return $ret
    }

    proc correct_syncfifo_names { tsigs } {
        set bluesim [isBlueSim]
        if { $bluesim } {
            set ret [list]
            foreach ts $tsigs {
                set t [lindex $ts 0]
                set s [lindex $ts 1]
                if { [regsub {sENQ$}     $s sCount ns ] } {
                    set t UInt
                } elseif { [regsub {dDEQ$}     $s dCount ns ] } {
                    set t UInt
                } elseif { [regsub {dD_OUT$}   $s dDoutReg ns ] } {
                } elseif { [regsub {sFULL_N$}  $s FULL_N ns ] } {
                } elseif { [regsub {dEMPTY_N$} $s EMPTY_N ns ] } {
                } else {
                    continue
                }
                lappend ret [list $t $ns]
            }
        } else {
            set ret $tsigs
        }
        return $ret
    }

    proc fix_remove_dollar { tsigs } {
        set remove [regexp "no-remove-dollar" [get_module_flag remove-dollar]]
        if { $remove } {
            return $tsigs
        } else {
            set ret [list]
            foreach ts $tsigs {
                set t [lindex $ts 0]
                set s [lindex $ts 1]
                regsub -all {\$} $s "_" ns
                lappend ret [list $t $ns]
            }
            return $ret
        }
    }

    proc isBlueSim {} {
        string equal "-sim" [Bluetcl::flags show sim]
    }

    proc get_module_flag {flg} {
        set topm [lindex [Bluetcl::module list] end]
        if { $topm ne "" } {
            set val [Bluetcl::module flags $topm $flg]
        } else {
            set val [Bluetcl::flags show $flg]
        }
        return $val
    }

}
package provide TypeSupport 1.0
