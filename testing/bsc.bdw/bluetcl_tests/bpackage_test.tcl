namespace import ::Bluetcl::*

# Loads the specified package
puts [bpackage load Test]
puts ""

# Loads the specified package
puts [bpackage load RegFile]
puts ""

# Lists currently loaded packages
puts [bpackage list]
puts ""

# Shows package dependencies
puts [bpackage depend]
puts ""

# Clears all currently loaded packages
puts [bpackage clear]
puts ""

# Lists currently loaded packages(list should be empty)
puts [bpackage list]

