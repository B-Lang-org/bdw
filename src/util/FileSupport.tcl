#!/bin/sh
### -*- Tcl -*- ##############################################################
###
##############################################################################
# \
exec tclsh "$0" ${1+"$@"}

################################################################################
###
################################################################################

namespace eval ::FileSupport {

    namespace export \
	createPosition \
	createRealPosition \
	getPositionFile \
	getPositionLine \
	getPositionColumn \
	getRealFileName

    global env

    variable TranslateFileArray
    array unset TranslateFileArray

    variable gBLUESPECDIR
    set gBLUESPECDIR $env(BLUESPECDIR)

    ################################################################################
    ###
    ################################################################################
    
    proc createPosition {file {line 0} {column 0}} {
	return [list $file $line $column]

    }

    proc createRealPosition {position} {
	set filename [getPositionFile $position]
        set filename [getRealFileName $filename]
	return [concat [list $filename] [utils::tail $position]]
    }

    proc getPositionFile {position} {
	return [lindex $position 0]
    }
    
    proc getPositionLine {position} {
	return [lindex $position 1]
    }
    
    proc getPositionColumn {position} {
	return [lindex $position 2]
    }
    
    ################################################################################
    ### This proc returns either a string which is a filename (which exists) or a 2 
    ### element list. The first element is a 0, the second element is an error
    ### message.
    ################################################################################
    
    proc getRealFileName {filename} {
	
	variable gBLUESPECDIR
	
	set translated [translateFileName $filename $gBLUESPECDIR]
	set translated [file normalize $translated]
	
	if {[file exists $translated]} {

	    return $translated

	}

	set file_desc [list 0 [format "Unable to find file `%s`." $filename]]
	
	return $file_desc

    }

    proc translateFileName {filename bluespecdir} {

	set translated $filename

	regsub "%" $translated "$bluespecdir" translated

	return $translated

    }
}

package provide FileSupport 1.0
