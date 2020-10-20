
# Opens the specified project
handlers::open_project project.bspec

# Displays the project status
commands::display_project_status

# Sets the compilation type to bsc
handlers::set_compilation_type bsc

# Sets the bsc type and options
handlers::set_bsc_options -verilog -options -v

# Sets the compilation result directories
handlers::set_compilation_results_location -vdir mult4 -bdir mult4

# Sets the simulator to iverilog
handlers::set_verilog_simulator iverilog

# Displays the project status
commands::display_project_status

# Sets the bsc type to bluesim
handlers::set_bsc_options -bluesim

# Sets the compilation result directories
handlers::set_compilation_results_location -simdir mult4 -bdir mult4

# Displays the project status
commands::display_project_status

# Closes the project
handlers::close_project

# Exits the workstation
exit
