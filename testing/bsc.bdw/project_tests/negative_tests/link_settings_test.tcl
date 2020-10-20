
# Sets the compilation type to bsc
handlers::set_compilation_type bsc

# Opens the specified project
handlers::open_project project.bspec

# Sets the compilation type to bsc
handlers::set_compilation_type bsc

# Sets the link type without arguments 
handlers::set_link_type 

# Sets the link type with wrong argument
handlers::set_link_type wrong 

# Sets the link bsc type and options without arguments
handlers::set_link_bsc_options

# Sets the link bsc output file, directory and options
handlers::set_link_bsc_options mmm -wrong

# Sets the link bsc output file, directory and options
handlers::set_link_bsc_options mmm -path /wrong

# Sets the link make options
handlers::set_link_make_options Makefile

# Sets the link type to make
handlers::set_link_type make

# Sets the link bsc options
handlers::set_link_bsc_options mm

# Sets the link make options
handlers::set_link_make_options

# Sets the link make options
handlers::set_link_make_options mmm 

# Sets the link make options
handlers::set_link_make_options Makefile -tget ta

# Sets the link make options
handlers::set_link_make_options Makefile -target

# Sets the link type to bsc
handlers::set_link_custom_command puts

# Sets the link type to make
handlers::set_link_type custom_command 

# Sets the link type to bsc
handlers::set_link_custom_command

# Closes the project
handlers::close_project

# Exits the workstation
exit
