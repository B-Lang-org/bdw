
# Loads the module and shows in the Schedule Analysis window
handlers::show_schedule 

# Opens the specified project
handlers::open_project project.bspec 

# Loads the module and shows in the Schedule Analysis window
handlers::show_schedule 

# Loads the module and shows in the Schedule Analysis window
handlers::show_schedule mkMult4Tb

# Shows warnings accured during scheduling for the loaded module
handlers::get_schedule_warnings 

# Shows warnings accured during scheduling for the loaded module
handlers::get_schedule_warnings wrong_module

# Displays the project status
commands::full_clean

while {$BSPEC(FILES) == ""} {
        update
}

# Compiles the current project
handlers::compile_file Mult2.bsv -withdeps

# Waits until the process with the 'BSPEC(BUILDPID)' id has finished
while {$BSPEC(BUILDPID) != ""} {
        update
}

# Loads the specified module
handlers::load_module mkMult2

# Shows the rule execution order for the loaded moldule
handlers::get_execution_order wrong_module 

# Shows the rule execution order for the loaded moldule
handlers::get_rule_info

# Shows the rule execution order for the loaded moldule
handlers::get_rule_info wrong_rule

# Shows the rule execution order for the loaded moldule
handlers::get_rule_relations

# Shows the rule execution order for the loaded moldule
handlers::get_rule_relations result

# Shows the rule execution order for the loaded moldule
handlers::get_rule_relations wrong result

# Displays the project status
commands::full_clean

# Closes the current project
handlers::close_project

# Exits the workstation
exit
