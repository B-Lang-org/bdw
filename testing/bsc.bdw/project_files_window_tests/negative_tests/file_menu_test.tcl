
# Creates a new project
handlers::open_project project.bspec 

# Compiles the specified file
handlers::compile_file

# Compiles the specified file without considering dependencies 
handlers::compile_file mult4/Mult2.bsv 

# 
handlers::set_search_paths mult4 

while {$BSPEC(FILES) == ""} {
        update
}

# Compiles the specified file considering dependencies 
handlers::compile_file mult4/Mult2.bsv -withdependencies

# Compiles the specified file considering dependencies 
handlers::compile_file mult4/Mult2.bsv -typeeecheck

# Compiles the specified file considering dependencies 
handlers::compile_file mult4/Mult2.bsv -withdeps -typ

# Compiles the specified file considering dependencies 
handlers::compile_file file -withdeps

# Closes the project 
handlers::close_project

# Exits the worksptation
exit
