##############################################################################

package provide Virtual 2.0

package require Bluetcl
package require TypeSupport
package require utils
package require Itcl
package require VisitorPattern

namespace eval ::Virtual {
    namespace export inst signal reset omap show_hierarchy

    variable _signal_count  0
    variable _signal_map
    variable _inst_map
    variable _InstSearch
    variable _Boundary
    variable _MethodSignals
    variable _Method_map
    variable _Rule_map
    variable _SignalUsage
    variable _MethodUsage
    variable _ModuleCache

    proc inst {ikey args} {
        if {[string equal $ikey "filter"]} {
            return [eval do_inst_filter $args]
        }
        set key $ikey
        if {[string equal $ikey "top"]} {
            set key 1
            inst_key_get_or_create $key ""
        } else {
            puts stderr "error at $ikey"
            return -code error "error: Unrecognized method '$ikey'. Valid methods are: top filter"
        }
    }

    proc inst_key_get_or_create {key parent} {
        variable _inst_map
        if { [info exists _inst_map($key)] } {
            set inst $_inst_map($key)
        } else {
            set inst [uplevel #0 ::Virtual::VInst #auto "$key" "$parent"]
            set _inst_map($key) $inst
        }
        return $inst
    }

    proc get_signals { kind bsvmodule uniquename label } {
        set signals [list]
        switch -exact -- $kind {
            Rule {
                # construct with type Bool
                set w [signal_outer "WILL_FIRE_$uniquename" "WillFire" "$label" "Bool"]
                set c [signal_outer "CAN_FIRE_$uniquename" "CanFire" "$label" "Bool"]
                set signals [list $w $c]
            }
            Primitive {
                foreach k [getPortTypesForInstance $kind $bsvmodule $uniquename] {
                    set base [lindex $k 0]
                    lappend signals [signal_outer $base Signal $label [lindex $k 1]]
                }}
            Synthesized {
                foreach k [getPortTypesForInstance $kind $bsvmodule $uniquename] {
                    set base [lindex $k 0]
                    lappend signals [signal_outer $base Signal $label [lindex $k 1]]
                }
            }
            Instance {
                # No support for bsv instances
            }
            default {
                return -code error "error: unexpected kind $kind in get_signals"
            }
        }
        return $signals
    }

    proc lookUpModuleCache { subcmd mod } {
        variable _ModuleCache
        if { [info exists _ModuleCache($mod,$subcmd)] } {
            return $_ModuleCache($mod,$subcmd)
        }
        set _ModuleCache($mod,$subcmd) [Bluetcl::submodule $subcmd $mod]
        return $_ModuleCache($mod,$subcmd)
    }

    proc getPortTypesForInstance {  instKind module inst } {
        switch $instKind {
            "Primitive"   {
                set ports [lookUpModuleCache porttypes $module]
                set detail [TypeSupport::findKey $inst $ports]
                return [lindex [TypeSupport::findKey ports $detail] 1]
            }
            "Synthesized" { return [Bluetcl::module porttypes $module]}
            default       { return [list] }
        }
    }


    # show the instance hierarchy  useful in test and debug.
    proc show_hierarchy { {k 0} { prefix ""} } {
        set D(Name) ""
        set D(Module) ""
        set D(Interface) ""
        set D(SynthPath) ""

        set children [Bluetcl::browseinst list $k]
        array set D [Bluetcl::browseinst detail $k]
        #parray D

        if { $D(Node) eq "Rule" } {
            set D(Module) Rule
            lappend D(SynthPath) $D(RuleName)
        }

        if { $D(Node) ne "ROOT" } {
            set fullpath  [join $D(BSVPath) "."]
            puts [format "%s%-15s\t -- %s %s\t%s " $prefix $D(Name) $D(Module) $D(Interface)  [join $D(SynthPath) "."]]
        }

        foreach child $children {
            set key [lindex $child 0]
            show_hierarchy  $key "$prefix    "
        }
    }


    proc lookup_method_signals {vinst meth} {
        variable _MethodSignals
        if {[array size _MethodSignals] == 0} {
            generate_method_cache

        }
        set mod  [$vinst modname]
        set inst [$vinst name synth]
        if {[info exists _MethodSignals($mod,$inst,$meth)]} {
            return $_MethodSignals($mod,$inst,$meth)
        }
        return [list]
    }
    proc lookup_methods_on_inst {vinst} {
        variable _MethodSignals
        if {[array size _MethodSignals] == 0} {
            generate_method_cache
        }
        set mod [$vinst modname]
        set inst [$vinst name synth]
        set keys [array names _MethodSignals "$mod,$inst,*"]
        proc takethird {n} { lindex [split $n ","] 2 }
        utils::nub [utils::map takethird $keys]
    }
    proc generate_method_cache {} {
        variable _MethodSignals
        foreach mod [Bluetcl::module list] {
            foreach port [Bluetcl::submodule full $mod] {
                set rest [lassign $port inst modc]
                set mlist [get_tag_from_list $rest mports]
                utils::map "analyze_method {$inst} {$modc}" $mlist
            }
        }
    }
    proc analyze_method {inst mod methport } {
        variable _MethodSignals
        lassign $methport meth port
        lappend _MethodSignals($mod,$inst,$meth) $port
    }

    proc lookup_signal_usage {vsig} {
        variable _SignalUsage
        if {[array size _SignalUsage] == 0} {
            generate_signal_usage
        }
        if {[info exists _SignalUsage($vsig)] } {
            return [utils::nub $_SignalUsage($vsig)]
        }
        return [list]
    }

    proc lookup_method_usage {vmeth} {
        variable _MethodUsage
        if {[array size _MethodUsage] == 0} {
            generate_signal_usage
        }
        if {[info exists _MethodUsage($vmeth)] } {
            return $_MethodUsage($vmeth)
        }
        return [list]
    }

    proc generate_signal_usage {} {
        variable _SignalUsage
        variable _MethodUsage
        catch "array unset _SignalUsage"
        catch "array unset _MethodUsage"
        array set _SignalUsage [list]
        array set _MethodUsage [list]

        # insure that all VRules are generated
        inst filter -kind Rule *
        foreach m [inst filter -kind Synth *] {
            $m portmethods
        }

        foreach rx [itcl::find objects -class VRule] {
            set r [$rx thisname]

            set ms [$r predmethods]
            eval lappend ms [$r bodymethods]
            foreach vmeth [utils::nub $ms] {
                lappend _MethodUsage($vmeth) $r
            }

            # Can and Will fire signals
            set ss [$r signals]
            eval lappend ss [$r predsignals]
            eval lappend ss [$r bodysignals]
            foreach vsig [utils::nub $ss] {
                lappend _SignalUsage($vsig) $r
            }
        }
    }

    proc set_boundary { path inst } {
        variable _Boundary
        set _Boundary($path) $inst
    }
    proc lookup_boundary { path } {
        variable _Boundary
        if {![info exists _Boundary($path)] } {
            inst filter $path
            if { ![info exists _Boundary($path)] } {
                return ""
            }
        }
        return $_Boundary($path)
    }


    proc get_tag_from_list {list tag} {
        lindex [lsearch -inline -index 0 -exact $list $tag] 1
    }

    ################################################################################
    ###
    ################################################################################
    proc reset {} {
        variable _signal_count
        variable _signal_map
        variable _inst_map
        variable _MethodSignals
        variable _InstSearch
        variable _Boundary
        variable _Method_map
        variable _Rule_map
        variable _SignalUsage
        variable _MethodUsage
        variable _ModuleCache

        foreach c [list VInst VSignal VMethod VRule] {
            set sobjs [itcl::find objects -class $c]
            eval "itcl::delete object $sobjs"
        }

        set _signal_count 0
        catch "array unset _signal_map"
        catch "array unset _inst_map"
        catch "array unset _MethodSignals"
        catch "array unset _InstSearch"
        catch "array unset _Boundary"
        catch "array unset _Method_map"
        catch "array unset _Rule_map"
        catch "array unset _SignalUsage"
        catch "array unset _MethodUsage"
        catch "array unset _ModuleCache"

        array set _signal_map [list]
        array set _inst_map [list]
        array set _InstSearch [list]
        array set _Boundary [list]
        array set _MethodSignals [list]
        array set _Method_map [list]
        array set _Rule_map [list]
        array set _SignalUsage [list]
        array set _MethodUsage [list]
        array set _ModuleCache [list]

        Bluetcl::browseinst refresh
        Bluetcl::browseinst list 0
    }

    proc omap {options list} {
        set result [list]
        foreach item $list {
            lappend result [uplevel 1 $item $options ]
        }
        return $result
    }

    ################################################################################
    proc signal_outer {name kind inst type} {
        variable _signal_count
        variable _signal_map

        set iname [$inst name bsv]
        if { [info exists _signal_map($inst,$name)]  } {
            set sig $_signal_map($inst,$name)
        } else {
            set key $_signal_count
            incr _signal_count

            set Smem(key)  $key
            set Smem(kind) $kind
            set Smem(name) $name
            set Smem(type) $type
            set Smem(inst) $inst

            set sig [uplevel #0 ::Virtual::VSignal #auto [array get Smem]]

            set _signal_map($inst,$name) $sig
        }
        return $sig
    }

    ################################################################################
    proc preorder_traversef { predicatef object } {
        set ret [list]
        if {[uplevel 1 $predicatef $object]} {
            lappend ret $object
        }
        foreach child [$object children] {
            set ret [concat $ret [preorder_traversef $predicatef $child]]
        }
        return $ret
    }

    proc do_inst_filter { args } {
        variable _InstSearch
        if {[info exists _InstSearch([join $args ","])]} {
            return $_InstSearch([join $args ","])
        }

        set BoolOptions [list -regexp]
        set ValOptions  [list  -kind -nametype]
        array set OPT   [list -nametype bsv]
        if { [catch [list ::utils::scanOptions $BoolOptions $ValOptions true OPT [join $args]] opts] } {
            return -code error "Error in 'inst filter' arguments: $opts"
        }
        # More checking on options
        if { [info exist OPT(-kind)] } {
            if  { [string first  "%$OPT(-kind)%"  "%Rule%Prim%Synth%Inst%" ] == -1} {
                error "Unsupported argument to -kind option `$OPT(-kind)', must be `Rule', `Synth', `Prim' or `Inst'"
            }
        }
        if { [info exist OPT(-nametype)] } {
            if  { [string first  "%$OPT(-nametype)%"  "%bsv%synth%" ] == -1} {
                error "Unsupported argument to -nametype option `$OPT(-nametype)', must be `bsv' or `synth'"
            }
        }
        if { [llength $opts] != 1 } {
            error "inst filter: Expected a search expression, found `$opts'"
        }
        set sfunc globsearch
        if {[info exists OPT(-regexp)]} {
            set sfunc regexsearch
        }

        set opts [string trim $opts "{}"]
        set search [split $opts "/"]
        if { [llength $search] == 1 } {
            set sp ""
            set si $opts
        } else {
            set sp [join [lrange $search 0 end-1] /]/
            if { $sp eq "" } { set sp "/" }
            set si [lindex $search end]
        }
        #puts "Inst search $args --> `$sp' `$si'"
        if { $si eq "" } {
            set _InstSearch([join $args ","]) [inst top]
            return [inst top]
        }
        set allnames [preorder_traversef [list $sfunc $sp $si $OPT(-nametype)] [inst top]]

        if {[info exists OPT(-kind)]} {
            set afterfilter [list]
            foreach n $allnames {
                if {[string equal $OPT(-kind) [$n kind]]} {
                    lappend afterfilter $n
                }
            set allnames $afterfilter
            }
        }
        set _InstSearch([join $args ","]) $allnames
        return $allnames
    }

    proc globsearch {glbp glbi nt obj } {
        set ps [split [$obj path $nt] "/"]
        set p [join [lrange $ps 0 end-1] /]/
        set i [lindex $ps end]

        #puts -nonewline "GS: `$p' `$i'  [$obj path bsv]   $nt "
        if { $glbp ne "" } {
            if { [string match $glbp $p] == 0 } {
                #puts " >>> Failed PATH"
                return false
            }
        }
        set r [string match $glbi $i]
        #puts " >>> $r"
        return $r
    }

    proc regexsearch {regp regi nt obj } {
        set ps [split [$obj path $nt] "/"]
        set p [join [lrange $ps 0 end-1] /]/
        set i [lindex $ps end]

        if { $regp ne "" } {
            if { [regexp $regp $p] == 0 } {
                return false
            }
        }
        set r [regexp $regi $i]
        return $r
    }

    ################################################################################
    # signal find
    ################################################################################

    proc signal { op args } {
        set l [llength $args]
        switch -exact -- $op {
            filter {
                do_signal_filter $args
            }
            default {
                return -code error "signal: expecting find"
            }
        }
    }

    proc do_signal_filter { args } {
        set BoolOptions [list -regexp]
        set ValOptions  [list -nametype -inst]
        array set OPT   [list -nametype bsv]

        if { [catch [list ::utils::scanOptions $BoolOptions $ValOptions true OPT [join $args]] opts] } {
            return -code error "Error signal filter: $opts"
        }
        if { [info exist OPT(-nametype)] } {
            if  { [string first  "%$OPT(-nametype)%"  "%bsv%synth%" ] == -1} {
                error "Unsupported argument to -nametype option `$OPT(-nametype)', must be `bsv' or `synth'"
            }
        }
        set opts [join $opts]
        if { [llength $opts] != 1 } {
            error "signal filter: Expected a search expression, found `$opts'"
        }
        set parts [split $opts /]
        set pbreak [string last / $opts]
        set path2 [string range $opts 0 $pbreak]

        set path [join [lrange $parts 0 end-1] /]
        set name [lindex $parts end]

        set inst_search_args ""
        foreach x [list -nametype] {
            if { [info exists OPT($x)] } { append inst_search_args " $x $OPT($x)" }
        }
        foreach x [list -regexp] {
            if { [info exists OPT($x)] } { append inst_search_args " $x" }
        }

        #puts "Signal search $args -- '$opts' '$parts' `$path'  `$name'"
        if {$path eq "" } {
            set path $path2
            if { $path eq "" } {
                set path "*"
            }
        }
        if { [info exists OPT(-inst)] } {
            set insts $OPT(-inst)
            foreach i $insts {
                if { [catch [list $i isa ::Virtual::VInst] err] || ! $err } {
                    error "signal filter -inst argumenet `$i' is not a valid instance"
                }
            }
        } else {
            set insts [eval Virtual::inst filter $inst_search_args {$path}]
        }
        my_signals_with_name OPT $name $insts
    }

   proc my_signals_with_name { oname pattern insts } {
        upvar $oname OPT
        set answer [list]
        set sigs [join [Virtual::omap signals $insts]]
        foreach s $sigs {
            if { [info exists OPT(-regexp)] } {
                if {[regexp $pattern [$s name]]} {
                    lappend answer $s
                }
            } else {
                if {[string match $pattern [$s name]]} {
                    lappend answer $s
                }
            }
        }
        return $answer
    }

    ############################################################################
    ############################################################################
    catch "itcl::delete class VInst"
    itcl::class VInst {
    inherit ::VisitorPattern::Acceptor
        private {
            variable _key ""
            variable _parent ""
            variable _kind ""
            variable _name ""
            variable _module ""
            variable _bsvmodule ""
            variable _name_synth ""
            variable _hier ""
            variable _hier_synth [list]
            variable _position ""
            variable _interface ""
            variable _rule ""
            variable Memoize
            common   _methods [list key kind position name path signals bodysignals predsignals children parent class module methods wave_format ancestors rule]

        }
        constructor {key {parent ""}} {
            set _key $key
            set _parent $parent

            if { [catch "Bluetcl::browseinst detail $key" det] } {
                if { [Bluetcl::module list] eq [list] } {
                    error "No modules have been loaded"
                }
                return -code error "error (1): inst with key '$key' does not exist"
            }
            array set Detail $det
            array set Memoize [list]
            set _kind $Detail(Node)

            set _name $Detail(Name)
            set _bsvmodule $Detail(BSVModule)
            set _module ""
            if ([info exists Detail(Module)]) {
                set _module $Detail(Module)
                #kind=Instance appear to have no Module
            }
            if ([info exists Detail(Interface)]) {
                set _interface $Detail(Interface)
            }

            if { $_kind == "Rule" } {
                set _name_synth   $Detail(RuleName)
                set _hier         [create_path $Detail(BSVPath)]
                set _hier_synth   [create_path $Detail(SynthPath)]
                set _rule         [Virtual::create_rule [thisname] $_name_synth]
            } elseif { $_kind == "Primitive" } {
                set _name_synth   $Detail(UniqueName)
                set _hier         [create_path $Detail(BSVPath)]
                set _hier_synth   [create_path $Detail(SynthPath)]
                Virtual::set_boundary $_hier_synth [thisname]
            } elseif { $_kind == "Synthesized" } {
                set _name_synth   $Detail(UniqueName)
                set _hier         [create_path $Detail(BSVPath)]
                set _hier_synth   [create_path $Detail(SynthPath)]
                Virtual::set_boundary $_hier_synth [thisname]
            } elseif { $_kind == "Instance" } {
                set _name_synth   $Detail(Name)
                set _hier         [create_path $Detail(BSVPath)]
                set _hier_synth   [create_path $Detail(SynthPath)]
            } else {
                puts stderr "Unrecognized kind = $_kind"
            }
            if {[info exists Detail(position)]} {
                set _position $Detail(position)
            }
        }
        public {
            method key      {} {return $_key}
            method position {} {return $_position}
            method kind     {} {
                switch -exact -- $_kind {
                    Primitive   {return Prim}
                    Synthesized {return Synth}
                    Instance    {return Inst}
                    Rule        {return Rule}
                    default     {error "Unexpected kind `$_kind' found in instance `[path]'"}
                }
            }
            method name { {family bsv} } {
                switch -exact -- $family {
                    "bsv" {return $_name}
                    "synth" {return  $_name_synth}
                    default  {error "Unexpected arguments '$family' in name. Expected just 'bsv' or 'synth."
                    }
                }
            }
            method path { {family bsv}} {
                switch -exact -- $family {
                    "bsv"    {return $_hier}
                    "synth"  {return $_hier_synth}
                    default  {error "Unexpected arguments '$family' in path method. Expected just 'bsv' or 'synth."
                    }
                }
            }
            method show {} {
                path
            }
            method signals {} {
                if {[info exists Memoize(signals)]} {
                    return $Memoize(signals)
                } else {
                    set Memoize(signals) [Virtual::get_signals $_kind $_bsvmodule $_name_synth [$this thisname]]
                    return $Memoize(signals)
                }
            }
            method predsignals  {} {
                if {[info exists Memoize(predsignals)]} {
                    return $Memoize(predsignals)
                } else {
                    set Memoize(predsignals) [join [Virtual::omap signals [predmethods]]]
                    return $Memoize(predsignals)
                }
            }
            method bodysignals {} {
                if {[info exists Memoize(bodysignals)]} {
                    return $Memoize(bodysignals)
                } else {
                    set Memoize(bodysignals) [join [Virtual::omap signals [bodymethods]]]
                    return $Memoize(bodysignals)
                }
            }
            method predmethods {} {
                if {$_rule eq ""} {
                    return [list]
                }
                $_rule predmethods
            }
            method bodymethods {} {
                if {$_rule eq ""} {
                    return [list]
                }
                $_rule bodymethods
            }
            method portmethods {} {
                if {![info exists Memoize(portmethods)]} {
                    set ms [Virtual::lookup_methods_on_inst [thisname]]
                    set Memoize(portmethods) [list]
                    foreach m $ms {
                        eval lappend Memoize(portmethods) [Virtual::create_method [path synth] $m]
                    }
                }
                return $Memoize(portmethods)
            }
            method children {} {
                if {[info exists Memoize(children)]} {
                    return $Memoize(children)
                } else {
                    if { [catch "Bluetcl::browseinst list $_key" chldrn] } {
                        return -code error "error (2): inst with key '$_key' does not exist"
                    }
                    set Memoize(children) [list]
                    foreach ch [utils::map utils::fst $chldrn] {
                        lappend Memoize(children) [Virtual::inst_key_get_or_create $ch [$this thisname]]
                    }
                    return $Memoize(children)
                }
            }
            method interface {} {
                return $_interface
            }
            method parent {} {return $_parent}
            method module {} {return $_bsvmodule}
            method modname {} {return $_module}
            method hiertree {} {
                set tags [list]
                set name [$this name bsv]
                set ifc  [utils::unQualType [$this interface]]
                switch -exact -- $_kind {
                    Primitive   	{
                        lappend tags "prim" "leaf"
                        if { $ifc ne "" } { lappend name $ifc }
                    }
                    Synthesized 	{
                        lappend tags "synth" "branch"
                        if { $ifc ne "" } { lappend name $ifc }
                    }
                    Rule        	{
                        lappend tags "rule" "leaf"
                    }
                    default 		{}
                }
                return [list [$this thisname] [join $name "  "] $tags]
            }
            method wave_format {{modifier ALL}} {
                switch -exact -- $_kind {
                    Primitive 	{set tsigs [wave_format_prim $modifier]}
                    Synthesized {set tsigs [wave_format_syn $modifier]}
                    Instance    {set tsigs [list]}
                    Rule 	{set tsigs [wave_format_rule $modifier]}
                    default {error "Unexpected kind $_kind in [info level 0]"}
                }
                return $tsigs
            }

            method ancestors {} {
                set ret [list [thisname]]
                set p [$this parent]
                while { $p ne "" } {
                    lappend ret $p
                    set p [$p parent]
                }
                lreverse $ret
            }

            method methods {} {
                return $_methods
            }
            method rule {} { return $_rule }
            method class {} {namespace tail [$this info class]}
        }
        private {
            proc create_path { paths } {
                set p [join [concat $paths] "/"]
                return "/[string trim $p "/"]"
            }
            proc correct_hier {lin hier} {
                set tsigs [list]
                foreach st $lin {
                    set s [lindex $st 0]
                    set t [lindex $st 1]
                    set n [create_path [concat $hier $s]]
                    lappend tsigs [list $t $n]
                }
                return $tsigs
            }
            method thisname {} { string trimleft $this ":" }

            method wave_format_prim {modifier} {
                set rawSTs [::Virtual::getPortTypesForInstance $_kind $_bsvmodule $_name_synth]

                set hier [join [concat $_hier_synth $_name_synth] "/"]
                regsub {/[^/]+$} $hier "" hier
                set tsigs  [correct_hier $rawSTs $hier]
                switch $modifier {
                    ALL {
                        set tsigs [lsearch -regexp -all -inline -index 0 -not $tsigs "^Clock$|^Reset$"]
                    }
                    CLK {
                        set tsigs [lsearch -regexp -all -inline -index 0 $tsigs "^Clock$|^Reset$"]
                    }
                    QOUT {
                        set tsigs [lsearch -regexp -all -inline -index 1 $tsigs "Q_OUT"]
                    }
                    TEST {
                    }
                    default {set tsigs [list] }
                }
                set tsigs [TypeSupport::correct_primitive_names $_module $tsigs]
                return $tsigs
            }
            method wave_format_syn {modifier} {
                set rawSTs [Virtual::getPortTypesForInstance $_kind $_bsvmodule $_name_synth]
                set hier [join $_hier_synth "/"]
                set tsigs [correct_hier $rawSTs $hier]
                switch $modifier {
                    ALL {
                        set tsigs [lsearch -regexp -all -inline -index 0 -not $tsigs "^Clock$|^Reset$"]
                    }
                    CLK {
                        set tsigs [lsearch -regexp -all -inline -index 0 $tsigs "^Clock$|^Reset$"]
                    }
                    TEST {
                    }
                    default {set tsigs [list] }
                }
                return $tsigs
            }
            method wave_format_rule {modifier} {
                set rule_name $_name_synth
                set already_sent 0
                set prefixes [list]
                set tsigs [list]
                switch $modifier {
                    "CANFIRE" {
                        set prefixes [list CAN_FIRE] }
                    "WILLFIRE" {
                        set prefixes [list WILL_FIRE] }
                    "ALL" {
                        set prefixes [list CAN_FIRE WILL_FIRE] }
                    "PREDICATE" {
                        set predsignals [$this predsignals]
                        set tsigs [join [Virtual::omap wave_format $predsignals]]
                    }
                    "BODY" {
                        set bodysignals [$this bodysignals]
                        set tsigs [join [Virtual::omap wave_format $bodysignals]]
                    }
                    "TEST" {
                        set prefixes [list CAN_FIRE WILL_FIRE] }
                    default {
                        set prefixes [list] }
                    }
                foreach pre $prefixes  {
                    set rname ${pre}_${rule_name}
                    lappend tsigs [list "Bool" [create_path [concat $_hier_synth $rname]]]
                }
                return $tsigs
            }
        }
    }


    catch "itcl::delete class VSignal"
    itcl::class VSignal {
        inherit ::VisitorPattern::Acceptor
        private {
            variable Smem
            common methods [list key kind name path type inst wave_format methods position class]
        }
        constructor {args} {
            array set Smem $args
        }
        public {
            method key {}   {return $Smem(key)}
            method kind {}  {return $Smem(kind)}
            method name {}  {return $Smem(name)}
            method thisname {} { string trimleft $this ":" }
            method path {{family bsv}}  {
                create_path [list [$Smem(inst) path $family] $Smem(name)]
            }
            method type {} {return $Smem(type)}
            method inst {} {return $Smem(inst)}
            method position {} {return [$Smem(inst) position]}
            method wave_format {{modifier ALL}} {
                set tsigs [list]
                if { [filter_test $modifier] } {
                    set tsigs [list [list $Smem(type) [create_path [list [$Smem(inst) path synth] $Smem(name)]]]]
                }
                if {[$Smem(inst) kind] eq "Prim"} {
                    set tsigs [TypeSupport::correct_primitive_names [$Smem(inst) modname] $tsigs]
                }
                return $tsigs
            }

            method used_by {} {Virtual::lookup_signal_usage [thisname]}
            method methods {} {return $methods}
            method class {} {namespace tail [$this info class]}
            method filter_test { modifier } {
                switch -exact $modifier {
                    "ALL" { return true }
                    "WILLFIRE" { return [regexp "^WILL_FIRE" [name]] }
                    "CANFIRE"  { return [regexp "^CAN_FIRE" [name]] }
                    "CLK"      { return [regexp "CLK" [name]] }
                    "QOUT"     { return 1 }
                    "PREDICATE"    { return 0 }
                    "BODY"         { return 0 }
                }
            }
            method show {} {
                create_path [list [$Smem(inst) path] $Smem(name)]
            }
        }
        private {
            proc create_path { paths } {
                set p [join [concat $paths] "/"]
                return "/[string trim $p "/"]"
            }
        }

    }

    catch "itcl::delete class VMethod"
    itcl::class VMethod {
        inherit ::VisitorPattern::Acceptor
        private {
            variable _inst ""
            variable _meth ""
            variable _rule ""
            variable Memoize
            common _methods [list name path inst signals wave_format class position rule ready enable]
        }
        constructor {inst meth args} {
            set _inst $inst
            set _meth $meth
            # Synthesized methods have interfaces which are rules

            set isRDY [regexp {^RDY_} $meth]
            if { $isRDY } {
                set _rule ""
            } elseif { [$_inst kind] == "Synth"} {
                set _rule [Virtual::create_rule $inst $meth]
            }

        }
        destructor {
        }
        public {
            method inst {} { return $_inst }
            method name {} { return $_meth }
            method position {} { return [$_inst position] }
            method path {{family bsv}} {
                $_inst path $family
            }
            method signals {} {
                if { ![info exists Memoize(signals)] } {
                    utils::listToSet PosSigs [Virtual::lookup_method_signals $_inst $_meth]
                    set ret [list]
                    foreach sig [$_inst signals] {
                        if { [info exists PosSigs([$sig name])] } {
                            lappend ret $sig
                        }
                    }
                    set Memoize(signals) [utils::nub $ret]
                }
                return $Memoize(signals)
            }
            method wave_format {{modifier ALL}} {
                join [Virtual::omap "wave_format $modifier" [signals]]
            }
            method used_by {} {Virtual::lookup_method_usage [thisname]}
            method ready {} {
                if { $_rule eq "" } { return "" }
                $_rule canfire
            }
            method enable {} {
                if { $_rule eq "" } { return "" }
                $_rule willfire
            }
            method predmethods {} {
                if { $_rule eq "" } { return "" }
                $_rule predmethods
            }
            method bodymethods {} {
                if { $_rule eq "" } { return "" }
                $_rule bodymethods
            }
            method allmethods {} {
                if { $_rule eq "" } { return "" }
                utils::nub [concat [$_rule bodymethods] [$_rule predmethods]]
            }
            method class {} {namespace tail [$this info class]}
            method rule {} { return $_rule }
            method thisname {} { string trimleft $this ":" }
            method show {} {
                format "%s.%s" [$_inst path] $_meth
            }
        }
    }

    # Synthesis name...   can return "" for hidden instances
    proc create_method {iname meth} {
        variable _Method_map
        set key "$iname.$meth"
        if { ![info exist _Method_map($key)] } {
            set vinst [Virtual::lookup_boundary $iname]
            if { $vinst eq "" } {
                return ""
            }
            set vm [uplevel #0 ::Virtual::VMethod #auto $vinst $meth]
            set _Method_map($key) $vm
        }
        return $_Method_map($key)
    }

    proc method_filter { bsviname meth } {
        set iobj [inst filter $bsviname]
        if { [llength $iobj] != 1 } { return ""}
        create_method [$iobj path synth] $meth
    }


    ################################################################
    ## Rule Objects  seperate from VInst
    ################################################################
    catch "itcl::delete class VRule"
    itcl::class VRule {
        inherit ::VisitorPattern::Acceptor
        private {
            variable _inst ""
            variable _name ""
            variable _kind ""
            variable _position ""
            variable _predicate ""
            variable _predmethods [list]
            variable _bodymethods [list]
            variable _canfire ""
            variable _willfire ""
            variable _methodsBuilt false
            variable _ruleinfo ""
            common _methods [list class inst name kind position predicate predmethods bodymethods signals canfire willfire]
        }
        constructor {inst name} {
            set _name $name
            set _inst $inst

            set mod [$inst module]
            set _ruleinfo [Bluetcl::rule full $mod $name]
            switch -exact [lindex $_ruleinfo 0] {
                "method" { set _kind Method }
                "rule"   { set _kind Rule }
                default  {return -code error "error: unexpected rule type: $inst/$name -> $_ruleinfo"}
            }
            set _position [Virtual::get_tag_from_list $_ruleinfo "position"]
            set _predicate [Virtual::get_tag_from_list $_ruleinfo "predicate"]

            set _canfire [Virtual::signal_outer "CAN_FIRE_$name" "CanFire" $_inst  "Bool"]
            set _willfire [Virtual::signal_outer "WILL_FIRE_$name" "WillFire" $_inst  "Bool"]
        }
        destructor {
        }
        private {
            method build_methods {} {
                set mod [$_inst module]
                set methds  [Virtual::get_tag_from_list $_ruleinfo "methods"]
                set spath [$_inst path synth]
                set _predmethods [create_methods_for_rule $spath  [lindex $methds 0]]
                set _bodymethods [create_methods_for_rule $spath [lindex $methds 1]]

                set _methodsBuilt true
            }
        }
        public {
            method thisname {} { string trimleft $this ":" }
            method inst {} {return $_inst }
            method name {} { return $_name }
            method kind {} { return $_kind }
            method position {} { return $_position }
            method predicate {} { return $_predicate }
            method predmethods {} {
                if { ! $_methodsBuilt } {
                    build_methods
                }
                return $_predmethods
            }
            method bodymethods {} {
                if { ! $_methodsBuilt } {
                    build_methods
                }
                return $_bodymethods
            }
            method signals {} { return [list $_canfire $_willfire] }
            method class {} {namespace tail [$this info class]}
            method canfire {} { return $_canfire }
            method willfire {} { return $_willfire }
            method predsignals {} {
                set ret [list]
                foreach m [predmethods] {
                    eval lappend ret [$m signals]
                }
                return $ret
            }
            method bodysignals {} {
                set ret [list]
                foreach m [bodymethods] {
                    eval lappend ret [$m signals]
                }
                return $ret
            }
            method wave_format {{modifier ALL}} {
                join [Virtual::omap "wave_format $modifier" [signals]]
            }
            method path { {family bsv}} {
                $_inst path $family
            }
            method show {} {
                switch -exact $_kind {
                    "Rule" { return [format "%s" [$_inst path]] }
                    "Method" { return [format "%s.%s()" [$_inst path] $_name] }
                    default { return -cide error "Unexpected kind ($_kind) in VRule" }
                }
            }
        }
        private {
            proc create_methods_for_rule {synthpath mlist} {
                set ret [list]
                foreach m $mlist {
                    lassign [split $m .] inst meth
                    set iname [join [list $synthpath $inst] "/"]
                    regsub {//} $iname "/" iname
                    # create method can return "" for hidden modules
                    eval lappend ret [Virtual::create_method $iname $meth]
                }
                return [utils::nub $ret]
            }
        }

    }
    # instance object, name string
    proc create_rule {inst name} {
        variable _Rule_map
        set key $inst.$name
        if { ![info exist _Rule_map($key)] } {
            set vr [uplevel #0 ::Virtual::VRule #auto $inst $name]
            set _Rule_map($key) $vr
        }
        return $_Rule_map($key)
    }

    ################################################################
    ## Debug and data management
    ################################################################
    proc reset_hook {commandStr code result op} {
        set subcmd [lindex $commandStr 1]

        # reload hierarchy and search on reload
        if {-1 != [lsearch -exact [list "load" "clear"] $subcmd] } {
            reset
        }
        return $result
    }

    proc debug_trace {msg} {
        variable _Method_map
        variable _Boundary
        variable _signal_map
        variable _MethodUsage

        puts stderr $msg
        set l [info level]
        for { set i $l } { $i > 0} {incr i -1} {
            puts stderr " $i:  [info level $i]"
        }
        parray _Method_map
        parray _Boundary
        parray _signal_map

        parray _MethodUsage
        foreach {m r} [array get _MethodUsage] {
            puts "[$m path] -> [Virtual::omap show $r]"
        }

        foreach i [itcl::find objects -class VInst] {
            puts stderr "$i [$i path bsv] \t [$i path synth]"
        }

        return ""
    }

    trace add execution Bluetcl::module [list leave] [namespace code reset_hook]
    reset
}

##############################################
## Type names, and optional attributes from Interface
proc ::Virtual::createType { name {attrs {}} } {

    ## Special case handling for variables
    if { [regexp {^[a-z]\w*$} $name var ]  } {
        if {[lsearch -exact [list bit int] $var ] == -1 } {
            set obj [uplevel #0 [list ::Virtual::VVariable #auto $var]]
            return ::$obj
        }
    }

    if { [regexp {^Action$} $name unused ]  } {
        set obj [uplevel #0 [list ::Virtual::VAction #auto $name]]
        return ::$obj
    }

    if { [regexp {^ActionValue\s*#\s*\((.*)\s*\)$} $name unused subt ]  } {
        set nanme [regsub -all " " $name ""]
        set obj [uplevel #0 [list ::Virtual::VActionValue #auto $name $subt]]
        return ::$obj
    }

    ## Special case handling for function
    if { [regexp {((?:function)|(?:method))\s+(\w+(?:\s*#\s*\(.*\))?)\s+(\w+)\s*\((.*)\)} $name unused fORm rt nm ags] } {
        if { $fORm == "method" } {
            set obj [uplevel #0 [list ::Virtual::VMethodType  #auto $nm $rt $ags $attrs ]]
        } else {
            set obj [uplevel #0 [list ::Virtual::VFunctionType #auto $nm $rt [list $ags]]]
        }
        return ::$obj
    }

    # if we are given a type, deal with it here,  e.g.  Tuple2
    if { [catch [list Bluetcl::type constr $name] constr] } {
        set constr $name
    } else {
    }
    set full  [Bluetcl::type full "$constr"]
    set kind [lindex $full 0]
    set name [regsub -all " " $name ""]
    set obj [switch -exact $kind {
        Primary     {uplevel #0 [list ::Virtual::VPrimary     #auto $name $full]}
        Alias       {uplevel #0 [list ::Virtual::VAlias       #auto $name $full]}
        Enum        {uplevel #0 [list ::Virtual::VEnum        #auto $name $full]}
        Struct      {uplevel #0 [list ::Virtual::VStruct      #auto $name $full]}
        Interface   {uplevel #0 [list ::Virtual::VInterface   #auto $name $full $attrs]}
        TaggedUnion {uplevel #0 [list ::Virtual::VTaggedUnion #auto $name $full]}
        Typeclass   {uplevel #0 [list ::Virtual::VTypeclass   #auto $name $full]}
        Vector      {uplevel #0 [list ::Virtual::VVector      #auto $name $full]}
        List        {uplevel #0 [list ::Virtual::VList        #auto $name $full]}
        Variable    {uplevel #0 [list ::Virtual::VVariable    #auto $name $full]}
        default { error "Unexpected type found -- $name --> $full" }
    }]
    return ::$obj
}

##############################################
proc ::Virtual::createMethod { nm rt ats attrs } {
    set obj [uplevel #0 [list ::Virtual::VMethodType #auto $nm $rt $ats $attrs]]
    return ::$obj
}

itcl::class ::Virtual::VType {
    inherit ::VisitorPattern::Acceptor
    variable type
    variable constr
    variable full
    variable kind "Unknown"
    variable position
    variable width -1
    variable polymorphic true
    variable members [list]

    constructor {ctype cfull} {
        set type $ctype
        set constr [lindex $cfull 1]
        set full  $cfull
        set kind  [lindex $full 0]
        set position [Virtual::get_tag_from_list $full "position"]
    }

    method getName     {} { return $type }
    method getConstr   {} { return $constr }
    method getPosition {} { return $position }
    method getWidth    {} { return $width }
    method getKind     {} { return $kind }
    method isPolymorphic {} { return $polymorphic }
    method getMembers  {} { return $members }
    method isAction    {} { return false }
    method show        {args} {
        return "$type"
    }
    method getTopType  {} {
        regsub {\#.*} $type ""
    }
    method getPrefixName { nameStr } { return false }
    method getPackages {} {
        set res [list]
        set q [utils::getQual $constr]
        if { $q ne "" } {
            lappend res $q
        }
        foreach m [getMembers] {
            set t [lindex $m 1]
            eval lappend res [$t getPackages]
        }
        utils::nub $res
    }
}

### Primary ###
itcl::class ::Virtual::VPrimary {
    inherit ::Virtual::VType
    constructor {ctype cfull} {
        chain $ctype $cfull
        set kind "Primary"
    } {
        if { [lsearch -exact $full "polymorphic"] == -1 } {
            set polymorphic false
        }
        set w [Virtual::get_tag_from_list $full "width"]
        if { $w != "" } {
            set width $w
        }
    }
}

### Alias ###
itcl::class ::Virtual::VAlias {
    inherit ::Virtual::VType
    variable subtype

    constructor {ctype cfull} {
        chain $ctype $cfull
        set kind "Alias"
    } {
        set x [lindex $full 2]
        set subtype     [::Virtual::createType $x]
        set polymorphic [$subtype isPolymorphic]
        set width       [$subtype getWidth]
    }
    method subtype {} { return $subtype }
    method show {} {
        $subtype show
    }
}

### Struct ###
itcl::class ::Virtual::VStruct {
    inherit ::Virtual::VType
    constructor {ctype cfull} {
        chain $ctype $cfull
        set kind "Struct"
    } {
        set p [lsearch -exact $full "polymorphic"]
        set polymorphic [expr $p != -1]
        set w [Virtual::get_tag_from_list $full "width"]
        if { $w != "" } {
            set width $w
        }
        foreach m [Virtual::get_tag_from_list $full members] {
            set st [::Virtual::createType [lindex $m 0] ]
            lappend members [list [lindex $m 1] $st]
        }
    }
}

### Interface ###
itcl::class ::Virtual::VInterface {
    inherit ::Virtual::VType
    variable iattrs [list]
    variable mattrs [list]
    constructor {ctype cfull attrs} {
        chain $ctype $cfull
        set kind "Interface"
    } {
        set p [lsearch -exact $full "polymorphic"]
        set polymorphic [expr $p != -1]
        set iattrs  [concat $attrs [Virtual::get_tag_from_list $full attributes]]
        set passAttrs [getPassAttrs]
        foreach m [Virtual::get_tag_from_list $full members] {
            set k [lindex $m 0]
            switch -exact $k {
                "method" {
                    set name [lindex $m 1 1]
                    set args  [lindex $m 1 2]
                    set mattr  [concat $passAttrs [lindex $m 1 3]]
                    set obj  [::Virtual::createMethod $name \
                                       [lindex $m 1 0] $args $mattr]
                }
                "interface" {
                    # interface Type name
                    set name [lindex $m 2]
                    set stype [lindex $m 1]
                    # interface attrs do not pass to other interfaces
                    set mattr  [lindex $m 3]
                    set obj  [::Virtual::createType $stype $mattr]
                }
                default {error "unexpected member in interface"}
            }
            lappend members [list $name $obj]
            lappend mattrs $mattrs
        }
    }
    method getAttributes {} { return $iattrs }

    # returns true if prefix name is defined
    method getPrefixName { nameStr } {
        upvar $nameStr  name
        regexp {prefix = "([A-Za-z0-9_]*)"} $iattrs unused name
    }
    method getMemberAttributes {} { return $mattrs }

    private method getPassAttrs {} {
        set ret [list]
        foreach a $iattrs {
            switch -regex $a {
                {always_ready}   { lappend ret $a }
                {always_enabled} { lappend ret $a }
                default {}
            }
        }
        return $ret
    }
}

### Tagged Unions ###
itcl::class ::Virtual::VTaggedUnion {
    inherit ::Virtual::VType
    constructor {ctype cfull} {
        chain $ctype $cfull
        set kind "TaggedUnion"
    } {
        set p [lsearch -exact $full "polymorphic"]
        set polymorphic [expr $p != -1]
        set w [Virtual::get_tag_from_list $full "width"]
        if { $w != "" } {
            set width $w
        }
        foreach m [Virtual::get_tag_from_list $full members] {
            set st [::Virtual::createType [lindex $m 0] ]
            lappend members [list [lindex $m 1] $st]
        }
    }
}

### Enums ###
itcl::class ::Virtual::VEnum {
    inherit ::Virtual::VType
    constructor {ctype cfull} {
        chain $ctype $cfull
        set kind "Enum"
    } {
        set polymorphic false
        set w [Virtual::get_tag_from_list $full "width"]
        if { $w != "" } {
            set width $w
        }
        set st [::Virtual::createType void]
        foreach m [Virtual::get_tag_from_list $full members] {
            lappend members [list $m $st]
        }
    }
}

itcl::class ::Virtual::VTypeclass {
    inherit ::Virtual::VType
    variable instances
    constructor {ctype cfull} {
        chain $ctype $cfull
        set kind "Typeclass"
    } {
        foreach m [Virtual::get_tag_from_list $full members] {
            set st [::Virtual::createType [lindex $m 0] ]
            lappend members [list [lindex $m 1] $st]
        }
        set instances [Virtual::get_tag_from_list $full instances]
    }
    method getInstance {} { return $instances } 
}

### Vector ###
itcl::class ::Virtual::VVector {
    inherit ::Virtual::VType
    variable subtype
    variable len -1
    constructor {ctype cfull} {
        chain $ctype $cfull
        set kind "Vector"
    } {
        set p [lsearch -exact $full "polymorphic"]
        set polymorphic [expr $p != -1]
        set len [Virtual::get_tag_from_list $full length]
        set st [Virtual::get_tag_from_list $full elem]
        set subtype [::Virtual::createType $st]
    }
    method getSubtype {} { return $subtype }
    method length  {} { return $len }
    method getPackages {} { list Vector }
}

### Vector ###
itcl::class ::Virtual::VList {
    inherit ::Virtual::VType
    variable subtype
    constructor {ctype cfull} {
        chain $ctype $cfull
        set kind "List"
    } {
        set p [lsearch -exact $full "polymorphic"]
        set polymorphic [expr $p != -1]
        set st [Virtual::get_tag_from_list $full elem]
        set subtype [::Virtual::createType $st]
    }
    method getSubtype {} { return $subtype }
    method getPackages {} { list List }
}

### Action ###
itcl::class ::Virtual::VAction {
    inherit ::Virtual::VType

    constructor {ctype} {
        chain $ctype [list]
        set kind "Action"
    } {
    }
    method isAction {} { return true }
}

### ActionValue ###
itcl::class ::Virtual::VActionValue {
    inherit ::Virtual::VType
    variable subtype
    constructor {ctype st} {
        chain $ctype [list]
        set kind "ActionValue"
    } {
        set subtype [::Virtual::createType $st]
    }
    method getSubtype {} { return $subtype }
    method isAction {} { return true }

}


### Variable ###
itcl::class ::Virtual::VVariable {
    inherit ::Virtual::VType
    constructor {name} {
        chain $name [list $name a]
        set kind "Variable"
    } {
    }
}

### functions and method ###
itcl::class ::Virtual::VFunctionMethod {
    inherit ::Virtual::VType

    variable retType
    variable argTypes [list]

    constructor {nm retT argsT} {
        chain $nm [list]
    } {
        set retType [::Virtual::createType $retT]
        foreach argT $argsT {
            while { [string length $argT] != 0 } {
                set r0 0
                if { [regexp -indices {((?:[A-Z]\w*::)?\w+(?:#\s*\(.*\))?)} $argT t1] } {
                    set ty [string range $argT [lindex $t1 0] [lindex $t1 1]]
                    lappend argTypes [::Virtual::createType $ty]
                    set r0 [expr 1 + [lindex $t1 1]]
                }
                if { [regexp -indices -start $r0 {(\w+(?:\s*,)?\s*)} $argT t1] } {
                    set r0  [expr 1 + [lindex $t1 1]]
                }
                set argT [string range $argT $r0 end]
            }
        }
    }
    method getReturnType {} {
        return $retType
    }
    method getArguments {} { return $argTypes }
    method isAction {}     { $retType isAction }

    method showFM {funcOrMeth} {
        set ags [list]
        set i 0
        foreach a $argTypes {
            lappend ags "[$a show] x[incr i]"
        }
        format "%s %s %s (%s)" $funcOrMeth [$retType show] $type \
             [join $ags ", "]
    }
}

itcl::class ::Virtual::VFunctionType {
    inherit ::Virtual::VFunctionMethod


    constructor {nm retT argT} {
        chain $nm $retT $argT
        set kind "Function"
    } {
    }
    method show {} {
        showFM "function"
    }
}

itcl::class ::Virtual::VMethodType {
    inherit ::Virtual::VFunctionMethod

    variable attributes [list]

    constructor {nm retT argT attrs} {
        chain $nm $retT $argT
        set kind "Method"
        set attributes $attrs
    } {
    }
    method show {} {
        showFM "method"
    }
    method getAttributes {} { return $attributes }

    method isAlwaysReady {} { regexp "always_ready" $attributes }
    method isAlwaysEnabled {} { regexp "always_enabled" $attributes }
    method getResultName {} {
        if { [regexp {result = "([A-Za-z0-9_]+)"} $attributes unused name] } {
            return $name
        }
        return ""
    }
    method getReadyName {} {
        if { [regexp {ready = "([A-Za-z0-9_]+)"} $attributes unused name] } {
            return $name
        }
        return ""
    }
    method getEnableName {} {
        if { [regexp {enable = "([A-Za-z0-9_]+)"} $attributes unused name] } {
            return $name
        }
        return ""
    }

    # returns true if name is defined
    method getPrefixName { nameStr } {
        upvar $nameStr  name
        regexp {prefix = "([A-Za-z0-9_]*)"} $attributes unused name
    }

    method getArgNames {} {
        #  E.g.  ports = ["value", "xx"]

        if { [regexp {ports = \[([^\]]*)\]} $attributes unused names] } {
            regsub -all {[",]} $names "" names
            return [split $names]
        }
        return ""
    }
}
