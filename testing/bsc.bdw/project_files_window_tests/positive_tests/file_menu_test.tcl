
# Creates a new project
handlers::open_project project.bspec 

# Sets the compilation result directories
handlers::set_compilation_results_location -simdir mult4 -bdir mult4

# Displays the project status
commands::display_project_status

# Cleans the files
commands::full_clean

while {$BSPEC(FILES) == ""} {
        update
}

# Compiles the specified file considering dependencies 
handlers::compile_file mult4/Mult2.bsv -withdeps -typecheck

while {$BSPEC(BUILDPID) != ""} {
        update
}

# Cleans the files
commands::full_clean

while {$BSPEC(FILES) == ""} {
        update
}

# Compiles the specified file considering dependencies 
handlers::compile_file mult4/Mult2.bsv -withdeps

while {$BSPEC(BUILDPID) != ""} {
        update
}

# Compiles the specified file without considering dependencies 
handlers::compile_file mult4/Mult2.bsv 

while {$BSPEC(BUILDPID) != ""} {
        update
}

# Cleans the files
commands::full_clean

# Closes the project 
handlers::close_project

# Exits the worksptation
exit
