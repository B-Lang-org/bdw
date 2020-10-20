namespace import ::Bluetcl::*

# Sets the specified flag
puts [flags set {-verilog}]

# Loads the specified module
puts [module load mkT]
puts {----------}

# Displays the ports information
puts [submodule porttypes mkT]
puts ""

# Displays the ports information
puts [submodule porttypes mkM]
puts {----------}

# Displays the full information
puts [submodule full mkT]
puts ""

# Displays the full information
puts [submodule full mkM]
