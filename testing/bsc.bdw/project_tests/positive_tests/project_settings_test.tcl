
# Opens the specified project
handlers::open_project project.bspec

# Displays the project status
commands::display_project_status

# Sets the project editor to emacs
handlers::set_project_editor emacs

# Adds mult4 dir to search paths
handlers::set_search_paths mult4

# Sets the top file and module 
commands::set_top_module mult4/Mult4Tb.bsv mkMult4Tb

# Displays the project status
commands::display_project_status

# Closes the project
handlers::close_project

# Exits the workstation
exit
