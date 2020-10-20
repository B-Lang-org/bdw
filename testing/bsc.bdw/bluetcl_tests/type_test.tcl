namespace import ::Bluetcl::*

# Loads the specified package
puts [bpackage load Test]
puts ""

# Returns the type constructor
puts [type constr Sz]

# Returns detailed information about the specified type
puts [type full Sz]
puts ""

# Returns the type constructor
puts [type constr T]

# Returns detailed information about the specified type
puts [type full {T#(t1,t2)}]
puts [type full {T#(bit,int)}]
puts ""

puts [type constr Bar]
puts [type full Bar]
puts ""

puts [type constr Baz]
puts [type full {Baz#(x,sz)}]
puts [type full {Baz#(Bool,2)}]
puts ""

puts [type constr TopIFC]
puts [type full {TopIFC#(ty)}]
puts [type full {TopIFC#(Bit#(8))}]
puts ""

puts [type constr SubIFC]
puts [type full {SubIFC#(ty)}]
puts [type full {SubIFC#(Bit#(8))}]
puts ""

puts [type constr U]
puts [type full {U#(t)}]
puts [type full {U#(Bool)}]
puts ""

puts [type constr U2]
puts [type full {U#(t)}]
puts [type full {U#(bit)}]
puts ""

puts [type constr Foo]
puts [type full {Foo#(x)}]
puts [type full {Foo#(int)}]
puts ""

