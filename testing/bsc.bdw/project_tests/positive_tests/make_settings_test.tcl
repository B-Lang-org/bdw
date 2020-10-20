
# Opens the specified project
handlers::open_project project.bspec

# Displays the project status
commands::display_project_status

# Sets the compilation type to make
handlers::set_compilation_type make

# Sets the makefile and appropriate targets
handlers::set_make_options Makefile -target run -clean clean -fullclean cleanall

# Displays the project status
commands::display_project_status

# Closes the project
handlers::close_project

# Exits the workstation
exit
