
##
# @file menubar.tcl
#
# @brief Definition of class menubar.
#

namespace eval base {

##
# @brief Defintion of class menubar
#
itcl::class menubar {
       inherit iwidgets::Menubar

       ##
       # @brief Sets state of menu-item 
       #
       # @param m Name of menu 
       # @param i Index of menu-item
       # @param s State to be set 
       #
       method set_state {m i s} {
              set menu "[component $m].menu"
              set ind [index .$m.$i]
              $menu entryconfigure $ind -state $s
       }

       ##
       # @brief Adds menubutton
       #
       # @param n Name of menubutton 
       # @param t Title of menubutton
       # @param u Underline 
       # @param c Command 
       #
       method add_menubutton {n t u {c ""}} {
                global postcommand
                set postcommand $c
                add menubutton $n -text $t -underline $u -menu {
                        global postcommand
                        options -tearoff false -postcommand $postcommand
                }
                unset postcommand
       }

    method add_separator {x} {
        $this add separator $x
    }
       
       ##
       # @brief Adds command 
       #
       # @param n Name of menubutton 
       # @param t Title of menubutton
       # @param u Underline
       # @param h Help string
       # @param f Function to be executed
       # @param e State of command. Can be active/disabled.
       # @param a Accelator
       #
       method add_command {p l u h f {e "disabled"} {a ""}} {
           add command $p -label $l -underline $u -helpstr $h \
               -command $f -state $e -accelerator $a
       }

       constructor {args} {
               lappend args -helpvariable helpVar -font bscMenuFont \
               -cursor ""
               eval itk_initialize $args
       }

       destructor {
       }
}
}
