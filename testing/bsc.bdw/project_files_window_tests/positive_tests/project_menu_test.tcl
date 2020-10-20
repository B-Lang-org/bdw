
# Creates a new project
handlers::open_project project.bspec 

# Sets the compilation result directories
handlers::set_compilation_results_location -simdir mult4 -bdir mult4

# Displays the project status
commands::display_project_status

# Cleans the files
commands::full_clean

# Typechecks the current project
handlers::typecheck

while {$BSPEC(BUILDPID) != ""} {
        update
}

# Cleans the files
commands::full_clean

# Compiles the current project
handlers::compile

while {$BSPEC(BUILDPID) != ""} {
        update
}

# Cleans the files
commands::full_clean

# Refreshes the project hierarchy
handlers::refresh

# Closes the project 
handlers::close_project

# Exits the worksptation
exit
