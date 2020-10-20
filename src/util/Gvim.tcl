
namespace eval ::Gvim {

    package require Unique

    namespace export \
	isRunning \
	jumpToPosition \
        openNewFile \
	quit \
	start

################################################################################
###
################################################################################
    variable gvimExec gvim


################################################################################
### Exported procedures
################################################################################

proc start {} {
    global env
    global PROJECT

    set gvimExec [lindex $PROJECT(EDITOR_GVIM) 0]
    set gvimArgs [utils::tail $PROJECT(EDITOR_GVIM)]

    set env(SEARCH_PATHS) {}
    foreach i $PROJECT(PATHS) {
        lappend env(SEARCH_PATHS) [commands::make_absolute_path \
                [regsub "%" $i "$env(BLUESPECDIR)"]]
    }

    eval exec $gvimExec -S $env(BDWDIR)/tcllib/gvim/gvim_config.vim --servername editor $gvimArgs &
    set count 0

    while {![isRunning] && ($count < 100)} {
	after 50
	set count [expr $count + 1]
    }
}

proc quit {} {
    gvimSend "\033:conf q<CR>"
}

proc isRunning {} {

    variable gvimExec 

    if {[catch "exec gvim --serverlist" err]} {
                puts stderr $err
                return false
        }
    if {[lsearch $err EDITOR] == -1} {
	return false
    }
    return true

}

proc jumpToPosition {position} {

    variable gvimExec 

    exec $gvimExec --servername editor --remote +[lindex $position 1] +Hlfile [lindex $position 0]

}

proc openNewFile {name} {

    variable gvimExec 

    exec $gvimExec --servername editor --remote +"\033:Hlfile<CR>" $name 

}

################################################################################
### Private procedures
################################################################################

proc gvimSend {cmd} {

    variable gvimExec 

    set c [list exec $gvimExec --servername editor --remote-send $cmd]
    if {[catch $c err]} {
	puts stderr $err
    }
}

################################################################################
###
################################################################################

}

package provide Gvim 1.0
