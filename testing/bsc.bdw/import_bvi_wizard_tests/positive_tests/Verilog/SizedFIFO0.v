
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif


// Depth N FIFO (N > 1)
module SizedFIFO0(CLK, RST, ENQ, FULL_N, DEQ, EMPTY_N, CLR);
   // synopsys template   
   parameter p1depth = 2;
   parameter p2cntr_width = 2; // log2(p1depth+1)
   parameter guarded = 1;
   
   input     CLK;
   input     RST;
   input     CLR;
   input     ENQ;
   input     DEQ;
   output    FULL_N;
   output    EMPTY_N;

   reg       not_full;                           
   reg       not_empty;
   reg [p2cntr_width-1 : 0] count;
   
   assign                 EMPTY_N = not_empty;
   assign                 FULL_N = not_full;

`ifdef BSV_NO_INITIAL_BLOCKS
`else // not BSV_NO_INITIAL_BLOCKS
   // synopsys translate_off
   initial 
     begin
        count      = 0 ;        
        not_empty  = 1'b0;
        not_full   = 1'b1;
     end // initial begin
   // synopsys translate_on
`endif // BSV_NO_INITIAL_BLOCKS


   always @(posedge CLK /* or negedge RST */) 
     begin
        if (!RST)
          begin
             count <= `BSV_ASSIGNMENT_DELAY 0 ;
             not_empty <= `BSV_ASSIGNMENT_DELAY 1'b0;
             not_full <= `BSV_ASSIGNMENT_DELAY 1'b1;
          end // if (RST == 0)
        else
           begin
              if (CLR) 
                begin
                   count <= `BSV_ASSIGNMENT_DELAY 0 ;
                   not_empty <= `BSV_ASSIGNMENT_DELAY 1'b0;
                   not_full <= `BSV_ASSIGNMENT_DELAY 1'b1;
                end // if (CLR)              
              else begin
                 if (DEQ && ! ENQ && not_empty ) 
                   begin
                      not_full <= `BSV_ASSIGNMENT_DELAY 1'b1;
                      not_empty <= `BSV_ASSIGNMENT_DELAY  count != 'b01  ;   
                      count <= `BSV_ASSIGNMENT_DELAY count - 1'b1 ;
                   end // if (DEQ && ! ENQ && not_empty )
                 else if (ENQ && ! DEQ && not_full ) 
                   begin
                      not_empty <= `BSV_ASSIGNMENT_DELAY 1'b1;
                      not_full <= `BSV_ASSIGNMENT_DELAY count != (p1depth - 1) ;
                      count <= `BSV_ASSIGNMENT_DELAY count + 1'b1 ;
                   end // if (ENQ && ! DEQ && not_full )
              end // else: !if(CLR)
           end // else: !if(RST == 0)
     end // always @ (posedge CLK or negedge RST)
   
      // synopsys translate_off
   always@(posedge CLK)
     begin: error_checks
        reg deqerror, enqerror ;
        
        deqerror =  0;
        enqerror = 0;
        if ( RST )
           begin
              if ( ! EMPTY_N && DEQ )
                begin
                   deqerror = 1 ;             
                   $display( "Warning: SizedFIFO0: %m -- Dequeuing from empty fifo" ) ;
                end
              if ( ! FULL_N && ENQ && (!DEQ || guarded) )
                begin
                   enqerror =  1 ;             
                   $display( "Warning: SizedFIFO0: %m -- Enqueuing to a full fifo" ) ;
                end
           end // if ( RST )
     end // block: error_checks
   // synopsys translate_on

endmodule // SizedFIFO0

