
# Creates a new project
handlers::open_project project.bspec 

# Cleans the build results
commands::full_clean

# Compiles the current project
handlers::compile

# Waits until the process with the 'BSPEC(BUILDPID)' id has finished
while {$BSPEC(BUILDPID) != ""} {
        update
}

# Loads the specified package
handlers::load_package Mult1

# Adds the specified type to the type hierarchy
handlers::add_type

# Removes the specified type from the type hierarchy
handlers::remove_type

# Removes the specified type from the type hierarchy
handlers::remove_type Tin

# Adds the specified types to the type hierarchy
handlers::add_type T ut TMM 

# Removes the specified type from the type hierarchy
handlers::remove_type T

# Removes the specified type from the type hierarchy
handlers::remove_type Tout

# Cleans the build results
commands::full_clean

# Closes the current project
handlers::close_project

# Exits the workstation
exit
