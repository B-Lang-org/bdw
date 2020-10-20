
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif


// Depth 1 FIFO
// Allows simultaneous ENQ and DEQ (at the expense of potentially
// causing combinational loops).
module FIFOL10(CLK, RST, ENQ, FULL_N, DEQ, EMPTY_N, CLR);
   input  CLK;
   input  RST;
   input  ENQ;
   input  DEQ;
   input  CLR ;

   output FULL_N;
   output EMPTY_N;

   reg    empty_reg;

   assign FULL_N  = !empty_reg || DEQ;
   assign EMPTY_N = empty_reg ;
   
`ifdef BSV_NO_INITIAL_BLOCKS
`else // not BSV_NO_INITIAL_BLOCKS
   // synopsys translate_off
   initial 
     begin
        empty_reg = 1'b0 ;
     end // initial begin
   // synopsys translate_on
`endif // BSV_NO_INITIAL_BLOCKS


   always@(posedge CLK /* or negedge RST */ )
     begin
        if (!RST)
          begin
             empty_reg <= `BSV_ASSIGNMENT_DELAY 1'b0;
          end // if (RST == 0)
        else
          begin
             if (CLR)
               begin
                  empty_reg <= `BSV_ASSIGNMENT_DELAY 1'b0;
               end
             else if (ENQ)
               begin
                  empty_reg <= `BSV_ASSIGNMENT_DELAY 1'b1;
               end
             else if (DEQ)
               begin
                  empty_reg <= `BSV_ASSIGNMENT_DELAY 1'b0;
               end // if (DEQ)
          end // else: !if(RST == 0)
     end // always@ (posedge CLK or negedge RST)

   // synopsys translate_off
   always@(posedge CLK)
     begin: error_checks
        reg deqerror, enqerror ;
        
        deqerror =  0;
        enqerror = 0;        
        if ( ! empty_reg && DEQ )
          begin
             deqerror = 1 ;             
             $display( "Warning: FIFOL10: %m -- Dequeuing from empty fifo" ) ;
          end
        if ( ! FULL_N && ENQ && ! DEQ)
          begin
             enqerror =  1 ;             
             $display( "Warning: FIFOL10: %m -- Enqueuing to a full fifo" ) ;
          end
     end
   // synopsys translate_on
   
endmodule

