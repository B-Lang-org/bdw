
// This module is not synthesizable.

`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif


// A generator for resets from an absolute clock, starting at 
// time 0. The output reset is held for RSTHOLD cycles, RSTHOLD > 0.

module InitialReset (
                     CLK,
                     OUT_RST
                     );

   parameter          RSTHOLD = 2  ; // Width of reset shift reg

   input              CLK ;
   output             OUT_RST ;

   // synopsys translate_off

   reg [RSTHOLD-1:0]  reset_hold ;

   assign  OUT_RST = reset_hold[RSTHOLD-1] ;

   always @( posedge CLK )
     begin
       reset_hold <= `BSV_ASSIGNMENT_DELAY ( reset_hold << 1 ) | 'b1 ;
     end // always @ ( posedge CLK )

   initial
     begin
       #0 // Required so that negedge is seen by any derived async resets
       reset_hold = 0;  // set to all 0s: RSTHOLD{1'b0}
     end


   // synopsys translate_on
   
endmodule // InitialReset

