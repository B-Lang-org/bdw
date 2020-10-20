
#Don't know exactly how many of these are actually needed
package require MathSupport 
package require SignalTypes
package require TypeSupport
package require Unique
package require ViewerCommon
package require utils
package provide NovasSupportSendSignal 1.0

namespace eval NovasSupportSendSignal {
    namespace export *

    namespace import ::MathSupport::*
    namespace import ::TypeSupport::*
    namespace import ::ViewerCommon::*
    namespace import ::Unique::*

    variable gDoDeletes
    set gDoDeletes 0
    
    variable gNovasDeleteList
    set gNovasDeleteList [list]
    
    variable gNovasDisplayInfo
    array set gNovasDisplayInfo []
    
    variable gNovasEnumFlags      ""
################################################################################
###
################################################################################

# TODO  no need to open stream when the file is sourced!
    
    variable rc_file_name       [Unique::create_temp_file_name]
    variable gNovasRCFileStream [open $rc_file_name w]
    
    variable gNovasSignals
    array set gNovasSignals []
    
    variable gNovasUnionEnumFlags "-c ID_BLUE6"
    #variable gNovasStructFlags    "-c ID_RED5"
    variable gNovasStructFlags    ""
    #variable gNovasUnionFlags     "-c ID_ORANGE5"
    variable gNovasUnionFlags     ""
    
    variable signal_prev ""

proc send_rc_cmd {cmd fileStream} {

    variable gNovasRCFileStream
    if {$fileStream eq ""} {
        set fileStream $gNovasRCFileStream
    }
    modeEval {puts $fileStream $cmd}
    set value "buffered"

    return $value

}


################################################################################
###
################################################################################

proc send_typed_signal_to_novas {type_name name suffix_ lsb \
				     {depth 0} {send_as_bits 0} {extend_names 0} \
                                     {bool_as_enum 1} {fileStream ""}} {

    set size 0

    if {$extend_names} {
        #we do not need to pass fileStream to get_typed_signal_size_gtkwave because
        #it calls send_typed_signal_to_*_inner with gEvalMode==0 (so modeEval prevents output)
	set size [get_typed_signal_size \
		      $type_name $name $suffix_ $lsb $depth $send_as_bits $extend_names $bool_as_enum]
    }

    send_typed_signal_to_novas_inner \
	$type_name $name $suffix_ $lsb $depth $send_as_bits $size $bool_as_enum $fileStream
    
}


################################################################################
### send_typed_signal_to_novas_inner now returns a list:
### [list name flavor alias]
### The "alias" value is only meaningful if the "flavor" is "ENUM"
################################################################################

proc send_typed_signal_to_novas_inner {type_name name suffix_ lsb {depth 0} {send_as_bits 0} {len_min 0} {bool_as_enum 1} {fileStream ""}} {

    variable signal_prev
    variable gNovasEnumFlags 
    variable gNovasStructFlags 
    variable gNovasUnionFlags 
    variable gNovasUnionEnumFlags
    variable ::ViewerCommon::delim_body
    variable ::ViewerCommon::delim_last
    variable gDoDeletes

    if {$send_as_bits} {
	set add_cmd [create_add_cmd $name "" $len_min]
	send_rc_cmd $add_cmd $fileStream
	return [list $name BASIC ""]
    }

    set delim  $::ViewerCommon::delim_body
    set suffix [cleanup_suffix $suffix_]
#    set delim_tip   "  |-"
#    set delim_line  "  | "
#    set delim_blank "    "

  #    if {$depth >= 2} {
#  	set delim_first $delim_line
#      } else {
#  	set delim_first $delim_tip
#      }

#    set delim  "|"
#    set delim_first  "|"
    set delim_first ""

    set type_name [cleanUpType $type_name]

    set details [SignalTypes::getTypeDetails $type_name]
    
    set flavor [SignalTypes::extractFlavor $details]
    set size   [SignalTypes::extractSize   $details]

    if {$size == 0} { return "" }

    if {(!$bool_as_enum && $type_name == "Bool") || ($gDoDeletes && $size == 1)} {
	set flavor "BASIC"
    }

    set type_label [getBriefType $type_name]

    set type_suffix "&\[$type_label\]"

    if {($flavor == "STRUCT") || ($flavor == "TAGGEDUNION")} {

	set fields [SignalTypes::extractFields $details]

	set just_one false
	if {[llength $fields] == 1} {
	    set just_one true
	}

	set type_suffix " \[+\]&\[$type_label\]"
    } 

    if {$suffix != "" } {

	set new_name "$name$delim_first$suffix$type_suffix"

    } else {

	set new_name "$name$type_suffix"
    }

    variable ::ViewerCommon::gEvalMode

    if {$::ViewerCommon::gEvalMode} {
	if {$name != $signal_prev} {
	    set zow [create_signal_name $name 0 1]
	    set add_cmd [create_add_cmd $zow "" $len_min true]
	    send_rc_cmd $add_cmd $fileStream
	    add_to_delete_list $zow $len_min
	    set signal_prev $name
	}
    }

    regsub  {.*\/} $new_name "" local_name
    set prefix [string trim $new_name $local_name]

    switch $flavor {
	ENUM {
	    set signal_name_0 [create_signal_name $name $lsb $size]
	    if {$size == 1} {
		set signal_name [create_signal_name $name\_two_bit_$lsb -1 $size]
		create_two_bit_signal $signal_name_0 $signal_name $len_min $fileStream
		set alias_name [send_enum_to_novas $type_name $signal_name $new_name $details $depth \
				    $gNovasEnumFlags 1 $len_min $fileStream]
	    } else {
		set signal_name $signal_name_0
		set alias_name [send_enum_to_novas $type_name $signal_name $new_name $details $depth \
				    $gNovasEnumFlags 0 $len_min $fileStream]
	    }
	    return [list $new_name ENUM $alias_name]
	}
	STRUCT {

	    set suffix2 [nextSuffix $suffix]

	    set cmd ""

	    set count 1
	    set field_count [count_real_fields $fields]
	    foreach field $fields {
		set field_name [lindex $field 0]
		set field_type [lindex $field 1]
		set field_lsb  [lindex $field 3]
		set field_size [lindex $field 2]

		if {$field_size > 0 } {

		    set last 0
		    if {$count == $field_count} {
			set last 1
			set zow $::ViewerCommon::delim_last
		    } else {
			set zow $delim
		    }
		    set suf $field_name
		    if {$suffix2 != "" } {
			set suf $suffix2$zow$field_name
		    } else {
			set suf $suffix2$zow$field_name
		    }
		    set sig_info [send_typed_signal_to_novas_inner \
				      $field_type \
				      $name \
				      $suf \
				      [plus [max 0 $lsb] $field_lsb] \
				      [expr $depth + 1] \
				      0 \
				      $len_min \
				      $bool_as_enum \
				      $fileStream]

		    set signal_name [lindex $sig_info 0]
		    set alias ""
		    if {[lindex $sig_info 1] == "ENUM"} {
			set alias [lindex $sig_info 2]
		    }

		    if {$signal_name != "" } {
			set member_cmd [create_member_cmd $signal_name $len_min $alias]
			set cmd "$cmd$member_cmd"
		    }
		}
		incr count
	    }

	    set bundle_cmd [create_bundle_cmd $local_name $len_min]
	    set cmd "$cmd$bundle_cmd"
	    if {$depth == 0} {
  		set add_cmd [create_add_cmd $local_name "-holdScope $gNovasStructFlags" $len_min]
  	    } else {
		set_display_info $new_name $gNovasStructFlags
  		set add_cmd "\n"
  	    }
  	    set cmd "$cmd$add_cmd"
	    send_rc_cmd $cmd $fileStream
	    return [list $new_name STRUCT ""]
	}
	TAGGEDUNION {

	    set suffix2 [nextSuffix $suffix]

	    set cmd ""

	    set select_msb [expr [max 0 $lsb] + [expr $size - 1]]
	    set select_lsb 0

	    # calulate lsb for "select" field
	    foreach field $fields {
		set field_lsb  [plus [max 0 $lsb] [lindex $field 3]]
		set field_size [lindex $field 2]
		set field_msb  [expr $field_lsb + [expr $field_size - 1]]
		set select_lsb [max $select_lsb [expr $field_msb + 1]]
	    }

	    set select_size [expr [expr $select_msb - $select_lsb] + 1]

	    if {[isScalarType $type_name]} {

	    }

	    if {!$just_one} {

		# add one field for an "enum" display
		set field_name "tag"
		set suf $field_name
		
		set suf $suffix2$delim$field_name
		
		set added_name "$name$suf&\[$type_label\]"
		
		if {$select_size == 1} {
		    set ignore_lsb 1
		    set signal_name_0 [create_signal_name $name $select_lsb $select_size]
		    set select_signal [create_signal_name $name\_two_bit_$select_lsb -1 $select_size]
		    create_two_bit_signal $signal_name_0 $select_signal $len_min $fileStream
		} else {
		    set ignore_lsb 0
		    set select_signal [create_signal_name $name $select_lsb $select_size]
		}
		
		set signal_name $select_signal
		
		send_enum_to_novas $type_name $signal_name $added_name $details \
		    [expr $depth + 1] $gNovasUnionEnumFlags $ignore_lsb $len_min $fileStream
		
		set member_cmd [create_member_cmd $added_name $len_min [create_alias_map_name $type_name]]
		set cmd "$cmd$member_cmd"
		
	    }
	    
	    set count 1
	    set field_count [count_real_fields $fields]
	    foreach field $fields {
		set field_name [lindex $field 0]
		set field_type [lindex $field 1]
		set field_lsb  [lindex $field 3]
		set field_size [lindex $field 2]
		
		if {$field_size > 0 } {

		    set last 0
		    if {$count == $field_count} {
			set last 1
			set zow $::ViewerCommon::delim_last
		    } else {
			set zow $delim
		    }
		    set suf $field_name
		    if {$suffix2 != "" } {
			set suf $suffix2$zow$field_name
		    } else {
			set suf $suffix2$zow$field_name
		    }
		    if {$just_one} {
			set suf $suffix2
		    }
		    set sig_info [send_typed_signal_to_novas_inner \
				      $field_type \
				      $name \
				      $suf \
				      [plus [max 0 $lsb] $field_lsb] \
				      [expr $depth + 1] \
				      0 \
				      $len_min \
				      $bool_as_enum \
				      $fileStream]

		    set signal_name [lindex $sig_info 0]
		    set alias ""
		    if {[lindex $sig_info 1] == "ENUM"} {
			set alias [lindex $sig_info 2]
		    }

		    set member_cmd [create_member_cmd $signal_name $len_min $alias]
		    set cmd "$cmd$member_cmd"

		}
		incr count
	    }

	    set bundle_cmd [create_bundle_cmd $local_name $len_min]
	    set cmd "$cmd$bundle_cmd"
	    if {$depth == 0} {
		set add_cmd [create_add_cmd $local_name "-holdScope $gNovasUnionFlags" $len_min]
	    } else {
		set_display_info $new_name $gNovasUnionFlags
		set add_cmd "\n"
	    }
	    set cmd "$cmd$add_cmd"
	    send_rc_cmd $cmd $fileStream
	    return [list $new_name TAGGEDUNION ""]
	}
	default {
	    set signal_name [create_signal_name $name $lsb $size]
	    set cmd [create_rename_cmd $signal_name $new_name $gDoDeletes $len_min]
	    if {$depth == 0} {
		set add_cmd [create_add_cmd $new_name "" $len_min]
	    } else {
#		set add_cmd [create_add_cmd $new_name "" $len_min true]
		set add_cmd "\n"
	    }
	    set cmd "$cmd$add_cmd"
	    send_rc_cmd $cmd $fileStream
	    return [list $new_name BASIC "D"]
	}
    }
}

################################################################################
###
################################################################################

proc send_enum_to_novas {type_name signal_name new_name details depth flags ignore_lsb len_min fileStream} {

    regsub  {.*\/} $new_name "" local_name

    set alias_map_name [create_alias_map_name $type_name]

    set members [SignalTypes::extractMembers $details]
#    set cmd [create_rename_cmd $signal_name $local_name 0 $len_min]
    set cmd [create_rename_cmd $signal_name $new_name 0 $len_min]
    set alias_map_cmd \
	[create_alias_map_cmd $alias_map_name $members NULL $ignore_lsb]
    set cmd "$cmd$alias_map_cmd"
    set set_cmd "aliasname $alias_map_name\n"
    set cmd "$cmd$set_cmd"
    set display_flags $flags
    set flags "-holdScope $display_flags"
##    set flags "$display_flags"
    if {$depth == 0} {
	set add_cmd [create_add_cmd $local_name $flags $len_min]
    } else {
	set add_cmd [create_add_cmd $local_name $flags $len_min true]
	if {$display_flags != ""} {
	    set_display_info $new_name $display_flags
	}
	add_to_delete_list $new_name $len_min
    }
    set cmd "$cmd$add_cmd"
    send_rc_cmd $cmd $fileStream
    return $alias_map_name
}

proc create_two_bit_signal {one_bit_signal new_name len_min fileStream} {

    regsub  {.*\/} $new_name "" local_name

    set cmd ""
    set cmd $cmd[create_bus_member_cmd $one_bit_signal $len_min]
    set cmd $cmd[create_bus_member_cmd $one_bit_signal $len_min]
    set cmd $cmd[create_bus_cmd $new_name $len_min]
    send_rc_cmd $cmd $fileStream

    return $new_name

}

proc create_two_bit_signal_orig {one_bit_signal new_name len_min fileStream} {

    regsub  {.*\/} $new_name "" local_name

    set cmd ""
    set cmd $cmd[create_member_cmd $one_bit_signal $len_min]
    set cmd $cmd[create_member_cmd $one_bit_signal $len_min]
    set cmd $cmd[create_bundle_cmd $local_name $len_min]
    send_rc_cmd $cmd $fileStream

    return $new_name

}

proc create_tag_signal {signal_name signal_select num} {

    set base_name [new_name]
    set cmd "addExprSig -b 1 $base_name (\"$signal_select\" == $num) ? \"$signal_name\" : 'bx\n"
    send_rc_cmd $cmd

    return $base_name

}

proc create_alias_map_name {type_name} {

    regsub  -all {, } $type_name  "_" clean_name
    regsub  -all {,}  $clean_name "_" clean_name
    regsub  -all { }  $clean_name "_" clean_name

    regsub {::} $clean_name {.} clean_name

    return "$clean_name\_aliases"
}



################################################################################
###
################################################################################

proc create_rename_cmd {name_orig name_new record len_min} {

    variable gNovasSignals
    variable ::ViewerCommon::gEvalMode

    set name_new [extendName $name_new $len_min]

    set key [create_signal_key $name_new]

    if {$name_orig == $name_new} {
	return ""
    }

    if {[array get gNovasSignals $key] != ""} {
	return ""
    } 

    if {$record && $::ViewerCommon::gEvalMode} {
  	array set gNovasSignals [list $key 1]
    }

    return "addRenameSig \"$name_new\" \"$name_orig\"\n"

}

proc create_signal_key {signal_name} {

    regsub  -all { }  $signal_name "_" key
    regsub  -all {\[} $key         "|" key
    regsub  -all {\]} $key         "|" key

    return $key

}

proc create_add_cmd {name flags len_min {hidden false}} {

    global gNovasSignals

    set name [extendName $name $len_min]
    set hide ""
    if {$hidden} {
	set hide "-HIDDEN"
    }

    set key [create_signal_key $name]

    return "addSignal $hide $flags $name\n"
}

proc create_member_cmd {name len_min {alias ""}} {
    
    set name [extendName $name $len_min]
    if {$alias == "" } {
	return "userCompositeMem $name\n"
    } else {
	return "; ALIAS $alias\nuserCompositeMem $name\n"
    }
}

proc create_bundle_cmd {name len_min} {
    
    set name [extendName $name $len_min]
    return "saveRunCompositeSig \"$name\"\n"
}

proc create_bus_member_cmd {name len_min} {
    
    set name [extendName $name $len_min]
    return "userBusMem $name\n"
}

proc create_bus_cmd {name len_min} {
    
    set name [extendName $name $len_min]
    return "saveRunSig \"$name\"\n"
}

proc create_alias_map_cmd {name member_list {color NULL} {ignore_lsb 0}} {

    set value "aliasmapname $name\n"
    set i 0

    foreach member $member_list {
	set label [getBriefType $member]
	set row "nalias $label \t$i \t$color\n"

	set value "$value$row"
	set i [expr $i + 1]
	
	if {$ignore_lsb} {

	    set row "nalias $label \t$i \t$color\n"

	    set value "$value$row"
	    set i [expr $i + 1]

	}
    }

    set value "$value\n"

    return $value
}

proc add_to_delete_list {signal_name len_min} {

    variable gNovasDeleteList
    variable gDoDeletes

    modeEval {

	set signal_name [extendName $signal_name $len_min]

	
	if {$gDoDeletes} {
#	    puts "DELETE $signal_name"
	    set gNovasDeleteList [concat $gNovasDeleteList "\{$signal_name\}"]
	}
    }
}

################################################################################
###
################################################################################

#global gNovasDisplayInfo
#array set gNovasDisplayInfo []

proc set_display_info {signal_name flags} {

    variable gNovasDisplayInfo

    set key [create_signal_key $signal_name]

    array set gNovasDisplayInfo [list $key $flags]

}

proc get_display_info {signal_name} {

    variable gNovasDisplayInfo

    set key [create_signal_key $signal_name]

    return [array get gNovasDisplayInfo $key]

}

################################################################################
###
################################################################################

proc get_typed_signal_size {type_name name suffix_ lsb {depth 0} {send_as_bits 0} {extend_names 0} {bool_as_enum 1}} {

    variable ::ViewerCommon::gCurrentMax
    variable ::ViewerCommon::gEvalMode
    variable gNovasSizes

    set pos [string last "/" $name]
    set prefix [string range $name 0 $pos]
    set suffix [string range $name [expr $pos + 1] end]

    set length [string length $suffix]

    set key "$type_name$suffix_$send_as_bits"

    set value [array get gNovasSizes $key]

    if {$value != ""} {
  	return [expr [lindex $value 1] + $length]
    }

    set orig $::ViewerCommon::gEvalMode

    set ::ViewerCommon::gEvalMode 0
    set ::ViewerCommon::gCurrentMax 0

    send_typed_signal_to_novas_inner \
	$type_name "x" $suffix_ $lsb $depth $send_as_bits $extend_names $bool_as_enum

    set ::ViewerCommon::gEvalMode $orig

    set value [expr $::ViewerCommon::gCurrentMax - 1]

    array set gNovasSizes [list $key $value]

    return [expr $value + $length]
}
}
