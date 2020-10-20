namespace import ::Bluetcl::*

# Loads the specified package
puts [bpackage load Test]
puts ""

# Adds the specified type to the type hierarchy
puts [browsetype add [type constr Sz]]

# Shows up level of the type hierarchy
puts [browsetype list 0]

# Expands the specified node of the type hierarchy
puts [browsetype list 1]

# Adds the specified type to the type hierarchy
puts [browsetype add [type constr Bar]]

# Adds the specified type to the type hierarchy
puts [browsetype add {TopIFC#(ty)}]

# Refreshes the type hierarchy
puts [browsetype refresh]

# Shows up level of the type hierarchy
puts [browsetype list 0]

# Expands the specified node of the type hierarchy
puts [browsetype list 1]
puts [browsetype list 2]

# Refreshes the type hierarchy
puts [browsetype clear]

# Refreshes the type hierarchy
puts [browsetype refresh]

# Shows up level of the type hierarchy
puts [browsetype list 0]
