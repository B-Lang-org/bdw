
# Loads the specified package
handlers::load_package Mult4

# Creates a new project
handlers::open_project project.bspec 

# Loads the specified package
handlers::load_package 

# Loads the specified package
handlers::load_package Mult4

# Reloads all currently loaded packages
handlers::reload_packages

# Shows the import hierarchy for the specified package
handlers::import_hierarchy

# Searches for the specified pattern through the package hierarchy
handlers::search_in_packages 

# Searches for the specified pattern through the package hierarchy
handlers::search_in_packages Mult -nex

# Searches for the specified pattern through the package hierarchy
handlers::search_in_packages Mu -next -previous

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

# Loads the specified package
handlers::load_package Mult2

# Shows the import hierarchy for the specified package
handlers::import_hierarchy Mult4

# Displays the project status
commands::full_clean

# Closes the current project
handlers::close_project

# Exits the workstation
exit
