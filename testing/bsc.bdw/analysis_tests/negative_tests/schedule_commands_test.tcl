
# Opens the specified project
handlers::open_project project.bspec 

# Cleans the build results
commands::full_clean

# Compiles the current project
handlers::compile

# Waits until the process with the 'BSPEC(BUILDPID)' id has finished
while {$BSPEC(BUILDPID) != ""} {
        update
}

# Loads the module and shows in the Schedule Analysis window
handlers::show_schedule mkMult4Tbbb

# Shows the rule execution order for the loaded moldule
handlers::get_execution_order

# Shows the rule execution order for the loaded moldule
handlers::get_execution_order mkMultvv2

# Shows the rule execution order for the loaded moldule
handlers::get_rule_info

# Loads the specified module
handlers::load_module mkMult1

# Loads the module and shows in the Schedule Analysis window
handlers::show_schedule mkMult4Tbbb

# Shows the rule execution order for the loaded moldule
handlers::get_execution_order

# Shows the rule execution order for the loaded moldule
handlers::get_execution_order mkMultvv2

# Shows the rule execution order for the loaded moldule
handlers::get_rule_info

# Shows the rule execution order for the loaded moldule
handlers::get_rule_info sss

# Shows the rule execution order for the loaded moldule
handlers::get_rule_relations 

# Shows the rule execution order for the loaded moldule
handlers::get_rule_relations result

# Shows the rule execution order for the loaded moldule
handlers::get_rule_relations resuleeet

# Shows the rule execution order for the loaded moldule
handlers::get_rule_relations "start result ddd" RL_cycle

# Shows the rule execution order for the loaded moldule
handlers::get_rule_relations "start result" "RL_cycle asss"

# Cleans the build results
commands::full_clean

# Closes the current project
handlers::close_project

# Exits the workstation
exit

