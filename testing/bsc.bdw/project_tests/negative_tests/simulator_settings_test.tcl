
# Sets the simulation results location directory without opened project
handlers::set_sim_results_location mult4

# Opens the specified project
handlers::open_project project.bspec

# Sets the simulation results location directory without argument
handlers::set_sim_results_location

# Sets the simulation results location directory with wrong argument
handlers::set_sim_results_location mult3

# Sets the simulation results location directory 
handlers::set_sim_results_location negative_tests.exp

# Sets the simulator to iverilog
handlers::set_verilog_simulator 

# Sets the simulator to iverilog
handlers::set_verilog_simulator simulator

# Sets the simulator to iverilog
handlers::set_verilog_simulator iverilog -path

# Sets the simulator to iverilog
handlers::set_verilog_simulator iverilog -paths ddd

# Sets the simulator to iverilog
handlers::set_verilog_simulator iverilog -path ddd

# Closes the project
handlers::close_project

# Exits the workstation
exit
