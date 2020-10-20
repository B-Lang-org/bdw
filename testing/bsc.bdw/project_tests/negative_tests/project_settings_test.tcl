
# Opens the specified project
handlers::open_project project.bspec

# Adds mult4 dir to search paths
handlers::set_search_paths

# Adds mult4 dir to search paths
handlers::set_search_paths mult5

# Adds mult4 dir to search paths
handlers::set_search_paths negative_tests.exp

# Adds mult4 dir to search paths
handlers::set_search_paths mult4

#  
handlers::set_project_editor 

# Sets the project editor to emacs
handlers::set_project_editor vedit

# Sets the project editor to emacs
handlers::set_project_editor gvim -path editor 

# Sets the project editor to emacs
handlers::set_project_editor emacs -options ee -options www 

# Sets the top file and module 
handlers::set_top_file 

# Closes the project
handlers::close_project

# Exits the workstation
exit
