
# Opens the specified project
handlers::open_project project.bspec 

# Compiles the current project
handlers::compile

# Waits until the process with the 'BSPEC(BUILDPID)' id has finished
while {$BSPEC(BUILDPID) != ""} {
        update
}

# Loads the specified module
handlers::load_module mkMult4Tb

# Reloads the currently loaded module
handlers::reload_module

# Cleans the build results
commands::full_clean

# Closes the current project
handlers::close_project

# Exits the workstation
exit
