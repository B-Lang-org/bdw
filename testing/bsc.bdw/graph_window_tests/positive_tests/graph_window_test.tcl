
# Opens the specified project
handlers::open_project project.bspec

# Displays the project status
commands::display_project_status

# Cleans the project
commands::full_clean

while {$BSPEC(FILES) == ""} {
        update
}

# Compiles the specified file considering dependencies 
handlers::compile_file mult4/Mult2.bsv -withdeps

while {$BSPEC(BUILDPID) != ""} {
        update
}

# Loads the specified module
handlers::load_module mkMult2

# Opens the specified graph window
handlers::show_graph -conflict 

# Opens the specified graph window
handlers::show_graph -exec

# Opens the specified graph window
handlers::show_graph -urgency 

# Opens the specified graph window
handlers::show_graph -combined 

# Opens the specified graph window
handlers::show_graph -combined_full 

# Minimizes all currently active windows except the Main window
commands::minimize_all

# Cleans the project
commands::full_clean

# Closes all currently opened windows except the Main window
commands::close_all

# Closes the project 
handlers::close_project

# Exits the workstation
exit
