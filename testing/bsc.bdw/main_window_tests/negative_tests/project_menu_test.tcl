
# Creates a new project
handlers::new_project  

# Creates a new project
handlers::new_project project 

# Creates a new project
handlers::new_project project1 -loc dddd

# Creates a new project
handlers::new_project project1 -location mult4 -location mult4 

# Opens the specified project
handlers::open_project 

# Opens the specified project
handlers::open_project project1.bspec

# Opens the specified project
handlers::open_project negative_tests.exp

# Opens the specified project
handlers::new_project proj

# Opens the specified project
handlers::open_project project.bspec

# Closes the project 
handlers::close_project

# Opens the specified project
handlers::open_project project.bspec

# Adds mult4 dir to search paths
handlers::set_search_paths

# Adds mult4 dir to search paths
handlers::set_search_paths mult5

# Adds mult4 dir to search paths
handlers::set_search_paths negative_tests.exp

# Sets the project editor
handlers::set_project_editor 

# Sets the project editor to a not supported one
handlers::set_project_editor vedit

# Sets a wrong path for the project editor
handlers::set_project_editor gvim -path editor 

# Sets the project editor to emacs
handlers::set_project_editor emacs -options ee -options www 

# Sets the top file and module 
handlers::set_top_file 

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

# Sets the bsc type to bluesim
handlers::set_bsc_options -bluesim -info-di

# Sets the bsc type to bluesim
handlers::set_bsc_options -bluesim 

# Sets the verilog simulator
handlers::set_verilog_simulator modelsim  

# Sets the bsc type to verilog
handlers::set_bsc_options -verilog

# Sets the bluesim options
handlers::set_bluesim_options -V

# Sets the compilation result directories
handlers::set_compilation_results_location 

# Sets the compilation result directories
handlers::set_compilation_results_location -vdir 

# Sets the compilation result directories
handlers::set_compilation_results_location -vdir mult4 -vdir mult4

# Sets the compilation result directories
handlers::set_compilation_results_location -vdir mult4 -bdir

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

# Sets the link type without arguments 
handlers::set_link_type 

# Sets the link type with wrong argument
handlers::set_link_type wrong 

# Sets the link bsc type and options without arguments
handlers::set_link_bsc_options

# Sets the link bsc output file, directory and options
handlers::set_link_bsc_options mmm -wrong

# Sets the link bsc output file, directory and options
handlers::set_link_bsc_options mmm -path subdir/wrong

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

# Exits the workstation
exit
