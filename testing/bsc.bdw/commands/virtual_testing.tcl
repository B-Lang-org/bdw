package require Virtual
package require Waves
namespace import ::Virtual::*

# This script may not currently work with Bluespec Haskell syntax
# so turn that off for now.
if {[info command Bluetcl::syntax] ne ""} {
    Bluetcl::syntax set bsv
}

proc inst_test_one_method {path object args} {
    puts "$path . $args = [$object {*}$args]"
}

#sort so the test output remains the same, though I don't foresee children and signals returning things in different orders
proc sort_insts {insts} {
    set pairs {}
    foreach i $insts {
        lappend pairs [list [$i path bsv] $i]
    }
    set finish {}
    foreach i [lsort $pairs] {
        lappend finish [lindex $i 1]
    }
    return $finish

}

proc sort_signals {insts} {
    set pairs {}
    foreach i $insts {
        lappend pairs [list [$i show] $i]
    }
    set finish {}
    foreach i [lsort $pairs] {
        lappend finish [lindex $i 1]
    }
    return $finish
}
proc sort_rules {rules} {
    set pairs {}
    foreach r $rules {
        lappend pairs [list [$r show] $r]
    }
    set finish {}
    foreach r [lsort $pairs] {
        lappend finish [lindex $r 1]
    }
    return $finish
}

proc showsignals {sigs} {
    set answer ""
    foreach s [sort_signals $sigs] {
        lappend answer [$s show]
    }
    return $answer
}
proc showinsts {sigs} {
    set answer ""
    foreach s [sort_insts $sigs] {
        lappend answer [$s path bsv]
    }
    return $answer
}

proc showrules {rules} {
    set answer ""
    foreach r $rules {
        lappend answer "[$r show]"
    }
    lsort $answer
}

proc showmethods {meths} {
    set answer ""
    foreach m $meths {
        lappend answer "[$m show]"
    }
    lsort $answer
}

proc insttest {insts} {
    puts "starting insttest"
    foreach o $insts {
        set path "INST [$o path bsv]"
        puts "got path $path"
        #dont test "key" because it might be nondeterministic
        foreach methodd {
            kind position module class hiertree wave_format key
        } {
            inst_test_one_method $path $o $methodd
        }
        foreach m [list ancestors] {
            puts "$path . $m = [showinsts [$o $m]]"
        }
        inst_test_one_method $path $o name bsv
        inst_test_one_method $path $o name synth
        inst_test_one_method $path $o path bsv
        inst_test_one_method $path $o path synth
        set parent [$o parent]
        if {$parent ne ""} {
            puts "$path . parent = [$parent path bsv]"
        }
        foreach m {signals predsignals bodysignals} {
            puts "$path . $m = [showsignals [$o $m]]"
        }
        foreach m { predmethods bodymethods portmethods} {
            puts "$path . $m = [showmethods [$o $m]]"
        }
        # filter search test
        set n [$o path bsv]
        set i [inst filter $n]
        if { [llength $i] != 1 } {
            puts "Error on name lookup $n  found '$i'"
        } elseif { $n ne [$i path bsv] } {
            puts "Error on name lookup $n  finds [$i path bsv]"
        }

    }
}

proc signal_test_one_method {object args} {
    puts "SIG [$object path] . $args = [$object $args]"
}

proc signaltest {sigs} {
    puts "starting signaltest"
    foreach o $sigs {
        set path "SIG [$o name]"
        #dont test "key" because it might be nondeterministic
        foreach methodd {
            kind name path type "class" wave_format position
        } {
            signal_test_one_method $o $methodd
        }
        puts "SIG [$o show] . used_by [showrules [$o used_by]]"
        puts "$path . inst = [[$o inst] path bsv]"

        # filter search test
        set n [$o path bsv]
        set s [signal filter $n]
        if { [llength $s] != 1 } {
            puts "Error on name lookup $n  found '$s'"
        } elseif { $n ne [$s path bsv] } {
            puts "Error on name lookup $n  finds [$s path bsv]"
        }
    }
}

proc methodtest {meths} {
    puts "starting method testing"
    foreach m $meths {
        foreach c [list name path "path synth" "path bsv" wave_format class] {
            puts "METH  [$m show] $c = [eval $m $c]"
        }
        foreach c [list signals] {
            puts "METH  [$m show] $c = [showsignals [eval $m $c]]"
        }
        foreach c [list used_by] {
            puts "METH  [$m show] $c = [showrules [eval $m $c]]"
        }
        puts "----"
    }
}

proc ruletest {rules} {
    puts "starting method testing"
    foreach r $rules {
        foreach c [list show name kind wave_format] {
            puts "RULE  [$r path] $c = [eval $r $c]"
        }
        foreach c [list predmethods bodymethods] {
            puts "RULE  [$r path] $c = [showmethods [eval $r $c]]"
        }
        foreach c [list signals predsignals bodysignals] {
            puts "RULE  [$r path] $c = [showsignals [eval $r $c]]"
        }
        puts "----"
    }
}



proc testCmd { displayf args }  {
    puts "Command: $args"
    if { [catch $args err] } {
        puts "Caught error:  $err"
        set err [list]
    } else {
        foreach e $err {
            puts [$displayf $e]
        }
    }
    puts "---------"
    return $err 
}


#signaltest [sort_signals [signal filter]]
#insttest [sort_insts [inst filter]]
proc inst_filter_tests {} {
    puts "top = [[inst top] path bsv]"
    puts "f1 = [showinsts [inst filter */*e* -nametype bsv]]"
    puts "f2 = [showinsts [inst filter */*e* -nametype synth]]"
    puts "f3 = [showinsts [inst filter -kind Rule *]]"
    puts "f4 = [showinsts [inst filter -kind Prim *]]"
    puts "f5 = [showinsts [inst filter -kind Synth *]]"
    puts "f6 = [showinsts [inst filter -kind Inst *]]"
    testCmd showinsts inst filter *
    testCmd showinsts inst filter /*
    testCmd showinsts inst filter r* g* 
    testCmd showinsts inst filter /r1/*o* 
    testCmd showinsts inst filter /r1/*ll* -kind rule
    testCmd showinsts inst filter /r1/*ll* -kind Rule
    testCmd showinsts inst filter /r2/*ll*  -kind Prim
    testCmd showinsts inst filter /r.*/*  -kind Prim
    testCmd showinsts inst filter {/r.*/r.*} -regexp
    testCmd showinsts inst filter {/r.*/^r.*} -regexp
    testCmd showinsts inst filter /r.*/^r\[0-9\]+ -regexp
    testCmd showinsts inst filter {/r.*/^r[0-9]*} -regexp
    testCmd showinsts inst filter {^r[0-9]+} -regexp
    testCmd showinsts inst filter {.*/r[0-9]+} -regexp

}

proc runtests1 {} {
    inst_filter_tests

    puts "s1 = [showsignals [signal filter *]]"
    puts "s2 = [showsignals [signal filter *r*]]"
    puts "s3 = [showsignals [signal filter * -inst [lindex [[inst top] children] 0]]]"

    testCmd showsignals signal filter
    testCmd showsignals signal filter *
    testCmd showsignals signal filter */*
    testCmd showsignals signal filter */
    testCmd showsignals signal filter /*/
    testCmd showsignals signal filter /*/*
    testCmd showsignals signal filter /r2/*
    testCmd showsignals signal filter /r2/* -nametype synth
    testCmd showsignals signal filter /*/r2/*
    

    insttest [sort_insts [inst filter *]]
    ruletest [sort_rules [itcl::find objects vRule*]]
    signaltest [sort_signals [signal filter *]]
    methodtest [sort_signals [itcl::find objects vMethod*]]
}

proc runtests2 {sim_or_verilog top} {
    inittest $sim_or_verilog $top
    runtests1
    #run everything twice to make sure reset works
    # reset
    inittest $sim_or_verilog $top
    puts "===========================RESET===================="
    runtests1
}

proc inittest {sim_or_verilog top} {
    Bluetcl::flags set $sim_or_verilog
    Bluetcl::module load $top
}

proc do_test {sim_or_verilog top prefix} {
    runtests2 $sim_or_verilog $top 

    outputtest $prefix
    # Exit needed to close wish enviroment
    exit
}
#Bluetcl::flags set -verilog
#Bluetcl::module load mkT
proc outputtest_one {prefix wave typed} {
    #taking advantage that *.dump is in Makefile to be cleaned
    set viewer [Waves::create_viewer $wave -ScriptFile $prefix.$wave.$typed.dump]
    set  unty 0
    if { $typed eq "bits" } { set unty 1 }
    $viewer send_objects [signal filter *] $unty
    $viewer send_objects [inst filter *] $unty
    $viewer send_instance [inst filter *]

    $viewer save_history "$prefix.$wave.$typed.tcl-out"

    itcl::delete object $viewer


}
proc outputtest {prefix} {
    outputtest_one $prefix NovasRC typed
    outputtest_one $prefix NovasRC bits

    outputtest_one $prefix GtkWaveScript typed
    outputtest_one $prefix GtkWaveScript bits
    #utils::ldisplay [omap path [signal filter *]]
}
