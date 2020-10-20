
# Compiles the project
handlers::link 

# Creates a new project
handlers::open_project project.bspec 

# Links the project
handlers::link 

# Sets the compilation type
handlers::set_link_type make

# Compiles the project
handlers::link 

# Sets the compilation type
handlers::set_link_type custom_command

# Compiles the project
handlers::link 

# Closes the project 
handlers::close_project

# Exits the worksptation
exit
