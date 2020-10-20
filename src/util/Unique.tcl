
namespace eval Unique {

    namespace export \
        new_name \
        new_number \
        create_temp_file_name \
        uid \
        process_exists \
        printf \
        fprintf \
        sprintf

    proc uid {} {

        set file_name [create_temp_file_name]
        exec touch $file_name

        file stat $file_name stat_array
        file delete $file_name

        return $stat_array(uid)
    }

    ################################################################################
    ### A unique number generator
    ################################################################################
    variable  new_num_count -1

    proc new_num {} {
        variable new_num_count

        set new_num_count [expr $new_num_count + 1]
        return $new_num_count
    }

    ################################################################################
    ### A unique name generator
    ################################################################################
    variable new_name_count -1

    proc new_name {{string ""}} {
        variable new_name_count

        set new_name_count [expr $new_name_count + 1]
        if {$string == ""} {
            return "_gen_$new_name_count"
        } else {
            return "_gen_$string\_$new_name_count"
        }
    }

    ################################################################################
    ### lookfor and set tmp dir name from the environment
    ################################################################################
    variable Tmpdir /tmp/tcl

    proc setTmpDir {} {
        global env
        variable Tmpdir

        set envnames [list BLUESPECTMP TMP TEMP]
        set name ""
        foreach e $envnames {
            if { [info exists env($e)] } {
                set name [file join $env($e) tcl]
                break
            }
        }
        if { $name == "" } {
            set name /tmp/tcl
        }
        set Tmpdir $name
        clean_temp_files
        return $Tmpdir
    }
    ################################################################################
    ###
    ################################################################################

    proc delete_unused_files {dir_name} {
        if {![file exists $dir_name]} {
            exec mkdir -p -m 777 $dir_name
        }
        foreach file_name [exec ls $dir_name] {
            #puts "$dir_name/$file_name"
            temp_file_delete "$dir_name/$file_name"
        }
    }

    proc temp_file_delete {file_name} {
        if {![temp_file_in_use $file_name]} {
            file delete $file_name
        }
    }

    proc temp_file_in_use {file_name} {
        return [process_exists [temp_file_get_process_id $file_name]]
    }

    proc temp_file_get_process_id {file_name} {
        return [string replace [file extension $file_name] 0 0 ""]

    }

    proc process_exists {pid} {
        if {$pid == -1} { return 0 }
        set value [expr ![catch {exec kill -s 0 $pid}]]
        return $value
    }

    proc create_temp_file_name {} {
        variable Tmpdir
        if { ! [file writable $Tmpdir] } {
            exec mkdir -p -m 777 $Tmpdir
        }
        return [format "$Tmpdir/%s_tcl_tmp_%s" [new_name] [pid]]

    }

    #
    proc clean_temp_files { {prefix ".*"} } {
        variable Tmpdir
        set pattern "^"
        append pattern $prefix
        append pattern "tcl_tmp_\[0-9\]"
        set pattern_dot $pattern
        append pattern_dot "\..*"

        foreach file_name [glob -nocomplain -directory $Tmpdir *] {
            if {[regexp $pattern $file_name]||[regexp $pattern_dot $file_name]} {
                set file_name [file join $Tmpdir $file_name]
                regsub "^.*tcl_tmp_(\[0-9\]+).*$" $file_name "\\1" pid

                if {![process_exists $pid]} {
                    file delete $file_name
                }
            }
        }
    }

    proc printf {format args} {
        puts -nonewline stdout [eval [list format $format] $args]
        flush stdout
    }

    proc fprintf {stream format args} {
        puts -nonewline stream [eval [list format $format] $args]
        flush stdout
    }

    proc sprintf {format args} {
        return [eval [list format $format] $args]
    }

    # Determine the

}

# set the temp dir
Unique::setTmpDir

package provide Unique 1.1

