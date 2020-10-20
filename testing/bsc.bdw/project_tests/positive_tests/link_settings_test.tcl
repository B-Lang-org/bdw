
# Opens the specified project
handlers::open_project project.bspec

# Displays the project status
commands::display_project_status

# Sets the compilation type to bsc
handlers::set_compilation_type bsc

# Sets the link type to bsc
handlers::set_link_type bsc

# Sets the bsc type and options
handlers::set_link_bsc_options out -path mult4 -options -v

# Displays the project status
commands::display_project_status

# Sets the link type to bsc
handlers::set_link_type make

# Sets the bsc type and options
handlers::set_link_make_options Makefile -target targ -options clean

# Displays the project status
commands::display_project_status

# Sets the link type to bsc
handlers::set_link_custom_command puts

# Displays the project status
commands::display_project_status

# Closes the project
handlers::close_project

# Exits the workstation
exit
