
package require Bluetcl
package require utils

package provide SignalTypes 1.0

namespace eval ::SignalTypes {

    namespace export \
        generateSigTypeMap \
        clearMap \
        lookupSig \
        setDelim \
        dumpMap \
        getKeys \
        getValues \
        getNames \
        getTypeDetails \
        extractFlavor \
        extractType \
        extractMembers \
        extractFields \


    variable STMAP
    variable Delim "/"
    variable RmDollar 0

    proc generateSigTypeMap { topmodule {hierPrefix {}} } {
        variable STMAP

        # make sure the module is loaded
        set loaded [Bluetcl::module list]
        if { -1 == [lsearch -exact $loaded $topmodule] } {
            Bluetcl::module load $topmodule
        }

        genSigMapForModules $hierPrefix $topmodule
    }

    # traverse hierarchy adding to map at each level
    proc genSigMapForModules { prefix mod } {

        collectFlags $mod
        set smap [list]
        if { [catch "Bluetcl::module porttypes $mod" ports] } {set ports [list] }
        foreach port $ports {
            set n [utils::fst $port]
            set t [utils::snd $port]
            set thisPort [genPathName $prefix $n]
            setEntry $thisPort $t
        }

        if { [catch "Bluetcl::submodule porttypes $mod" insts ] } { set insts [list] }
        foreach inst $insts {
            set i [utils::fst $inst]
            set thisPath  [genPathName $prefix $i]
            set mconstr  [utils::snd $inst]
            set isReg [regexp {^RegN$|^RegA$|^RegUN$}  $mconstr]
            set subports [lindex $inst 2]
            set subports [utils::snd $subports]

            foreach pair $subports {
                set type [utils::snd $pair]
                set thisPort [genPathName $thisPath [utils::fst $pair]]
                setEntry $thisPort $type

                if {$type == "Clock"} continue;
                if {$type == "Reset"} continue;
                # the name of the port in the top module  foo$Q_OUT
                set thisTopPort [format "%s$%s" $thisPath [utils::fst $pair]]
                setEntry $thisTopPort $type

                # inline reg
                if { $isReg &&  [utils::fst $pair] == "Q_OUT"} {
                    setEntry $thisPath $type
                }
            }
            genSigMapForModules $thisPath $mconstr
        }
    }

    proc collectFlags { mod } {
        variable RmDollar
        set f [Bluetcl::module flags $mod remove-dollar]
        if {$f == ""} { return "" }
        set RmDollar 1
        if { [regexp "no-remove-dollar" $f] } {
            set RmDollar 0
        }
    }

    proc setEntry { sig type } {
        variable RmDollar
        variable STMAP

        if {$RmDollar} {
            regsub {\$} $sig "_" sig
        }
        set STMAP($sig)  $type
    }

    # generate a path name
    proc genPathName { path next } {
        variable Delim
        set newpath $path
        lappend newpath $next
        return [join $newpath $Delim]
    }

    proc setDelim { newd } {
        variable Delim
        set Delim $newd
    }

    proc lookupSig { sig } {
        variable STMAP
        if { [info exists STMAP($sig)] } {
            return $STMAP($sig)
        }
        return ""
    }

    # return a list of names, not types which match pattern
    proc getNames { pattern } {
        variable STMAP
        array names STMAP -regexp $pattern
    }

    proc clearMap {} {
        variable STMAP
        foreach i [array names STMAP] {
            unset STMAP($i)
        }
    }

    proc dumpMap {} {
        variable STMAP
        parray STMAP
    }

    proc getKeys {} {
        variable STMAP
        return [lsort [array names STMAP]]
    }

    proc getValues {} {
        variable STMAP
        set sz [array size STMAP]
        foreach k [getKeys] {
            set VALS($STMAP($k)) 0
        }
        return [lsort [array names VALS]]
    }

    # returns the details of a type which can be accessed
    # from the methods below
    proc getTypeDetails { type } {

        # silently ignore error
        if { [catch "Bluetcl::type bitify [list $type]" ft] } {set ft "UNKNOWN" }
        set key [extractFlavor $ft]

        switch -exact $key {
            "ALIAS" { return [getTypeDetails [extractType $ft]] }
            "UNKNOWN" { return [list BASIC $type 1 {} {} ] }
            default { return $ft }
        }

        return $ft
    }

    # Corresponds to TypeAnalysisTclUtil.hs
    proc extractFlavor  {t} { return [lindex $t 0] }
    proc extractType    {t} { return [lindex $t 1] }
    proc extractSize    {t} { return [lindex $t 2] }
    proc extractMembers {t} { return [lindex $t 3] }
    proc extractFields  {t} { return [lindex $t 4] }

# end namespace
}
