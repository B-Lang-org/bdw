
# Typechecks the project
handlers::typecheck 

# Creates a new project
handlers::new_project project1 

# Typechecks the project
handlers::typecheck 

# Closes the project 
handlers::close_project

# Creates a new project
handlers::open_project project.bspec 

# Sets the compilation type
handlers::set_compilation_type bsc

# Typechecks the project
handlers::typecheck 

# Closes the project 
handlers::close_project

# Exits the worksptation
exit
