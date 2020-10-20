
# Simulates the project
handlers::simulate 

# Creates a new project
handlers::open_project project.bspec 

# Simulates the project
handlers::simulate

# Sets the compilation type
handlers::set_link_type make

# Simulates the project
handlers::simulate

# Sets the compilation type
handlers::set_link_type custom_command

# Simulates the project
handlers::simulate

# Closes the project 
handlers::close_project

# Exits the worksptation
exit
