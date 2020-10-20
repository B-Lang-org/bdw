

# Sets the makefile and appropriate targets
handlers::set_make_options Makefile

# Opens the specified project
handlers::open_project project.bspec

# Sets the makefile and appropriate targets
handlers::set_make_options Makefile

# Sets the compilation type to make
handlers::set_compilation_type make

# Sets the make options with no argument
handlers::set_make_options

# Sets the make options with wrong argument
handlers::set_make_options wrong_file

# Sets the make options with wrong argument
handlers::set_make_options negative_tests.exp

# Sets the makefile without an argument fot -target option
handlers::set_make_options Makefile -fullclean

# Sets the makefile with wrong options
handlers::set_make_options Makefile -targett run

# Sets the makefile and appropriate targets
handlers::set_make_options Makefile -target run -target run -clean clean

# Closes the project
handlers::close_project

# Exits the workstation
exit
