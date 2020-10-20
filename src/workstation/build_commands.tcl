##
# @file build_commands.tcl
#
# @brief Definition of build commands.
#

namespace eval commands {

##
# @brief Compiles the specified file.
#
# @param s file which will be compiled.
# @param d if this option is set then dependencies will be considered.
# @param tc if this option is set then only type checking will be done
#
proc compile_file {s {d ""} {tc "" }} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                error_message "There is no open project"
                return
        }
        set f ""
        if {$d != ""} {
            append f "-u "
        }
        append f [add_bsc_options]
        if { $tc != "" } {
            regsub {\-sim|\-verilog} $f "" ff
            set f $ff
        }
        commands::action_start "Compiling the file $s"
        set cmd "bsc $f $s"
        execute_in_shell $cmd "commands::action_finished Compile"
}

##
# @brief Adds bluesim options
#
# @param f the string to add options
#
proc add_bluesim_options {f} {
        global PROJECT
        upvar $f ff
        append ff "-sim "
        if {$PROJECT(COMP_SIMDIR) != ""} {
                append ff "-simdir $PROJECT(COMP_SIMDIR) "
        }
}

##
# @brief Adds verilog options
#
# @param f the string to add options
#
proc add_verilog_options {f} {
        global PROJECT
        upvar $f ff
        append ff "-verilog -elab "
        if {$PROJECT(COMP_VDIR) != ""} {
                append ff "-vdir $PROJECT(COMP_VDIR) "
        }
}

##
# @brief Returns project paths
#
# @return project paths
#
proc get_project_paths {} {
    global PROJECT
    set p $PROJECT(PATHS)
    # remove BDIR, since this is already added..
    regsub $PROJECT(COMP_BDIR) $p "" p
    set p [join  $p ":"]
    return $p
}

##
# @brief Adds bsc options
#
proc add_bsc_options {} {
        global PROJECT
        set f ""
        switch $PROJECT(COMP_BSC_TYPE) {
                bluesim {
                        add_bluesim_options f
                }
                verilog {
                        add_verilog_options f
                }
        }
        if {$PROJECT(COMP_BDIR) != ""} {
                append f "-bdir $PROJECT(COMP_BDIR) "
        }
        if {$PROJECT(COMP_RTS_OPTIONS) != ""} {
                append f "+RTS $PROJECT(COMP_RTS_OPTIONS) -RTS "
        }
        if {$PROJECT(COMP_INFO_DIR) != ""} {
                append f "-info-dir $PROJECT(COMP_INFO_DIR) "
        }
        if {$PROJECT(COMP_BSC_OPTIONS) != ""} {
                append f "$PROJECT(COMP_BSC_OPTIONS) "
        }
        append f "-p [get_project_paths] "
        return $f
}

##
# @brief Typechecks the current project
#
proc typecheck {} {
        global PROJECT
        global BSPEC
        if {$PROJECT(NAME) == ""} {
                error_message "There is no open project"
                return
        }
        if {![file exists $PROJECT(DIR)]} {
                error_message "The current project has not been saved yet.\n\
                        Please save it and then compile."
                return
        }
        if {$PROJECT(TOP_FILE) == ""} {
                error_message "Top file is not specified"
                return
        }
        set f [add_bsc_options]
        commands::action_start Typechecking
        regsub {\-sim|\-verilog} $f "" ff
        set cmd "bsc -u $ff $PROJECT(TOP_FILE) "
        execute_in_shell $cmd "commands::action_finished Typecheck"
}

##
# @brief Compiles current project
#
proc compile_get_cmd {} {
        global PROJECT
        global BSPEC
        if {$PROJECT(NAME) == ""} {
                error_message "There is no open project"
                return
        }
        if {![file exists $PROJECT(DIR)]} {
                error_message "The current project has not been saved yet.\n\
                        Please save it and then compile."
                return
        }
        switch $PROJECT(COMP_TYPE) {
                make {
                        set cmd [commands::get_compile_via_make_command]
                }
                bsc {
			set cmd [commands::get_bsc_compile_command]
                }
                default {
                        error_message "Unsupported compilation type"
                }
        }
        return $cmd
}
proc compile {} {
        set cmd [compile_get_cmd]
	if {$cmd != ""} {
        	commands::action_start Compiling
        	execute_in_shell $cmd "commands::action_finished Compile"
	}
}

##
# @brief Compiles the project via make
#
proc get_compile_via_make_command {} {
        global PROJECT
        if {$PROJECT(MAKE_FILE) == ""} {
                error_message "Makefile is not specified."
                return
        }
        commands::action_start Compiling
        set mt [customize_custom_command $PROJECT(MAKE_TARGET)]
        set mo [customize_custom_command $PROJECT(MAKE_OPTIONS)]

        return "make -f $PROJECT(MAKE_FILE) $mo $mt"
}


##
# @brief Sets appropriate settings to start the build action
#
# $param action the current action
#
proc action_start {action} {
        global BSPEC
        if {[winfo exists .sbvi]} {
                .sbvi buttonconfigure OK -state disabled
        }
        if {[winfo exists $BSPEC(IMPORT_BVI)] && [set but [$BSPEC(IMPORT_BVI) \
                                                get_compile_id]] != ""} {
                 $but configure -state disabled
        }
        if {[winfo exists $BSPEC(PROJECT)]} {
                project_window::change_menu_status project {tccompile compile} \
                        disabled
                project_window::change_menu_status file {compile \
                compile_with_deps tccompile tccompile_with_deps} disabled
                project_window::change_item_menu_status {"Compile file" \
                        "Compile file with deps" "Typecheck file" \
                        "Typecheck file with deps"} disabled
                project_window::change_bg_menu_status {"Compile project"} \
                        disabled
        }
        main_window::change_menu_status build {tccompile compile link simulate \
                compilelink compilelinksim rebuild clean full_clean} disabled
        main_window::change_menu_status build stop normal
        main_window::change_menu_status project \
                {new open save save_as close} disabled
        main_window::change_toolbar_state {new open save tccompile compile \
                 compilelink compilelinksim link simulate clean build} disabled
        main_window::change_toolbar_state stop normal
        status_command_window::display_message "" false
        status_command_window::display_message "$action..."
}

##
# @brief Sets appropriate settings to finish the build action
#
# $param action the current action
#
proc action_finished {action} {
        global BSPEC
        status_command_window::display_message "$action finished" false
        set BSPEC(BUILDPID) ""
        if {[winfo exists .sbvi]} {
                .sbvi buttonconfigure OK -state normal
        }
        if {[winfo exists $BSPEC(IMPORT_BVI)] && [set but [$BSPEC(IMPORT_BVI) \
                                                get_compile_id]] != ""} {
                 $but configure -state normal
        }
        if {[winfo exists $BSPEC(PROJECT)]} {
                project_window::change_menu_status project {tccompile compile} \
                        normal
                project_window::change_item_menu_status {"Compile file" \
                        "Compile file with deps" "Typecheck file" \
                        "Typecheck file with deps"} normal
                project_window::change_bg_menu_status {"Compile project"} normal
                if {[$BSPEC(PROJECT_HIERARCHY) selection get] != ""} {
                        project_window::change_menu_status file {compile \
                        compile_with_deps tccompile tccompile_with_deps} normal
                }
        }
        main_window::change_menu_status build {tccompile compile link simulate \
                compilelink compilelinksim rebuild clean full_clean} normal
        main_window::change_menu_status project \
                {new open save save_as close} normal
        main_window::change_toolbar_state {new open} normal
        change_menu_toolbar_state
}

##
# @brief Returns the command for compile via bsc
#
proc get_bsc_compile_command {} {
        global PROJECT
        if {$PROJECT(TOP_FILE) == ""} {
                error_message "Top file is not specified"
                return ""
        }
        set f ""
        append f [add_bsc_options]
        if {$PROJECT(TOP_MODULE) != ""} {
                append f "-g $PROJECT(TOP_MODULE) "
        }
        set cmd "bsc -u $f $PROJECT(TOP_FILE) "
        return $cmd
}

##
# @brief Compiles the project via bsc
#
proc execute_bsc {} {
        if {[set cmd [get_bsc_compile_command]] != ""} {
                commands::action_start Compiling
                execute_in_shell $cmd "commands::action_finished Compile"
        }
}

##
# @brief Sets bluesim options for link
#
# @return string with options
#
proc set_link_bluesim_options {} {
        global PROJECT
        set exe "bsc -e $PROJECT(TOP_MODULE) -sim "
        append exe "-o $PROJECT(LINK_OUTDIR)/$PROJECT(LINK_OUTNAME) "
        if { $PROJECT(COMP_SIMDIR) != "" } {
                append exe "-simdir $PROJECT(COMP_SIMDIR) "
        }
        append exe "-p [get_project_paths] "
        append exe "-bdir $PROJECT(COMP_BDIR) " 
        append exe "$PROJECT(LINK_BSC_OPTIONS) "
        # append exe "$PROJECT(COMP_BDIR)/$PROJECT(TOP_MODULE).ba"
        return $exe
}

##
# @brief Sets verilog options for link
#
# @return string with verilog options
#
proc set_link_verilog_options {} {
        global PROJECT
        set out "$PROJECT(LINK_OUTDIR)/$PROJECT(LINK_OUTNAME)"
        set vdir $PROJECT(COMP_VDIR)
        set topv $vdir/$PROJECT(TOP_MODULE).v
        set exe "bsc -e $PROJECT(TOP_MODULE) -verilog -o $out -vdir $vdir \
                -vsim $PROJECT(SIM_NAME) \
                $PROJECT(LINK_BSC_OPTIONS) $topv"
        return $exe
}

##
# @brief Returns the link command for bsc linking
#
# @return the link command
#
proc link_via_bsc {} {
        global PROJECT
        if {$PROJECT(TOP_MODULE) == ""} {
                error_message "The top module is not specified."
                return ""
        }
        switch $PROJECT(COMP_BSC_TYPE) {
                bluesim {
                        set exe [set_link_bluesim_options]
                }
                verilog {
                        set exe [set_link_verilog_options]
                }
                default {
                        set exe ""
                }
        }
        customize_custom_command $exe

}

##
# @brief Returns the link command for linking via make
#
# @return the link command
#
proc link_via_make {} {
        global PROJECT
        set lmo [customize_custom_command $PROJECT(LINK_MAKE_OPTIONS)]
        set lt [customize_custom_command $PROJECT(LINK_TARGET)]
        return "make -f $PROJECT(LINK_MAKEFILE) $lmo $lt"
}

##
# @brief Substitutes the unknown variables with environment variables
#
# @param exe the string
#
# @return the substituted string
#
proc customize_custom_command {exe} {
        global PROJECT
        global env

        proc max { x y } { if { $x > $y } { return $x } else { return  $y } }

        # Common environment variables
        set exe [regsub -all "%B" $exe $env(BLUESPECDIR)]

        # Basic project 
        set exe [regsub -all "%M" $exe $PROJECT(TOP_MODULE)]
        set exe [regsub -all "%P" $exe $PROJECT(TOP_FILE)]

        set tmp $exe
        set exe ""
        while { [string length $tmp] != 0 } {
                set fst [string index $tmp 0]
                if { "$" == $fst } {
                        if { "\{" == [string index $tmp 1] } {
                                set endw [expr 1 + [string first "\}"  $tmp]] 
                                set word [string range $tmp 0 $endw-1]
                        } else {
                                set endw [string wordend $tmp 1]
                                set word [string range $tmp 0 $endw]
                        }
                        set name [string trim  $word "\{\} $"]
                        if { [info exists env($name)] } {
                                set word $env($name)
                        }
                        append exe $word
                        set tmp [string range $tmp [max 1 $endw] end]
                } else {
                        append exe $fst
                        set tmp [string range $tmp 1 end]
                }
        }
        return $exe
}

##
# @brief Returns the custom command for linking
#
# @return the link command
#
proc link_via_custom_command {} {
        global PROJECT
        return [customize_custom_command "$PROJECT(LINK_COMMAND)"]
}

##
# @brief Links the current project
#
proc link_get_cmd {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                error_message "There is no open project"
                return ""
        }
        switch $PROJECT(LINK_TYPE) {
                bsc {
                        set cmd [commands::link_via_bsc]
                }
                make {
                        set cmd [commands::link_via_make]
                }
                custom_command {
                        set cmd [commands::link_via_custom_command]
                }
        }
        return $cmd
}
proc link {} {
        set cmd [link_get_cmd]
        commands::action_start Linking
        execute_in_shell $cmd "commands::action_finished Link"
}

##
# @brief Returns the simulation command for bsc linking
#
# @return the simulation command
#
proc simulate_via_bsc {} {
        global PROJECT
        set out $PROJECT(LINK_OUTDIR)/$PROJECT(LINK_OUTNAME)
        if {$PROJECT(COMP_BSC_TYPE) == "bluesim"} {
                return  "$out $PROJECT(RUN_OPTIONS)"
        } elseif {$PROJECT(COMP_BSC_TYPE) == "verilog"} {
                return  "$out $PROJECT(SIM_OPTIONS)"
        }
}

##
# @brief Returns the simulation command for linking via make
#
# @return the simulation command
#
proc simulate_via_make {} {
        global PROJECT
        set lmo [customize_custom_command $PROJECT(LINK_MAKE_OPTIONS)]
        set lst [customize_custom_command $PROJECT(LINK_SIM_TARGET)]
        return "make -f $PROJECT(LINK_MAKEFILE) $lmo $lst"
}

##
# @brief Returns the simulation command for linking with a custom command
#
# @return the simulation command
#
proc simulate_via_custom_command {} {
        global PROJECT
        return [customize_custom_command "$PROJECT(SIM_CUSTOM_COMMAND)"]
}

##
# @brief Simulates the current project
#
proc simulate_get_command {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                error_message "There is no open project"
                return
        }
        switch $PROJECT(LINK_TYPE) {
                bsc {
                        set cmd [commands::simulate_via_bsc]
                }
                make {
                        set cmd [commands::simulate_via_make]
                }
                custom_command {
                        set cmd [commands::simulate_via_custom_command]
                }
        }
        return $cmd
}

proc simulate {} {
        global PROJECT
        set cmd [simulate_get_command]
	commands::action_start Simulating
	execute_in_shell $cmd "commands::action_finished Simulation"
}

##
# @brief Handles the full_clean, compile, link, simulate commands
#
proc build {} {
        global BSPEC
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                error_message "There is no open project"
                return
        }
        commands::full_clean
        commands::compile
        tkwait variable BSPEC(BUILDPID)
        if {$BSPEC(BUILDPID) == "killed"} {
                set BSPEC(BUILDPID) ""
                return
        }
        if {$PROJECT(LINK_TYPE) == "bsc" && $PROJECT(COMP_TYPE) == "bsc"} {
                if {![file exists \
                        "$PROJECT(COMP_BDIR)/$PROJECT(TOP_MODULE).ba"]} {
                        return
                }
        } elseif {$PROJECT(LINK_TYPE) == "make" && \
                                $PROJECT(LINK_SIM_TARGET) == ""} {
                return
        }
        commands::link
        tkwait variable BSPEC(BUILDPID)
        if {$BSPEC(BUILDPID) == "killed"} {
                set BSPEC(BUILDPID) ""
                return
        }
        set t "$PROJECT(LINK_OUTDIR)/$PROJECT(LINK_OUTNAME)"
        if {[file exists $t] && $PROJECT(LINK_OUTNAME) != ""} {
                commands::simulate
        }
}

proc comp_and_link {} {
        set ccmd [compile_get_cmd]
        set lcmd [link_get_cmd]
        set cmd "$ccmd ;\n $lcmd"

        commands::action_start "Compile and Link the Project"
        execute_in_shell $cmd "commands::action_finished Compile/Link"
}

proc comp_link_and_sim {} {
        set ccmd [compile_get_cmd]
        set lcmd [link_get_cmd]
        set cmd "$ccmd ;\n $lcmd"

        set scmd [simulate_get_command]
        append cmd " ;\n" $scmd

        commands::action_start "Compile Link and Simulate the Project"
        execute_in_shell $cmd "commands::action_finished Compile/Link/Simulate"
}

##
# @brief Stops build of current project
#
# PIDs are tracked in BSPEC(CPID,filename) array
#
proc stop {} {
        global BSPEC
        set procs [list]
        foreach x [array names BSPEC CPID,*] {
                lappend procs $BSPEC($x)
                unset BSPEC($x)
        }
        set procs [getChildPids $procs]
        if { $procs != "" } {
                set cmd "kill $procs"
                catch "exec $cmd"
        }
        set BSPEC(BUILDPID) "killed"
        change_menu_toolbar_state
}

##
# @brief Removes result files
#
proc clean {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                error_message "There is no open project"
                return
        }
        switch $PROJECT(COMP_TYPE) {
                make {
                        commands::make_clean
                }
                bsc {
                        commands::bsc_clean
                }
                default {
                        error_message "Unsupported compilation type"
                        return
                }
        }
        if {$PROJECT(LINK_TYPE) == "make"} {
                commands::link_make_clean
        }
        change_menu_toolbar_state
}

##
# @brief Displays status message for clean via make
#
proc make_completed {} {
        status_command_window::display_message "Make finished" false
}

##
# @brief Invokes make with the specified "clean" target
#
proc link_make_clean {} {
        global PROJECT
        if {$PROJECT(LINK_MAKEFILE) == ""} {
                error_message "The makefile for linking is not specified."
                return
        }
        if {$PROJECT(LINK_CLEAN_TARGET) == ""} {
                return
        }
        set lct [customize_custom_command $PROJECT(LINK_CLEAN_TARGET)]
        set lmo [customize_custom_command $PROJECT(LINK_MAKE_OPTIONS)]
        set cmd "make -f $PROJECT(LINK_MAKEFILE) $lmo $lct"
        execute_in_shell $cmd commands::make_completed
}

##
# @brief Invokes make with the specified "clean" target
#
proc make_clean {} {
        global PROJECT
        if {$PROJECT(MAKE_FILE) == ""} {
                error_message "Makefile is not specified."
                return
        }
        if {$PROJECT(MAKE_CLEAN) == ""} {
                error_message "Target for cleaning is not specified"
                return
        }
        set mc [customize_custom_command $PROJECT(MAKE_CLEAN)]
        set mo [customize_custom_command $PROJECT(MAKE_OPTIONS)]
        set cmd "make -f $PROJECT(MAKE_FILE) $mo $mc"
        execute_in_shell $cmd commands::make_completed
}

##
# @brief Invokes make with the specified "full clean" target
#
proc make_full_clean {} {
        global PROJECT
        if {$PROJECT(MAKE_FILE) == ""} {
                error_message "Makefile is not specified."
                return
        }
        if {$PROJECT(MAKE_FULLCLEAN) == ""} {
                error_message "Target for full clean is not specified"
                return
        }
        set mfc [customize_custom_command $PROJECT(MAKE_FULLCLEAN)]
        set mo [customize_custom_command $PROJECT(MAKE_OPTIONS)]
        set cmd "make -f $PROJECT(MAKE_FILE) $mo $mfc"
        execute_in_shell $cmd commands::make_completed
}

##
# @brief Get files from given directory with specified extensions
#
# @param ext extension
# @param dir path of the directory
#
proc get_files {ext dir} {
        return [glob -nocomplain -directory $dir *$ext]
}

##
# @brief Deletes files
#
# @param f files
#
proc delete_files {files} {
        if {$files != ""} {
                set ext [file extension $files]
                if {$ext == ".v"} {
                        set ext $files
                }
                status_command_window::display_message \
                        "Deleting generated *$ext files..." false
                foreach i $files {
                         status_command_window::display_message "  $i" false
                }
                set cmd "exec rm -f $files"
                catch $cmd
        }
}

##
# @brief Adds the files generated after compilation to the list
#
# @param type the type of the generated file
#
proc add_generated_files {type} {
        global PROJECT
        set c [glob -nocomplain -directory $PROJECT(COMP_BDIR) *.$type]
        if {$c != ""} {
                foreach i $c {
                        set i [file rootname [file tail $i]]
                        if {[lsearch $PROJECT(GEN_FILES) $i] == -1 } {
                                lappend PROJECT(GEN_FILES) $i
                        }
                }
        }
}

##
# @brief Gets last compilation results
#
proc get_bsc_clean_files {} {
        global PROJECT
        set files ""
        if {$PROJECT(COMP_BDIR) != ""} {
                foreach f ".bo .bi .ba .o" {
                        if {[set fs [get_files $f $PROJECT(COMP_BDIR)]] != ""} {
                                lappend files $fs
                        }
                }
        }
        return $files
}

##
# @brief Deletes last compilation results
#
proc bsc_clean {} {
        global PROJECT
        if {$PROJECT(COMP_BDIR) != ""} {
                foreach files [get_bsc_clean_files] {
                        delete_files $files
                }
        }
}

##
# @brief Returns the file names generated during compilation/link/simulation
#
proc get_generated_files {} {
        global PROJECT
        set files [get_bsc_clean_files]
        if {$PROJECT(GEN_FILES) != ""} {
                if {[set cvd $PROJECT(COMP_VDIR)] != ""} {
                        foreach i $PROJECT(GEN_FILES) {
                                if {[set vf [get_files $i.v $cvd]] != "" } {
                                        lappend files $vf
                                }
                        }
                        foreach f ".sched .info .dot" {
                                if {[set fs [get_files $f $cvd]] != ""} {
                                        lappend files $fs
                                }
                        }
                }
                if {[set csd $PROJECT(COMP_SIMDIR)] != ""} {
                        foreach i $PROJECT(GEN_FILES) {
                                foreach e "h cxx" {
                                        if {[set sf [get_files $i.$e $csd]] \
                                                        != ""} {
                                                lappend files $sf
                                        }
                                }
                        }
                }
        }
        if {[set df [get_files .dot $PROJECT(COMP_INFO_DIR)]] != ""} {
                lappend files $df
        }
        set PROJECT(GEN_FILES) ""
        return $files
}

##
# @brief Gets last compilation/link results
#
proc get_bsc_clean_all_files {} {
        add_generated_files sched
        add_generated_files ba
        add_generated_files dot
        set files [get_generated_files]
        return $files
}

##
# @brief Deletes last compilation/link results
#
proc bsc_full_clean {} {
        foreach files [get_bsc_clean_all_files] {
                delete_files $files
        }
}

##
# @brief Deletes the simulation executable file
#
proc delete_sim_exe {} {
        global PROJECT
        delete_files [get_files .so $PROJECT(LINK_OUTDIR)]
        set s $PROJECT(LINK_OUTDIR)/$PROJECT(LINK_OUTNAME)
        if {[file exists $s] && $PROJECT(LINK_OUTNAME) != ""} {
                status_command_window::display_message "Deleting $s" false
                catch "exec rm -f $s"
        }
}

##
# @brief Deletes last compilation/link/simulation results
#
proc full_clean {} {
        global PROJECT
        if {$PROJECT(NAME) == ""} {
                error_message "There is no open project"
                return
        }
        switch -exact -- $PROJECT(COMP_TYPE) {
                make {
                        commands::make_full_clean
                }
                bsc {
                        commands::bsc_full_clean
                        commands::delete_sim_exe
                }
        }
        change_menu_toolbar_state
}

##
# @brief Executes the specified command
#
# @param cmd the command to be executed
# @param closeProc the procedure to be executed when the command
# execution has finished
#
proc execute_in_shell { cmd closeProc } {
        global BSPEC
        global env
        if { $cmd == "" } { return }
        set chans [status_command_window::open_writable_pipe_out_err $closeProc RESULT WARNING]
        set outStd [lindex $chans 0]
        set outErr [lindex $chans 1]
        commands::display_command_results "Executing: $cmd"
        if { [catch "exec > $outStd 2> $outErr sh -x -e -c { $cmd } &" err] } {
                puts stderr $err
                set err ""
        } else {
                set BSPEC(BUILDPID) $err
                registerPid $outErr $err
        }
        return $err
}

##
# @brief Returns the child process pids for the specified process
#
# @param p the process identifiers
#
# @return list with child Pids
#
proc getChildPids { p } {
        set result [list]
        while { [llength $p] != 0 } {
                set thisp [lindex $p 0]
                set p [lrange $p 1 end]
                if { $thisp == "" } { continue }
                lappend result $thisp
                if { [catch "exec pgrep -P $thisp" children] } {
                        set children [list]
                }
                foreach child $children {
                    lappend p $child
                }
        }
        return $result
}

##
# @brief Writes the command output into the file
#
# @param s the string to write
# return 1 if output is set, 0 otherwise
#
proc display_command_results {s} {
        global BSPEC
        if {$BSPEC(OUTPUT) == ""} {
                return 0
        }
        set id [open $BSPEC(OUTPUT) a]
        puts $id $s
        close $id
        return 1
}

proc registerPid { filename pd } {
        global BSPEC
        set BSPEC(CPID,$filename) $pd
}
proc unregisterPid { fileName } {
        if { [info exists ::BSPEC(CPID,$fileName)] } {
                set pid $::BSPEC(CPID,$fileName)
                unset ::BSPEC(CPID,$fileName)
        }
}
}


## Local Variables:
## eval: (set (make-local-variable 'tcl-indent-level) 8)
## End:
