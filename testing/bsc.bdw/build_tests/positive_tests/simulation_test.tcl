
# Creates a new project
handlers::open_project project.bspec 

# Sets the bsc type and options
handlers::set_bsc_options -verilog

# Sets the compilation result directories
handlers::set_compilation_results_location -vdir mult4 -bdir mult4

# Displays the project status
commands::display_project_status

# Displays the project status
commands::full_clean

# Compiles the current project
handlers::compile

while {$BSPEC(BUILDPID) != ""} {
        update
}

# Compiles the current project
handlers::link

while {$BSPEC(BUILDPID) != ""} {
        update
}

# Compiles the current project
handlers::simulate

while {$BSPEC(BUILDPID) != ""} {
        update
}

# Displays the project status
commands::full_clean

# Closes the project 
handlers::close_project

# Exits the workstation
commands::exit_main_window

