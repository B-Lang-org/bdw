
# Opens the specified project
handlers::open_project project.bspec

# Compiles the project
handlers::compile 

# Sets the compilation type
handlers::set_compilation_type bsc

# Compiles the project
handlers::compile 

# Sets the compilation type
handlers::set_compilation_type make 

# Compiles the current project
handlers::compile

# Links the project
handlers::link 

# Simulates the project
handlers::simulate

# Sets the compilation type
handlers::set_link_type make

# Compiles the project
handlers::link 

# Simulates the project
handlers::simulate

# Sets the compilation type
handlers::set_link_type custom_command

# Compiles the project
handlers::link 

# Simulates the project
handlers::simulate

# Closes the project
handlers::close_project

# Exits the workstation
exit

