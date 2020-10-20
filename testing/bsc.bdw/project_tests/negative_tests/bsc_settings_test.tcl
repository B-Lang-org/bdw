
# Opens the specified project
handlers::open_project project.bspec

# Calls the set_compilation_type without arguments
handlers::set_compilation_type 

# Calls the set_compilation_type with a wrong argument
handlers::set_compilation_type wrong_comp_type

# Sets the bsc type to bluesim
handlers::set_bsc_options

# Sets the bsc type to bluesim
handlers::set_bsc_options -bluesimmm

# Sets the bsc type to bluesim
handlers::set_bsc_options -bluesim -opt -v

# Sets the compilation result directories
handlers::set_compilation_results_location 

# Sets the compilation result directories
handlers::set_compilation_results_location -vdir 

# Sets the compilation result directories
handlers::set_compilation_results_location -vdir mult4 -vdir mult4

# Sets the compilation result directories
handlers::set_compilation_results_location -vdir mult4 -bdir

# Closes the project
handlers::close_project

# Exits the workstation
exit
