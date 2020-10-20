
##
# @file file_commands.tcl
#
# @brief Definition of file manipulation commands.
#

namespace eval commands {

##
# @brief Executes the editor on the specified line of the file.
#
# @param file URL of the file
# @param line the line number, defaults to the 0
#
proc execute_editor {position} {
    Editor::start 1
    set cmd "Editor::jumpToPosition [list $position]"
    after 250 $cmd
}

##
# @brief Creates new file
#
# @param file path of the file
#
proc new_file {file} {
    Editor::start 1
    
    Editor::openNewFile $file
}

##
# @brief Opens the specified file. The file should be a project file.
#
# @param file file path 
# @param line line number
#
proc open_file {file {line 0} {column 0}} {
        global BSPEC
        set f [lindex [lindex $BSPEC(FILES)\
                [lsearch -regexp $BSPEC(FILES) $file]] 0]
        if {$f != ""} {
	    commands::execute_editor [FileSupport::createPosition $f $line $column]
        }
}

##
# @brief Opens the specified file at the specified line. The file exist.
#
# @param file file path 
# @param line line number
#
proc edit_file {position} {
    commands::execute_editor $position
}

##
#
#
proc gvim_editor_send {cmd} {
        set c [list exec gvim --servername editor --remote-send $cmd]
        if {[catch $c err]} {
                puts stderr $err
        }
}

##
# @brief Checks the existance of gvim server calles EDITOR.
#
proc gvim_check_existance_of_editor_server {} {
        if {[catch "exec gvim --serverlist" err]} {
#               puts stderr $err
                return false
        }
        if {[lsearch [exec gvim --serverlist] EDITOR] == -1} {
                return false
        }
        return true
}

##
# @brief Saves the currently opened file
#
proc save_file {} {
    global PROJECT
    if { $PROJECT(EDITOR_NAME) == "gvim" && \
             [gvim_check_existance_of_editor_server]} {
        gvim_editor_send  "\033:w<CR>"
    } 
}

##
# @brief Saves the currently opened file in the specified location
#
# @param file file location
#
proc save_file_as {file} {
    global PROJECT
    if { $PROJECT(EDITOR_NAME) == "gvim" && \
             [gvim_check_existance_of_editor_server]} {
        gvim_editor_send "\033:sav $file<CR>"
    }
}

##
# @brief Closes the currently opened file
#
proc close_file {} {
    global PROJECT
    if { $PROJECT(EDITOR_NAME) == "gvim" && \
             [gvim_check_existance_of_editor_server]} {
        gvim_editor_send \033:q<CR>
    }
}

##
# @brief Closes all opened files without saving
#
proc close_all_files {} {
        global PROJECT
        if {[gvim_check_existance_of_editor_server]} {
                # do not do an unconditional quit here
                gvim_editor_send \033:qall<CR>
        }
}


proc get_dot_file_name {name} {
        global PROJECT
        global BSPEC
        set MOD  ""
        if {$BSPEC(MODULE) == ""} {
                set MOD $PROJECT(TOP_MODULE)
        } else {
                set MOD $BSPEC(MODULE)
        }
        set file "$PROJECT(COMP_INFO_DIR)/$MOD\_$name.dot"
        return $file
}

}
