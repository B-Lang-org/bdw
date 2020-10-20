
# Creates a new project
handlers::open_project project.bspec 

# Cleans the build results
commands::full_clean

while {$BSPEC(FILES) == ""} {
        update
}

# Compiles the specified file
handlers::compile_file Mult4.bsv -withdeps

# Waits until the process with the 'BSPEC(BUILDPID)' id has finished
while {$BSPEC(BUILDPID) != ""} {
        update
}

# Loads the specified package
handlers::load_package Mult4

# Adds the specified type to the type hierarchy
handlers::add_type Tin

# Adds the specified type to the type hierarchy
handlers::remove_type Tin

# Cleans the build results
commands::full_clean

# Closes the current project
handlers::close_project

# Exits the workstation
exit
