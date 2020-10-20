
# Opens the specified project
handlers::open_project project.bspec 

# Compiles the current project
handlers::compile

# Waits until the process with the 'BSPEC(BUILDPID)' id has finished
while {$BSPEC(BUILDPID) != ""} {
        update
}

# Loads the module and shows in the Schedule Analysis window
handlers::show_schedule mkMult4Tb

# Shows warnings accured during scheduling for the loaded module
handlers::get_schedule_warnings 

# Shows the rule execution order for the loaded moldule
handlers::get_execution_order mkMult2

# Shows the rule execution order for the loaded moldule
handlers::get_rule_info start

# Shows the rule execution order for the loaded moldule
handlers::get_rule_relations start result

# Cleans the build results
commands::full_clean

# Closes the current project
handlers::close_project

# Exits the workstation
exit

