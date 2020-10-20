namespace import ::Bluetcl::*

# Sets the specified flag
puts [flags set {-verilog}]
puts {----------}

# Loads the specified module
puts [module load mkS]

# Returns the urgency dependencies 
puts [schedule urgency mkS]

# Returns the rule/method execution order
puts [schedule execution mkS]

# Returns 
puts [schedule methodinfo mkS]

# Returns
puts [schedule pathinfo mkS]

# Returns warnings accured during scheduling for the loaded module
puts [schedule warnings mkS]

puts {----------}

# Loads the specified module
puts [module load mkM]

# Returns the urgency dependencies 
puts [schedule urgency mkM]

# Returns the rule/method execution order
puts [schedule execution mkM]

# Returns 
puts [schedule methodinfo mkM]

# Returns
puts [schedule pathinfo mkM]

# Returns warnings accured during scheduling for the loaded module
puts [schedule warnings mkM]

