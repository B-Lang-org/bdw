namespace import ::Bluetcl::*

# Loads the specified package
puts [bpackage load Test]

# Expands the information for the specified node
puts [browsepackage list 0]
puts [browsepackage list 1]
puts [browsepackage list 2]
puts [browsepackage list 3]
puts [browsepackage list 4]
puts [browsepackage list 10]
puts [browsepackage list 12]
puts [browsepackage list 11]

# Returns a detailed information for the specified node
puts [browsepackage detail 1]
puts [browsepackage detail 4]
puts [browsepackage detail 10]
puts [browsepackage detail 12]
puts [browsepackage detail 11]
puts [browsepackage detail 22]
puts [browsepackage detail 25]

# Returns the type of the specified node
puts [browsepackage nodekind 1]
puts [browsepackage nodekind 4]
puts [browsepackage nodekind 10]
puts [browsepackage nodekind 12]
puts [browsepackage nodekind 11]
puts [browsepackage nodekind 25]

# Loads the specified package
puts [bpackage load RegFile]

# Refreshes the package hierarchy
puts [browsepackage refresh]

# Shows the package hierarchy
puts [browsepackage list 0]

