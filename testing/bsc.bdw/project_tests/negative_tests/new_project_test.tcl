
# Creates a new project
handlers::new_project  

# Creates a new project
handlers::new_project project 

# Creates a new project
handlers::new_project project1 -loc dddd

# Creates a new project
handlers::new_project project1 -location dddd

# Creates a new project
handlers::new_project project1 -location mult4 -location mult4 

# Opens the project project.bspec
handlers::open_project project.bspec

# Sets the top file and module 
commands::set_top_module mult4/Mult4Tb.bsv mkMult4Tb

# Creates a new project
handlers::new_project project1 -location mult4 

# Closes the project 
handlers::close_project

# Exits the worksptation
exit

