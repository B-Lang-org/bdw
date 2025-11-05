# This script does not currently work with Bluespec Haskell syntax
# so turn that off for now.
if {[info command Bluetcl::syntax] ne ""} {
    Bluetcl::syntax set bsv
}

## ------------------------------
## Tests for virtual object type representations

proc testCmd { args }  {
    puts "Command: $args"
    if { [catch $args err] } {
        puts "Caught error:  $err $::errorInfo"
        set err [list]
    } else {
        foreach e $err {
            puts "$e"
        }
    }
    puts "---------"
    return $err
}

proc testCmdS { args }  {
    puts "Command: $args"
    if { [catch $args err] } {
        puts "Caught error:  $err $::errorInfo"
        set err [list]
    } else {
        puts $err
    }
    puts "---------"
    return $err
}


testCmd Bluetcl::bpackage load Test ClientServer

package require Virtual

set toTest [list \
                xxx \
                Tuple2 \
                Tuple2#(a,x) \
                "Tuple2#(a, z)" \
                "Tuple2#(bit, Bool)" \
                "Tuple2#(bit, Bool)" \
                T \
                T#(t1,t2) \
                T#(bit,int) \
                Bar \
                Baz#(x,sz) \
                Baz#(Bool,34) \
                TopIFC \
                TopIFC#(xx) \
                TopIFC#(UInt#(7)) \
                SubIFC \
                SubIFC#(xx) \
                SubIFC#(UInt#(7)) \
                U \
                U#(xx) \
                U#(Bool) \
                U2 \
                U2#(xx) \
                U2#(Bool) \
                Foo \
                Foo#(zz) \
                Foo#(int) \
                Arith \
                "function int zzz(int x1, Bool x2, a x3)" \
                "function int strange(int x1, Bool x2, Tuple2#(a, int) x3)" \
                Get#(UInt#(4)) \
                Put#(UInt#(5)) \
                Action \
                ActionValue#(int) \
                "Put#(Tuple2#(Bool, UInt#(65)))"\
                "Get#(Tuple2#(Bool, UInt#(65)))"\
                "Tuple2#(Bar, List#(Bool))" \
                "Tuple2#(Bar, Put#(Bool))" \
                "Tuple2#(Bar, FIFO#(Counter#(a)))" \
           ]

foreach t $toTest {
    set o [testCmd ::Virtual::createType $t]
    ## testCmd My::oshow $o
    puts [$o show]
    puts "Kind: [$o getKind]"

    puts "Members"
    foreach m [$o getMembers] {
        set n [lindex $m 0]
        set mo [lindex $m 1]
        puts "$n:  [$mo show]"
        
    }
    puts "Width: [$o getWidth]"
    puts "type:  [$o getName]"
    puts "const:  [$o getConstr]"
    puts "packages [$o getPackages]"
#    My::oshow $o
}
