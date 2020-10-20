
##
# @file command_line_handlers.tcl
#
# @brief Definition of command line handlers.
#

##
# @brief Namespace for command line handlers. 
#
namespace eval handlers {

package require Bluetcl

##
# @brief Checks if the options are valid for the command
#
# @param boolArgs options with no argument
# @param optArgs  options which take an argument
# @param checkAll if true consider additional arguments
# @param outArray array with the values for the specified options
# @param argList the list with the additional arguments
#
# @return unaccounted for arguments, and array of key/value argument
#
proc check_options { boolArgs optArgs checkAll outArray argList } {
    upvar 1 $outArray ARG
    set result {}
    while { [llength $argList] != 0 } {
        set thisArg [lindex $argList 0]
        if {[info exists ARG($thisArg)]} {
                show_error "The option $thisArg has already been specified"  
                return error
        }
        if { [lsearch -exact $boolArgs $thisArg] != -1 } {
            set ARG($thisArg) $thisArg
            set argList [lrange $argList 1 end]
        } elseif {[lsearch -exact $optArgs $thisArg] != -1 } {
            if { [llength $argList] == 1 } {
                show_error "Argument $thisArg expects an argument none found" 
                return error
            }
            set ARG($thisArg) [lindex $argList 1]
            set argList [lrange $argList 2 end]
        } elseif { $checkAll } {
            if { [regexp {^-} $thisArg] == 1 } {
                show_error "Unknown option: $thisArg"
                return error
            } else {
                show_error "Wrong argument: $thisArg \nSee help"
                lappend result $thisArg
                set argList [lrange $argList 1 end]
                return error
            }
        } else {            
            lappend result $thisArg
            set argList [lrange $argList 1 end]
        }
    }
    return $result
}

##
# @brief Sets the focus on the command line
#
proc focus_command_line {} {
        global eval 
        focus -force $eval(text)
}

##
# @brief Handles the new_project command
#
proc new_project {args} {
        global PROJECT
        global env
        set n [lindex $args 0]
        set l $env(PWD)
        set e [check_options {} {-location} True OPT [lrange $args 1 end]]
        if {[info exists OPT(-location)]} {
                set l [regsub "/$" $OPT(-location) ""]
        }
        if {$n == ""} {
                show_error "Project name is not specified"  
        } elseif {$e == "error"} {
        } elseif {[file exists "$l/$n.bspec"]} {
                show_error "The project '$n' already exists."
        } elseif {$PROJECT(STATUS) == ""} {
                show_error "The current project has not been saved."
        } else {
                commands::new_project $n $l
                focus_command_line
        }
}

##
# @brief Handles the open_project command
#
# @param file the URL of the project file
#
proc open_project {{file ""}} {
        global PROJECT
        if {$file == ""} {
                show_error "The project name is not specified."
        } elseif {![file exists $file]} {
                show_error "The file '$file' does not exist."
        } elseif {[file extension $file] != ".bspec"} {
                show_error "The '$file' is not a project file."
        } elseif {$PROJECT(STATUS) == ""} {
                show_error "The current project has not been saved."
        } else {
                commands::open_project [commands::make_absolute_path $file]
                focus_command_line
        }
}

##
# @brief Handles the set_search_paths command
#
# @param paths the list of search paths
#
proc set_search_paths {{paths ""}} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {$paths == ""} {
                show_error "The search path is not specified"  
        } else {
                set path [split $paths ":"]
                foreach p $path {
                        if {![file isdirectory $p]} {
                                show_error "Search path entry '$p' is not \
                                        a directory."
                                return
                        }
                }
                commands::set_search_paths [commands::get_real_path $path]
                focus_command_line
        }
}

##
# @brief Handles the save_project command
#
proc save_project {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } else {
                commands::save_project
                focus_command_line
        }
}

##
# @brief Handles the save_project_as command
#
proc save_project_as {{args {}}} {
        global env
        global PROJECT
        set l $env(PWD)
        set e [check_options {} {-path} True OPT [lrange $args 1 end]]
        if {[info exists OPT(-path)]} {
                set l $OPT(-path)
        }
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {[set n [lindex $args 0]] == ""} {
                show_error "The project name is not specified."  
        } elseif {$e == "error"} {
        } elseif {![file isdirectory $l]} {
                show_error "The file '$l' is not a directory."
        } elseif {[file exists "$l/$n.bspec"]} {
                show_error "The project named $n already exists."
        } else {
                commands::save_project_as $n $l
                focus_command_line
        }
}

##
# @brief Handles backup_project command
#
proc backup_project {{args {}}} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        set out $PROJECT(NAME).tgz
        set opt "-z"
        set sp_files ".bsv"
        set files {}
        set e [check_options {-input_files -project_dir -search_path} \
                {-options -search_path_files} True OPT [lrange $args 1 end]]
        foreach i [list -input_files -project_dir -search_path] {
                if {[info exists OPT($i)]} {
                        lappend files 1
                } else {
                        lappend files 0
                }
        }
        if {$e == "error"} {
        } elseif {[lindex $args 0] == ""} {                
                show_error "Archive file name should be specified."
        } elseif {[lindex $files 0] == 0 && [lindex $files 1] == 0 && \
                                                [lindex $files 2] == 0} {
                show_error "Files to be backed up should be specified."
        } else {
                if {[info exists OPT(-options)]} {
                        set opt $OPT(-options)
                }
                if {[info exists OPT(-search_path_files)]} {
                        set sp_files $OPT(-search_path_files)
                }
                set out [lindex $args 0]
                if {[string equal $out $PROJECT(NAME).bspec]} {
                        set out $PROJECT(NAME).tgz
                }
                commands::project_backup $out $files $opt $sp_files 
                focus_command_line
        }
}

##
# @brief Handles the close_project command
#
proc close_project {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } else {
                commands::close_project
                focus_command_line
        }
}

##
# @brief Handles the help command
#
proc help {{args {}}} {
        if {[lindex $args 0] == ""} {
                commands::help
        } elseif {[lindex $args 1] == ""} {
                set opt [list -content -bsc -about -list]
                if {[lsearch -exact $opt [lindex $args 0]] != -1} {
                        commands::help [lindex $args 0]
                } else {
                        show_error "Wrong arguments"
                }
        } elseif {[lindex $args 0] == "-command"} {
                commands::help [lindex $args 1]
        } else {
                show_error "Wrong arguments"
        }
}

##
# @brief Handles the set_project_editor command
#
proc set_project_editor {{args {}}} {
        global PROJECT
        global BSPEC
        set n [lindex $args 0]
        set o [check_options {} {-command} True OPT [lrange $args 1 end]]
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {$n == ""} {
                show_error "The editor name is not specified"
        } elseif {[lsearch $BSPEC(EDITORS) $n] == -1} {
                show_error "Wrong editor name. \nThe editor name can be [join $BSPEC(EDITORS) {, }]"
        } elseif {$o == "error"} {
        } else {
                set c $PROJECT(EDITOR_[string toupper $n])
                if {[info exists OPT(-command)]} {
                        set c $OPT(-command)
                }
                if {$c == ""} {
                        show_error "There is no default command for the \
                                specified editor"
                        return
                }
                commands::set_project_editor $n $c
                handlers::get_project_editor
        }
}

##
# @brief Handles the set_compilation_results_location command
#
# @todo break into small functions
#
proc set_compilation_results_location {{args {}}} {
        global PROJECT
        set v $PROJECT(COMP_VDIR)
        set b $PROJECT(COMP_BDIR)
        set s $PROJECT(COMP_SIMDIR)
        set e [check_options {} {-vdir -bdir -simdir} True OPT $args]
        if {[info exists OPT(-vdir)]} {
                set v $OPT(-vdir)
        }
        if {[info exists OPT(-bdir)]} {
                set b $OPT(-bdir)
        }
        if {[info exists OPT(-simdir)]} {
                set s $OPT(-simdir)
        }
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {[lindex $args 0] == ""} {
                show_error "There are no arguments specified"
        } elseif {$e == "error"} {
        } else {
                commands::create_dir_if_doesnt_exist [list $v $b $s]
                commands::set_compilation_results_location $v $b $s
                handlers::get_compilation_results_location
                focus_command_line
        }
}

##
# @brief Handles the set_compilation_type command
#
proc set_compilation_type {{c ""}} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {$c == ""} {
                show_error "The compilation type is not specified"  
        } elseif {$c != "bsc" && $c != "make"} {
                show_error "The compilation type should be either make or bsc."
        } else {
                commands::set_compilation_type $c
                handlers::get_compilation_type
        }
}

##
# @brief Handles the set_bsc_options command
#
# @todo break into small functions
#
proc set_bsc_options {{args {}}} {
        global PROJECT
        set t $PROJECT(COMP_BSC_TYPE)
        set o $PROJECT(COMP_BSC_OPTIONS)
        set i $PROJECT(COMP_INFO_DIR)
        set r $PROJECT(COMP_RTS_OPTIONS)
        set e [check_options {-bluesim -verilog} {-options -info-dir \
                -rts-options} True OPT $args]
        if {[info exists OPT(-bluesim)]} {
                set t [regsub -- "-" $OPT(-bluesim) ""]
        } elseif {[info exists OPT(-verilog)]} {
                set t [regsub -- "-" $OPT(-verilog) ""]
        } 
        if {[info exists OPT(-options)]} {
                set o $OPT(-options)
        } 
        if {[info exists OPT(-info-dir)]} {
                set i $OPT(-info-dir)
        } 
        if {[info exists OPT(-rts-options)]} {
                set r $OPT(-rts-options)
        } 
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {[lindex $args 0] == ""} {
                show_error "There is no option specified"  
        } elseif {$e == "error"} {
        } elseif {$o != "" && [catch "Bluetcl::flags set $o" err]} {
                error_message [lindex [split $err "\n"] 1]
        } else {
                commands::create_dir_if_doesnt_exist $i
                commands::set_bsc_options $t $i $r $o
                handlers::get_bsc_options
        }
}

##
# @brief Handles the set_make_options command
#
# @todo break into small functions
#
proc set_make_options {{args {}}} {
        global PROJECT
        set t $PROJECT(MAKE_TARGET)
        set c $PROJECT(MAKE_CLEAN)
        set f $PROJECT(MAKE_FULLCLEAN)
        set o $PROJECT(MAKE_OPTIONS)
        set m [lindex $args 0]
        set e [check_options {} {-target -clean -fullclean -options} True OPT \
                [lrange $args 1 end]]
        if {[info exists OPT(-target)]} {
                set t $OPT(-target)
        }
        if {[info exists OPT(-clean)]} {
                set c $OPT(-clean)
        }
        if {[info exists OPT(-fullclean)]} {
                set f $OPT(-fullclean)
        }
        if {[info exists OPT(-options)]} {
                set o $OPT(-options)
        }
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {$PROJECT(COMP_TYPE) != "make"} {
                show_error "The compilation type is not set to \"make\" \
                        for the current project."
        } elseif {$m == ""} {
                show_error "The Makefile is not specified"  
        } elseif {![file exists $m]} {
                show_error "The file '$m' does not exist."
        } elseif {$e == "error"} {
        } else {
                commands::set_make_options $m $t $c $f $o
                handlers::get_make_options
                if {$PROJECT(LINK_TYPE) == "make" \
                        && $PROJECT(LINK_MAKEFILE) == ""} {
                        commands::set_link_make_options $m
                }
        }
}

##
# @brief Handles the set_top_file command
#
# @todo breake into small functions
#
proc set_top_file {{args {}}} {
        global PROJECT
        global BSPEC
        set f [lindex $args 0]
        set m $PROJECT(TOP_MODULE)
        set e [check_options {} {-module} True OPT [lrange $args 1 end]]
        if {[info exists OPT(-module)]} {
                set m $OPT(-module)
        }
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {$f == ""} {
                show_error "The top file is not specified"  
        } elseif {$e == "error"} {
        } elseif {![file exists $f]} {
                set pf [lindex [lindex $BSPEC(FILES) \
                        [lsearch -regexp $BSPEC(FILES) $f]] 0]
                if {$pf == ""} {
                        show_error "The file '$f' does not exist."
                } else {
                        commands::set_top_module $pf $m
                        handlers::get_top_file
                }
        } else {
                if {[lsearch -regexp $BSPEC(FILES) $f] == -1} {
                        show_error "The file '$f' is not a project file."
                } else {
                        commands::set_top_module $f $m
                        handlers::get_top_file
                }
        }
}

##
# @brief Handles the set_verilog_simulator command
#
proc set_verilog_simulator {{args {}}} {
        global PROJECT
        set s [lindex $args 0]
        set o $PROJECT(SIM_OPTIONS)
        set e [check_options {} {-options} True OPT [lrange $args 1 end]]
        if {[info exists OPT(-options)]} {
                set o $OPT(-options)
        }
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {$PROJECT(COMP_BSC_TYPE) != "verilog"} {
                show_error "The bsc type is not set to 'Verilog'."
        } elseif {$s == ""} {
                show_error "The simulator is not specified"  
        } elseif {[lsearch -exact [get_system_simulators] $s] == -1} {
                show_error "Current version does not support the simulator '$s'"
        } elseif {$e == "error"} {
        } else {
                commands::set_verilog_simulator $s $o
                handlers::get_verilog_simulator
        }
}

##
# @brief Handles the set_bluesim_options command
#
proc set_bluesim_options {{opt ""}} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {$PROJECT(COMP_BSC_TYPE) != "bluesim"} {
                show_error "The bsc type is not set to 'Bluesim'."
        } elseif {$opt == ""} {
                show_error "Bluesim options are not specified."
        } else {
                commands::set_bluesim_options $opt
                handlers::get_bluesim_options 
                handlers::focus_command_line
        }
}

##
# @brief Handles the set_link_type command
#
proc set_link_type {{t ""}} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {$t == ""} {
                show_error "The link type is not specified"
        } elseif {$t != "bsc" && $t != "make" && $t != "custom_command"} {
                show_error "The link type should be bsc, make, custom_command."
        } else {
                commands::set_link_type $t
                handlers::get_link_type
        }
}

##
# @brief Handles the set_link_bsc_options command
#
# @todo break into small functions
#
proc set_link_bsc_options {{args {}}} {
        global PROJECT
        set n [lindex $args 0]
        set p $PROJECT(LINK_OUTDIR)
        set o $PROJECT(LINK_BSC_OPTIONS)
        set e [check_options {-bluesim -verilog} {-path -options} \
                True OPT [lrange $args 1 end]]
        if {[info exists OPT(-path)]} {
                set p $OPT(-path)
        }
        if {[info exists OPT(-options)]} {
                set o $OPT(-options)
        }
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {$PROJECT(LINK_TYPE) != "bsc"} {
                show_error "The link type is not set to \"bsc\" \
                     for the current project."
        } elseif {$n == ""} {
                show_error "The output file name for linking is not specified."
        } elseif {$e == "error"} {
        } elseif {$p == ""} {
                show_error "The output directory for linking is not sepcified."
        } else {
                commands::create_dir_if_doesnt_exist $p
                commands::set_link_bsc_options $n $p $o
                handlers::get_link_bsc_options
        }
}

##
# @brief Handles the set_link_make_options command
#
# @todo break into small functions
#
proc set_link_make_options {{args {}}} {
        global PROJECT
        set m [lindex $args 0]
        set t $PROJECT(LINK_TARGET)
        set c $PROJECT(LINK_CLEAN_TARGET)
        set o $PROJECT(LINK_MAKE_OPTIONS)
        set st $PROJECT(LINK_SIM_TARGET)
        set e [check_options {} {-target -sim_target -clean_target -options} \
                True OPT [lrange $args 1 end]]
        if {[info exists OPT(-target)]} {
                set t $OPT(-target)
        } 
        if {[info exists OPT(-sim_target)]} {
                set st $OPT(-sim_target)
        } 
        if {[info exists OPT(-clean_target)]} {
                set c $OPT(-clean_target)
        } 
        if {[info exists OPT(-options)]} {
                set o $OPT(-options)
        }
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {$PROJECT(LINK_TYPE) != "make"} {
                show_error "The link type is not set to \"make\" \
                        for the current project."
        } elseif {$m == ""} {
                show_error "The makefile for the link is not specified"
        } elseif {![file exists $m]} {
            show_error "The file '$m' does not exist."
        } elseif {$e == "error"} {
        } else {
                commands::set_link_make_options $m $t $st $c $o
                handlers::get_link_make_options
        }
}

##
# @brief Handles the set_link_custom_command command
#
proc set_link_custom_command {{c ""}} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {$PROJECT(LINK_TYPE) != "custom_command"} {
                show_error "The link type is not set to \"custom_comand\" \
                            for the current project."
        } elseif {$c == ""} {
                show_error "The custom command for the link is not specified"
        } else {
                commands::set_link_custom_command $c
                handlers::get_link_custom_command
        }
}

##
# @brief Handles the set_sim_custom_command command
#
proc set_sim_custom_command {{c ""}} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {$PROJECT(LINK_TYPE) != "custom_command"} {
                show_error "The link type is not set to \"custom_comand\" \
                            for the current project."
        } elseif {$c == ""} {
                show_error "The custom command for the simulation is not \
                        specified"
        } else {
                commands::set_sim_custom_command $c
                handlers::get_sim_custom_command
        }
}

##
# @brief Handles the set_waveform_viewer command
#
proc set_waveform_viewer {viewer} {
    if {[lsearch -exact [Waves::get_supported_wave_viewers] $viewer] == -1} {
        error "Unsupported viewer,  must be one of:  [Waves::get_supported_wave_viewers]"
    }
    Waves::set_options viewer $viewer
    return $viewer
}

##
# @brief Handles the get_nonbsv_hierarchy command
#
proc get_nonbsv_hierarchy {} {
    if { [winfo exists $::BSPEC(MODULE_BROWSER)] } {
        return [[$::BSPEC(MODULE_BROWSER) get_viewer] cget -nonbsv_hierarchy]
    }
    Waves::get_nonbsv_hierarchy
}

proc wave_viewer {args} {
    if { ![winfo exists $::BSPEC(MODULE_BROWSER)] } {
        error "Wave viewer commands are not available,  module browser window is required"
    }
    set v [$::BSPEC(MODULE_BROWSER) get_viewer]
    if {$v ne ""} {
        eval $v $args
    } else {
        error "No wave viewer is available this does not seem correct"
    }
}


##
# @brief Handles the get_project_editor command
#
proc get_project_editor {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        set e $PROJECT(EDITOR_NAME)
        puts "\nEditor is set to $e\nThe editor command is\
                $PROJECT(EDITOR_[string toupper $e])"
}

proc return_project_editor {} {
    global PROJECT
    return $PROJECT(EDITOR_NAME)
}

##
# @brief Handles the get_compilation_results_location command
#
proc get_compilation_results_location {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        if {$PROJECT(COMP_VDIR) != ""} {
                puts "\nVerilog files location $PROJECT(COMP_VDIR)"
        }
        if {$PROJECT(COMP_SIMDIR) != ""} {
                puts "\nBluesim files location $PROJECT(COMP_SIMDIR)"
        }
        if {$PROJECT(COMP_BDIR) != ""} {
                puts "\n.bo/.ba files location $PROJECT(COMP_BDIR)"
        }
}

proc return_vdir {}   { global PROJECT; return $PROJECT(COMP_VDIR)  }
proc return_simdir {} { global PROJECT; return $PROJECT(COMP_SIMDIR) }
proc return_bdir {}   { global PROJECT; return $PROJECT(COMP_BDIR) }

##
# @brief Handles the get_compilation_type command
#
proc get_compilation_type {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        puts "\nThe compilation type is $PROJECT(COMP_TYPE)"
}
proc return_compilation_type {} { global PROJECT; return $PROJECT(COMP_TYPE) }

##
# @brief Handles the get_bsc_options command
#
proc get_bsc_options {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        if {$PROJECT(COMP_BSC_TYPE) != ""} {
                puts "\nThe bsc type is $PROJECT(COMP_BSC_TYPE)"
        }
        if {$PROJECT(COMP_BSC_OPTIONS) != ""} {
                puts "\nOptions $PROJECT(COMP_BSC_OPTIONS)"
        }
}

proc return_bsc_options {} { global PROJECT; return $PROJECT(COMP_BSC_OPTIONS) }

##
# @brief Handles the get_make_options command
#
proc get_make_options {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        if {$PROJECT(COMP_TYPE) != "make"} {
                show_error "\nThe compilation type is not set to make"
                return
        }
        set g ""
        if {$PROJECT(MAKE_FILE) != ""} {
                append g "\nMakefile $PROJECT(MAKE_FILE)"
        } 
        if {$PROJECT(MAKE_TARGET) != ""} {
                append g "\nMake target $PROJECT(MAKE_TARGET)"
        }
        if {$PROJECT(MAKE_CLEAN) != ""} { 
                append g "\nMake clean $PROJECT(MAKE_CLEAN)"
        }
        if {$PROJECT(MAKE_FULLCLEAN) != ""} {
                append g "\nMake fullclean $PROJECT(MAKE_FULLCLEAN)"
        }
        if {$PROJECT(MAKE_OPTIONS) != ""} {
                append g "\nMake options $PROJECT(MAKE_OPTIONS)"
        }
        if {$g == ""} {
                append g "The compilation make options are not specified."
        }
        puts $g
}

##
# @brief Handles the get_top_file command
#
proc get_top_file {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        if {$PROJECT(TOP_FILE) != ""} {
                puts "\nTop file $PROJECT(TOP_FILE)"
        }
        if {$PROJECT(TOP_MODULE) != ""} {
                puts "\nTop module $PROJECT(TOP_MODULE)"
        }
}

proc return_top_file {}   { global PROJECT; return $PROJECT(TOP_FILE) }
proc return_top_module {} { global PROJECT; return $PROJECT(TOP_MODULE) }


##
# @brief Handles the get_verilog_simulator command
#
proc get_verilog_simulator {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        if {$PROJECT(SIM_NAME) != ""} {
                puts "\nSimulator $PROJECT(SIM_NAME)"
        }
}
proc return_verilog_simulator {} { global PROJECT; return $PROJECT(SIM_NAME) }

##
# @brief Handles the get_bluesim_options command
#
proc get_bluesim_options {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        puts "\nBluesim options are set to '$PROJECT(RUN_OPTIONS)'"
}
proc return_bluesim_options {} { global PROJECT; return $PROJECT(RUN_OPTIONS) }

##
# @brief Handles the get_link_type command
#
proc get_link_type {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        puts "\nThe link type is $PROJECT(LINK_TYPE)"
}
proc return_link_type {} { global PROJECT; return $PROJECT(LINK_TYPE) }


##
# @brief Handles the get_link_bsc_options command
#
proc get_link_bsc_options {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        if {$PROJECT(LINK_TYPE) != "bsc"} {
                show_error "The link type is not set to bsc"
                return
        }
        set r ""
        if {$PROJECT(LINK_OUTDIR) != ""} {
                append r "\nThe output directory is $PROJECT(LINK_OUTDIR)"
        }
        if {$PROJECT(LINK_OUTNAME) != ""} {
                append r "\nThe output file name is $PROJECT(LINK_OUTNAME)"
        }
        if {$PROJECT(LINK_BSC_OPTIONS) != ""} {
                append r "\nLink bsc options $PROJECT(LINK_BSC_OPTIONS)"
        }
        if {$r == ""} {
                append r "The link bsc options are not specified."
        }
        puts $r
}
proc return_link_name {} { global PROJECT; return [file join $PROJECT(LINK_OUTDIR) $PROJECT(LINK_OUTNAME)] }

##
# @brief Handles the get_link_make_options command
#
proc get_link_make_options {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        if {$PROJECT(LINK_TYPE) != "make"} {
                show_error "The link type is not set to make"
                return
        }
        set g ""
        if {$PROJECT(LINK_MAKEFILE) != ""} {
                append g "\nThe link Makefile $PROJECT(LINK_MAKEFILE)"
        }
        if {$PROJECT(LINK_TARGET) != ""} {
                append g "\nThe link make target $PROJECT(LINK_TARGET)"
        }
        if {$PROJECT(LINK_MAKE_OPTIONS) != ""} { 
                append g "\nLink make options $PROJECT(LINK_MAKE_OPTIONS)"
        }
        if {$g == ""} {
                append g "The link make options are not specified."
        }
        puts $g
}

##
# @brief Handles the get_link_custom_command command
#
proc get_link_custom_command {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        if {$PROJECT(LINK_TYPE) != "custom_command"} {
                show_error "The link type is not set to custom_command"
                return
        }
        set g ""
        if {$PROJECT(LINK_COMMAND) != ""} {
                append g "\nThe link custom command is $PROJECT(LINK_COMMAND)"
        }
        if {$g == ""} {
                append g "The link custom_command is not specified."
        }
        puts $g
}

##
# @brief Handles the get_sim_custom_command command
#
proc get_sim_custom_command {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        if {$PROJECT(LINK_TYPE) != "custom_command"} {
                show_error "The link type is not set to custom_command"
                return
        }
        set g ""
        if {$PROJECT(SIM_CUSTOM_COMMAND) != ""} {
                append g "\nThe link custom command is \
                        $PROJECT(SIM_CUSTOM_COMMAND)"
        }
        if {$g == ""} {
                append g "The link custom_command is not specified."
        }
        puts $g
}

##
# @brief Handles the refresh command
#
proc refresh {{f ""}} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return
        }
        handlers::show -project
        commands::refresh $f
        if {$f != ""} {
                puts "\nThe file $f has been refreshed."
        } else {
                puts "\nThe project has been refreshed."
        }
}

##
# @brief Handles the compile_file command
#
proc compile_file {{args {}}} {
        global PROJECT
        global BSPEC
        set d ""
        set tc ""
        set e [check_options {-withdeps -typecheck} {} True OPT [lrange $args 1 end]]
        if {[info exists OPT(-withdeps)]} {
                set d $OPT(-withdeps)
        }
        if {[info exists OPT(-typecheck)]} {
                set tc $OPT(-typecheck)
        }
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {[set f [lindex $args 0]] == ""} {
                show_error "The file is not specified"  
        } elseif {$e == "error"} {
        } elseif {![file exists $f]} {
                set pf [lindex [lindex $BSPEC(FILES) \
                        [lsearch -regexp $BSPEC(FILES) $f]] 0]
                if {$pf == ""} {
                    show_error "The file '$f' does not exist."
                } else {
                        commands::compile_file $pf $d $tc
                }
        } else { 
                if {[lsearch -regexp $BSPEC(FILES) $f] == -1} {
                        show_error "The file '$f' is not a project file."
                } else {
                        commands::compile_file $f $d $tc
                }
        }
        focus_command_line
}

##
# @brief Handles the new_file command
#
proc new_file {{args {}}} {
        global PROJECT
        set p $PROJECT(DIR)
        set e [check_options {} {-path} True OPT [lrange $args 1 end]]
        if {[info exists OPT(-path)]} {
                set p $OPT(-path)
        }
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {[set f [lindex $args 0]] == ""} {
                show_error "The file name is not specified."  
        } elseif {$e == "error"} {
        } elseif {![file isdirectory $p]} {
                show_error "The file '$p' is not a directory."
        } else {
                commands::new_file $p/$f
                focus_command_line
        }
}

##
# @brief Handles the open_file command
#
# @todo break into small functions
#
proc open_file {{args {}}} {
        global BSPEC
        global PROJECT
        set l 0
        set e [check_options {} {-line} True OPT [lrange $args 1 end]]
        if {[info exists OPT(-line)]} {
                set l $OPT(-line)
        }
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {[set f [lindex $args 0]] == ""} {
                show_error "The file is not specified"  
        } elseif {$e == "error"} {
        } elseif {![file exists $f]} {
                set pf [lindex [lindex $BSPEC(FILES) \
                        [lsearch -regexp $BSPEC(FILES) $f]] 0]
                if {$pf == ""} {
                        show_error "The file '$f' does not exist."
                } else {
                        commands::open_file $pf $l
                }
        } else {
                if {[lsearch -regexp $BSPEC(FILES) $f] == -1} {
                        show_error "The file '$f' is not a project file."
                } else {
                        commands::open_file $f $l
                }
        }
        focus_command_line
}

##
# @brief Handles the typecheck command
#
proc typecheck {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {![file exists $PROJECT(DIR)]} {
                show_error "The current project has not been saved yet."
        } elseif {$PROJECT(COMP_TYPE) == "bsc" && $PROJECT(TOP_FILE) == ""} {
                show_error "The project top file is not specified."
        } else {
                commands::typecheck
        }
}

##
# @brief Handles the compile command
#
proc compile_ok {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
            return false
        } elseif {![file exists $PROJECT(DIR)]} {
                show_error "The current project has not been saved yet.\n\
                        Please save it and then compile."
            return false
        } elseif {$PROJECT(COMP_TYPE) == "bsc" && $PROJECT(TOP_FILE) == ""} {
                show_error "The project top file is not specified."
            return false
        } elseif {$PROJECT(COMP_TYPE) == "make" && $PROJECT(MAKE_FILE) == ""} {
                show_error "The project Makefile is not specified."
            return false
        } 
    return true
}
proc compile {} {
    if { [compile_ok] } {
        commands::compile
    }
}

proc check_link_bsc_options {} {
        global PROJECT
        if {$PROJECT(LINK_OUTDIR) == ""} {
                show_error "The directory for the link output file \
                is not specified."
                return error
        }
        if {$PROJECT(LINK_OUTNAME) == ""} {
                show_error "The name of the link output file is not specified."
                return error
        }
        return ""
}

proc check_link_make_options {} {
        global PROJECT
        if {$PROJECT(LINK_MAKEFILE) == ""} {
                show_error "Makefile for the link command is not specified."
                return error
        } 
        return ""
}

proc check_link_custom_options {} {
        global PROJECT
        if {$PROJECT(LINK_COMMAND) == ""} {
                show_error "The custom command for linking is not specified."
                return error
        }
        return ""
}

##
# @brief Handles the link command
#
proc link_ok {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return false
        }
        switch -exact $PROJECT(LINK_TYPE) {
                bsc {
                        set err [handlers::check_link_bsc_options]
                }
                make {
                        set err [handlers::check_link_make_options]
                }
                custom_command {
                        set err [handlers::check_link_custom_options]
                }
        }
    if { $err != "" } {
        return false
    }
    return true
}
proc link {} {
    global PROJECT
    if { [link_ok]} {
        set f "$PROJECT(COMP_BDIR)/$PROJECT(TOP_MODULE).ba"
        if {![file exists "$f"]} {
                show_error "The current project has not been compiled yet.\n\
                        Please compile!"
                return
        } else {
            commands::link
        }
    }
}

##
# @brief Handles the simulate command
#
proc simulate_ok {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
                return false
        } elseif {$PROJECT(LINK_TYPE) == "bsc"} {
                set t "$PROJECT(LINK_OUTDIR)/$PROJECT(LINK_OUTNAME)"
                if {![file exists $t] || $PROJECT(LINK_OUTNAME) == ""} {
                        show_error "The simulation executable does not exist"
                        return false
                } 
        } elseif {$PROJECT(LINK_TYPE) == "make"} {
                if {$PROJECT(LINK_SIM_TARGET) == ""} {
                        show_error "The simulation target is not specified"
                        return false
                }
        } else {
                if {$PROJECT(SIM_CUSTOM_COMMAND) == ""} {
                        show_error "The custom command for simulation \
                        is not specified"
                        return false
                }
        }
    return true
}
proc simulate {} {
    if { [simulate_ok] } {
        commands::simulate
    }
}

proc comp_and_link {} {
    if { [compile_ok] && [link_ok] } {
        commands::comp_and_link
    }
}
proc comp_link_and_sim {} {
    if { [compile_ok] && [link_ok] && [simulate_ok] } {
        commands::comp_link_and_sim
    }
}

##
# @brief Handles the clean command
#
proc clean {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } else {
                commands::clean
        }
}

##
# @brief Handles the full_clean command
#
proc full_clean {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } else {
                commands::full_clean
        }
}

##
# @brief Handles the show command
#
# @todo break into small functions
#
proc show {{w ""}} {
        if {$w == ""} {
                show_error "The window is not specified."  
                return
        }
        switch -exact -- $w {
                -project {
                        commands::show_project_window
                }
                -editor {
                        commands::show_editor_window
                }
                -package {
                        commands::show_package_window
                }
                -type_browser {
                        commands::show_type_browser_window
                }
                -module_browser {
                        commands::show_module_browser_window
                }
                -schedule_analysis {
                        commands::show_schedule_analysis_window
                }
                default {
                        show_error "There is no <$w> window"
                        return
                }
        }
        focus_command_line
}

proc check_dot_file {name} {
        if {![file exists [commands::get_dot_file_name $name]]} {
                show_error "There is no .dot file for the currently \
                        loaded module"
                return false
        }
        return true
}

##
# @brief Handles the show_graph command
#
proc show_graph {{type ""}} {
        global PROJECT
        global TCLDOT_EXIST
        global BSPEC
        set e [check_options {-conflict -exec -urgency \
                -combined -combined_full} {} True OPT $type]
        if {[info exists OPT($type)]} {
                set t [regsub -- "-" $OPT($type) ""]
        }
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project"
        } elseif {!$TCLDOT_EXIST} {
                show_error "Tcldot packages are not installed on this machine"
        } elseif {$type == ""} {
                show_error "The window is not specified."  
        } elseif {$e == "error"} {
        } else {
                if {[check_dot_file $t]} {
                        commands::show_graph_window $t
                }
                focus_command_line
        }
}

##
# @brief Handles the load_package command
#
proc load_package {{p ""}} {
        global PROJECT
        global env
        set r error
        foreach i [list $PROJECT(COMP_BDIR) \
                   $env(BLUESPECDIR)/Libraries] {
                if {[file exists "$i/$p.bo"]} {
                        set r ""
                }
        }
        if {$PROJECT(NAME) == ""} {
            show_error "There is no open project"
        } elseif {$p == ""} {
            show_error "The package name is not specified"  
        } elseif {$r != ""} {
                show_error "The package '$p' does not exist."
        } else {
                handlers::show -package
                commands::load_package $p
                focus_command_line
        }
}

##
# @brief Handles the reload_packages command
#
proc reload_packages {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
            show_error "There is no open project."
        } elseif {[Bluetcl::bpackage list] == ""} {
            show_error "There are no loaded packages."
        } else {
                handlers::show -package
                commands::reload_packages
                focus_command_line
        }
}

##
# @brief Handles the package_refresh command
#
proc package_refresh {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } else {
                handlers::show -package
                commands::package_refresh
                focus -force $eval(text)
        }
}

##
# @brief Handles the import_hierarchy command
#
# @todo enhance the implementation!
#
proc import_hierarchy {{p ""}} {
        global PROJECT
        global PACKAGE
        if {$PROJECT(NAME) == ""} {
            show_error "There is no open project."
            return
        } elseif {[Bluetcl::bpackage list] == ""} {
            show_error "There are no loaded packages."
            return
        } elseif {$p != "" && [lsearch [Bluetcl::bpackage list] $p] == -1} {
            show_error "The package '$p' is not loaded"
            return
        }
        if {$p == ""} {
                set f [file rootname [file tail $PROJECT(TOP_FILE)]]
                if {[lsearch [Bluetcl::bpackage list] $f] == -1} {
                        show_error "The top file '$f' is not loaded."
                        return
                }
        } else {
                set p [lindex [lindex $PACKAGE(NODES) \
                        [lsearch -regexp $PACKAGE(NODES) $p]] 0]
        }
        handlers::show -package
        commands::import_hierarchy $p
        focus_command_line
}

##
# @brief Handles the package_collapse_all command
#
proc package_collapse_all {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {[Bluetcl::bpackage list] == ""} {
                show_error "There are no loaded packages."
        } else {
                handlers::show -package
                commands::package_collapse_all
                focus_command_line
        }
}

##
# @brief Handles the search_in_packages command
#
# @todo implement this functions
#
proc search_in_packages {{args ""}} {
        global PROJECT
        set p [lindex $args 0]
        set t "Next"
        set e [check_options {-next -previous} {} True OPT [lrange $args 1 end]]
        if {[info exists OPT(-next)]} {
                if {[info exists OPT(-previous)]} {
                        show_error "Additional option is specified.\nShould be \
                                either '-next' or '-previous'."
                        return
                }
        } elseif {[info exists OPT(-previous)]} {
                set t "Prev"
        }
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {$p == ""} {
                show_error "The search pattern is not specified"  
        } elseif {$e == "error"} {
        } else {
                handlers::show -package
                commands::search_in_packages $p $t
                focus_command_line
        }
}

##
# @brief Handles the add_type command
#
# @todo break into small functions
#
proc add_type {{args {}}} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {$args == ""} {
                show_error "The type is not specified"  
        } else {
                foreach t $args {
                        if {[catch "type constr $t"] != 1} {
                                set s [type constr $t]
                        } else {
                                set s $t
                        }
                        commands::add_type $s
                }
                focus_command_line
        }
}

##
# @brief Handles the remove_type command
#
proc remove_type {{t ""}} { 
        global PROJECT
        global BSPEC
        if {$PROJECT(NAME) == ""} {
            show_error "There is no open project."
        } elseif {$t == ""} {
            show_error "The type is not specified"
        } elseif {$BSPEC(TYPES) == ""} {
            show_error "There is no type in the Type Browser window."
        } elseif {[lsearch $BSPEC(TYPES) $t] == -1} {
            show_error "The type $t is not added to the Type Browser window"
        } else {
                handlers::show -type_browser
                commands::remove_type $t
                focus_command_line
        }
}

##
# @brief Handles the type_collapse_all command
#
proc type_collapse_all {} {
        global PROJECT
        global BSPEC
        if {$PROJECT(NAME) == ""} {
            show_error "There is no open project."
        } elseif {$BSPEC(TYPES) == ""} {
            show_error "There is no type in the Type Browser window."
        } else {
                handlers::show -type_browser
                commands::type_collapse_all 
                focus_command_line
        }
}

##
# @brief Handles the load_module command
#
proc load_module {{m ""}} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {$m == ""} {
                show_error "The module name is not specified"  
        } elseif {![file exists $PROJECT(COMP_BDIR)/$m.ba]} {
                show_error "The module '$m' does not exist."
        } else {
                commands::load_module $m
                handlers::show -module_browser
                focus_command_line
        }
}

##
# @brief Handles the reload_module command
#
proc reload_module {} {
        global PROJECT
        global BSPEC
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {$BSPEC(MODULE) == ""} {
                show_error "There is no module loaded."
        } else {
                commands::reload_module
                handlers::show -module_browser
                focus_command_line
        }
}

proc set_module {module} {
        global PROJECT
        global BSPEC
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } else {
                commands::set_module $module
                focus_command_line
        } 
}

##
#
#
proc check_module {{module ""}} {
        global BSPEC
        global PROJECT
        if {$module == "" && $BSPEC(MODULE) == ""} {
                show_error "There is no module loaded."
                return false
        }
        if {$module != ""} {
                if {![file exists $PROJECT(COMP_BDIR)/$module.ba]} {
                    show_error "The module '$module' does not exist."
                    return false
                }
                commands::load_module $module
        }
        return true
}

##
# @brief Handles the show_schedule command
#
proc show_schedule {{m ""}} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {[check_module $m]} {
                commands::show_schedule
                focus_command_line
        }
}

##
# @brief Handles the module_collapse_all command
#
proc module_collapse_all {} {
        global PROJECT
        global BSPEC
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {$BSPEC(MODULE) == ""} {
                show_error "There is no module loaded."
        } else {
                handlers::show -module_browser
                commands::module_collapse_all
                focus_command_line
        }
}

##
# @brief Handles the get_schedule_warnings command
#
# @param m the name of the module to be loaded
#
proc get_schedule_warnings {{m ""}} {
        global SCHEDULE
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {[check_module $m]} {
                handlers::show -schedule_analysis
                $SCHEDULE(TABNOTEBOOK) select 0
                commands::get_schedule_warnings
                focus_command_line
        }
}

##
# @brief Handles the get_execution_order command
#
proc get_execution_order {{m ""}} {
        global SCHEDULE
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {[check_module $m]} {
                handlers::show -schedule_analysis
                $SCHEDULE(TABNOTEBOOK) select 1
                commands::get_execution_order
                focus_command_line
        }
}

##
# @brief Handles the get_rule_info command
#
proc get_rule_info {{n ""}} {
        global SCHEDULE
        global PROJECT
        global BSPEC
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {$BSPEC(MODULE) == ""} {
                show_error "There is no module loaded."
        } elseif {$n == ""} {
                show_error "The rule is not specified"  
        } elseif {[lsearch [Bluetcl::schedule execution $BSPEC(MODULE)] $n] == -1} {
                show_error "Incorrect rule name \"$n\""
        } else {
                handlers::show -schedule_analysis
                $SCHEDULE(TABNOTEBOOK) select 1
                commands::get_rule_info $n
                focus_command_line
        }
}

##
# @brief Handles the get_method_call command
#
proc get_method_call {{m ""}} {
        global SCHEDULE
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {[check_module $m]} {
                handlers::show -schedule_analysis
                $SCHEDULE(TABNOTEBOOK) select 2
                focus_command_line
        }
}

##
# @brief Handles the get_rule_relations command
#
# @todo break into small functions
#
proc get_rule_relations {{n {}} {m {}}} {
        global SCHEDULE
        global PROJECT
        global BSPEC
        if {$PROJECT(NAME) == ""} {
                show_error "There is no open project."
        } elseif {$BSPEC(MODULE) == ""} {
                show_error "There is no loaded module."
        } elseif {$n == ""} {
                show_error "The rules are not specified"  
        } elseif {$m == ""} {
                show_error "The second rule is not specified"  
        } else {
                foreach r1 $n {
                        if {[lsearch [Bluetcl::schedule execution \
                                        $BSPEC(MODULE)] $r1] == -1} {
                                show_error "Incorrect rule name \"$r1\""
                                return
                        }
                }
                foreach r2 $m {
                        if {[lsearch [Bluetcl::schedule execution \
                                        $BSPEC(MODULE)] $r2] == -1} {
                                show_error "Incorrect rule name \"$r2\""
                                return
                        }
                }
                handlers::show -schedule_analysis
                $SCHEDULE(TABNOTEBOOK) select 3
                commands::get_rule_relations $n $m 
                focus_command_line
        }
}

##
# @brief Helper command for testing
#
proc show_error {s} {
        global BSPEC
        if {$BSPEC(OUTPUT) != ""} {
                set id [open $BSPEC(OUTPUT) a]
                puts $id $s
                close $id
        }
        puts stderr $s
}
}
# end namespace
