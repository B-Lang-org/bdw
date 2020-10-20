
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif


// Depth 1 FIFO
// Allows simultaneous ENQ and DEQ (at the expense of potentially
// causing combinational loops).
module FIFOL1(CLK, 
              RST, 
              D_IN, 
              ENQ, 
              FULL_N, 
              D_OUT, 
              DEQ, 
              EMPTY_N, 
              CLR);
   // synopsys template   
   parameter             width = 1;

   input                 CLK;
   input                 RST;

   input [width - 1 : 0] D_IN;
   input                 ENQ;
   input                 DEQ;
   input                 CLR ;

   output                FULL_N;
   output                 EMPTY_N;
   output [width - 1 : 0] D_OUT;


   
   reg                    empty_reg ;
   reg [width - 1 : 0]    D_OUT;

`ifdef BSV_NO_INITIAL_BLOCKS
`else // not BSV_NO_INITIAL_BLOCKS
   // synopsys translate_off
   initial 
     begin
        D_OUT     <= `BSV_ASSIGNMENT_DELAY {((width + 1)/2) {2'b10}} ;
        empty_reg <= `BSV_ASSIGNMENT_DELAY 1'b0;
     end // initial begin
   // synopsys translate_on
`endif // BSV_NO_INITIAL_BLOCKS

   
   assign FULL_N = !empty_reg || DEQ;
   assign EMPTY_N = empty_reg ;
   
   always@(posedge CLK /* or negedge RST */ )
     begin
        if (!RST)
           begin
             empty_reg <= `BSV_ASSIGNMENT_DELAY 1'b0;
           end
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
    
   always@(posedge CLK /* or negedge RST */ )
     begin
        // Following section initializes the data registers which
        // may be desired only in some situations.
        // Uncomment to initialize array        
        /*
        if (!RST)
          begin
             D_OUT <= `BSV_ASSIGNMENT_DELAY {width {1'b0}} ;
          end
        else
         */
          begin
              if (ENQ)
                D_OUT     <= `BSV_ASSIGNMENT_DELAY D_IN;
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
             $display( "Warning: FIFOL1: %m -- Dequeuing from empty fifo" ) ;
          end
        if ( ! FULL_N && ENQ && ! DEQ)
          begin
             enqerror =  1 ;             
             $display( "Warning: FIFOL1: %m -- Enqueuing to a full fifo" ) ;
          end
     end
   // synopsys translate_on

endmodule
