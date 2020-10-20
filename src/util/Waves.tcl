
namespace eval ::Waves {

    package require GtkWaveSupport
    package require NovasSupport
    package require TypeSupport
    package require Virtual
    package require Itcl

    namespace export \
        get_supported_wave_viewers \
        set_nonbsv_hierarchy \
        get_nonbsv_hierarchy \
        get_start_timeout \
        set_start_timeout \
        get_waveviewer \
        get_waveviewer_name \
        set_viewer_options \
        get_viewer_options \
        list_potential_viewers \
        open_xhost \
        get_dump_file_extensions \
        get_options_to_save \
        get_option \
        set_options \
	set_waveform_naming_mode \
	get_waveform_naming_mode \
	set_waveform_bool_mode \
	get_waveform_bool_mode \
        create_viewer \
        start_replay_viewer \


    # Static package global
    variable SupportViewers [list Novas GtkWave]
    # Display names for the viewers
    variable VNAMES
    set VNAMES(Novas) SpringSoft/Novas
    set VNAMES(Mentor) Mentor
    set VNAMES(GtkWave) GtkWave

    # user configurable options
    variable OPTS
    set OPTS(nonbsv_hierarchy) "/main/top"
    set OPTS(viewer) "GtkWave"
    set OPTS(Novas,Command) nWave
    set OPTS(Novas,Options) -nologo
    set OPTS(Mentor,Command)  "Not supported"
    set OPTS(Mentor,Options)  "Not supported"
    set OPTS(GtkWave,Command) gtkwave
    set OPTS(GtkWave,Options) {-W}
    set OPTS(DumpExtensions)  [list vcd fsdb fst wlf]
    set OPTS(StartTimeout) 20
    set OPTS(ExtendNameMode) 0
    set OPTS(BoolDisplayMode) 0

    variable debug 0

    proc set_nonbsv_hierarchy { hier } {
        variable OPTS
        regsub {[ \t/]+$} $hier "" hiercleaned
        set OPTS(nonbsv_hierarchy) $hiercleaned
        set_option_on_objects nonbsv_hierarchy  $hiercleaned
        return $hiercleaned
    }

    proc get_nonbsv_hierarchy {} {
        variable OPTS
        return $OPTS(nonbsv_hierarchy)
    }

    proc get_supported_wave_viewers {} {
        variable SupportViewers
        return $SupportViewers
    }

    # The currently selected or default wave viewer
    proc  get_waveviewer {} {
        variable OPTS
        return $OPTS(viewer)
    }

    proc get_waveviewer_name { v } {
        variable VNAMES
        if { [info exists VNAMES($v)] } {
            return $VNAMES($v)
        }
        return $v
    }

    # returns a list containing the command and the options for the waveviewer.
    # E.g.  { {Command  nWave} {Options {-nologo -licverdi}} }
    proc get_viewer_options { viewer } {
        variable OPTS
        set keys [array names OPTS $viewer*]
        set ret [list]
        foreach k $keys {
            regsub "$viewer," $k "" key
            lappend ret [list $key $OPTS($viewer,$key)]
        }
        return $ret
    }

    proc set_viewer_options { viewer args } {
        variable OPTS
        foreach {opt val} $args  {
            set OPTS($viewer,$opt) $val
            set_option_on_objects $opt $val $viewer
        }
    }

    proc get_options_to_save {} {
        variable OPTS
        set res [list]
        set ns [namespace current]
        foreach o [array names OPTS] {
              lappend res [format "%s::set_options {%s} {%s}" $ns $o $OPTS($o) ]
        }
        return [join $res "\n"]
    }

    proc set_options { args } {
        variable OPTS
        array set OPTS [concat $args]
    }

    proc set_option_on_objects { opt val { viewer "" } } {
        variable OPTS
        # find any existing viewer objects and change their options
        if { $viewer eq "" } {
            set viewer [list Novas GtkWave] 
        }
        foreach cl $viewer {
            foreach v [itcl::find object -class $cl] {
                catch "$v configure -$opt $val"
            }
        }
    }

    proc get_option { opt } {
        variable OPTS
        if { [info exists OPTS($opt)] } {
            return $OPTS($opt)
        } else {
            return ""
        }
    }

    proc set_waveform_naming_mode { mode } {
        variable OPTS
        set OPTS(ExtendNameMode) $mode
        set boolMode [string equal $::Waves::OPTS(ExtendNameMode) "extend"]
        set_option_on_objects ExtendNameMode $boolMode
        return $boolMode
    }

    proc get_waveform_naming_mode {} {
        variable OPTS
	return [set_waveform_naming_mode $OPTS(ExtendNameMode)]
    }

    proc set_waveform_bool_mode { mode } {
        variable OPTS
        set OPTS(BoolDisplayMode) $mode
	set boolMode  [string equal $::Waves::OPTS(BoolDisplayMode) "benum"]
        set_option_on_objects BoolDisplayMode $boolMode
        return $boolMode
    }

    proc get_waveform_bool_mode {} {
        variable OPTS
	return [set_waveform_bool_mode $OPTS(BoolDisplayMode)]
    }

    # internal use only
    proc dump {} {
        variable OPTS
        parray OPTS
    }

    # returns a list of file extension to include in the File Load dialog
    proc get_dump_file_extensions {} {
        variable OPTS
        return $OPTS(DumpExtensions)
    }


    proc get_start_timeout {} {
        variable OPTS
        return $OPTS(StartTimeout)
    }

    proc set_start_timeout { timeout } {
        variable OPTS
        if { [string is integer $timeout] == 1 } {
            set OPTS(StartTimeout) $timeout
            set_option_on_objects StartTimeout $timeout

        } else {
            error "Error: [info level 0]  timeout value must be an integer"
        }
        return $timeout
    }

    #####################################################################
    ## Interface to Specific viewers

    # returns a list of potential viewer which one can attach.
    proc list_potential_viewers {} {
        switch [get_waveviewer] {
            "Novas"   { NovasSupport::list_potential_viewers }
            "GtkWave" { GtkWaveSupport::list_potential_viewers }
            default { return [list] }
        }
    }


    proc fix_vcd_file { dumpfile } {
        global env
        if { [file exists $dumpfile] \
                 && [file writable $dumpfile] \
                 && [string equal -nocase ".vcd" [file extension $dumpfile]] \
                 && (([is_icarus_verilog $dumpfile]  && [vcd_has_no_spaces $dumpfile] )  || \
		     ([is_cvc_verilog $dumpfile]     && [vcd_has_zero_zero $dumpfile] &&  [get_waveviewer] == "GtkWaveXXXX" )) } {
            set fixvcd_exec $env(BDWDIR)/exec/fixvcd
            puts "RUNNING Script $fixvcd_exec on $dumpfile"
            update idletasks
            catch {set ignore [exec $fixvcd_exec $dumpfile]} value
        }
    }

    # returns true is the dump file was created by icarus verilog
    proc is_icarus_verilog { dumpfile } {
        if { [regexp {fsdb|wlf} [file extension $dumpfile]] } { return false }
        if { [catch {
            set ver [exec head -20 $dumpfile | grep -A1 -e {^$version}]
            regexp Icarus $ver
        } ver]  } {
            return false;
        }
        return $ver
    }

    # returns true is the dump file was created by cvc
    proc is_cvc_verilog { dumpfile } {
        if { [regexp {fsdb|wlf} [file extension $dumpfile]] } { return false }
        if { [catch {
            set ver [exec head -20 $dumpfile | grep -A1 -e {^$version}]
            regexp CVC $ver
        } ver]  } {
            return false;
        }
        return $ver
    }

    proc vcd_has_no_spaces {vcdfile} {
        # We want the vcd file to have spaces
        set patt {[A-Za-z](\[)([0-9]+:[0-9]+)\]}
        catch {
            set stat [exec grep -l -E $patt $vcdfile]
            return $stat
        } stat2
        if { $stat2 == $vcdfile } {
            return 1
        } else {
            return 0
        }
    }

    proc vcd_has_zero_zero {vcdfile} {
        return false
        # disable test,   gtkwave seems to be fixed.
        # We want the vcd file to not use [0:0] notation for one bit signals '
	# (an issue with gtkwave)
        # set patt {\[0:0\]}
        # catch {
        #     set stat [exec grep -l -E $patt $vcdfile]
        #     return $stat
        # } stat2
        # if { $stat2 == $vcdfile } {
        #     return 1
        # } else {
        #     return 0
        # }
    }

    proc start_replay_viewer  {args} {
        set OPT(-viewer) [get_waveviewer]
        set OPT(-backend) "-verilog"

        # Options processing
        set bOpt [list  -h -help --h --help]
        set vOpt [list -p -viewer -e -backend -start -attach]
        set vargs [utils::scanOptions $bOpt $vOpt false OPT [join $args]]

        foreach o [list -h -help --h --help] {
            if { [info exists OPT($o)] } {
                start_replay_usage [info level 0]
                exit 0
            }
        }
        if { ![info exists OPT(-e)] } {
            error "[info level 0] requires that the -e argument (top module) is set"
        }

        # Module loading and flags
        Bluetcl::flags set $OPT(-backend)
        if { [info exists OPT(-p)] } {
            eval Bluetcl::flags set -p $OPT(-p)
        }
        Bluetcl::module load $OPT(-e)
        # reset flags according to module's flags
        Bluetcl::flags reset
        eval Bluetcl::flags set [Bluetcl::module flags $OPT(-e) all]

        set viewer [eval create_viewer $OPT(-viewer) $vargs]
        return $viewer
    }
    proc start_replay_usage {cmd} {
        set str [list]
        lappend str \
            "Usage: $cmd <args>" \
            " Valid args are:"\
            "  -h -help --h --help" \
            "  -nonbsv-hierarchy <verilog_path>" \
            "  -viewer <viewer_class>" \
            "  -e <module_name>" \
            "  -attach <viewer>" \
            "  -start <true|false>" \
            "  -Command <viewer_shell_cmd>" \
            "  -Options <viewer_cmd_arguments>" \
            "  -ScriptFile <file>" \
            "  -DumpFile <file>" \
            "" \
            "Viewer classes are: $WaveViewer::Viewers" \
            "Examples" \
            " $cmd -viewer NovasRC -ScriptFile dump1.rc" \
            " $cmd -viewer Novas -attach Novas_1234" \
            " $cmd -viewer GtkWave -attach GtwWave" \

        # leave a blank line above to allow string to end
        puts stderr [join $str \n]
    }

    proc open_xhost {} {
        catch open_xhost_unsafe
    }
    proc open_xhost_unsafe {} {
        set xh [split [exec xhost] "\n"]
        foreach l [lrange $xh 1 end] {
            catch "exec xhost - $l"
        }
    }
    #########################################################################
    ## Test mode
    ## Mostly a sanity test to insure that everything we send to waves
    ## is found in the vcd file.
    ## Does not test that we are sending all the "right" signal.


    proc run_test { topmodule {vcdfile "dump.vcd"} {outfile "Wavestest.log"}} {

        set TestViewer [uplevel #0 Waves::TestMode #auto -ScriptFile $outfile]
        puts "Scanning VCD file ..."
        update
        $TestViewer test_scan_vcd_file $vcdfile
        puts "Done"
        update
        puts "Loading modules ..."
        update
        Bluetcl::module load $topmodule
        puts "Done"
        update
        puts "Checking all nodes in hierarchy"
        $TestViewer test_module_tree [Virtual::inst top]
        itcl::delete object $TestViewer
    }


    ############################################################################
    ## Wave viewer object classes
    ############################################################################
    namespace import ::itcl::*

    proc exit_hook {} {
        foreach c [list Novas NovasRC GtkWave GtkWaveScript TestMode ScriptFile Viewer WaveViewer] {
            catch {delete class $c}
        }
    }
    AtExit::atExit exit_hook

    # Constructor in Waves namespace
    proc create_viewer { {class ""} args } {
        if {$class eq ""} { set class $::Waves::OPTS(viewer) }
        if { [string first $class $WaveViewer::Viewers] == -1 } {
            error "Unsupported viewer `$class'.  Supported viewers are $WaveViewer::Viewers"
        }
        set x [uplevel #0 Waves::$class \#auto $args]
        return $x
    }

    class WaveViewer  {
        common Viewers [list Novas GtkWave NovasRC GtkWaveScript]
        public {
            variable nonbsv_hierarchy 	"" \
                { set  nonbsv_hierarchy [string trimright $nonbsv_hierarchy "/"] }
#            variable ExtendNameMode 	0
#            variable BoolDisplayMode  	0
            variable recording          1
        }
        protected {
            variable StatusMsg "Invalid"
            variable _history [list]
        }

        constructor {args} {
            # Set options based on global setting
#            set ExtendNameMode   [string equal $::Waves::OPTS(ExtendNameMode) "extend"]
#            set BoolDisplayMode  [string equal $::Waves::OPTS(BoolDisplayMode) "benum"]
            set nonbsv_hierarchy $::Waves::OPTS(nonbsv_hierarchy)
            set recording        1
            update_status_msg
            trace add execution Bluetcl::module [list leave] [itcl::code $this reload_hook]
        }
        destructor {
            trace remove execution Bluetcl::module [list leave] [itcl::code $this reload_hook]
        }

        protected method notSupported {} {
            error "[info level -1] : Not supported for class [$this class]"
        }
        protected method ignoredForClass {} {
            puts stderr "method [info level -1] for class [$this class] has no effect"
        }

        public {
            method class {} {namespace tail  [$this info class]}
            method start {args} {notSupported}
            method isRunning {} {notSupported}
            method attach {args} {notSupported}
            method close {} {update_status_msg}
            method load_dump_file {dfile} {ignoredForClass}
            method reload_dump_file {} {ignoredForClass}
            method dump_file_loaded {} {return false}

            ## Send Virtual object to viewer
            method send_objects { objects {untyped 0} } {
                if {$objects eq ""} { return }
                record VObject $objects $untyped
                send_typed_signals [join [Virtual::omap wave_format $objects]] $untyped true
            }
            method send_objects_mod { objects {modifier ALL} } {
                if {$objects eq ""} { return }
                set filtered [list]
                foreach o $objects {
                    switch  -exact [$o class] {
                        "VInst" {
                            send_instance $o $modifier
                        }
                        "VSignal" {
                            if { [$o filter_test $modifier] } {
                                lappend filtered $o
                            }
                        }
                        "VMethod" {
                            send_objects_mod [$o signals] $modifier
                        }
                        "VRule" {
                            send_objects_mod [$o signals] $modifier
                        }
                    }
                }
                if { $filtered eq "" } { return }
                record VObject $objects 0
                send_typed_signals [join [Virtual::omap wave_format $filtered]] 0 true
            }
            method send_instance { objects {modifier ALL} } {
                if {$objects eq ""} { return }
                record VInst $objects $modifier
                set sigs [Virtual::omap "wave_format $modifier" $objects]
                send_typed_signals [join $sigs] 0 true
            }
            method ready_to_send {} {
                if { ![isRunning] } {
                    return false
                }
                if { ![dump_file_loaded] } {
                    return false
                }
                return true
            }
            method can_send_instance { obj } {
                if { ![ready_to_send] } {
                    return false
                }
                regexp "Synth|Prim|Rule" [$obj kind]
            }

            method send_typed_signals { signals {untyped 0} {recorded 0}} {
                if { [llength $signals] == 0 } { return }
                if {! $recorded } { record TSignal $signals $untyped}
                $this pre_send
                foreach st $signals {
                    set ty  [lindex $st 0]
                    set sig [lindex $st 1]
                    set sig "${nonbsv_hierarchy}${sig}"
                    $this send_signal_raw $ty $sig $untyped
                }
                $this post_send
            }
            method send_signals { signals } {
                if { [llength $signals] == 0 } { return }
                record SSignal $signals
                $this pre_send
                foreach sig $signals {
                    set sig "${nonbsv_hierarchy}${sig}"
                    $this send_signal_raw "" $sig 1
                }
                $this post_send
            }

            method clear_history {} {
                set _history [list]
            }
            method save_history { fname } {
                if {[catch [list ::open $fname "w" 0o755] err]} {
                    error "Cannot save wave history: $err"
                }
                set fh $err
                record_preamble $fh
                record_signals  $fh $fname
                record_close    $fh $fname
                ::close $fh
                puts "Wave history captured in $fname"
            }
            method save_history_dialog {args} {
                package require Tk
                set ft [list \
                            [list {tcl Script Files} .tcl] \
                            [list {sh Script Files} .sh] \
                            [list {All Files} *] ]
                set fn [eval tk_getSaveFile -filetypes {$ft} -title {"Waves History -- save file"} $args]
                if { $fn != "" } {
                    save_history $fn
                    regsub [pwd] $fn "." fn
                    eval tk_messageBox -type ok -title {"Waves Play back"} \
                        -message {"File $fn has been written"} -icon info $args
                }
            }
            method play_back_dialog {args} {
                package require Tk
                set ft [list \
                            [list {tcl Script Files} .tcl] \
                            [list {sh Script Files} .sh] \
                            [list {All Files} *] ]
                set fn [eval tk_getOpenFile -filetypes {$ft} \
                            -title {"Waves History -- replay file"} $args]
                replay_history_file $fn
            }

            method replay_history_file { filename } {
                errorIfNotRunning
                source $filename
                replay_history_list $wave_history
            }
            method replay_history_list {history_list} {
                errorIfNotRunning
                foreach elem $history_list {
                    lassign $elem kind name code
                    send_element  $kind $name $code
                }
            }
            method send_element { kind name {code ""} } {
                switch -exact $kind {
                    VSignal {
                        # VSignal class
                        set obj [Virtual::signal filter -nametype bsv $name]
                        if { $obj eq "" } {
                            puts stderr "Could not find Signal `$name' during wave replay"
                        }
                        $this send_objects $obj $code
                    }
                    SSignal {
                        # Simple signal name
                        $this send_signals $name
                    }
                    TSignal {
                        # Simple signal name
                        $this send_typed_signals $name $code
                    }
                    VInst {
                        # VInst class
                        set obj [Virtual::inst filter $name]
                        if { $obj eq "" } {
                            puts stderr "Could not find Instance `$name' during wave replay"
                        }
                        $this send_instance $obj $code
                    }
                    VMethod {
                        # VMethod class
                        lassign [split $name "."] inst meth
                        set obj [Virtual::method_filter $inst $meth]
                        if { $obj eq "" } {
                            puts stderr "Could not find Instance `$name' during wave replay"
                        }
                        $this send_objects $obj $code
                    }
                    default {error "Unexpected kind in replay_history $kind $name $code"}
                }
            }
            method scope_variable {name}  { itcl::scope $name }
            method update_status_msg {} {
                set cl [namespace tail [$this info class]]
                if { [$this dump_file_loaded] } {
                    set StatusMsg "$cl Ready"
                } elseif { [isRunning] } {
                    set StatusMsg  "$cl Connected"
                } else {
                    set StatusMsg $cl
                }
            }
        }
        protected {
            method reload_hook {commandStr code result op} {
                set subcmd [lindex $commandStr 1]
                # reload hierarchy and search on reload
                if {-1 != [lsearch -exact [list "load" "clear"] $subcmd] } {
                    #puts "Clearing history for wave object $this, due to $commandStr"
                    clear_history
                }
                return $result
            }
            method send_signal_raw {ty sig as_bits} {notSupported}
            method post_send {} {}
            method pre_send {} {}
            method errorIfRunning {} {
                if {[$this isRunning]} {
                    error "[utils::fst [info level -1]] cannot be invoked when a viewer is already running"
                }
            }
            method errorIfNotRunning {} {
                if {![$this isRunning]} {
                    error "[utils::fst [info level -1]] cannot be invoked when a viewer is not running"
                }
            }
            method record {kind args} {
                if {$recording} {
                    lappend _history [list $kind $args]
                }
            }
            method vinst_save   {bname it}
            method vobject_save {bname it}
            method tsignal_save {bname it}
            method signal_save  {bname it}
            method record_preamble {fh}
            method record_signals {fh name}
            method record_close   {fh name}
        }
    }
    
    body WaveViewer::vinst_save {bname it} {
        upvar  $bname bdy
        lassign $it insts mod
        foreach vi $insts {
            lappend bdy [list VInst [$vi path bsv] $mod]
        }
    }
    body WaveViewer::vobject_save {bname it} {
        upvar $bname bdy
        lassign $it vsigs untyped
        foreach vs $vsigs {
            set cl [$vs class]
            if { $cl eq "VInst" } { set untyped ALL }
            lappend bdy [list $cl [$vs path bsv] $untyped]
        }
    }
    body WaveViewer::tsignal_save {bname it} {
        upvar $bname bdy
        lassign $it sigs untyped
        foreach s $sigs {
            set sname [utils::snd $s]
            lappend bdy [list TSignal $sname 0]
        }
    }
    body WaveViewer::signal_save {bname it} {
        upvar $bname bdy
        lassign $it sigs
        foreach s $sigs {
            lappend bdy [list signal $s 0]
        }
    }

    body WaveViewer::record_signals {fh name} {
        set pre [list \n \
                     "set wave_history \[list\]" ""   \
                    ]

        set bdy [list]
        foreach it $_history {
            set it [lassign $it kind rest]
            switch $kind {
                VInst   {vinst_save   bdy $rest}
                VObject {vobject_save bdy $rest}
                TSignal {tsignal_save bdy $rest}
                SSignal {signal_save  bdy $rest}
                default: {error "Unexpected record in Waves playback"}
            }
        }

        proc helperf {i} { return "lappend wave_history \{$i\}" }
        set bdy [utils::map helperf $bdy]

        puts $fh [join [concat $pre $bdy] \n]
    }
    body WaveViewer::record_preamble {fh} {
        set str \
            [list \
                 "#!/bin/sh" \
                 "# Extend comment for tcl \\" \
                 {exec bluetcl "$0" "$@"} \
                 "" \
                 "package require Waves" \
                ]
        puts $fh [join $str "\n"]
    }

    body WaveViewer::record_close {fh name} {
        set topmod [lindex [Bluetcl::module list] end]
        if {$topmod eq ""} {
            error "Error: [info level 0]: Cannot record a module without a loaded ba file"
        }
        set ppath  [Bluetcl::flags show p]

        set str [list]
        lappend str \
            "" "" "" "" \
            "if {\[info frame\]  == 2 } {"\
            "  # Default option taken from the recorded environment" \
            "  set newargs \"\"" \
            "  append newargs \" [regsub -all $::env(BLUESPECDIR) $ppath %]\"" \
            "  append newargs \" -e $topmod\"" \
            "  append newargs \" -backend [join [Bluetcl::flags show sim verilog]]\"" \
            "" \
            "  # Start the viewer based on recored and command line options" \
            "  if { \[catch  \[list Waves::start_replay_viewer  \$newargs \$argv\] err\] } {" \
            "    puts stderr \$err" \
            "    Waves::start_replay_usage \$argv0" \
            "    exit -1" \
            "  } else {" \
            "    set viewer \$err" \
            "  }" \
            "" \
            "  # Replay script" \
            "  if { \[catch \[list \$viewer replay_history_list \$wave_history\] err\] } {" \
            "    puts stderr \"Error:  Could not replay wave history: \$err\"" \
            "    Waves::start_replay_usage \$argv0" \
            "    exit -1" \
            "  }" \
            "}" \


        puts $fh [join $str "\n"]
    }


    ###########################
    # Generic Script File class
    ###########################
    class ScriptFile {
        inherit WaveViewer
        public variable ScriptFile "" {open_script}
        protected variable _ScriptFH ""
        protected variable _CurrentFile ""

        destructor { close }

        # Script called whenever ScriptFile is changed.
        public {
            method isRunning {} {
                return [expr [string length $ScriptFile] != 0]
            }
            method close {} {
                if { $_ScriptFH ne "" } {
                    puts "Closing $_CurrentFile"
                    catch {close $_ScriptFH}
                    set _ScriptFH ""
                    set _CurrentFile ""
                }
                chain
            }
        }
        protected {
            method open_script {} {
                close
                if { $ScriptFile ne "" } {
                    puts "Opening $ScriptFile for [$this class] script capture"
                    set _ScriptFH [open $ScriptFile "w"]
                    set _CurrentFile $ScriptFile
                }
            }
            method pre_send {} {
                if { $_ScriptFH eq "" } {
                    error "Cannot send signals to Viewer until -ScriptFile has been configured"
                }
                return [chain]
            }
            method post_send {} {
                flush $_ScriptFH
                return [chain]
            }
        }
    }
    ###########################
    ###########################
    class NovasRC {
        inherit ScriptFile
        constructor {args} {} {eval configure $args }

        protected method send_signal_raw {ty sig as_bits} {
            NovasSupportSendSignal::send_typed_signal_to_novas $ty $sig "" -1 0 \
                $as_bits [Waves::get_waveform_naming_mode] [Waves::get_waveform_bool_mode] $_ScriptFH
        }
    }

    class GtkWaveScript {
        inherit ScriptFile
        constructor {args} {} {eval configure $args }

        protected method send_signal_raw {ty sig as_bits} {
            GtkWaveSupport::send_typed_signal_to_gtkwave $ty $sig "" -1 0 \
                $as_bits [Waves::get_waveform_naming_mode] [Waves::get_waveform_bool_mode] $_ScriptFH

        }
    }
    class TestMode {
        inherit ScriptFile
        variable TestVCD
        variable TestErrorCount 0
        variable debug 0

        constructor {args} {} {
            array set TestVCD [list]
            eval configure $args
        }
        destructor {
            puts "\nTest completed: $TestErrorCount errors"
            puts $_ScriptFH "\nTest completed: $TestErrorCount errors"
            chain
        }

        protected method send_signal_raw {ty sig as_bits} {
            puts $_ScriptFH "$ty $sig"
            if { ! [info exists TestVCD($sig)] } {
                incr TestErrorCount
                puts $_ScriptFH "ERROR: Signal not in VCD file: $sig $ty"
                puts stderr "ERROR: Signal not in VCD file: $sig $ty"
            }
        }
        public method dump_file_loaded {} {return true}

        public method test_module_tree {k} {
            array set Detail [list Interface RULE Name XXX Node XXX Module XXX SynthPath XXX]
            array set Detail [Bluetcl::browseinst detail [$k key]]
            if { [$this can_send_instance $k] } {

                puts $_ScriptFH "\nSending signal for instance: $Detail(Name) $Detail(Node) \{$Detail(SynthPath)\} $Detail(Interface) $Detail(Module)"
                if { [catch "$this send_instance $k TEST" err] } {
                    puts $_ScriptFH "caught error from send_instance: $err"
                }
            } else {
                puts $_ScriptFH "\nIgnoring instance: $Detail(Name) $Detail(Node) \{$Detail(SynthPath)\} $Detail(Interface) $Detail(Module)"
            }

            ## Check all signals
            foreach subcmd [list signals bodysignals predsignals portmethods predmethods bodymethods] {
                puts $_ScriptFH "Sending $subcmd ..."
                foreach sig [$k $subcmd] {
                    set cmd  [list $this send_objects $sig] 
                    if { [catch $cmd err] } {
                        puts $_ScriptFH "Caught error for $cmd -- $err"
                        puts stderr     "Caught error for $cmd -- $err"
                    }
                }
            }

            foreach child [$k children] {
                set key [lindex $child 0]
                test_module_tree  $key
            }
        }
        public method test_scan_vcd_file { vcdfile } {

            Waves::fix_vcd_file $vcdfile
            set vcd [open $vcdfile "r"]
            set scope [list]
            array set TestVCD [list x x]
            array unset TestVCD *
            array set TestVCD [list]
            set cnt 0
            while { ! [eof $vcd] } {
                gets $vcd line
                incr cnt
                if { $debug } {puts $line}
                set first4 [string range $line 0 3]
                switch -exact $first4 {
                    {$var} {
                        if { [regexp {^\$var .+ ([0-9]+) .+ \\?(.+) .* \$end} $line x size name] } {
                            set fname [join [concat $scope $name] /]
                            set TestVCD(/$fname) $size
                        } elseif { [regexp {^\$var .+ ([0-9]+) .+ \\?(.+) \$end} $line x size name] } {
                            set fname [join [concat $scope $name] /]
                            set TestVCD(/$fname) $size
                        } else { puts stderr "Unmatched var: $line" }
                    }
                    {$sco} {                # $scope
                        if { [lindex $line 0] == {$scope} } {
                            lappend scope [lindex $line 2]
                        }
                    }
                    {$ups} {                #  $upscope
                        if { [lindex $line 0] == {$upscope} } {
                            set len [expr [llength $scope] - 2]
                            set scope [lrange $scope 0 $len]
                        }
                    }
                    {$end} {                #  $enddefinitions
                        if { [lindex $line 0] == {$enddefinitions} } {
                            break
                        }
                    }
                    default { continue }
                }
            }
            ::close $vcd
        }
    }

    ###########################
    # Generic Viewer class
    ###########################
    class Viewer {
        inherit WaveViewer
        public {
            variable DumpFile          ""
            variable start             "0" {start_hook}
            variable attach            "" {attach_hook}
            variable StartTimeout    	20
            variable Command            ""
            variable Options            ""
        }
        constructor {args} {} {
            set vclass [namespace tail  [$this info class]]
            set Command $::Waves::OPTS($vclass,Command)
            set Options $::Waves::OPTS($vclass,Options)
            set StartTimeout $::Waves::OPTS(StartTimeout)
        }

        protected {
            method post_connect {} {
                $this check_communications
                update_status_msg
                return  true
            }
            method check_communications {} {notSupported}
            method pre_send {} {
                errorIfNotRunning
                chain
            }
            method start {name} {
                set attach $name
                set start 1
                if {$DumpFile ne ""} {
                    $this load_dump_file $DumpFile
                }
                post_connect
            }
            method start_hook {} {
                $this start
            }
            method attach {args} {
                set attach [utils::fst $args]
                update_status_msg
                if {$attach ne ""} {
                    return [post_connect]
                }
                return true
            }
            method attach_hook {} {
                $this attach $attach
            }
            method load_dump_file {dfile} {
                set DumpFile $dfile
                update_status_msg
                return true
            }
            method close {} {
                set start 0
                chain
            }

        }
    }
    ###########################
    ###########################
    class Novas {
        inherit Viewer
        constructor {args} {} {eval configure $args }

        public {
            method start {args} {
                # Options -- -DumpFile  -StartTimeout -Command -Options
                errorIfRunning
                eval configure $args
                set name [NovasSupport::start_viewer $Command   $Options  $StartTimeout]
                chain $name
            }
            method attach {args} {
                if {[llength $args] == 0} {
                    return [NovasSupport::list_potential_viewers]
                }
                set viewer [utils::fst $args]
                if {[NovasSupport::attach_viewer $viewer]} {
                    return [chain $viewer]
                }
                return false
            }
            method isRunning {} {NovasSupport::check_running}
            method close {} {
                if {[isRunning]} {
                    NovasSupport::close_viewer
                }
                chain
            }
            method load_dump_file {dfile} {
                errorIfNotRunning
                Waves::fix_vcd_file $dfile
                if { [NovasSupport::load_dump_file $dfile] } {
                    return [chain $dfile]
                }
                return false
            }
            method reload_dump_file {} {
                errorIfNotRunning
                if { $DumpFile == "" } {
                    error "Cannot reload dump file since non have been loaded"
                }
                Waves::fix_vcd_file $DumpFile
                NovasSupport::reload_dump_file $DumpFile
            }
            method dump_file_loaded {} {
                if {![isRunning] } { return false }
                NovasSupport::isDumpFileLoaded
            }

        }

        protected {
            method send_signal_raw {ty sig as_bits} {
                 NovasSupport::send_typed_signal_to_novas $ty $sig "" -1 0 \
                     $as_bits [Waves::get_waveform_naming_mode] [Waves::get_waveform_bool_mode]
            }
            method post_send {} {
                NovasSupport::send_buffered_rc_cmd
                NovasSupport::raise_window
                chain
            }
            method check_communications {} {NovasSupport::check_communications}
        }
    }

    ###########################
    ###########################
    class GtkWave {
        inherit Viewer
        constructor {args} {} {eval configure $args }
        public {
            method start {args} {
                errorIfRunning
                eval configure $args
                set name [GtkWaveSupport::start_viewer $Command $Options $StartTimeout]
                chain $name
            }
            method attach {args} {
                if {[llength $args] == 0} {
                    return [GtkWaveSupport::list_potential_viewers]
                }
                set viewer [utils::fst $args]
                if {[GtkWaveSupport::::attach_viewer $viewer]} {
                    return [eval chain $args]
                }
                return false
            }
            method isRunning {} {GtkWaveSupport::check_running}
            method close {} {
                if {[isRunning]} {
                    GtkWaveSupport::close_viewer
                }
                chain
            }
             method load_dump_file {dfile} {
                errorIfNotRunning
                Waves::fix_vcd_file $dfile
                if { [GtkWaveSupport::load_dump_file $dfile] } {
                    return [chain $dfile]
                }
                return false
            }
            method reload_dump_file {} {
                errorIfNotRunning
                if { $DumpFile == "" } {
                    error "Cannot reload dump file since non have been loaded"
                }
                Waves::fix_vcd_file $DumpFile
                GtkWaveSupport::reload_dump_file
            }
            method dump_file_loaded {} {
                if {![isRunning] } { return false }
                GtkWaveSupport::isDumpFileLoaded
            }
        }
        protected {
            method send_signal_raw {ty sig as_bits}  {
                 GtkWaveSupport::send_typed_signal_to_gtkwave $ty $sig "" -1 0 \
                     $as_bits [Waves::get_waveform_naming_mode] [Waves::get_waveform_bool_mode] ""
            }
            method post_send {} {
		GtkWaveSupport::send_buffered_sav_cmd
		GtkWaveSupport::show_last_signal
		GtkWaveSupport::raise_window
                chain
            }
            method check_communications {} {GtkWaveSupport::check_communications}
        }
    }

}

package provide Waves 2.0
