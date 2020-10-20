
package require MathSupport

namespace eval ViewerCommon {

    namespace import ::MathSupport::*
    namespace import ::TypeSupport::*

    namespace export \
	isScalarType \
	count_real_fields \
	nextSuffix \
	cleanup_suffix \
	extendName \
	spaces \
	modeEval

    variable delim_body "\|"
    variable delim_last "\|"
    variable gCurrentMax 0
    variable gEvalMode   1
    
    proc isScalarType {type_name} {
	
	set type_name [cleanUpType $type_name]
	
	set details [SignalTypes::getTypeDetails $type_name]
        
	set flavor [SignalTypes::extractFlavor $details]
	
	switch $flavor {
	    STRUCT {
		return 0
	    }
	    TAGGEDUNION {
		
		set fields [SignalTypes::extractFields $details]
		set scalar 1
		
		foreach field $fields {
		    set field_type [lindex $field 1]
		    if {![isScalarType $field_type]} {
			set scalar 0
			break
		    }
		}
		return $scalar
	    }
	    default {
		return 1
	    }
	}
    }
    
    proc count_real_fields {fields} {
	
	set count 0
	foreach field $fields {
	    set field_size [lindex $field 2]
	    
	    if {$field_size > 0 } {
		incr count
	    }
	}
	
	return $count
	
    }
    
    proc nextSuffix {suffix} {
	return $suffix
    }
    
    proc cleanup_suffix {suffix} {
	variable delim_body
	variable delim_last
	
	if {$delim_body != "\|"} {
	    puts "ERROR A0"
	}
	if {$delim_last != "\|"} {
	    puts "ERROR A1"
	}
	
	#Vector fields dont need the delimiters on either side
	
	regsub -all {\|_\[} $suffix { [} suffix
	    regsub -all {\|_\[} $suffix { [} suffix
		regsub -all {\]\|}  $suffix {] } suffix
	    regsub -all {\]\|}  $suffix {] } suffix
	return $suffix
	
    }
    
    proc extendName {name len_min} {
	
	variable gCurrentMax
	
	set pos [string last "/" $name]
	set prefix [string range $name 0 $pos]
	set suffix [string range $name [expr $pos + 1] end]
	
	set length [string length $suffix]
	set delta  [max 0 [expr $len_min - $length]]
	
	regsub {&} $suffix [spaces [expr $delta + 1]] suffix
	
	set gCurrentMax [max $gCurrentMax [string length $suffix]]
	
	return "$prefix$suffix"
	
    }
    
    proc spaces {n} {
	if {$n == 0} {
	    return ""
	} else {
	    set value [spaces [expr $n - 1]]
	    set value " $value"
	    return $value
	}
    }
    
    proc modeEval {body} {
	variable gEvalMode
	
	if {$gEvalMode} {
	    
	    uplevel 1 [list eval $body]
	}
    }
}

package provide ViewerCommon 1.0 
