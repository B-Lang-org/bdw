
# Creates a new project
handlers::new_project new_project

# Displays the project status
commands::display_project_status

# Sets the compilation type to bsc
handlers::set_compilation_type bsc

# Sets the project editor to emacs
handlers::set_project_editor emacs

# Sets the bsc type and options
handlers::set_bsc_options -bluesim -options -v -info-dir . -rts-options fff

# Sets the link type to bsc
handlers::set_link_type bsc

# Sets the bsc type and options
handlers::set_link_bsc_options sim_exe -path mult4 -options -v

# Sets the bluesim options
handlers::set_bluesim_options -V

# Adds mult4 dir to search paths
handlers::set_search_paths mult4

# Sets the top file and module 
commands::set_top_module mult4/Mult4Tb.bsv mkMult4Tb

# Displays the project status
commands::display_project_status

# Sets the bsc type and options
handlers::set_bsc_options -verilog 

# Sets the verilog simulator
handlers::set_verilog_simulator modelsim -options -modelsim

# Displays the project status
commands::display_project_status

# Closes the project
handlers::close_project

# Displays the project status
commands::display_project_status

# Exits the workstation
exit
