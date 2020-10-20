#
# @file workstation.tcl
#
# @brief This is the main script of BSC Workstation.
#
# BSC workstation is launching point for simulators, compilers, editors
# and set of tools for analysing the output of the compilers and simulators.
#

package require BDWIwidgets 4.0
package require Itcl
package require Waves 2.0

############  Definition of project global variables  ############

##
# @brief A list of environment variables
#
global env

##
# @brief An array which contains compilation configuration values
#
global COMP

##
# @brief An array which contains link configuration values
#
global LINK

##
# @brief An array of workstation variables 
#
global BSPEC

##
# @brief An array which contains project configuration values
#
global PROJECT

##
# @brief A list which contains project configuration options
#
global CONFIG

##
# @brief A list which contains command line commands with definitions
#
global HELP

##
# @brief A list of tool-bars added by the user
#
global USER_TOOLBUTTON

set USER_TOOLBUTTON {}

lappend auto_path $env(PWD)

# Definition of BSC Workstation variables

##
# @brief A list which contains the executed command line commands
#
set BSPEC(HISTORY) ""

##
# @brief The maximum size of the BSPEC(HISTORY) list
#

set BSPEC(MAX_SIZE) 100

##
# @brief The current number of command line command from the BSPEC(HISTORY) list
#
set BSPEC(CURRENT) -1

##
# @brief The location of image files
#
set BSPEC(IMAGEDIR) $env(BDWDIR)/tcllib/workstation/images

##
# @brief The list of .bsv files
#
set BSPEC(FILES) ""

##
# @brief The name of Project Window 
#
set BSPEC(PROJECT) .pw

##
# @brief The name of the hierarchy widget in the Project Window 
#
set BSPEC(PROJECT_HIERARCHY) ""

##
# @brief The name of Package Browser Window 
#
set BSPEC(PACKAGE) .pk

##
# @brief The name of the hierarchy widget in the Package Browser Window 
#
set BSPEC(PACKAGE_HIERARCHY) ""

##
# @brief The name of the Import Hierarchy dialog
#
set BSPEC(IMPORT_HIERARCHY) ""

##
# @brief The list of file extensions to be shown in the Project Files window
#
set BSPEC(INCLUDED_FILES) "*.bsv"

##
# @brief The list of file extensions not to be shown in the Project Files window
#
set BSPEC(EXCLUDED_FILES) ""

##
# @brief The name of Schedule Analysis Window 
#
set BSPEC(SCHEDULE) .sch

##
# @brief The name of Type Browser Window 
#
set BSPEC(TYPE_BROWSER) .tp

##
# @brief The name of the hierarchy widget in the Type Browser Window 
#
set BSPEC(TYPE_HIERARCHY) ""

##
# @brief The title for Workstation windows
#
set BSPEC(TITLE) ""

##
# @brief The name of Import BVI Wizard Window 
#
set BSPEC(IMPORT_BVI) .bvi

##
# @brief The list of loaded types 
#
set BSPEC(TYPES) ""

##
# @brief The text (number of loaded modules) to be displayed in the status bar
# of Module Browser winsow 
#
set BSPEC(LOADED_MODULES) "0 modules"

##
# @brief The text (number of loaded packages) to be displayed in the status bar of Package winsow 
#
set BSPEC(LOADED_PACKAGES) "0 packages"

##
# @brief The name of Main Window 
#
set BSPEC(MAIN_WINDOW) .

##
# @brief The list of loaded modules 
#
set BSPEC(MODULE) ""

##
# @brief The name of Module Browser Window 
#
set BSPEC(MODULE_BROWSER) .md

##
# @brief The name of the hierarchy widget in the Module Browser Window 
#
set BSPEC(MODULE_HIERARCHY) ""

##
# @brief The process id of the browser
#
set BSPEC(HELP) ""

##
# @brief The name for BDW output
#
set BSPEC(OUTPUT) ""

##
# @brief A variable which is empty when there is no build process running
#
set BSPEC(BUILDPID) ""

##
# @brief A unique number for a new graph 
#
set BSPEC(NEW_GRAPH_ID) 0

##
# @brief A list with names of graph windows
#
set BSPEC(GRAPHS) ""

##
# @brief A list of supported graph types 
#
set BSPEC(GRAPH_TYPES) [list conflict exec urgency combined combined_full]

##
# @brief A list of supported default editors 
#
set BSPEC(EDITORS) [list gvim emacs other]

##
# @brief A list of build output directories 
#
set BSPEC(DIRS) [list COMP_BDIR COMP_VDIR COMP_SIMDIR LINK_OUTDIR COMP_INFO_DIR]

set BSPEC(PATHS) [list MAKE_FILE LINK_MAKEFILE TOP_FILE]

##
# @brief A list of build output directories 
#
set BSPEC(LIBRARIES) [regsub -all $env(BLUESPECDIR) \
        [list $env(BLUESPECDIR)/Libraries] "%"]
#set BSPEC(DEBUG) ""
# List of command line options
set BSPEC(OPTIONS) "-about\
                    -bdir\
                    -bluesim\
                    -bsc\
                    -clean\
                    -clean_target\
                    -column\
                    -combined\
                    -combined_full\
                    -command\
                    -conflict\
                    -content\
                    -editor\
                    -exec\
                    -fullclean\
                    -info-dir\
                    -input_files\
                    -line\
                    -list\
                    -location\
                    -module\
                    -module_browser\
                    -next\
                    -options\
                    -options\
                    -package\
                    -path\
                    -paths\
                    -previous\
                    -project\
                    -project_dir\
                    -rts-options\
                    -schedule_analysis\
                    -search_path\
                    -search_path_files\
                    -sim_target\
                    -simdir\
                    -target\
                    -type_browser\
                    -urgency\
                    -vdir\
                    -verilog\
                    -withdeps"

# List of project configurations
set CONFIG "COMP_BDIR\
            COMP_BSC_OPTIONS\
            COMP_BSC_TYPE\
            COMP_INFO_DIR\
            COMP_RTS_OPTIONS\
            COMP_SIMDIR\
            COMP_TYPE\
            COPY_FLAGS\
            COMP_VDIR\
            CURRENT_DIR\
            DIR\
            EDITOR_NAME\
            EXCLUDED_FILES\
            INCLUDED_FILES\
            GEN_FILES\
            LINK_BSC_OPTIONS\
            LINK_COMMAND\
            LINK_MAKEFILE\
            LINK_MAKE_OPTIONS\
            LINK_OUTDIR\
            LINK_OUTNAME\
            LINK_SIM_TARGET\
            LINK_CLEAN_TARGET\
            LINK_FULL_CLEAN_TARGET\
            LINK_TARGET\
            LINK_TYPE\
            MAIN_PLACEMENT\
            MAKE_CLEAN\
            MAKE_FILE\
            MAKE_FULLCLEAN\
            MAKE_OPTIONS\
            MAKE_TARGET\
            MODULE_PLACEMENT\
            NAME\
            PATHS\
            PACKAGE_PLACEMENT\
            PROJECT_PLACEMENT\
            RUN_OPTIONS\
            SCHEDULE_PLACEMENT\
            SIM_CUSTOM_COMMAND\
            SIM_EXE\
            SIM_NAME\
            SIM_OPTIONS\
            SOURCE\
            STATUS\
            TOP_FILE\
            TOP_MODULE\
            TYPE_PLACEMENT\
            VIEWER_CLOSE\
            WIZARD_PLACEMENT"

foreach e $BSPEC(EDITORS) {
        append CONFIG " EDITOR_[string toupper $e]"
}


proc get_system_simulators {} {
        global PROJECT
        global env
        if { ! [info exists PROJECT(SIMULATOR)] } {
                set sims [glob -nocomplain $env(BLUESPECDIR)/exec/bsc_build_*]
                array set Valid [list]
                foreach s $sims {
                        set scr [file tail $s]
                        if { [catch "exec $s detect" res] } {
                                #puts stderr "$scr fails"
                        } else {
                                set called [lindex $res 0]
                                set Valid($called) 1
                        }
                }
                set final [lsort [array names Valid]]
                if { [llength $final] == 0 } {
                        set final [list "None Found"] 
                }
                set PROJECT(SIMULATOR) $final
        }
        return $PROJECT(SIMULATOR)
}

##
# @brief Sets default options for the current project
#
proc set_default_options {} {
        global COMP
        global LINK
        global PROJECT
        global CONFIG
        global BSPEC
        global env

        # populated all with null
        foreach i $CONFIG {
                set PROJECT($i) ""
        }

        # Editor setup  pull in environment EDITOR
        set PROJECT(EDITOR_NAME) gvim
        set PROJECT(EDITOR_EMACS) emacs
        set PROJECT(EDITOR_GVIM) gvim
        set PROJECT(EDITOR_OTHER) "gedit +%n %f"

        if { [info exists env(EDITOR)] } {
                switch -regexp $env(EDITOR) {
                        emacs {
                                set PROJECT(EDITOR_NAME) emacs
                                set PROJECT(EDITOR_EMACS) $env(EDITOR)
                        }
                        gvim  {
                                set PROJECT(EDITOR_NAME) gvim
                                set PROJECT(EDITOR_GVIM) $env(EDITOR)
                        }
                        default {
                                set PROJECT(EDITOR_NAME) other
                                set PROJECT(EDITOR_OTHER) "$env(EDITOR) %f"
                        }
                }
        }


        set BSPEC(LOADED_MODULES) "0 modules"
        set BSPEC(LOADED_PACKAGES) "0 packages"
        set BSPEC(CURRENT_DIR) $env(PWD)
        set PROJECT(STATUS) saved

        set PROJECT(COMP_TYPE) $COMP(TYPE)
        set PROJECT(COMP_BSC_TYPE) $COMP(BSC_TYPE)
        set PROJECT(COMP_INFO_DIR) $COMP(INFO_DIR)
        set PROJECT(COMP_RTS_OPTIONS) $COMP(RTS_OPTIONS)
        set PROJECT(COMP_BSC_OPTIONS) $COMP(BSC_OPTIONS)
        set PROJECT(LINK_TYPE) $LINK(TYPE)
        set PROJECT(LINK_BSC_OPTIONS) $LINK(BSC_OPTIONS)
        set PROJECT(SIM_NAME) "cvc"
        set PROJECT(INCLUDED_FILES) $BSPEC(INCLUDED_FILES)
        set PROJECT(EXCLUDED_FILES) $BSPEC(EXCLUDED_FILES)
        set PROJECT(VIEWER_CLOSE) close
        set PROJECT(MAIN_PLACEMENT) "700x350+0+0"
        set PROJECT(PROJECT_PLACEMENT) "250x460+0+385"
        set PROJECT(PACKAGE_PLACEMENT) "770x420+475+150"
        set PROJECT(SCHEDULE_PLACEMENT) "650x650+500+225"
        set PROJECT(TYPE_PLACEMENT) "770x420+475+540"
        set PROJECT(MODULE_PLACEMENT) "550x350+50+500"
        set PROJECT(WIZARD_PLACEMENT) "1024x700+50+50"
        set PROJECT(COPY_FLAGS) 0

}

##
# @brief Sources necessary *.tcl files which are not automatically sourced
#
proc source_files {} {
        uplevel #0 {
        global env
        source $env(BDWDIR)/tcllib/workstation/help.tcl
        source $env(BDWDIR)/tcllib/workstation/main_window.tcl
        source $env(BDWDIR)/tcllib/workstation/dialog.tcl
        source $env(BDWDIR)/tcllib/workstation/selection_dialog.tcl
        source $env(BDWDIR)/tcllib/workstation/project_top_file_dialog.tcl
        source $env(BDWDIR)/tcllib/workstation/paned_window.tcl
        source $env(BDWDIR)/tcllib/workstation/tabnotebook.tcl
        source $env(BDWDIR)/tcllib/workstation/fonts.tcl
        source $env(BDWDIR)/tcllib/workstation/select_file_dialog.tcl
        source $env(BDWDIR)/tcllib/workstation/hierarchy.tcl
        source $env(BDWDIR)/tcllib/workstation/menubar.tcl
        source $env(BDWDIR)/tcllib/workstation/toolbar.tcl
        source $env(BDWDIR)/tcllib/workstation/status_command_window.tcl
        source $env(BDWDIR)/tcllib/workstation/project_window.tcl
        source $env(BDWDIR)/tcllib/workstation/package_window.tcl
        source $env(BDWDIR)/tcllib/workstation/type_browser_window.tcl
        source $env(BDWDIR)/tcllib/workstation/module_browser_window.tcl
        source $env(BDWDIR)/tcllib/workstation/schedule_analysis.tcl
        source $env(BDWDIR)/tcllib/workstation/messagebox.tcl
        source $env(BDWDIR)/tcllib/workstation/file_commands.tcl
        source $env(BDWDIR)/tcllib/workstation/finddialog.tcl
        source $env(BDWDIR)/tcllib/workstation/project_back_up_dialog.tcl
        source $env(BDWDIR)/tcllib/workstation/show_text_dialog.tcl
        source $env(BDWDIR)/tcllib/workstation/graph_export_dialog.tcl
        source $env(BDWDIR)/tcllib/workstation/import_bvi_wizard_graphic.tcl
        source $env(BDWDIR)/tcllib/workstation/import_bvi_wizard_analysis.tcl
        # source files from tk directory to override tk libraries
        source $env(BDWDIR)/tcllib/tk/msgbox.tcl
        source $env(BDWDIR)/tcllib/tk/tkfbox.tcl
        }
}


##
# @brief Sources the user's setup file . If the latter doesn't exist then it
# will be created with default options and then only sourced.
# This has been disabled as the interface is not stable.
#
proc source_setup_file {} {
        global env
        global COMP

        set COMP(TYPE) bsc
        set COMP(BSC_TYPE) bluesim
        set COMP(INFO_DIR) .
        set COMP(RTS_OPTIONS) {}
        set COMP(BSC_OPTIONS) {-keep-fires}

        global LINK
        set LINK(BSC_OPTIONS) {-keep-fires}
        set LINK(TYPE) bsc

        global BSPEC
        set BSPEC(INCLUDED_FILES) {*.bsv}
        set BSPEC(EXCLUDED_FILES) {}

}

##
# @brief Processes the arguments
#
proc process_arguments {argv} {
        global BSPEC
        if {[lindex $argv 0] != "" } {
                if {[file extension [lindex $argv 0]] == ".bspec"} {
                        commands::open_project [lindex $argv 0]
                } elseif {[file extension [lindex $argv 0]] == ".tcl"} {
                        source [lindex $argv 0]
                } else {
                        set BSPEC(OUTPUT) [lindex $argv 0]
                }
        }
        if {[lindex $argv 1] != "" } {
                if {[file extension [lindex $argv 1]] == ".bspec"} {
                        commands::open_project [lindex $argv 1]
                } else {
                        source [lindex $argv 1]
                }
        }
        if {[lindex $argv 2] != "" } {
                source [lindex $argv 2]
        }
}

##
# @brief Initialize tool bar variables
#
# $param name the name for tool bar
# $param command the command to be executed
# $param icon the image file
# $param helpstr the help message
#
proc register_tool_bar_item {{name ""} {command ""} {icon "warning.gif"} \
                                                                {helpstr "NOHELP"}} {
        global USER_TOOLBUTTON
        global BSPEC
        if {$name == ""} {
                error "The name and command for the tool button should be\
                        specified"
        } elseif {$command == ""} {
                error "The command for the tool button should be specified"
        } elseif {$icon == ""} {
                error "The icon for the tool button should not be an empty\
                        string"
        }
        set t [list new open save tccompile compile link simulate clean \
                build stop compilelink compilelinksim]
        foreach i $USER_TOOLBUTTON {
                if {[lsearch $name $t] != -1 || $name == [lindex $i 0]} {
                        error "Tool button with \"$name\" name alredy exists."
                }
        }
        if {![file exists $icon]} {
                if {![file exists [file join $BSPEC(IMAGEDIR) $icon]]} {
                        error "The $icon file does not exists"
                } else {
                        set icon [file join $BSPEC(IMAGEDIR) $icon]
                }
        }
        lappend USER_TOOLBUTTON [list $name $command $icon $helpstr]
}

proc check_tcldot {} {
        global TCLDOT_EXIST
        global auto_path
        global tcl_platform
        set width ""
        if { [info exists tcl_platform(wordSize)] } {
		if { $tcl_platform(wordSize) == 8 } {
			set width 64
		}
		if { $tcl_platform(wordSize) == 4 } {
			set width 32
		}
        }
        lappend auto_path /usr/lib/tcltk/graphviz/tcl
        lappend auto_path /usr/lib/tcltk/graphviz
        lappend auto_path /usr/lib/graphviz/tcl
        lappend auto_path /usr/lib/graphviz
        lappend auto_path /usr/lib/tcl8.5
        lappend auto_path /opt/local/lib/graphviz/tcl
        lappend auto_path /usr/lib$width/tcltk/graphviz/tcl
        lappend auto_path /usr/lib$width/tcltk/graphviz
        lappend auto_path /usr/lib$width/graphviz/tcl
        lappend auto_path /usr/lib$width/graphviz
        lappend auto_path /usr/lib$width/tcl8.5
        lappend auto_path /opt/local/lib$width/graphviz/tcl

        if {[catch "package require Tcldot 2.21" err]} {
                set TCLDOT_EXIST 0
                puts "Tcldot packages are not available on this machine"
                puts "Information: $err"
        } else {
                set TCLDOT_EXIST 1
        }
}


##
# @brief Initialization
#
proc initialization {argv} {
        global BSPEC
        global PROJECT
        global tcl_rcFileName
        global bscws
        # source BDW file
        source_files
        source_setup_file
        # setup default options
        set_default_options

        set bscws 1

        check_tcldot
        fonts::set_colours
        fonts::initialize

        ## We will resource tcl_rcFileName (~/.bluetclrc) again, to allow customizations to WS
        set customization_files [list \
                                     $tcl_rcFileName \
                                     "$::env(HOME)/bdw_init.tcl"  \
                                     "./bdw_init.tcl" \
                                    ]
        foreach f [utils::nub $customization_files] {
                source_user_customization_script $f
        }


        main_window $BSPEC(MAIN_WINDOW).mw
        wm title $BSPEC(MAIN_WINDOW) "BSC Workstation"
        wm minsize $BSPEC(MAIN_WINDOW) 700 350
        wm protocol $BSPEC(MAIN_WINDOW) WM_DELETE_WINDOW \
                commands::exit_main_window
        process_arguments $argv
        wm geometry $BSPEC(MAIN_WINDOW) $PROJECT(MAIN_PLACEMENT)
        wm iconphoto . -default [image create photo -file $BSPEC(IMAGEDIR)/bDW.gif]
}

proc source_user_customization_script { filename } {
        if {[file readable "$filename"]} {
                if { [catch "uplevel #0 source \"$filename\"" err] } {
                        global errorInfo
                        puts stderr "Error in startup script file: $filename"
                        puts stderr $errorInfo
                        exit 1
                }
        }

}
\
##
# @brief Debug function for printing given string
#
# @param m string to print
#
proc debug {m} {
        global BSPEC
        if [info exists BSPEC(DEBUG)] {
                puts $m
        }
}

proc debug_trace {m} {
        global BSPEC
        if [info exists BSPEC(OUTPUT)] {
                set of [open $BSPEC(OUTPUT) a+]
                puts $of $m
                set l [info level]
                for {set i 1} { $i < $l } {incr i} {
                        puts $of "$m: [info level $i]"
                }
                close $of
        }
}

initialization $argv

## Local Variables:
## eval: (set (make-local-variable 'tcl-indent-level) 8)
## End:
