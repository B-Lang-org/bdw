
fu BsvSyntax()
  " work with vim < 6.0
  "if version < 600
  "  syntax clear
  "elseif exists("b:current_syntax")
  "  finish
  "endif
  
  " BSV is case-sensitive
  syntax case match
  
  " SV operators (XXX stolen from verilog.vim)
  syntax match bsv_op "[&|~><!)(*/#%@+=?:;}{,.\^\-\[\]]"
  
  " SV identifiers
  syntax match bsv_identifier "\<[a-z_][A-Za-z_]*\>"
  
  " comments (must be before operators, or else / gets marked as an operator)
  syntax keyword bsv_todo XXX FIXME TODO
  syntax region  bsv_comment start="//"  end=/$/ contains=bsv_todo
  syntax region  bsv_comment start="/\*" end="\*/" contains=bsv_todo
  
  " numeric literals (XXX stolen from verilog.vim)
  syntax match   bsv_number "\(\<\d\+\|\)'[bB]\s*[0-1_xXzZ?]\+\>"
  syntax match   bsv_number "\(\<\d\+\|\)'[oO]\s*[0-7_xXzZ?]\+\>"
  syntax match   bsv_number "\(\<\d\+\|\)'[dD]\s*[0-9_xXzZ?]\+\>"
  syntax match   bsv_number "\(\<\d\+\|\)'[hH]\s*[0-9a-fA-F_xXzZ?]\+\>"
  syntax match   bsv_number "\<[+-]\=[0-9_]\+\(\.[0-9_]*\|\)\(e[0-9_]*\|\)\>"
   
  " strings
  syntax region bsv_string start=/"/ skip=/\\"/ end=/"/
  
  " SV keywords
  syntax keyword bsv_statement alias
  syntax keyword bsv_statement always
  syntax keyword bsv_statement always_comb
  syntax keyword bsv_statement always_ff
  syntax keyword bsv_statement always_latch
  syntax keyword bsv_statement and
  syntax keyword bsv_statement assert
  syntax keyword bsv_statement assert_strobe
  syntax keyword bsv_statement assign
  syntax keyword bsv_statement assume
  syntax keyword bsv_statement automatic
  syntax keyword bsv_statement before
  syntax keyword bsv_statement begin
  syntax keyword bsv_statement bind
  syntax keyword bsv_statement bins
  syntax keyword bsv_statement binsof
  syntax match   bsv_type      "bit\(\[.*\]\)\?"
  syntax keyword bsv_statement break
  syntax keyword bsv_statement buf
  syntax keyword bsv_statement bufif0
  syntax keyword bsv_statement bufif1
  syntax keyword bsv_statement byte
  syntax keyword bsv_conditional case
  syntax keyword bsv_conditional casex
  syntax keyword bsv_conditional casez
  syntax keyword bsv_statement cell
  syntax keyword bsv_statement chandle
  syntax keyword bsv_statement class
  syntax keyword bsv_statement clocking
  syntax keyword bsv_statement cmos
  syntax keyword bsv_statement config
  syntax keyword bsv_statement const
  syntax keyword bsv_statement constraint
  syntax keyword bsv_statement context
  syntax keyword bsv_statement continue
  syntax keyword bsv_statement cover
  syntax keyword bsv_statement covergroup
  syntax keyword bsv_statement coverpoint
  syntax keyword bsv_statement cross
  syntax keyword bsv_statement deassign
  syntax keyword bsv_statement default
  syntax keyword bsv_statement defparam
  syntax keyword bsv_statement design
  syntax keyword bsv_statement disable
  syntax keyword bsv_statement dist
  syntax keyword bsv_statement do
  syntax keyword bsv_statement edge
  syntax keyword bsv_conditional else
  syntax keyword bsv_statement end
  syntax keyword bsv_statement endcase
  syntax keyword bsv_statement endclass
  syntax keyword bsv_statement endclocking
  syntax keyword bsv_statement endconfig
  syntax keyword bsv_statement endfunction
  syntax keyword bsv_statement endgenerate
  syntax keyword bsv_statement endgroup
  syntax keyword bsv_typedef   endinterface
  syntax keyword bsv_statement endmodule
  syntax keyword bsv_statement endpackage
  syntax keyword bsv_statement endprimitive
  syntax keyword bsv_statement endprogram
  syntax keyword bsv_statement endproperty
  syntax keyword bsv_statement endspecify
  syntax keyword bsv_statement endsequence
  syntax keyword bsv_statement endtable
  syntax keyword bsv_statement endtask
  syntax keyword bsv_structure enum
  syntax keyword bsv_statement event
  syntax keyword bsv_statement expect
  syntax keyword bsv_statement export
  syntax keyword bsv_statement extends
  syntax keyword bsv_statement extern
  syntax keyword bsv_statement final
  syntax keyword bsv_statement first_match
  syntax keyword bsv_loop      for
  syntax keyword bsv_statement force
  syntax keyword bsv_statement foreach
  syntax keyword bsv_statement forever
  syntax keyword bsv_statement fork
  syntax keyword bsv_statement forkjoin
  syntax keyword bsv_statement function
  syntax keyword bsv_statement generate
  syntax keyword bsv_statement genvar
  syntax keyword bsv_statement highz0
  syntax keyword bsv_statement highz1
  syntax keyword bsv_conditional if
  syntax keyword bsv_statement iff
  syntax keyword bsv_statement ifnone
  syntax keyword bsv_statement ignore_bins
  syntax keyword bsv_statement illegal_bins
  syntax keyword bsv_statement import
  syntax keyword bsv_statement incdir
  syntax keyword bsv_statement include
  syntax keyword bsv_statement initial
  syntax keyword bsv_statement inout
  syntax keyword bsv_statement input
  syntax keyword bsv_statement inside
  syntax keyword bsv_statement instance
  syntax keyword bsv_type      int
  syntax keyword bsv_type      integer
  syntax keyword bsv_typedef   interface
  syntax keyword bsv_statement intersect
  syntax keyword bsv_statement join
  syntax keyword bsv_statement join_any
  syntax keyword bsv_statement join_none
  syntax keyword bsv_statement large
  syntax keyword bsv_statement liblist
  syntax keyword bsv_statement library
  syntax keyword bsv_statement local
  syntax keyword bsv_statement localparam
  syntax keyword bsv_statement logic
  syntax keyword bsv_type      longint
  syntax keyword bsv_statement macromodule
  syntax keyword bsv_conditional matches
  syntax keyword bsv_statement medium
  syntax keyword bsv_statement modport
  syntax keyword bsv_statement module
  syntax keyword bsv_statement nand
  syntax keyword bsv_statement negedge
  syntax keyword bsv_statement new
  syntax keyword bsv_statement nmos
  syntax keyword bsv_statement nor
  syntax keyword bsv_statement noshowcancelled
  syntax keyword bsv_statement not
  syntax keyword bsv_statement notif0
  syntax keyword bsv_statement notif1
  syntax keyword bsv_statement null
  syntax keyword bsv_statement or
  syntax keyword bsv_statement output
  syntax keyword bsv_statement package
  syntax keyword bsv_statement packed
  syntax keyword bsv_statement parameter
  syntax keyword bsv_statement pmos
  syntax keyword bsv_statement posedge
  syntax keyword bsv_statement primitive
  syntax keyword bsv_statement priority
  syntax keyword bsv_statement program
  syntax keyword bsv_statement property
  syntax keyword bsv_statement protected
  syntax keyword bsv_statement pull0
  syntax keyword bsv_statement pull1
  syntax keyword bsv_statement pulldown
  syntax keyword bsv_statement pullup
  syntax keyword bsv_statement pulsestyle_onevent
  syntax keyword bsv_statement pulsestyle_ondetect
  syntax keyword bsv_statement pure
  syntax keyword bsv_statement rand
  syntax keyword bsv_statement randc
  syntax keyword bsv_statement randcase
  syntax keyword bsv_statement randsequence
  syntax keyword bsv_statement rcmos
  syntax keyword bsv_type      real
  syntax keyword bsv_type      realtime
  syntax keyword bsv_statement ref
  syntax keyword bsv_type      reg
  syntax keyword bsv_statement release
  syntax keyword bsv_statement repeat
  syntax keyword bsv_statement return
  syntax keyword bsv_statement rnmos
  syntax keyword bsv_statement rpmos
  syntax keyword bsv_statement rtran
  syntax keyword bsv_statement rtranif0
  syntax keyword bsv_statement rtranif1
  syntax keyword bsv_statement scalared
  syntax keyword bsv_statement sequence
  syntax keyword bsv_type      shortint
  syntax keyword bsv_type      shortreal
  syntax keyword bsv_statement showcancelled
  syntax keyword bsv_statement signed
  syntax keyword bsv_statement small
  syntax keyword bsv_statement solve
  syntax keyword bsv_statement specify
  syntax keyword bsv_statement specparam
  syntax keyword bsv_statement static
  syntax keyword bsv_statement string
  syntax keyword bsv_statement strong0
  syntax keyword bsv_statement strong1
  syntax keyword bsv_structure struct
  syntax keyword bsv_statement super
  syntax keyword bsv_statement supply0
  syntax keyword bsv_statement supply1
  syntax keyword bsv_statement table
  syntax keyword bsv_structure tagged
  syntax keyword bsv_statement task
  syntax keyword bsv_statement this
  syntax keyword bsv_statement throughout
  syntax keyword bsv_type      time
  syntax keyword bsv_statement timeprecision
  syntax keyword bsv_statement timeunit
  syntax keyword bsv_statement tran
  syntax keyword bsv_statement tranif0
  syntax keyword bsv_statement tranif1
  syntax keyword bsv_statement tri
  syntax keyword bsv_statement tri0
  syntax keyword bsv_statement tri1
  syntax keyword bsv_statement triand
  syntax keyword bsv_statement trior
  syntax keyword bsv_statement trireg
  syntax keyword bsv_statement type
  syntax keyword bsv_typedef   typedef
  syntax keyword bsv_structure union
  syntax keyword bsv_statement unique
  syntax keyword bsv_statement unsigned
  syntax keyword bsv_statement use
  syntax keyword bsv_statement var
  syntax keyword bsv_statement vectored
  syntax keyword bsv_statement virtual
  syntax keyword bsv_type      void
  syntax keyword bsv_statement wait
  syntax keyword bsv_statement wait_order
  syntax keyword bsv_statement wand
  syntax keyword bsv_statement weak0
  syntax keyword bsv_statement weak1
  syntax keyword bsv_loop      while
  syntax keyword bsv_statement wildcard
  syntax keyword bsv_type      wire
  syntax keyword bsv_statement with
  syntax keyword bsv_statement within
  syntax keyword bsv_statement wor
  syntax keyword bsv_statement xnor
  syntax keyword bsv_statement xor
  " BSV keywords
  syntax keyword bsv_statement action
  syntax keyword bsv_statement endaction
  syntax keyword bsv_statement actionvalue
  syntax keyword bsv_statement endactionvalue
  syntax keyword bsv_statement ancestor
  syntax keyword bsv_statement deriving
  syntax keyword bsv_statement endinstance
  syntax keyword bsv_statement let
  syntax keyword bsv_statement match
  syntax keyword bsv_statement method
  syntax keyword bsv_statement endmethod
  syntax keyword bsv_statement par
  syntax keyword bsv_statement endpar
  syntax keyword bsv_statement powered_by
  syntax keyword bsv_statement provisos
  syntax keyword bsv_statement rule
  syntax keyword bsv_statement endrule
  syntax keyword bsv_statement rules
  syntax keyword bsv_statement endrules
  syntax keyword bsv_statement seq
  syntax keyword bsv_statement endseq
  syntax keyword bsv_statement schedule
  syntax keyword bsv_statement typeclass
  syntax keyword bsv_statement endtypeclass
  syntax keyword bsv_statement clock
  syntax keyword bsv_statement reset
  syntax keyword bsv_statement noreset
  syntax keyword bsv_statement no_reset
  syntax keyword bsv_statement valueof
  syntax keyword bsv_statement valueOf
  syntax keyword bsv_statement clocked_by
  syntax keyword bsv_statement reset_by
  syntax keyword bsv_statement default_clock
  syntax keyword bsv_statement default_reset
  syntax keyword bsv_statement output_clock
  syntax keyword bsv_statement output_reset
  syntax keyword bsv_statement input_clock
  syntax keyword bsv_statement input_reset
  syntax keyword bsv_statement same_family
  
  " frequently used predefined types
  syntax keyword bsv_type Action
  syntax keyword bsv_type ActionValue
  syntax keyword bsv_type Integer
  syntax keyword bsv_type Nat
  syntax keyword bsv_type Bit
  syntax keyword bsv_type UInt
  syntax keyword bsv_type Int
  syntax keyword bsv_type Bool
  syntax keyword bsv_type Maybe
  syntax keyword bsv_type String
  syntax keyword bsv_type Either
  syntax keyword bsv_type Rules
  syntax keyword bsv_type Module
  syntax keyword bsv_type Clock
  syntax keyword bsv_type Reset
  syntax keyword bsv_type Power
  syntax keyword bsv_type TAdd TSub TMul TDiv TLog TExp
  
  syntax keyword bsv_interface Empty
  syntax keyword bsv_interface Reg
  syntax keyword bsv_interface RWire Wire BypassWire PulseWire
  syntax keyword bsv_interface RegFile
  syntax keyword bsv_interface Vector
  syntax keyword bsv_interface FIFO FIFOF
  
  syntax keyword bsv_typeclass Bits Eq Ord Bounded
  syntax keyword bsv_typeclass Arith Literal Bitwise BitReduction BitExtend
  syntax keyword bsv_typeclass IsModule
  syntax keyword bsv_typeclass Add Max Log
  
  " frequently used expressions
  syntax keyword bsv_bool True
  syntax keyword bsv_bool False
  syntax keyword bsv_function mkReg mkRegU mkRegA mkRWire mkWire mkFIFO mkFIFO1
  syntax keyword bsv_function mkBypassWire mkDWire mkPulseWire
  syntax keyword bsv_function pack unpack zeroExtend signExtend truncate
  syntax keyword bsv_function fromInteger inLiteralRange negate
  syntax keyword bsv_function minBound maxBound
  syntax keyword bsv_function signedShiftRight div mod exp log2 add abs max min quot rem
  syntax keyword bsv_function fromMaybe isValid noAction
  syntax keyword bsv_function error warning message messageM
  syntax keyword bsv_function nosplit emptyRules addRules rJoin rJoinPreempts rJoinDescendingUrgency
  
  " system tasks
  syntax match bsv_system_task "\$display"
  syntax match bsv_system_task "\$displayb"
  syntax match bsv_system_task "\$displayh"
  syntax match bsv_system_task "\$displayo"
  syntax match bsv_system_task "\$write"
  syntax match bsv_system_task "\$writeb"
  syntax match bsv_system_task "\$writeh"
  syntax match bsv_system_task "\$writeo"
  syntax match bsv_system_task "\$fopen"
  syntax match bsv_system_task "\$fclose"
  syntax match bsv_system_task "\$fgetc"
  syntax match bsv_system_task "\$ungetc"
  syntax match bsv_system_task "\$fflush"
  syntax match bsv_system_task "\$fdisplay"
  syntax match bsv_system_task "\$fdisplayb"
  syntax match bsv_system_task "\$fdisplayh"
  syntax match bsv_system_task "\$fdisplayo"
  syntax match bsv_system_task "\$fwrite"
  syntax match bsv_system_task "\$fwriteb"
  syntax match bsv_system_task "\$fwriteh"
  syntax match bsv_system_task "\$fwriteo"
  syntax match bsv_system_task "\$stop"
  syntax match bsv_system_task "\$finish"
  syntax match bsv_system_task "\$dumpon"
  syntax match bsv_system_task "\$dumpoff"
  syntax match bsv_system_task "\$dumpvars"
  syntax match bsv_system_task "\$dumpfile"
  syntax match bsv_system_task "\$dumpflush"
  syntax match bsv_system_task "\$time"
  syntax match bsv_system_task "\$stime"
  syntax match bsv_system_task "\$signed"
  syntax match bsv_system_task "\$unsigned"
  syntax match bsv_system_task "\$test$plusargs"
  
  " attributes
  syntax keyword bsv_attribute synthesize noinline doc options
  syntax keyword bsv_attribute always_ready always_enabled
  syntax keyword bsv_attribute ready enable result prefix port 
  syntax keyword bsv_attribute fire_when_enabled no_implicit_conditions
  syntax keyword bsv_attribute bit_blast scan_insert
  syntax keyword bsv_attribute descending_urgency preempts
  syntax keyword bsv_attribute internal_scheduling method_scheduling
  syntax keyword bsv_attribute CLK RST_N RST RSTN ungated_clock
  syntax region  bsv_attributes start="(\*" end="\*)" contains=bsv_attribute
  
  " link classes to vim colors
  highlight link bsv_statement Keyword
  highlight link bsv_typedef Typedef
  highlight link bsv_type Type
  highlight link bsv_interface Type
  highlight link bsv_typeclass Type
  highlight link bsv_structure Structure
  highlight link bsv_conditional Conditional
  highlight link bsv_loop Repeat
  highlight link bsv_comment Comment
  highlight link bsv_op Operator
  highlight link bsv_string String
  highlight link bsv_bool Boolean
  highlight link bsv_number Number
  " highlighting identifiers gets a bit garish
  " highlight link bsv_identifier Identifier
  highlight link bsv_function Function
  highlight link bsv_system_task Function
  highlight link bsv_todo Todo
  highlight link bsv_attributes SpecialComment 
  highlight link bsv_attribute Keyword
  
  let b:current_syntax="bsv"

endfunction

fu BsvIndent()
 "if exists("b:did_indent")
 "  finish
 "endif
  let b:did_indent = 1
  
  setlocal indentexpr=GetBSVIndent()
  setlocal indentkeys=!^F,o,O,0),0},=begin,=end,=join,=endcase,=join_any,=join_none
  setlocal indentkeys+==endmodule,=endfunction,=endtask,=endspecify
  setlocal indentkeys+==endclass,=endpackage,=endsequence,=endclocking,=endrule
  setlocal indentkeys+==endmethod,=endinterface,=endgroup,=endprogram,=endproperty
  setlocal indentkeys+==`else,=`endif
  
  " Only define the function once.
  if exists("*GetBSVIndent") == 0
    
    set cpo-=C
    
    function GetBSVIndent()
    
      if exists('b:verilog_indent_width')
        let offset = b:verilog_indent_width
      else
        let offset = &sw
      endif
      if exists('b:verilog_indent_modules')
        let indent_modules = offset
      else
        let indent_modules = 0
      endif
    
      " Find a non-blank line above the current line.
      let lnum = prevnonblank(v:lnum - 1)
    
      " At the start of the file use zero indent.
      if lnum == 0
        return 0
      endif
    
      let lnum2 = prevnonblank(lnum - 1)
      let curr_line  = getline(v:lnum)
      let last_line  = getline(lnum)
      let last_line2 = getline(lnum2)
      let ind  = indent(lnum)
      let ind2 = indent(lnum - 1)
      let offset_comment1 = 1
      " Define the condition of an open statement
      "   Exclude the match of //, /* or */
      let vlog_openstat = '\(\<or\>\|\([*/]\)\@<![*(,{><+-/%^&|!=?:]\([*/]\)\@!\)'
      " Define the condition when the statement ends with a one-line comment
      let vlog_comment = '\(//.*\|/\*.*\*/\s*\)'
      if exists('b:verilog_indent_verbose')
        let vverb_str = 'INDENT VERBOSE:'
        let vverb = 1
      else
        let vverb = 0
      endif
    
      " Indent accoding to last line
      " End of multiple-line comment
      if last_line =~ '\*/\s*$' && last_line !~ '/\*.\{-}\*/'
        let ind = ind - offset_comment1
        if vverb
          echo vverb_str "De-indent after a multiple-line comment."
        endif
    
      " Indent after if/else/for/case/always/initial/specify/fork blocks
      elseif last_line =~ '`\@<!\<\(if\|else\)\>' ||
        \ last_line =~ '^\s*\<\(for\|case\%[[zx]]\|do\|foreach\|randcase\)\>' ||
        \ last_line =~ '^\s*\<\(always\|always_comb\|always_ff\|always_latch\)\>' ||
        \ last_line =~ '^\s*\<\(initial\|specify\|fork\|final\)\>'
        if last_line !~ '\(;\|\<end\>\)\s*' . vlog_comment . '*$' ||
          \ last_line =~ '\(//\|/\*\).*\(;\|\<end\>\)\s*' . vlog_comment . '*$'
          let ind = ind + offset
          if vverb | echo vverb_str "Indent after a block statement." | endif
        endif
      " Indent after function/task/class/package/sequence/clocking/
      " rule/method/interface/covergroup/property/program blocks
      elseif last_line =~ '^\s*\<\(function\|task\|class\|package\)\>' ||
        \ last_line =~ '^\s*\<\(sequence\|clocking\|rule\|method\|interface\)\>' ||
        \ last_line =~ '^\s*\(\w\+\s*:\)\=\s*\<covergroup\>' ||
        \ last_line =~ '^\s*\<\(property\|program\)\>'
        if last_line !~ '\<end\>\s*' . vlog_comment . '*$' ||
          \ last_line =~ '\(//\|/\*\).*\(;\|\<end\>\)\s*' . vlog_comment . '*$'
          let ind = ind + offset
          if vverb
            echo vverb_str "Indent after function/task/class block statement."
          endif
        endif
    
      " Indent after module/function/task/specify/fork blocks
      elseif last_line =~ '^\s*\(\<extern\>\s*\)\=\<module\>'
        let ind = ind + indent_modules
        if vverb && indent_modules
          echo vverb_str "Indent after module statement."
        endif
        if last_line =~ '[(,]\s*' . vlog_comment . '*$' &&
          \ last_line !~ '\(//\|/\*\).*[(,]\s*' . vlog_comment . '*$'
          let ind = ind + offset
          if vverb
            echo vverb_str "Indent after a multiple-line module statement."
          endif
        endif
    
      " Indent after a 'begin' statement
      elseif last_line =~ '\(\<begin\>\)\(\s*:\s*\w\+\)*' . vlog_comment . '*$' &&
        \ last_line !~ '\(//\|/\*\).*\(\<begin\>\)' &&
        \ ( last_line2 !~ vlog_openstat . '\s*' . vlog_comment . '*$' ||
        \ last_line2 =~ '^\s*[^=!]\+\s*:\s*' . vlog_comment . '*$' )
        let ind = ind + offset
        if vverb | echo vverb_str "Indent after begin statement." | endif
    
      " Indent after a '{' or a '('
      elseif last_line =~ '[{(]' . vlog_comment . '*$' &&
        \ last_line !~ '\(//\|/\*\).*[{(]' &&
        \ ( last_line2 !~ vlog_openstat . '\s*' . vlog_comment . '*$' ||
        \ last_line2 =~ '^\s*[^=!]\+\s*:\s*' . vlog_comment . '*$' )
        let ind = ind + offset
        if vverb | echo vverb_str "Indent after begin statement." | endif
    
      " De-indent for the end of one-line block
      elseif ( last_line !~ '\<begin\>' ||
        \ last_line =~ '\(//\|/\*\).*\<begin\>' ) &&
        \ last_line2 =~ '\<\(`\@<!if\|`\@<!else\|for\|always\|initial\|do\|foreach\|final\)\>.*' .
          \ vlog_comment . '*$' &&
        \ last_line2 !~
          \
        '\(//\|/\*\).*\<\(`\@<!if\|`\@<!else\|for\|always\|initial\|do\|foreach\|final\)\>' &&
        \ last_line2 !~ vlog_openstat . '\s*' . vlog_comment . '*$' &&
        \ ( last_line2 !~ '\<begin\>' ||
        \ last_line2 =~ '\(//\|/\*\).*\<begin\>' )
        let ind = ind - offset
        if vverb
          echo vverb_str "De-indent after the end of one-line statement."
        endif
    
        " Multiple-line statement (including case statement)
        " Open statement
        "   Ident the first open line
        elseif  last_line =~ vlog_openstat . '\s*' . vlog_comment . '*$' &&
          \ last_line !~ '\(//\|/\*\).*' . vlog_openstat . '\s*$' &&
          \ last_line2 !~ vlog_openstat . '\s*' . vlog_comment . '*$'
          let ind = ind + offset
          if vverb | echo vverb_str "Indent after an open statement." | endif
    
        " Close statement
        "   De-indent for an optional close parenthesis and a semicolon, and only
        "   if there exists precedent non-whitespace char
        elseif last_line =~ ')*\s*;\s*' . vlog_comment . '*$' &&
          \ last_line !~ '^\s*)*\s*;\s*' . vlog_comment . '*$' &&
          \ last_line !~ '\(//\|/\*\).*\S)*\s*;\s*' . vlog_comment . '*$' &&
          \ ( last_line2 =~ vlog_openstat . '\s*' . vlog_comment . '*$' &&
          \ last_line2 !~ ';\s*//.*$') &&
          \ last_line2 !~ '^\s*' . vlog_comment . '$'
          let ind = ind - offset
          if vverb | echo vverb_str "De-indent after a close statement." | endif
    
      " `ifdef and `else
      elseif last_line =~ '^\s*`\<\(ifdef\|else\)\>'
        let ind = ind + offset
        if vverb
          echo vverb_str "Indent after a `ifdef or `else statement."
        endif
    
      endif
    
      " Re-indent current line
    
      " De-indent on the end of the block
      " join/end/endcase/endfunction/endtask/endspecify
      if curr_line =~ '^\s*\<\(join\|join_any\|join_none\|\|end\|endcase\|while\)\>' ||
          \ curr_line =~ '^\s*\<\(endfunction\|endtask\|endspecify\|endclass\)\>' ||
        \ curr_line =~ '^\s*\<\(endpackage\|endsequence\|endclocking\|endrule\|endmethod\|endinterface\)\>' ||
          \ curr_line =~ '^\s*\<\(endgroup\|endproperty\|endprogram\)\>' ||
          \ curr_line =~ '^\s*}'
        let ind = ind - offset
        if vverb | echo vverb_str "De-indent the end of a block." | endif
      elseif curr_line =~ '^\s*\<endmodule\>'
        let ind = ind - indent_modules
        if vverb && indent_modules
          echo vverb_str "De-indent the end of a module."
        endif
    
      " De-indent on a stand-alone 'begin'
      elseif curr_line =~ '^\s*\<begin\>'
        if last_line !~ '^\s*\<\(function\|task\|specify\|module\|class\|package\)\>' ||
          \ last_line !~ '^\s*\<\(sequence\|clocking\|rule\|method\|interface\|covergroup\)\>' ||
          \ last_line !~ '^\s*\<\(property\|program\)\>' &&
          \ last_line !~ '^\s*\()*\s*;\|)\+\)\s*' . vlog_comment . '*$' &&
          \ ( last_line =~
          \ '\<\(`\@<!if\|`\@<!else\|for\|case\%[[zx]]\|always\|initial\|do\|foreach\|randcase\|final\)\>' ||
          \ last_line =~ ')\s*' . vlog_comment . '*$' ||
          \ last_line =~ vlog_openstat . '\s*' . vlog_comment . '*$' )
          let ind = ind - offset
          if vverb
            echo vverb_str "De-indent a stand alone begin statement."
          endif
        endif
    
      " De-indent after the end of multiple-line statement
      elseif curr_line =~ '^\s*)' &&
        \ ( last_line =~ vlog_openstat . '\s*' . vlog_comment . '*$' ||
        \ last_line !~ vlog_openstat . '\s*' . vlog_comment . '*$' &&
        \ last_line2 =~ vlog_openstat . '\s*' . vlog_comment . '*$' )
        let ind = ind - offset
        if vverb
          echo vverb_str "De-indent the end of a multiple statement."
        endif
    
      " De-indent `else and `endif
      elseif curr_line =~ '^\s*`\<\(else\|endif\)\>'
        let ind = ind - offset
        if vverb | echo vverb_str "De-indent `else and `endif statement." | endif
    
      endif
    
      " Return the indention
      return ind
    endfunction
    
    " vim:sw=2
    
  endif

endfunction

fu Hlfile()

  if version > 700
    let f=system("for i in $SEARCH_PATHS; do ls $i/*.bsv 2> /dev/null; done")
    for p in split(f)
      let s=split(p, "/")
      let fname=substitute(s[len(s)-1], ".bsv", "", "")
      execute "syn keyword cStructure" fname
    endfor
    
    highlight MyGroup ctermfg=blue guifg=blue
    highlight def link cStructure MyGroup
    set mouse=a
   
    call BsvSyntax()
    call BsvIndent()
  endif

endfunction

fu Find()

  if version > 700
    let f="/" . expand("<cword>") . "." . "bsv"
    let dir=system("echo -n $SEARCH_PATHS")
    let cf=expand("%")
    for p in split(dir)
      let p=p . f
      if p!=cf
        try
        execute ":find " . p
        catch /.*/
        endtry
      endif
    endfor
   
    Hlfile
  endif

endfunction

command! -nargs=0 Hlfile :call Hlfile()
command! -nargs=0 Find :call Find()

map <2-LeftMouse> :Find<CR>
"map <C-W> :qa<CR>

"au BufNewFile,BufRead   *.bsv   set filetype=bsv
