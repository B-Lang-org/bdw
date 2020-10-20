
namespace eval ::MathSupport {

    namespace export \
        plus \
        mult \
        min \
        max 

    proc plus {args} {
        set value_sum 0
        foreach value $args {
            set value_sum [expr $value + $value_sum]
        }
        return $value_sum
    }

    proc mult {args} {
        set value_product 1
        foreach value $args {
            set value_product [expr $value * $value_product]
        }
        return $value_product
    }

    proc min {args} {
        set value_min [lindex $args 0]
        foreach value $args {
            if { $value < $value_min } {
                set value_min $value
            }
        }
        return $value_min
    }
    proc max {args} {
        set value_max [lindex $args 0]
        foreach value $args {
            if { $value > $value_max } {
                set value_max $value
            }
        }
        return $value_max
    }

}
package provide MathSupport 1.0 
