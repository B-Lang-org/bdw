namespace import ::Bluetcl::*

# Sets the specified flag
puts [flags set {-verilog}]

# Loads the specified module
puts [module load mkT]

# Shows the module hierarchy
puts [browsemodule list 0]

# Expands the specified node of the module hierarchy
puts [browsemodule list 1]
puts [browsemodule list 2]
puts [browsemodule list 5]

# Returns information concerning the specified node of the module hierarchy
puts [browsemodule detail 5]
puts [browsemodule detail 2]
puts [browsemodule detail 1]

# Loads the specified module
puts [module load mkM]

# Refreshes the module hierarchy(used when the loaded module has changed)
puts [browsemodule refresh]

# Shows the module hierarchy
puts [browsemodule list 0]

