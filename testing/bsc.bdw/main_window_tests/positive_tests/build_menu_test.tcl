
# Opens the specified project
handlers::open_project project.bspec

# Sets the compilation result directories
handlers::set_compilation_results_location -simdir mult4 -bdir mult4

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

# Cleans the compile/link/simulate result files
handlers::full_clean

# Displays the project status
commands::display_project_status

# Closes the project
handlers::close_project

# Exits the workstation
exit

