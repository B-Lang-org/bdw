
##
# @file help.tcl
#
# @brief Definition of help for command line commands.
#

global HELP

set HELP(new_project) "new_project <project_name> \
                \[-location <project_path>\] \n\[-paths <search path location>\
                {:<search path location>}*\] \n Creates new project in the \
                given location with specified search paths."
set HELP(open_project) "open_project <project_file> \n\
                Opens the specified project."
set HELP(backup_project) "backup_project <archive_file_name> \
                <-input_files -project_dir -search_path> \n\[-options <option>\
                -search_path_files <file_ext>\] \n Archives the project."
set HELP(set_search_paths) "set_search_paths <location>\[:<location>\]* \n\
                Adds search paths to the current project."
set HELP(save_project) "save_project \n\
                Saves all information related to the current project."
set HELP(save_project_as) "save_project_as <project_name> \[-path <location>\] \
                \n Saves current project in another location."
set HELP(close_all) "close_all \nCloses all currently opened windows."
set HELP(exit) "exit \n Closes BSC Workstation."
set HELP(close_project) "close_project \n Closes the current project without \
                saving changes done after last open/save."
set HELP(set_project_editor) "set_project_editor  <editor_name> \n\
                \[-command <command>\]\n\
                Specifies editor for the current project."
set HELP(get_project_editor) "get_project_editor \n\
                Returns editor specific information for the current project."
set HELP(set_compilation_results_location) \
                "set_compilation_results_location \[-vdir <location>\] \n\
                \[-bdir <location>\] \[-simdir <location>\] \n\
                Specifies paths where the compilation results \
                should be located for the current project."
set HELP(get_compilation_results_location) \
                "get_compilation_results_location \n\
                Returns paths where compilation results are located."
set HELP(set_compilation_type) "set_compilation_type <compilation_type>\n\
                Specifies the type of compilation for the current project.\n\
                Should be either 'bsc' or 'make'."
set HELP(get_compilation_type) "get_compilation_type \n\
                Returns compilation type for current project."
set HELP(set_bsc_options) \
                "set_bsc_options -bluesim/-verilog \[-options <options>\] \n\
                Specifies bsc options for the current project."
set HELP(get_bsc_options) "get_bsc_options \n\
                Returns bsc options for the current project."
set HELP(set_bluesim_options) "set_bluesim_options \n\
                Specifies bluesim options for the current project."
set HELP(get_bluesim_options) "get_bluesim_options \n\
                Returns bluesim options for the current project."
set HELP(set_make_options) "set_make_options  <Makefile> \[-target <target>\] \n\
                \[-clean <target>\] \[-fullclean <target>\]\
                \[-options <option>\]\n\
                Specifies makefile and make options for the current project."
set HELP(get_make_options) "get_make_options \n\
                Returns make options for the current project."
set HELP(set_link_type) "set_link_type <type> \n\
                Specifies link type for the current project. \n\
                Should be either 'bsc', 'make', or 'custom_command'"
set HELP(get_link_type) "get_link_type \n\
                Returns link type for the current project."
set HELP(set_link_bsc_options) "set_link_bsc_options <filename> \
                \[-bluesim or -verilog\] \n\
                \[-path <directory>\] \[-options <option>\] \n\
                Specifies link bsc options for the current project."
set HELP(get_link_bsc_options) "get_link_bsc_options \n\
                Returns link bsc options for the current project."
set HELP(set_link_make_options) "set_link_make_options <Makefile> \n\
                \[-target <target>\] \[-clean <target>\] \[-fullclean <target>\]\
                \[-options <option>\] \n\
                Specifies link make options for the current project."
set HELP(get_link_make_options) "get_link_make_options \n\
                Returns link make options for the current project."
set HELP(set_link_custom_command) "set_link_custom_command <command> \n\
                Specifies link custom command for the current project."
set HELP(get_link_custom_command) "get_link_custom_command <command> \n\
                Returns link custom command for the current project."
set HELP(set_sim_custom_command) "set_sim_custom_command <command> \n\
                Specifies simulation custom command for the current project."
set HELP(get_sim_custom_command) "get_sim_custom_command <command> \n\
                Returns simulation custom command for the current project."
set HELP(set_top_file) "set_top_file <file> \[-module <module_name>\]\
                \n Specifies top file and top module for the current project."
set HELP(get_top_file) "get_top_file \n\
                 Returns top file and top module for the current project."
set HELP(set_verilog_simulator) "set_verilog_simulator <simulator_name> \
                \[-options <options>\] \n\
                Specifies verilog simulator for the current project."
set HELP(get_verilog_simulator) "get_verilog_simulator \n\
                Returns verilog simulator for the current project."
set HELP(set_sim_results_location) "set_sim_results_location <location> \n\
                Specifies path where the simulation results \n\
                should be located for the current project."
set HELP(get_sim_results_location) "get_sim_results_location \n\
                Returns paths where simulation results should be located."
set HELP(set_waveform_viewer) "set_waveform_viewer  <viewer_name> \
                \[-command <command>\] \[-options <options>\] \[-close 0 or 1\]\
                \n Specifies the waveform viewer for the current project."
set HELP(get_waveform_viewer) "get_waveform_viewer \n\
                Returns the waveform viewer for the current project."
set HELP(start_waveform_viewer) "start_waveform_viewer \n\
                Starts the specified waveform viewer."
set HELP(attach_waveform_viewer) "attach_waveform_viewer \n\
                Attaches to the waveform viewer."
set HELP(set_nonbsv_hierarchy) "set_nonbsv_hierarchy  <hier> \n\
                Specifies the hierarchy for the waveform viewer."
set HELP(get_nonbsv_hierarchy) "get_nonbsv_hierarchy <hier>\n\
                Returns the hierarchy for the current waveform viewer."
set HELP(refresh) "refresh \[<file_name>\] \n\
                Refreshes information about current project or particular file."
set HELP(link) "link  \n Links the project"
set HELP(load_dump_file) "load_dump_file <dump_file_path> \n\
	        Loads the dump file."
set HELP(reload_dump_file) "reload_dump_file \n\
	        Reloads the currently loaded dump file."
set HELP(compile_file) "compile_file  <file_name> \[-withdeps -typecheck\] \n\
                Compiles the specified file.\n If \"-withdeps\" option \
                is specified than the file dependencies are considered. \
                If \"-typecheck\" option is specified than the only \
                typechecking phase of complilation is performed."
set HELP(new_file) "new_file <file_name> \[-path <location>\] \n\
                Creates a new file and launches the editor on it."
set HELP(open_file) "open_file <location> \[-line <number>\] \
                \[-column <number>\] \n\
                Launches the editor in the given line and column of the file."
set HELP(compile) "compile \n\
                Compiles the current project with already defined options."
set HELP(typecheck) "typecheck \n\
                Typechecks the current project with already defined options."
set HELP(simulate) "simulate \n Calls simulator for the current project with \
                already defined options."
set HELP(clean) "clean \n\
                Removes compilation/simulation specific result files."
set HELP(full_clean) "full_clean \n\
                Removes all logs and result files created during last\n\
                compilation/simulation. If compilation via makefile has been \n\
                defined then appropriate target will be executed."
set HELP(show) "show -project|-editor|-schedule_analysis|-module_browser|\n\
                -type_browser |-package \n\
                Activates the specified window. If the window is already \n\
                active then focus will be set on it."
set HELP(show_graph) "show_graph -conflict|-exec|-urgency|-combined|\n\
                -combined_full \n\
                Activates the specified graph window. If the window is \n\
                already active then focus will be set on it."
set HELP(version) "version \n\
                Displays the version information for the BSC Workstation."
set HELP(minimize_all) "minimize_all \n\
                Minimizes all currently active windows except the main window."
set HELP(load_package) "load_package <package_name> \n\
                Loads a package with the specified name."
set HELP(reload_packages) "reload_packages \n Reloads all loaded packages."
set HELP(package_refresh) "package_refresh \n Refreshes the package hierarchy."
set HELP(import_hierarchy) "import_hierarchy \[<package_name>\] \n\
                Shows the imports hierarchy for the specified package\n\
                or the top file in a separate window."
set HELP(search_in_packages) "search_in_packages <pattern> \[-next|-previous\]\
                \n Searches for the specified pattern throughout\n\
                the package hierarchy.\n If the -next|-previous \
                options is specified\n then jumps to the \
                appropriate search, if not defaults to -next."
set HELP(package_collapse_all) "package_collapse_all \n\
                Collapse the hierarchical view to show only package list."
set HELP(add_type) "add_type <type> \n\
                Adds the specified type/types to the Type Browser window."
set HELP(remove_type) "remove_type <key> \n\
                Removes information for specified type \n\
                from the Type Browser window."
set HELP(type_collapse_all) "type_collapse_all \n Collapses the type hierarchy."
set HELP(load_module) "load_module <module_name> \n Loads the specified module."
set HELP(reload_module) "reload_module <module_name> \n\
                Reloads the currently loaded module."
set HELP(module_collapse_all) "module_collapse_all \n\
                Collapses the hierarchical view to show only module list."
set HELP(show_schedule) "show_schedule \[<module_name>\] \n\
                Opens the Schedule Analysis window for the specified module."
set HELP(get_schedule_warnings) "get_schedule_warnings \[<module_name>\] \n\
                Displays warnings occurred during scheduling \n\
                for the specified module in the Schedule Analysis window."
set HELP(get_execution_order) "get_execution_order \[<module_name>\] \n\
                Displays rules and methods for the specified \n\
                module in the Schedule Analysis window."
set HELP(get_method_call) "get_method_call \[<module_name>\] \n\
                Displays the Method Call perspective of the Schedule \
                Analysis window for the specified module."
set HELP(get_rule_relations) "get_rule_relations <rule1> <rule2> \n\
             Displays relations for the given pair of rules in\n\
             the Rule relations perspective of the Schedule Analysis window.\n\
             In case of multiple rules <rule> should be given in \"\" quotes"
set HELP(get_rule_info) "get_rule_info <rule_name> \n\
             Displays information for the specified rule\n\
             in the Rule Order perspective of the Schedule Analysis window."
set HELP(help) "help \[-list|-content|-bsc|-about|-command <command_name>\]\n\
             -list : displays all commands.\n\
             -command <command_name> : displays help for particular command.\n\
             -content : Activates Help->Content window.\n\
             -bsc : Activates Help->BSC window.\n\
             -about : Activates Help->About window.\n"
