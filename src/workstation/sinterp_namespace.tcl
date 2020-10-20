# commands and namespace for the Workstation's secondary interp
##
# @file sinterp_namespace.tcl
#
# @brief Setup the namespace for the secondary interpreter
#

if { [info exists bscws_interp] } {
    rename unknown _original_unknown
    set auto_noexec 1
    # unknown proc executes in shell
    proc unknown { args } {
        if {[catch {
            uplevel 1 [list _original_unknown {*}$args]
        } err ]} {
            ## Only try shell commands if this is the top (user) level
            if { [info level] == 1 } {
                set isBG  [regexp {&} $args]
                set cmd [lindex $args 0]

                set new [auto_execok $cmd]
                if { $new eq "" } {
                    error "invalid command name: $args"
                }

                if { ! $isBG } {
                    bscws_eval commands::action_start $cmd
                }
                set newargs [lreplace $args 0 0 $new]

                set fc "\{commands::action_finished $cmd\}"
                set pid [bscws_eval "commands::execute_in_shell [list $newargs] $fc"]

                # for background shell jobs indicate that secondary interp can take more commands
                if { $isBG } {
                    bscws_eval set ::BSPEC(BUILDPID) {""}
                }
            }
        }
    }


namespace eval WS {

    namespace export *

    namespace eval Project {
        namespace export *
        proc new_project { args } { bscws_eval "handlers::new_project $args" }
        proc open_project { args } { bscws_eval "handlers::open_project  $args" }
        proc set_search_paths { args } { bscws_eval "handlers::set_search_paths $args" }
        proc save_project { args } { bscws_eval "handlers::save_project $args" }
        proc save_project_as { args } { bscws_eval "handlers::save_project_as $args" }
        proc close_project { args } { bscws_eval "handlers::close_project $args" }
        proc set_project_editor { args } { bscws_eval "handlers::set_project_editor $args" }
        proc get_project_editor {} { bscws_eval "handlers::return_project_editor" }
        proc set_compilation_results_location { args } { bscws_eval "handlers::set_compilation_results_location $args" }
        proc get_compilation_results_location {} { bscws_eval "handlers::return_bdir" }
        proc set_compilation_type { args } { bscws_eval "handlers::set_compilation_type  $args" }
        proc get_compilation_type { args } { bscws_eval "handlers::return_compilation_type  $args" }
        proc set_bsc_options { args } { bscws_eval "handlers::set_bsc_options $args" }
        proc get_bsc_options { args } { bscws_eval "handlers::return_bsc_options $args" }
        proc set_make_options { args } { bscws_eval "handlers::set_make_options $args" }
        proc get_make_options { args } { bscws_eval "handlers::get_make_options $args" }
        proc set_link_type { args } { bscws_eval "handlers::set_link_type $args" }
        proc get_link_type { args } { bscws_eval "handlers::return_link_type $args" }
        proc set_link_bsc_options { args } { bscws_eval "handlers::set_link_bsc_options $args" }
        proc get_link_bsc_options {} { bscws_eval "handlers::return_link_name" }
        proc set_link_make_options { args } { bscws_eval "handlers::set_link_make_options $args" }
        proc get_link_make_options { args } { bscws_eval "handlers::get_link_make_options $args" }
        proc set_link_custom_command { args } { bscws_eval "handlers::set_link_custom_command $args" }
        proc get_link_custom_command { args } { bscws_eval "handlers::get_link_custom_command $args" }
        proc set_sim_custom_command { args } { bscws_eval "handlers::set_sim_custom_command $args" }
        proc get_sim_custom_command { args } { bscws_eval "handlers::get_sim_custom_command $args" }
        proc set_top_file { args } { bscws_eval "handlers::set_top_file $args" }
        proc get_top_file { args } { bscws_eval "handlers::return_top_file $args" }
        proc get_top_module { args } { bscws_eval "handlers::return_top_module $args" }
        proc set_verilog_simulator { args } { bscws_eval "handlers::set_verilog_simulator $args" }
        proc get_verilog_simulator { args } { bscws_eval "handlers::return_verilog_simulator $args" }
        proc set_bluesim_options { args } { bscws_eval "handlers::set_bluesim_options $args" }
        proc get_bluesim_options { args } { bscws_eval "handlers::return_bluesim_options $args" }
        #proc set_sim_results_location { args } { bscws_eval "handlers::set_sim_results_location  $args" }
        #proc get_sim_results_location {} { bscws_eval "handlers::get_sim_results_location" }
        proc refresh { args } { bscws_eval "handlers::refresh $args" }
        proc backup_project { args } { bscws_eval "handlers::backup_project $args" }
    }

    namespace eval File {
        namespace export *
        proc new_file { args } { bscws_eval "handlers::new_file $args" }
        proc open_file { args } { bscws_eval "handlers::open_file $args" }
        # proc save_file { args } { bscws_eval "commands::save_file $args" }
        # proc save_file_as { args } { bscws_eval "commands::save_file_as $args" }
        # proc save_all { args } { bscws_eval "commands::save_all $args" }
    }

    namespace eval Build {
        namespace export *
        proc typecheck { args } { bscws_eval "handlers::typecheck $args; return {}" }
        proc compile { args } { bscws_eval "handlers::compile   $args; return {}" }
        proc link { args } { bscws_eval "handlers::link   $args; return {} " }
        proc simulate { args } { bscws_eval "handlers::simulate $args; return {}" }
        proc clean { args } { bscws_eval "handlers::clean $args" }
        proc full_clean { args } { bscws_eval "handlers::full_clean $args" }
        proc compile_file { args } { bscws_eval "handlers::compile_file $args; return {}" }

        proc compile_and_link { args } {bscws_eval "handlers::comp_and_link $args; return {}" }
        proc compile_link_and_simulate { args } {bscws_eval "handlers::comp_link_and_sim $args; return {}" }
    }

    namespace eval Window {
        namespace export *
        proc show { args } { bscws_eval "handlers::show $args" }
        proc show_graph { args } { bscws_eval "handlers::show_graph $args" }
        proc minimize_all { args } { bscws_eval "commands::minimize_all $args" }
        proc close_all { args } { bscws_eval "commands::close_all $args" }
        proc set_result_font { args } { bscws_eval "status_command_window::set_result_font $args;" }
    }

    namespace eval Analysis {
        namespace export *
        proc load_package { args } { bscws_eval "handlers::load_package $args" }
        proc reload_packages { args } { bscws_eval "handlers::reload_packages $args" }
        proc package_refresh { args } { bscws_eval "handlers::package_refresh $args" }
        proc import_hierarchy { args } { bscws_eval "handlers::import_hierarchy $args" }
        proc search_in_packages { args } { bscws_eval "handlers::search_in_packages $args" }
        proc package_collapse_all { args } { bscws_eval "handlers::package_collapse_all  $args" }
        proc add_type { args } { bscws_eval "handlers::add_type $args" }
        proc remove_type { args } { bscws_eval "handlers::remove_type $args" }
        proc type_collapse_all { args } { bscws_eval "handlers::type_collapse_all  $args" }
        proc load_module { args } { bscws_eval "handlers::load_module $args" }
        proc reload_module { args } { bscws_eval "handlers::reload_module $args" }
        proc set_module { args } { bscws_eval "handlers::set_module  $args" }
        proc show_schedule { args } { bscws_eval "handlers::show_schedule $args" }
        proc module_collapse_all { args } { bscws_eval "handlers::module_collapse_all  $args" }
        proc get_schedule_warnings { args } { bscws_eval "handlers::get_schedule_warnings $args" }
        proc get_execution_order { args } { bscws_eval "handlers::get_execution_order $args" }
        proc get_method_call { args } { bscws_eval "handlers::get_method_call $args" }
        proc get_rule_relations { args } { bscws_eval "handlers::get_rule_relations $args" }
        proc get_rule_info { args } { bscws_eval "handlers::get_rule_info $args" }
    }

    namespace eval Wave {
        namespace export *
        proc set_nonbsv_hierarchy { hier } { bscws_eval "commands::set_nonbsv_hierarchy $hier" }
        proc get_nonbsv_hierarchy {      } { bscws_eval "handlers::get_nonbsv_hierarchy" }

        proc set_waveform_viewer  { viewer } { bscws_eval "handlers::set_waveform_viewer $viewer" }
        proc get_waveform_viewer  {      } { bscws_eval  "Waves::get_waveviewer" }

        proc wave_viewer           { args } { bscws_eval "handlers::wave_viewer $args" }
        proc clone_viewer          { }      {
            package require Waves 2.0
            set clone [bscws_eval {
                if { ![winfo exists $::BSPEC(MODULE_BROWSER)] } {
                    error "Wave viewer commands are not available,  module browser window is required"
                }
                set v [$::BSPEC(MODULE_BROWSER) get_viewer]
                set vs [$v class]
                set skip_list [list -start -ScriptFile]
                foreach cfg [$v configure] {
                    lassign $cfg a x val
                    if { [lsearch -exact $skip_list $a] != -1 } { continue }
                    if { $val eq "" } { continue }
                    append vs " $a $val"
                }
                set vs
            }]
            set cviewer [eval Waves::create_viewer  $clone]
            return $cviewer
        }

        proc start_waveform_viewer  { args } { bscws_eval "handlers::wave_viewer start $args"  }
        proc attach_waveform_viewer { args } { bscws_eval "handlers::wave_viewer attach $args" }
        proc load_dump_file         { args } { bscws_eval "handlers::wave_viewer load_dump_file $args" }
        proc reload_dump_file       { args } { bscws_eval "handlers::wave_viewer reload_dump_file $args" }

    }

    proc help { args } { bscws_eval "handlers::help $args" }
    proc change_font_size { args } { bscws_eval fonts::bump_fonts $args }

}

package provide WS 1.0

namespace eval SInterpUtils {
    # command to work with help system.  returns list of all commands under the given namespaces
    proc getNamespaceCommands { ns } {
        set qualns [list]
        foreach n $ns {
            eval lappend qualns [namespace children :: $n]
        }
        set allns [list]
        while {[llength $qualns] != 0 } {
            set this [lindex $qualns 0]
            set qualns [lrange $qualns 1 end]
            lappend allns $this
            eval lappend allns [namespace children $this]
        }
        set ret [list]
        foreach n $allns {
            eval lappend ret [info commands ${n}::*]
        }
        return $ret
    }


}

}
