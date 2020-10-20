
##
# @file fonts.tcl
#
# @brief Definition of font configuration in BSC Workstation
#

##
# @brief namespace fonts
#

namespace eval fonts {

    variable init_done False
    variable Images

    proc initialize {} {
        variable init_done

        if { $init_done } { return }

        # font creation
        font create bscDefaultFont           -family Helvetica -size 10 -weight bold

        font create bscMessageFontBold       -family Helvetica -size 14 -weight bold
        font create bscMessageFont           -family Helvetica -size 14

        font create bscInfoHeadingFont       -family Helvetica -size 12 -weight bold
        font create bscInfoFont              -family Helvetica -size 10
        font create bscTextFont              -family Helvetica -size 10 -weight bold

        font create bscMenuFont              -family Helvetica -size 10
        font create bscTooltipFont           -family Helvetica -size 9

        font create bscFixedFont             -family Courier -size 10
        font create bscNULLFont               -family Courier -size -1

        font configure TkDefaultFont  -family Helvetica -weight bold


        option add *Font        bscDefaultFont startupFile
        option add *BalloonFont bscTooltipFont startupFile
        # Adjust widht of tk's dialog boxes
        option add  *Dialog.msg.wrapLength 5.5i startupFile
        option add  *Dialog.dtl.wrapLength 5.5i startupFile

        bind all <Control-plus>   [list fonts::bump_fonts +1]
        bind all <Control-equal>  [list fonts::bump_fonts +1]
        bind all <Control-minus>  [list fonts::bump_fonts -1]

        create_images

        set init_done True

    }

    # create some images for common use
    proc create_images {} {
        variable Images
        catch "unset Images"
        set imagedir [file join $::env(BDWDIR) tcllib workstation images]

        foreach g [glob -nocomplain $imagedir/*.gif] {
            set i [file rootname [file tail $g]]
            set Images($i) [image create photo -file $g]
       }
    }

    proc get_image {name} {
        variable Images
        variable init_done
        if {!$init_done} {initialize}
        if { [info exists Images($name)] } {
            set img $Images($name)
        } else {
            set img $Images(error)
        }
        return $img
    }

    proc bump_fonts {incr} {
        foreach font [font names] {
            catch {
                set size [font configure $font -size]
                if {$size <= 1 } continue ;
                incr size $incr
                if {$size < 8 } { set size 8  }
                if {$size > 32} { set size 32 }
                font configure $font -size $size
            }
        }
    }

    proc show_detail {} {
        foreach font [font names] {
            if { [regexp "^bsc" $font] == 0 } { continue }
            puts "$font [font actual $font]"
        }
    }

    proc set_colours {} {
        tk_setPalette background gray80 \
            foreground black \
            activeBackground #100842 \
            activeForeground white \
            disabledForeground DarkSlateGray \
            highlightBackground gray80 \
            highlightColor gray55 \
            insertBackground black \
            selectColor white \
            selectBackground #100842 \
            selectForeground white \
            troughColor gray50

        option add *background            gray80   userDefault
        option add *foreground            black     userDefault
        option add *activeBackground      #100842   userDefault
        option add *activeForeground      white     userDefault
        option add *disabledForeground    DarkSlateGray   userDefault

        option add *highlightBackground   gray80    userDefault;
        option add *highlightColor        gray55    userDefault

        option add *insertBackground      black     userDefault
        option add *selectColor           white     userDefault ;  # ok
        option add *selectBackground      #100842   userDefault ;  # ok
        option add *selectForeground      white     userDefault
        option add *troughColor           gray50    userDefault

        # options for tabbed notebook
        option add *backdrop #100842 userDefault
        option add *tabBackground gray80 userDefault
        option add *tabForeground black userDefault

        option add *spacing2 2 userDefault
        option add *spacing3 1 userDefault


        ttk::style theme settings default {
            ttk::style configure . -background grey80
        }
        ttk::style theme use default

    }

    proc getBSCIncImage {} {
        image create photo -data [getBSCIncLogo]
    }
    proc getBSCIncLogo {} {
        return {
            R0lGODlhjAArAIQAABMJRf///05HdHp1l4mEojEoXCIYUcTC0bWyxWxli+Lg6FxVftPR3fHx
            9JeTrqejuj83aP//////////////////////////////////////////////////////////
            /yH+FUNyZWF0ZWQgd2l0aCBUaGUgR0lNUAAsAAAAAIwAKwAABf4gII5kaZ5oqq5s675wLM90
            bd94ru987//AoHBILBqPyKRyyWwCEyTIyGEKAKwAgkCEJQQCh4BA3IA6z7+tSE0wEwptAgFN
            V0lFBdJ8LTqM/FeAYmBfBAh1iCt5fAICcACACWFhY32FYomZLQUGW2oCBAcOBxCAoweSEIcx
            X19qVa1YdIsoi7RQr5AjCVpWvl5cY2NhAXuYMLG5JLGymj8Fn52dEI2LjqytyiPMziPafSN7
            e1dZWlzkgYPDl8LNLMko3N1BAtTSn9D3Bi/JY18D22KVk6MGjpxxAAwQC4BgX4kEClopWBDu
            YMKIDAFsoeVAIsVdABJAYNDqgAJdBP5lFftCaRAXL+0a8GtFUh63WHv8fRmBkRmDZcxacckW
            9FbQLw6HHi3hSSOoNiLexNEiFY6ZFkdj/bzZKqdAAA2yBpB5RexJsUIBLEDrEK0VNX7iegET
            jNDKdoCwui0rFOcagToD7DMAD14BgUEXfoES64GIsF9kzv3iuOYXao7mAJrbcl3dYTMjixiQ
            jGuhv0IhB/gpomNfZg/uKN05u0FgoDvl8c3IqanGUKNKlRrVR7io0Md2T87dFTXzvZaZndxN
            dncA12gDOw6pSwSvSr+wqLMLc1Ded9kCXkLcXCP7vZDE7p5uXXHW5QhhCLiHOd/+eshttxtp
            7wWw3QMFsv6mQgHYtQKBbsws5x0sX9A3iYEpbcNFZ+KVB5oLzEhh2nOFNGgFAl8BgMABLCJw
            22yBBaCAAKpdN+AaLLIIQE+ChRQLQCnU89801azRyTfx7DViVrMdlUcsM/Jo3VIG1BjUSYSh
            FZUa4RGC12lXjCEgemI9CVhQNYrwYFYHiuWYW1dp6Z1Yd/Sm0RrAFScKi6mQch6ZvsSyiDwJ
            aLUbCfYpkBQAa8bSwKCxNCjbnMxcNUJ0q2Xh1CObsVQXMR6OOY9eadEwKR7hbJqXIBy+NEh+
            owLqDj2pZsELHI9kAUqusSI3Ky3ecDfCLXdyl1eG4X1GnhiW9spCjjo6MaSQjj4g6awNwCJ5
            7DK1+hIVS+OBeu24eDRiz38JAEnuLMFqxCsqLAZHgAGLrmvvvfjmq+++/Pbr778AByzwwImE
            AAA7
        }
    }
}
