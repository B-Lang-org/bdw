#
# @brief Definition of project manipulation commands.
#

namespace eval commands {

        package require Bluetcl
        package require Unique 

##
# @brief Checks if f is the subpath of p
#
# @param p URL (expressed as a list)
# @param f URL (expressed as a list)
# @return the number of common elements in the list 0 is there are non
#
proc compare_lists {p f} {
        if {[expr [llength $p] < [llength $f]]} {
                set min  [llength $p]
        } else {
                set min [llength $f]
        }
        for {set i 0} {$i < $min} {incr i} {
                if {[string compare [lindex $p $i] [lindex $f $i]]} {
                        break;
                }
        }
        return $i
}

proc drop_dots_in_path {p} {
        set ret [list]
        foreach e $p {
                if {$e != "."} {
                        lappend ret $e
                }
        }
        if {[llength $ret] == 0} {
                lappend ret "."
        }
        return $ret
}

##
# @brief Returnes the relative path for the specified file path
#
# @param file URL of the file
# @param path URL of the directory according to which the file 
# should be relative
# @return relative path
#        
proc make_related_path {file {path [pwd]}} {
        if {$file == ""} {
                return ""
        }
        eval set path $path
        if {[file pathtype $file] == "absolute"} {
                set ps [drop_dots_in_path [file split $path]]
                set fs [drop_dots_in_path [file split $file]]
                # drop common path
                set com [compare_lists $ps $fs]
                set ps [lrange $ps $com end]
                set fs [lrange $fs $com end]
                set r [list]
                for { set i 0} { $i < [llength $ps] } { incr i} {
                        lappend r ".."
                }
                set r [eval file join [concat "." $r $fs]]
        } else {
                set fs [drop_dots_in_path [file split $file]]
                set r [eval file join $fs]
        }
        return $r
}

##
# @brief Returnes the relative path for the specified file path
#
# @param file URL of the file
# @return relative path
#        
proc make_absolute_path {file} {
        if {$file == ""} {
                return ""
        }
        if {[file pathtype $file] == "relative"} {
                set c [file split [pwd]]
                set p [file split $file]
                while {[lindex $p 0] == "."} {
                        set p [lrange $p 1 end]
                }
                while {[lindex $p 0] == ".."} {
                        set p [lrange $p 1 end]
                        set c [lreplace $c end end]
                }
                set c [concat $c $p]
                set r "/"
                foreach i $c {
                        set r [file join $r $i]
                }
        } else {
                set r $file
        }
        return $r
}

##
# @brief Returns the real path from the given path
#
# @param path the path
#
proc get_real_path {path} {
        if {$path == ""} {
                return ""
        } elseif {[file pathtype $path] == "absolute"} {
                return [commands::make_absolute_path $path]
        } else {
                return [commands::make_related_path $path]
        }
}

##
# @brief Checks if the specified path is added to search paths
#
# @param path the URL of the specified path
#
# @return true if the path is already added to search paths, false otherwise
#        
proc check_path {path} {
        global PROJECT
        global env
        set r [make_related_path $path]
        set a [make_absolute_path $path]
        set as [regsub "$env(BLUESPECDIR)" $a "%"]
        if {[lsearch $PROJECT(PATHS) $r] == -1 && \
            [lsearch $PROJECT(PATHS) $a] == -1 && \
            [lsearch $PROJECT(PATHS) $as] == -1} {
                return true
        }
        return false
}

##
# @brief Enables/Disables menu and tool-bar build buttons when 
# link via bsc is set
#
proc set_link_bsc_state {} {
        global PROJECT
        set f $PROJECT(TOP_MODULE)  
        if {$PROJECT(COMP_TYPE) == "bsc"} {
                if {[file exists "$PROJECT(COMP_BDIR)/$f.ba"]} {
                        main_window::change_toolbar_state link normal
                        main_window::change_menu_status build link normal
                }
        } else {
                main_window::change_toolbar_state link normal
                main_window::change_menu_status build link normal
        }
        set t "$PROJECT(LINK_OUTDIR)/$PROJECT(LINK_OUTNAME)"
        if {[file exists $t] && $PROJECT(LINK_OUTNAME) != ""} {
                main_window::change_toolbar_state simulate normal
                main_window::change_menu_status build simulate normal
        } 
}

##
# @brief Enables/Disables menu and tool-bar build buttons when 
# link via make is set
#
proc set_link_make_state {} {
        global PROJECT
        main_window::change_toolbar_state link normal
        main_window::change_menu_status build link normal
        if {$PROJECT(LINK_SIM_TARGET) != ""} {
                main_window::change_toolbar_state simulate normal
                main_window::change_menu_status build simulate normal
        }
}

##
# @brief Enables/Disables menu and tool-bar build buttons 
#
proc set_build_state {} {
        global PROJECT
        if {$PROJECT(LINK_TYPE) == "bsc"} {
                set_link_bsc_state
        }  elseif {$PROJECT(LINK_TYPE) == "make"} {
                set_link_make_state
        } else {
                main_window::change_toolbar_state {link simulate} normal
                main_window::change_menu_status build {link simulate} normal
        }
}

proc set_stop_state {} {
        global BSPEC
        set x [array names BSPEC CPID,*]
        if { $x != [list] } {
                set s normal
        } else {
                set s disabled
        }
        main_window::change_menu_status build {stop} $s
        main_window::change_toolbar_state  {stop} $s
}

##
# @brief Defines the toolbar state according to the project status
#        
proc change_menu_toolbar_state {} {
        global PROJECT
        main_window::change_toolbar_state {save link simulate} disabled
        main_window::change_toolbar_state {tccompile compile compilelink compilelinksim clean build} normal
        main_window::change_menu_status build {link simulate} disabled
        main_window::change_menu_status project save disabled
        if {$PROJECT(STATUS) == ""} {
                main_window::change_toolbar_state save normal
                main_window::change_menu_status project save normal
        }
        set_build_state
        set_stop_state
}

##
# @brief
#
proc update_window_titles {} {
        global BSPEC
        wm title . "BSC Workstation$BSPEC(TITLE)"
        if {[winfo exists $BSPEC(PROJECT)]} {
                wm title $BSPEC(PROJECT) "Project Files$BSPEC(TITLE)"
        }
        if {[winfo exists $BSPEC(PACKAGE)]} {
                wm title $BSPEC(PACKAGE) "Package$BSPEC(TITLE)"
        }
        if {[winfo exists $BSPEC(TYPE_BROWSER)]} {
                wm title $BSPEC(TYPE_BROWSER) "Type Browser$BSPEC(TITLE)"
        }
        if {[winfo exists $BSPEC(MODULE_BROWSER)]} {
                wm title $BSPEC(MODULE_BROWSER) "Module Browser$BSPEC(TITLE)"
        }
        if {[winfo exists $BSPEC(SCHEDULE)]} {
                wm title $BSPEC(SCHEDULE) "Schedule Analysis$BSPEC(TITLE)"
        }

}

##
# @brief Sets new project settings
#
proc set_new_project_settings {} {
        global BSPEC
        global PROJECT
        foreach i $BSPEC(DIRS) {
                set PROJECT($i) $PROJECT(DIR)
        }
        set PROJECT(LINK_OUTNAME) out
        set PROJECT(MAKE_FILE) Makefile
        set PROJECT(MAKE_CLEAN) clean
        set PROJECT(MAKE_FULLCLEAN) clean
        set PROJECT(STATUS) ""
        set PROJECT(VIEWER_CLOSE) 0
        set_project_options_in_interp 
        commands::show_project_window
        enable_project_specific_menu_actions
        change_menu_toolbar_state
        main_window::change_menu_status project save_placement disabled
}

##
# @brief Creates new project.
#
# @param n name of the project 
# @param l location of the project
#
proc new_project {n l} {
        global PROJECT        
        global BSPEC
        if {$PROJECT(NAME) != ""} {
                commands::close_project
        }
        set l [string trimright $l /]
        if {[catch "file mkdir \"$l\"" err]} {
                error_message "Can not create the directory '$l'\n$err" .pn
                return
        }
        set dir [make_absolute_path $l]
        catch "cd \"$dir\"" err
        set BSPEC(CURRENT_DIR) $dir
        set PROJECT(NAME) $n
        # the project dir is always the directory where the bspec file resides
        set PROJECT(DIR) . 
        set BSPEC(TITLE) "  -  $PROJECT(NAME)"
        set_new_project_settings
        update_window_titles
        status_command_window::display_message "The project \
        $PROJECT(DIR)/$PROJECT(NAME).bspec is created."
}

##
# @brief Sets the project options
#
# @param proj URL of the project file
#
proc set_open_project_settings {proj} {
        global PROJECT
        global BSPEC
        set proj [commands::make_absolute_path $proj]
        cd [file dirname $proj]
        set BSPEC(CURRENT_DIR) [file dirname $proj]
        if {[catch "source \"$proj\"" log]} {
                puts stderr "Can not open the project '[file tail $proj]' : \
                        \n$log"
                return false
        }
        # the project dir is always the directory where the bspec file resides
        set PROJECT(DIR) .
        set PROJECT(NAME) [file rootname [file tail $proj]]
        set PROJECT(STATUS) saved

        project_file_compatibility
        set_project_options_in_interp
        show_project_window
        package_refresh
        enable_project_specific_menu_actions
        change_menu_toolbar_state
        main_window::change_menu_status project save_placement normal
        set_files
        return true
}

# Set flags in the interp according to project options and BSC_OPTIONS
proc set_project_options_in_interp {} {
        global PROJECT
        global env
        set oldstatus $PROJECT(STATUS)

        commands::reset_flags
        # set defpath [split [lindex [Bluetcl::flags show p] 1] :]
        set defpath [list . %/Libraries]
        set defpath [regsub -all "$env(BLUESPECDIR)" $defpath %]

        catch "Bluetcl::flags set [add_bsc_options]"
        # add path from BSC_OPTIONS
        commands::set_search_paths $defpath

        # if { ![directory_exists_in_search_paths $PROJECT(COMP_BDIR)] } {
        #         catch "Bluetcl::flags set -p $PROJECT(COMP_BDIR):+"
        # }

        Bluetcl::flags set -bdir $PROJECT(COMP_BDIR)

        set PROJECT(STATUS) $oldstatus
        return true
}

## handle any renameing of options to maintain compatibility
proc project_file_compatibility {} {
        global PROJECT
        if {[info exists PROJECT(EDITOR_GVIM_EXEC)]} {
                set PROJECT(EDITOR_GVIM) [lindex $PROJECT(EDITOR_GVIM_EXEC) 0]
                unset PROJECT(EDITOR_GVIM_EXEC)
        }
        if {[info exists PROJECT(EDITOR_EMACS_EXEC)]} {
                set PROJECT(EDITOR_EMACS) [lindex $PROJECT(EDITOR_EMACS_EXEC) 0]
                unset PROJECT(EDITOR_EMACS_EXEC)
        }
        if {[info exists PROJECT(EDITOR_OTHER_EXEC)]} {
                set PROJECT(EDITOR_OTHER) $PROJECT(EDITOR_OTHER_EXEC)
                unset PROJECT(EDITOR_OTHER_EXEC)
        }
}

##
# @brief Opens the specified project.
#
# @param proj URL of the project which should be processed
#
proc open_project {proj} {
        global PROJECT
        global BSPEC
        if {$PROJECT(NAME) != ""} {
                commands::close_project
        }
        if {![set_open_project_settings $proj]} {
                return
        }
        set BSPEC(TITLE) "  -  $PROJECT(NAME)"
        update_window_titles
        status_command_window::display_message "The project \
        $PROJECT(DIR)/$PROJECT(NAME).bspec is opened."
}

##
# @brief Enables project specific menu actions
#
proc enable_project_specific_menu_actions {} {
        global BSPEC
        main_window::change_menu_status project {save save_as options close} \
                normal
        main_window::change_menu_status tool {back_up export_makefile \
                import_bvi} normal
        main_window::change_menu_status build {tccompile compile link simulate \
                compilelink compilelinksim rebuild clean stop full_clean} normal
        main_window::change_menu_status window {project_window editor_window \
               package_window type_window module_window schedule_window } \
               normal
        if {[winfo exists $BSPEC(PROJECT)]} {
                project_window::change_menu_status project \
                        {options tccompile compile refresh} normal
                project_window::change_menu_status file new normal
                project_window::change_bg_menu_status {"New File" \
                        "Compile project" "Refresh"} normal 
        }
        if {[winfo exists $BSPEC(PACKAGE)]} {
                package_window::change_menu_status package \
                        {load_package refresh} normal
        }
        if {[winfo exists $BSPEC(TYPE_BROWSER)]} {
                type_browser::change_menu_status types pload normal
        }
        if {[winfo exists $BSPEC(MODULE_BROWSER)]} {
                #module_browser::change_menu_status module load normal
        }
        if {[winfo exists $BSPEC(SCHEDULE)]} {
                schedule_analysis::change_menu_status module load normal
        }
}

proc set_files {} {
        global BSPEC
        global PROJECT
        global env
        set BSPEC(FILES) {}
        set files {}
        set ldir [regsub -all "%" $PROJECT(PATHS) $env(BLUESPECDIR)]
        set project_files {"*.bsv" "*.bs"}
        foreach f $project_files {
                foreach d $ldir {
                        foreach i [lsort [glob -nocomplain -directory $d $f]] {
                                lappend files $i
                        }
                }
        }
        foreach i $files {
                lappend BSPEC(FILES) [list $i [file join \
                        [file tail [file dirname $i]] [file tail $i]]]
        }
}

##
# @brief Add the specified paths to the project search paths.
#
# @param paths list of directories where .bsv files are located
#
proc set_search_paths {paths} {
        global BSPEC
        global PROJECT
        set PROJECT(STATUS) ""
        foreach i $paths {
                if {[directory_exists_in_search_paths $i] }   { continue }
                if {[lsearch -exact $PROJECT(PATHS) $i] >= 0} { continue }
                lappend PROJECT(PATHS) $i
        }

        # Set the flags in the bluetcl interp now
        set path [get_project_paths]
        catch "Bluetcl::flags set -p \"$path\""

        show_project_window False
        if { [winfo exists  $BSPEC(PROJECT_HIERARCHY)] } {
                $BSPEC(PROJECT_HIERARCHY) configure \
                    -querycommand "project_window::get_files %n"
        }
        set_files
}

proc reset_flags {} {
        Bluetcl::flags reset
}

##
# @brief Selects files to display/hide in the Project File window.
#
# @param include the files which should be shown
# @param exclude the files which should be hidden
#
proc display_rules {include exclude} {
        global PROJECT
        set PROJECT(STATUS) ""
        set PROJECT(INCLUDED_FILES) $include
        set PROJECT(EXCLUDED_FILES) $exclude
        commands::refresh
}

##
# @brief Saves current project.
#
proc save_project {} {
        global PROJECT 
        file delete -force $PROJECT(DIR)/$PROJECT(NAME).bspec
        if {[catch "exec touch \"$PROJECT(DIR)/$PROJECT(NAME).bspec\"" err]} {
                error_message "Can not save\n$PROJECT(NAME).bspec\n$err"
                return
        }
        set id [open "$PROJECT(DIR)/$PROJECT(NAME).bspec" a+]
        write_project_info $id
        write_project_options $id
        close $id
        set PROJECT(STATUS) saved
        change_menu_toolbar_state
        main_window::change_menu_status project save_placement normal
        status_command_window::display_message "The project \
        $PROJECT(DIR)/$PROJECT(NAME).bspec is saved."
}

##
# @brief Opens the "Project->Save as..." dialog
#
proc create_save_as_dialog {} {
        set type {{{Bspec files} {.bspec} }}
        set f [tk_getSaveFile -filetypes $type -minsize "350 200"]
        if {[file extension $f] != ""} {
                set f [regsub -- ".bspec" $f ""]
        }
        if {[set n [file tail $f]] != ""} {
                commands::save_project_as $n [file dirname $f]
        }
}

##
# @brief Saves current project in another location.
#
# @param p name of the project.
# @param l path where the project should be located. 
#
proc save_project_as {p l} {
        global PROJECT
        file delete -force $l/$p.bspec
        catch "exec mkdir -p $l"
        if {[catch "exec touch \"$l/$p.bspec\"" err]} {
                error_message "Can not create file '$l/$p.bspec'\n$err" .sa
                return
        }
        set d $PROJECT(DIR)
        set n $PROJECT(NAME)
        set PROJECT(DIR) $l
        set PROJECT(NAME) $p
        set id [open "$PROJECT(DIR)/$PROJECT(NAME).bspec" a+]
        write_project_info $id
        write_project_options_into_another_location $id $PROJECT(DIR)
        close $id
        set PROJECT(DIR) $d
        set PROJECT(NAME) $n
        status_command_window::display_message "The project \
        $PROJECT(DIR)/$PROJECT(NAME).bspec is saved as $l/$p.bspec."
        close_project
        open_project $l/$p.bspec
}

##
# @brief Writes the project options into the specified file
#
# @param id channel identifier
#
proc write_project_options {id} {
        global PROJECT
        global CONFIG
        foreach i $CONFIG {
                if {$i == "DIR" || $i == "NAME"} {
                        continue
                }
                # Escape \ and $ before writing to bspec file
                regsub -all "\"" $PROJECT($i) "\\\"" a
                regsub -all "\\$" $a "\\$" a

                puts $id "set PROJECT($i) \"$a\""
        }
        puts $id [Waves::get_options_to_save]
}

##
# @brief If the specified file URL is relative then it is made relative to the
# specified directory
#
# @param file URL of a file
# @param dir the directory relative to which the file should be made
#
# @return path relative to the specified directory
#
proc change_relative_paths {file dir} {
        global PROJECT
        if {$file == "."} {
                return $file
        }
        if {[file pathtype $file] == "relative"} {
                set file [make_related_path [make_absolute_path $file] $dir] 
        }
        return $file
}

##
# @brief Writes the project options into the specified file
#
# @param id channel identifier, where the project should be written
# @param dir the directory where the project should be saved
#
proc write_project_options_into_another_location {id dir} {
        global PROJECT
        global CONFIG 
        global BSPEC
        set dirs [concat $BSPEC(DIRS) $BSPEC(PATHS)]
        set p [list LINK_COMMAND SIM_CUSTOM_COMMAND MAKE_TARGET MAKE_CLEAN \
                MAKE_FULLCLEAN MAKE_OPTIONS LINK_TARGET LINK_SIM_TARGET \
                LINK_CLEAN_TARGET LINK_FULL_CLEAN_TARGET LINK_MAKE_OPTIONS]
        foreach i $CONFIG {
                set d ""
                if {$i == "DIR" || $i == "NAME" || $PROJECT($i) == ""} {
                        continue
                }
                if {[lsearch $dirs $i] != -1 } {
                        set d [change_relative_paths $PROJECT($i) $dir]
                } elseif {[lsearch $p $i] != -1} {
                        set a [regsub -all "\"" $PROJECT($i) "\\\""]
                        set d [regsub -all "\\$" $a "\\$"]
                } elseif {$i == "PATHS"} {
                        foreach j $PROJECT(PATHS) {
                                if {[lsearch $BSPEC(LIBRARIES) $j] == -1} {
                                        lappend d \
                                                [change_relative_paths $j $dir]
                                } else {
                                        lappend d $j
                                }
                        }
                } else {
                        set d $PROJECT($i)
                }
                if {$d != ""} {
                        regsub -all "\\$" $d "\\$" d
                        regsub -all "\"" $d "\\\"" d

                        puts $id "set PROJECT($i) \"$d\""
                }
        }
        puts $id [Waves::get_options_to_save]
}

##
# @brief Writes the project into the specified file
#
# @param id identifier of the opened channel
#
proc write_project_info {id} {
        puts $id "### BDW project file."
        set d [exec date]
        puts $id "### Generated by BSC Workstation on $d\n"
        puts $id "global PROJECT\n" 
}

##
#
#
proc close_opened_editors {} {
        commands::close_all_files
        if {[file exists editor_ids]} {
# Disabled the kill since changes are not saved!
#                set id [open editor_ids]
#                set t [read $id]
#                close $id
#                if {$t != ""} {
#                        foreach i $t {
#                                puts $i
#                                set procs [commands::getChildPids $i]
#                                set cmd "kill -9 $procs"
#                                catch "exec $cmd"
#                        }
#                }
                file delete -force editor_ids
        }
}

##
# @brief Clears project specific settings
#
proc clear_project {} {
        global PROJECT
        global BSPEC
        main_window::clear
        project_window::clear
        package_window::clear
        type_browser::clear
        module_browser::clear
        schedule_analysis::clear
        set_default_options
        set BSPEC(TITLE) ""
        update_window_titles
        commands::close_opened_editors
}

## 
# @brief Closes the project.
#
proc close_project {} {
        global BSPEC
        global PROJECT 
        global env
        status_command_window::display_message "The project \
        $PROJECT(DIR)/$PROJECT(NAME).bspec is closed."
        set PROJECT(STATUS) saved
        commands::clear_project
        cd $env(PWD)
        set BSPEC(CURRENT_DIR) $env(PWD)
}

##
# @brief Specifies editor for current project.
#
# @param name name of editor. 
# @param exec command to be executed for the editor. 
#
proc set_project_editor {name exec} {
        global PROJECT
        global BSPEC
        if { [lsearch $BSPEC(EDITORS) $name] == -1 } {
                set name [lindex $BSPEC(EDITORS) end]
        }
        set PROJECT(STATUS) ""
        set PROJECT(EDITOR_NAME) $name
        set PROJECT(EDITOR_[string toupper $name]) $exec
}
 
##
# @brief Specifies Waveform Viewer for current project.
#
# @param name the name of Waveform Viewer tool.
# @param com the command for Viewer.
# @param opt options for current Viewer.
# @param close whether to close the Viewer on BDW close or not, the
# default value is Yes. 
#
proc set_waveform_viewer {name  {cmd ""} {opt ""} {close 0}} {
        global PROJECT
        set PROJECT(STATUS) ""
        set PROJECT(VIEWER_CLOSE) $close
        Waves::set_options viewer $name
        Waves::set_viewer_options $name Command $cmd Options $opt
}
 
##
# @brief Specifies Non-Bsv Hierarchy for the Waveform Viewer.
#
# @param hier the Non-BSV hierarchy for the Waveform Viewer.
#
proc set_nonbsv_hierarchy {{hier "/main/top"}} {
        global PROJECT
        set PROJECT(STATUS) ""
        Waves::set_nonbsv_hierarchy $hier
        if { [winfo exists $::BSPEC(MODULE_BROWSER)] } {
                [$::BSPEC(MODULE_BROWSER) get_viewer] configure -nonbsv_hierarchy $hier
        }
        Waves::get_nonbsv_hierarchy
}

##
# @brief Specifies Signal naming mode for the Waveform Viewer.
#
# @param mode Signal naming mode for the Waveform Viewer.
#
proc set_waveform_naming_mode {{mode ""}} {
        global PROJECT
        set PROJECT(STATUS) ""
        Waves::set_waveform_naming_mode $mode
}

##
# @brief Specifies Bool display mode for the Waveform Viewer.
#
# @param mode Bool display mode for the Waveform Viewer.
#
proc set_bool_display_mode {{mode ""}} {
        global PROJECT
        set PROJECT(STATUS) ""
        Waves::set_waveform_bool_mode $mode
}

##
# @brief Specifies if workstation flags values are copied from top module.
#
# @param mode Flags copy mode.
#

proc set_flags_mode {{mode ""}} {
        global PROJECT
        set PROJECT(STATUS) ""
	set PROJECT(COPY_FLAGS) $mode
}

##
# @brief Specifies appliaction start=up timeout for the Waveform Viewer.
#
# @param timeout in seconds for the Waveform Viewer.
#
proc set_start_timeout {timeout} {
        global PROJECT
        set PROJECT(STATUS) ""
        if { [regexp {^[0-9]+$} $timeout] != 1 } {
                error_message "Waveview timeout must be positive integer,\
                        found $timeout" .po
                return
        }
        if { $timeout <= 0} {
                error_message "Waveview timeout must be non-zero, found\
                        $timeout" .po
                return
        }
        Waves::set_start_timeout $timeout
        
} 
##
# @brief Specifies directory where the compilation results should be located.
#
# @param vdir directory where generated Verilog files should be located.
# @param bdir directory where generated .bo/.ba files should be located. 
# @param simdir directory where Bluesim intermediate files should be located.
#
proc set_compilation_results_location {{vdir ""} {bdir ""} {simdir ""}} {
        global PROJECT
        set PROJECT(STATUS) ""
        set bdir [get_real_path $bdir]
        set odir [make_absolute_path $PROJECT(COMP_BDIR)]
        set ndir [make_absolute_path $bdir]
#        if {![string equal $odir $ndir]} {
#                commands::bsc_clean
#        }
        set PROJECT(COMP_BDIR) $bdir
        if {[commands::check_path $bdir]} {
                set_search_paths $bdir
        }
        set PROJECT(COMP_VDIR) [get_real_path $vdir]
        set PROJECT(COMP_SIMDIR) [get_real_path $simdir]
}

##
# @brief Specifies type of compilation for current project.
#
# @param type either "make" or "bsc"
#
proc set_compilation_type {type} {
        global PROJECT
        set PROJECT(STATUS) ""
        set PROJECT(COMP_TYPE) $type
}

##
# @brief Specifies bsc options for the current project.
#
# @param type specifies bsc type.Either bluesim or verilog.
# @param opt additional options to pass to bsc.
#
proc set_bsc_options {type {info_dir} {rts_opt ""} {opt ""}} {
        global PROJECT
        set PROJECT(STATUS) ""
        set PROJECT(COMP_BSC_TYPE) $type
        set PROJECT(COMP_INFO_DIR) [get_real_path $info_dir]
        set PROJECT(COMP_RTS_OPTIONS) $rts_opt
        set PROJECT(COMP_BSC_OPTIONS) $opt
}

##
# @brief Sets make options for the current project.
#
# @param mkfile makefile for the current project. 
# @param trg makefile target.
# @param cln optional target which will be called upon "clean" command execution
# @param fcln optional target which will be called upon "full_clean" command
# execution 
# @param opt optional option which will be called upon "make" 
#
proc set_make_options {mkfile {trg ""} {cln ""} {fcln ""} {opt ""}} {
        global PROJECT
        set PROJECT(STATUS) ""
        set PROJECT(MAKE_FILE) [get_real_path $mkfile]
        if {$PROJECT(LINK_MAKEFILE) == ""} {
                set PROJECT(LINK_MAKEFILE) [get_real_path $mkfile]
        }
        set PROJECT(MAKE_TARGET) $trg
        set PROJECT(MAKE_CLEAN) $cln
        set PROJECT(MAKE_FULLCLEAN) $fcln
        set PROJECT(MAKE_OPTIONS) $opt
        if {$PROJECT(LINK_MAKE_OPTIONS) == ""} {
                set PROJECT(LINK_MAKE_OPTIONS) $opt
        }
}

##
# @brief Specifies top file and module for current project.
#
# @param file full name of top file
# @param module name of top module
#
proc set_top_module {file module} {
        global PROJECT
        set PROJECT(STATUS) ""
        set PROJECT(TOP_FILE) [get_real_path $file]
        set PROJECT(TOP_MODULE) $module
        if {$PROJECT(LINK_OUTNAME) == ""} {
                set PROJECT(LINK_OUTNAME) $module
        }
}

##
# @brief Specifies verilog simulator for current project.
# 
# @param name name of simulation tool
# @param opt options to pass to the simulator
#
proc set_verilog_simulator {name {opt ""}} {
        global PROJECT
        set PROJECT(STATUS) ""
        set PROJECT(SIM_NAME) $name
        set PROJECT(SIM_OPTIONS) $opt
}

##
# @brief Specifies bluesim simulator for current project.
# 
# @param opt options to pass to the simulator
#
proc set_bluesim_options {{opt ""}} {
        global PROJECT
        set PROJECT(STATUS) ""
        set PROJECT(RUN_OPTIONS) $opt
}

##
# @brief Specifies link type
#
# @param type the link type: bsc, make or custom
#
proc set_link_type {type} {
        global PROJECT
        set PROJECT(LINK_TYPE) $type
}

##
# @brief Specifies link bsc options.
#
# @param type link bsc type bluesim or verilog
# @param name link output file name
# @param dir link output directory
# @param opt link option
#
proc set_link_bsc_options {name dir opt} {
        global PROJECT
        set PROJECT(LINK_OUTNAME) $name   
        set PROJECT(LINK_OUTDIR) [get_real_path $dir]
        set PROJECT(LINK_BSC_OPTIONS) $opt
}

##
# @brief Specifies make options for linking.
#
# @param makefile the link makefile
# @param trg makefile target
# @param sim_trg makefile target for simulation
# @param cln_trg makefile target for clean
# @param fcln_trg makefile target for full clean
# @param opt link make option
#
proc set_link_make_options {makefile {trg ""} {sim_trg ""} \
                                {cln_trg ""} {fcln_trg ""} {opt ""}} {
        global PROJECT
        set PROJECT(LINK_MAKEFILE) [get_real_path $makefile]
        set PROJECT(LINK_TARGET) $trg
        set PROJECT(LINK_SIM_TARGET) $sim_trg
        set PROJECT(LINK_CLEAN_TARGET) $cln_trg
        set PROJECT(LINK_FULL_CLEAN_TARGET) $fcln_trg
        set PROJECT(LINK_MAKE_OPTIONS) $opt 
}

##
# @brief Specifies linking custom command.
#
# @param cmd link custom command
#
proc set_link_custom_command {cmd} {
        global PROJECT
        set PROJECT(LINK_COMMAND) $cmd
}

##
# @brief Specifies a custom command for simulating.
#
# @param cmd custom command for linking
#
proc set_sim_custom_command {cmd} {
        global PROJECT
        set PROJECT(SIM_CUSTOM_COMMAND) $cmd
}

##
# @brief Refresh information about current project or particular file
#
# @param file the selected file
#
proc refresh {{file ""}} {
        global BSPEC
        commands::set_files
        if {[winfo exists $BSPEC(PROJECT)]} {
                if {$file == ""} {
                        $BSPEC(PROJECT_HIERARCHY) configure \
                        -querycommand "project_window::get_files %n"
                        project_window::change_menu_status file {edit refresh \
                                compile compile_with_deps tccompile \
                                tccompile_with_deps} disabled
                } else {
                        $BSPEC(PROJECT_HIERARCHY) refresh $file
                }
        }
}

##
# @brief Minimizes all active windows except the Main window
#
proc minimize_all {} {
        global BSPEC
        if {[winfo exists $BSPEC(PROJECT)]} {
                wm iconify $BSPEC(PROJECT)
        }
        if {[winfo exists $BSPEC(PACKAGE)]} {
                wm iconify $BSPEC(PACKAGE)
        }
        if {[winfo exists $BSPEC(TYPE_BROWSER)]} {
                wm iconify $BSPEC(TYPE_BROWSER)
        }
        if {[winfo exists $BSPEC(MODULE_BROWSER)]} {
                wm iconify $BSPEC(MODULE_BROWSER)
        }
        if {[winfo exists $BSPEC(SCHEDULE)]} {
                wm iconify $BSPEC(SCHEDULE)
        }
        if {[winfo exists $BSPEC(IMPORT_BVI)]} {
                wm iconify $BSPEC(IMPORT_BVI)
        }
        if {[winfo exists .sbvi]} {
                wm iconify .sbvi
        }
        foreach i $BSPEC(GRAPHS) {
                if {[winfo exists $i]} {
                        wm iconify $i
                }
        }
}

##
# @brief Closes all active windows except the Main window
#
proc close_all {} {
        global BSPEC
        if {[winfo exists $BSPEC(PROJECT)]} {
                project_window::close
        }
        if {[winfo exists $BSPEC(PACKAGE)]} {
                package_window::close
        }
        if {[winfo exists $BSPEC(TYPE_BROWSER)]} {
                type_browser::close
        }
        if {[winfo exists $BSPEC(MODULE_BROWSER)]} {
                $BSPEC(MODULE_BROWSER) close
        }
        if {[winfo exists $BSPEC(SCHEDULE)]} {
                $BSPEC(SCHEDULE) close
        }
        if {[winfo exists $BSPEC(IMPORT_BVI)]} {
                $BSPEC(IMPORT_BVI) action_close
        }
        foreach i $BSPEC(GRAPHS) {
                if {[winfo exists $i]} {
                        destroy $i
                }
        }
        commands::close_all_files
}

##
# @brief Activates the Project Files window
#
proc show_project_window { {force True} } {
        global BSPEC

        if { [winfo exists $BSPEC(PROJECT)] } {
                $BSPEC(PROJECT_HIERARCHY) configure \
                -querycommand "project_window::get_files %n"
                wm deiconify $BSPEC(PROJECT) 
                #raise $BSPEC(PROJECT) 
                #focus -force $BSPEC(PROJECT)
        } elseif { $force } {
                project_window::create
                project_window::change_menu_status project \
                        {options tccompile compile refresh} normal
        } else {
        }
}

##
# @brief Activates the Editor window
#
proc show_editor_window {} {
        Editor::start 1
}

##
# @brief Activates the Package window
#
proc show_package_window {} {
        global BSPEC
        if {! [winfo exists $BSPEC(PACKAGE)]} {
                package_window::create
                package_window::change_menu_status package {load_top_package \
                        load_package reload refresh import search} disabled
                package_window::change_menu_status package \
                        {load_package refresh} normal
        } else {
                wm deiconify $BSPEC(PACKAGE) 
                raise $BSPEC(PACKAGE)
                focus -force $BSPEC(PACKAGE)
        }
        if {[Bluetcl::bpackage list] != ""} {
                package_window::change_menu_status package {load_top_package \
                        load_package reload refresh import search} normal
        }

}

##
# @brief Activates the Type Browser window
#
proc show_type_browser_window {} {
        global BSPEC
        if {! [winfo exists $BSPEC(TYPE_BROWSER)]} {
               type_browser::create
               if {[Bluetcl::bpackage list] != ""} {
                     type_browser::change_menu_status types add normal
               }
        } else {
                wm deiconify $BSPEC(TYPE_BROWSER) 
                raise $BSPEC(TYPE_BROWSER)
                focus -force $BSPEC(TYPE_BROWSER)
        }
}

##
# @brief Activates the Module Browser window
#
proc show_module_browser_window {} {
        global BSPEC
        global PROJECT
        if {! [winfo exists $BSPEC(MODULE_BROWSER)]} {
                create_module_browser_window
        } else {
                wm deiconify $BSPEC(MODULE_BROWSER) 
                raise $BSPEC(MODULE_BROWSER)
                focus -force $BSPEC(MODULE_BROWSER)
        }
}

##
# @brief Activates the Schedule Analysis window
#
proc show_schedule_analysis_window {} {
        global BSPEC
        global PROJECT
        if {! [winfo exists $BSPEC(SCHEDULE)]} {
                create_schedule_analysis_window
                schedule_analysis::change_menu_status module load normal
                schedule_analysis::change_menu_status module {load_top \
                        reload set_modul} disabled
                if {$PROJECT(TOP_MODULE) != "" && [file exists \
                        $PROJECT(COMP_BDIR)/$PROJECT(TOP_MODULE).ba]} {
                        schedule_analysis::change_menu_status module \
                                load_top normal
                }
                if {$BSPEC(MODULE) != ""} {
                        schedule_analysis::change_menu_status module \
                                {reload set_modul} normal
                }
        } else {
                wm deiconify $BSPEC(SCHEDULE) 
                raise $BSPEC(SCHEDULE)
                focus -force $BSPEC(SCHEDULE)
        }
}

##
# @brief Activates the graph window
#
# @param type the type of the graph
#
proc show_graph_window {type} {
        global BSPEC
        set g [commands::get_dot_file_name $type]
        if {![file exists $g]} {
                error_message "There is no .dot file for the currently \
                        loaded module" $BSPEC(SCHEDULE)
                return
        }
        set gname [string replace $type 0 0 [string toupper \
                        [string index $type 0]]]
        if {$type == "exec"} {
                set gname "Execution"
        } elseif {$type == "combined_full"} {
                set gname "Combined Full"
        }
        set wname [file tail [file rootname $g]]
        if {![winfo exists .$wname]} {
                create_graph_window $g "$gname Graph" 
        } else {
                wm deiconify .$wname 
                raise .$wname
                focus -force .$wname
        }
        commands::display_command_results "The $gname Graph is opened."
}

##
# @brief Activates the Import BVI window
#
proc show_import_bvi_window {} {
        global BSPEC
        if {! [winfo exists $BSPEC(IMPORT_BVI)]} {
                create_import_bvi_wizard_window
        } else {
                wm deiconify $BSPEC(IMPORT_BVI) 
                raise $BSPEC(IMPORT_BVI)
                focus -force $BSPEC(IMPORT_BVI)
        }
}



##
# @brief Displays help content window
#
proc figure_out_default_browser {} {
        global env
        set def1 "/etc/alternatives/x-www-browser"
        set def0 "firefox"
        if { [info exists env(BROWSER)] } {
                return $env(BROWSER)
        } elseif { [file executable $def1] } {
                return $def1 
        } else {
                return $def0 
        }
}

##
# @brief Opens the specified file in the browser
#
# @param file URL 
#        
proc open_browser { file } {
        global BSPEC
        global env
        set browser [figure_out_default_browser]
        set cmd "exec $browser $file &"
        if {[catch $cmd err]} {
                error_message "Can not open html: \n $err"
                return
        } else {
                lappend BSPEC(HELP) $err
        }
}


##
# @brief Displays help content window
#
proc show_help_content {} {
        global env
        open_browser $env(BDWDIR)/tcllib/workstation/help/html/index.html
}

##
# @brief Displays help content window
#
proc show_bsc_doc {} {
        global env
        open_browser https://github.com/B-Lang-org
}


##
# @brief Displays help information
#
# @param h content or about
#
proc help {{h ""}} {
        switch -exact -- $h {
                -content {
                        show_help_content
                }
                -bsc {
                        show_bsc_doc
                }
                -about {
                        create_help_about_dialog
                }
                default {
                        status_command_window::display_help $h
                }
        }
}

##
# @brief Helper function for testing
#
proc display_project_status {} {
        global PROJECT
        global CONFIG
        global BSPEC
        if {$BSPEC(OUTPUT) == ""} {
                return
        }
        set id [open $BSPEC(OUTPUT) a]
        foreach i $CONFIG {
                if {$i == "PATHS"} {
                        foreach j $PROJECT($i) {
                                puts $id "$i = [file tail $j]"
                        }
                        continue
                }
                if {$PROJECT($i) != ""} {
                        if {[lsearch $BSPEC(DIRS) $i] != -1} {
                                puts $id "$i = [file tail $PROJECT($i)]"
                        } else {
                                puts $id "$i = $PROJECT($i)"
                        }
                }
        }
        close $id
}

##
# @brief Extracts spaces from the beginning and the end of the specified string
#
# @param string the specified string
#
proc extract_spaces {string} {
        return [string trim $string]
}

##
# @brief Creates the specified directory if it doesn't exist
#
# @param dirs list of directories
#
proc create_dir_if_doesnt_exist {dirs} {
        foreach i $dirs {
                if {![file isdirectory $i]} {
                        if {[catch "file mkdir \"$i\"" err]} {
                                handlers::show_error $err
                                return
                        } else {
                                puts "The '$i' directory is created."
                        }
                }
        }
}

##
# @brief Returns true if the specified directory exists in the specified paths
#
# @param dir the URL of the directory
# @param paths list of paths to be searched
#
proc directory_exists_in_search_paths {dir} {
        global PROJECT
        set ad [commands::make_absolute_path $dir]
        set rd [commands::make_related_path $dir]
        if {[lsearch $PROJECT(PATHS) $ad] == -1 && \
                [lsearch $PROJECT(PATHS) $rd] == -1} {
                        return false
        }
        return true
}

##
# @brief Writes the coordinates of windows into file
#
proc save_placement {} {
        global PROJECT
        set id [open "$PROJECT(DIR)/$PROJECT(NAME).bspec"]
        set t [open "$PROJECT(DIR)/temp.bspec" a+]
        set v "MAIN_PLACEMENT PROJECT_PLACEMENT PACKAGE_PLACEMENT \
                TYPE_PLACEMENT MODULE_PLACEMENT SCHEDULE_PLACEMENT \
                WIZARD_PLACEMENT"
        while {[gets $id line] >= 0} {
                set k 0
                foreach i $v {
                        if {[string equal "[lindex $line 1]" "PROJECT($i)"]} {
                                puts $t "set PROJECT($i) $PROJECT($i)"
                                set pos [lsearch $v $i]
                                set v [lreplace $v $pos $pos]
                                set k 1
                                break
                        }
                }
                if {$k == 0} {
                        puts $t $line
                }
        }
        foreach i $v {
                puts $t "set PROJECT($i) $PROJECT($i)"
        }
        close $id
        close $t
        file rename -force "$PROJECT(DIR)/temp.bspec" \
                "$PROJECT(DIR)/$PROJECT(NAME).bspec" 
}

##
# @brief Handles the "Project->Save Placement" command
#
proc project_save_placement {} {
        global PROJECT
        global BSPEC
        if {[winfo exists $BSPEC(MAIN_WINDOW)]} {
                set PROJECT(MAIN_PLACEMENT) [winfo geometry $BSPEC(MAIN_WINDOW)]
        }
        if {[winfo exists $BSPEC(PROJECT)]} {
                set PROJECT(PROJECT_PLACEMENT) [winfo geometry $BSPEC(PROJECT)]
        }
        if {[winfo exists $BSPEC(PACKAGE)]} {
                set PROJECT(PACKAGE_PLACEMENT) [winfo geometry $BSPEC(PACKAGE)]
        }
        if {[winfo exists $BSPEC(MODULE_BROWSER)]} {
                set PROJECT(MODULE_PLACEMENT) \
                        [winfo geometry $BSPEC(MODULE_BROWSER)]
        }
        if {[winfo exists $BSPEC(TYPE_BROWSER)]} {
                set PROJECT(TYPE_PLACEMENT) \
                        [winfo geometry $BSPEC(TYPE_BROWSER)]
        }
        if {[winfo exists $BSPEC(SCHEDULE)]} {
                set PROJECT(SCHEDULE_PLACEMENT) \
                        [winfo geometry $BSPEC(SCHEDULE)]
        }
        if {[winfo exists $BSPEC(IMPORT_BVI)]} {
                set PROJECT(WIZARD_PLACEMENT) \
                        [winfo geometry $BSPEC(IMPORT_BVI)]
        }
        save_placement
}

proc back_up_files {tcmd files names sdir verb} {
        global PROJECT
        set msg "\nBackup"
        if {[lindex $files 0] == 1 && [lindex $files 1] != 1} {
                append tcmd " $names $PROJECT(DIR)/$PROJECT(NAME).bspec"
                append msg " Input files."
        }
        if {[lindex $files 1] == 1} {
                append tcmd " $PROJECT(DIR)"
                append msg " Project directory."
        }
        if {[lindex $files 2] == 1} {
                append tcmd " $sdir"
                append msg " Search Path."
        }
        status_command_window::display_message "$msg" false
        status_command_window::display_message "$tcmd" false
        commands::display_command_results "Executing: $tcmd"
        catch $tcmd err
        if {$verb} {
                puts "$err"
                commands::display_command_results "$err"
        }
        status_command_window::display_message "Backup finished" false
}

##
# @brief Handles the "Project->Backup files" command
#
# @param name the name of backup output file (default is .tgz)
#
# @param options the options to pass to "tar -xf" command
#
# @param sp_files the files from Search Path to be backed up.
#
# @param files the files to be backed up.
#
proc project_backup {name files options sp_files} {
        global PROJECT
        global env
        set tcmd ""
        set opt ""
        set verb 0
        foreach i $options {
                append opt [regsub -all -- "-" $i ""]
                if {[regexp -all v $i]} {
                        set verb 1
                }
        }
        append tcmd "exec tar cf$opt $name"
        set input_ext [list "*.bsv" "*.v" "*.vcd"]
        set names ""
        foreach i $input_ext {
                set fts [lsort [exec find $PROJECT(DIR) -name $i]]
                append names "$fts "
        }
        set sdir ""
        foreach f $sp_files {
                foreach s $PROJECT(PATHS) {
                        set ps "[exec find [make_related_path \
                                [regsub % $s $env(BLUESPECDIR)]] -name *$f]"
                        foreach p [lsort $ps] {
                                append sdir "[make_related_path $p] "
                        }
                }
        }
        back_up_files $tcmd $files $names $sdir $verb
}

##
# @brief
#
# @param n makefile name 
# @param l makefile location 
# @param comp_cmd compile command
# @param link_cmd link command
# @param sim_cmd simulation command
# @param clean clean command
# @param full_clean full_clean command
#
proc write_makefile_info {n l comp_cmd link_cmd sim_cmd clean full_clean} {
        global PROJECT
        set id [open "$l/$n" a+]
        puts $id "### Makefile for the $PROJECT(NAME) project" 
        set d [exec date]
        puts $id "### Generated by BSC Workstation on $d\n"
        puts $id "default: full_clean compile link simulate\n" 
        puts $id ".PHONY: compile\ncompile:\n\t@echo Compiling...\n\t$comp_cmd\n\t@echo Compilation finished\n" 
        puts $id ".PHONY: link\nlink:\n\t@echo Linking...\n\t$link_cmd\n\t@echo Linking finished\n" 
        puts $id ".PHONY: simulate\nsimulate:\n\t@echo Simulation...\n\t$sim_cmd\n\t@echo Simulation finished\n"
        puts $id ".PHONY: clean\nclean:"
        foreach f $clean {
                if {$f != ""} {
                        puts $id "\texec rm -f $f"
                }
        }
        puts $id "\n.PHONY: full_clean\nfull_clean:" 
        foreach f $full_clean {
                if {$f != ""} {
                        puts $id "\trm -f $f"
                }
        }
        close $id
}

##
# @brief Handles the "Project->Export Makefile" command
#
proc export_makefile {n l} {
        global PROJECT 
        if {[set comp_cmd [get_bsc_compile_command]] == ""} {
                return
        }
        if {[set link_cmd [commands::link_via_bsc]] == ""} {
                return
        }
        if {[set sim_cmd [commands::simulate_via_bsc]] == ""} {
                return
        }
        set clean [commands::get_bsc_clean_files]
        set full_clean [commands::get_bsc_clean_all_files]
        file delete -force $l/$n
        if {[catch "exec touch \"$l/$n\"" err]} {
                error_message "Can not create the $n makefile\n$err" .pem
                return
        }
        write_makefile_info $n $l $comp_cmd $link_cmd $sim_cmd $clean \
                $full_clean
        status_command_window::display_message "The makefile $l/$n is created."
}

##
# @brief Exits the Main window
#
proc exit_main_window {} {
    global PROJECT
    global BSPEC
    Editor::quit
    # Stop child processes
    commands::stop
    after 100
    set really_exit true
    if {[Editor::isRunning]} {
	set really_exit false
	set really_exit [editor_running_dialog]
    }
    if {!$really_exit}  { return }
    if {$PROJECT(NAME) != ""} {
	if {$PROJECT(STATUS) == ""} {
	    save_current 
	}
	if {$PROJECT(STATUS) == ""} {
	    return        
	} 
        if {[winfo exists $BSPEC(IMPORT_BVI)]} {
                if {![$BSPEC(IMPORT_BVI) action_cancel]} { return }
        }
    }
    foreach i $BSPEC(HELP) {
	set procs [commands::getChildPids $i]
	#set cmd "kill -15 $procs"
	# Disabled the kill, since browser may be used for many things
	#catch "exec $cmd"
    }
    close_opened_editors
    if {$PROJECT(VIEWER_CLOSE) == "close"} {
	catch "$BSPEC(MODULE_BROWSER) viewer_close"
    }
    exit
}
# End of namespace commands
} 

## Local Variables:
## eval: (set (make-local-variable 'tcl-indent-level) 8)
## End:
