
# Creates a new project
handlers::open_project project.bspec 

# Cleans the build results
commands::full_clean

while {$BSPEC(FILES) == ""} {
        update
}

# Compiles the current project
handlers::compile_file Mult4.bsv -withdeps

# Waits until the process with the 'BSPEC(BUILDPID)' id has finished
while {$BSPEC(BUILDPID) != ""} {
        update
}

# Loads the specified package
handlers::load_package Mult4

# Reloads all currently loaded packages
handlers::reload_packages

# Shows the import hierarchy for the specified package
handlers::import_hierarchy Mult2

# Cleans the build results
commands::full_clean

# Closes the current project
handlers::close_project

# Exits the workstation
exit
