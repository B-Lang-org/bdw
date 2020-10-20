
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif

// Bluespec primitive module which allows creation of clocks
// with non-constant periods.  The CLK_IN and COND_IN inputs
// are registered and used to compute the CLK_OUT and
// CLK_GATE_OUT outputs.
module MakeClock ( CLK, RST,
                   CLK_IN, CLK_IN_EN,
                   COND_IN, COND_IN_EN,
                   CLK_VAL_OUT, COND_OUT,
                   CLK_OUT, CLK_GATE_OUT );

   parameter initVal = 0;
   parameter initGate = 1;

   input  CLK;
   input  RST;

   input  CLK_IN;
   input  CLK_IN_EN;
   input  COND_IN;
   input  COND_IN_EN;

   output CLK_VAL_OUT;
   output COND_OUT;
   output CLK_OUT;
   output CLK_GATE_OUT;
   
   reg current_clk;
   reg current_gate;
   reg new_gate;
   
   always @(posedge CLK or negedge RST)
   begin
     if (RST == 0)
     begin
       current_clk <= initVal;
       new_gate    <= initGate;
     end
     else
     begin
       if (CLK_IN_EN)
         current_clk <= CLK_IN;
       if (COND_IN_EN)
         new_gate <= COND_IN;
     end
   end


   // Use latch to avoid glitches
   // Gate can only change when clock is low
   always @( CLK_OUT or new_gate )
     begin
        if (CLK_OUT == 0)
          current_gate <= `BSV_ASSIGNMENT_DELAY new_gate ;
     end

   assign CLK_OUT      = current_clk & current_gate;
   assign CLK_GATE_OUT = current_gate;
   assign CLK_VAL_OUT  = current_clk;
   assign COND_OUT     = new_gate;
   
`ifdef BSV_NO_INITIAL_BLOCKS
`else // not BSV_NO_INITIAL_BLOCKS
   // synopsys translate_off
   initial begin
      #0 ;
      current_clk  = 1'b0 ;
      current_gate = 1'b1 ;
      new_gate     = 1'b1 ;
   end
   // synopsys translate_on
`endif // BSV_NO_INITIAL_BLOCKS
   
endmodule
   
   
