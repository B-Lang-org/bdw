
# Compiles the project
handlers::compile 

# Creates a new project
handlers::new_project project1 

# Compiles the project
handlers::compile 

# Closes the project 
handlers::close_project

# Creates a new project
handlers::open_project project.bspec 

# Sets the compilation type
handlers::set_compilation_type bsc

# Compiles the project
handlers::compile 

# Sets the compilation type
handlers::set_compilation_type make 

# Compiles the current project
handlers::compile

# Closes the project 
handlers::close_project

# Exits the worksptation
exit
