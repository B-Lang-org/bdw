package provide Functional 1.0

# eval+ always tries to compile its argument
interp alias {} ::Functional::eval+ {} if 1

proc ::Functional::lambda {params body args} {
    set ns [uplevel 1 { namespace current }]
    list ::apply [list $params $body $ns] {*}$args
}

proc ::Functional::iota {args} {
    switch [llength $args] {
	1 {set from 0; set to [lindex $args 0]; set incr 1}
	2 {set from [lindex $args 0]; set to [lindex $args 1]; set incr 1}
	3 {set from [lindex $args 0]; set to [lindex $args 1]; set incr [lindex $args 2]}
	default {
	    error "wrong number of args 1-3"
	}
    }
    set result {}
    for {set i $from} {$i < $to} {incr i $incr} {
	lappend result $i
    }
    return $result
}

proc ::Functional::curry {lam args} {
    lappend lam {*}$args
}

# Maps a function to each element of a list,
# and returns a list of the results.
proc ::Functional::map {prefix list} {
    set result {}
    foreach item $list {
	lappend result [uplevel 1 {*}$prefix [list $item]]
    }
    return $result
}

proc ::Functional::mapargs {func args} {
    return [Functional::map $func $args]
}

# Filters a list, returning only those items which pass the filter.
proc ::Functional::filter {prefix list} {
    set ret {}
    foreach item $list {
	if {[uplevel 1 {*}$prefix [list $item]]} {
	    lappend ret $item
	}
    }
    return $ret
}

proc ::Functional::filterargs {func args} {
    return [Functional::filter $func $args]
}

# Useful higher-order functions which replace common uses of recursion
# foldl (fold left)
# foldl - 0 {1 2 3} -> ((0-1)-2)-3
proc ::Functional::foldl {func default list} {
    set res $default
    foreach item $list {
	set res [uplevel 1 {*}$func [list $res $item]]
    }
    return $res
}

# foldr (fold right)
# foldr + 0 {1 2 3} -> 1+(2+(3+0))
proc ::Functional::foldr {func default list} {
    set tot $default
    # Go in reverse
    for {set i [llength $list]} {$i > 0} {incr i -1} {
	set tot [uplevel 1 {*}$func [list [lindex $list [expr {$i-1}]] $tot]]
    }
    return $tot
}

# compose - compose two functions together
# [compose f g] $args -> f [g $args]
proc ::Functional::compose {f g} {
    return [Functional::lambda {args} "$f \[$g {*}\$args\]"]
}

# The K combinator - obscure, but very useful.
proc ::Functional::K {a b} { set a }
