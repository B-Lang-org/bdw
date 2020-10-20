
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif


// Depth 2 FIFO
module FIFO2(CLK,
             RST, 
             D_IN, 
             ENQ, 
             FULL_N, 
             D_OUT, 
             DEQ, 
             EMPTY_N, 
             CLR);
   // synopsys template   

   parameter width = 1;
   parameter guarded = 1;

   input     CLK ;
   input     RST ;
   input [width - 1 : 0] D_IN;
   input                 ENQ;
   input                 DEQ;
   input                 CLR ;
   
   output                FULL_N;
   output                EMPTY_N;
   output [width - 1 : 0] D_OUT;

   reg                    full_reg;
   reg                    empty_reg;
   reg [width - 1 : 0]    data0_reg;
   reg [width - 1 : 0]    data1_reg;

   assign                 FULL_N = full_reg ;
   assign                 EMPTY_N = empty_reg ;
   assign                 D_OUT = data0_reg ;
   

   // Optimize the loading logic since state encoding is not power of 2!
   wire                   d0di = (ENQ && ! empty_reg ) || ( ENQ && DEQ && full_reg ) ;
   wire                   d0d1 = DEQ && ! full_reg ;
   wire                   d0h = ((! DEQ) && (! ENQ )) || (!DEQ && empty_reg ) || ( ! ENQ &&full_reg) ;
   wire                   d1di = ENQ & empty_reg ;
   
`ifdef BSV_NO_INITIAL_BLOCKS
`else // not BSV_NO_INITIAL_BLOCKS
   // synopsys translate_off
   initial 
     begin
        data0_reg   = {((width + 1)/2) {2'b10}} ;
        data1_reg  = {((width + 1)/2) {2'b10}} ;
        empty_reg = 1'b0;
        full_reg  = 1'b1;
     end // initial begin
   // synopsys translate_on
`endif // BSV_NO_INITIAL_BLOCKS

   always@(posedge CLK /* or negedge RST */) 
     begin
        if (!RST) 
          begin
             empty_reg <= `BSV_ASSIGNMENT_DELAY 1'b0;
             full_reg  <= `BSV_ASSIGNMENT_DELAY 1'b1;
          end // if (RST == 0)
        else
          begin
             if (CLR)
               begin
                  empty_reg <= `BSV_ASSIGNMENT_DELAY 1'b0;
                  full_reg  <= `BSV_ASSIGNMENT_DELAY 1'b1;
               end // if (CLR)
             else if ( ENQ && ! DEQ ) // just enq
               begin
                  empty_reg <= `BSV_ASSIGNMENT_DELAY 1'b1;
                  full_reg <= `BSV_ASSIGNMENT_DELAY ! empty_reg ;
               end 
             else if ( DEQ && ! ENQ )
               begin
                  full_reg  <= `BSV_ASSIGNMENT_DELAY 1'b1;
                  empty_reg <= `BSV_ASSIGNMENT_DELAY ! full_reg;
               end // if ( DEQ && ! ENQ )
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
             data0_reg <= `BSV_ASSIGNMENT_DELAY {width {1'b0}} ;
             data1_reg <= `BSV_ASSIGNMENT_DELAY {width {1'b0}} ;
          end
        else
         */
          begin
             data0_reg  <= `BSV_ASSIGNMENT_DELAY 
                           {width{d0di}} & D_IN | {width{d0d1}} & data1_reg | {width{d0h}} & data0_reg ;
             data1_reg <= `BSV_ASSIGNMENT_DELAY 
                          d1di ? D_IN : data1_reg ;
          end // else: !if(RST == 0)
     end // always@ (posedge CLK or negedge RST)
   

   
   // synopsys translate_off
   always@(posedge CLK)
     begin: error_checks
        reg deqerror, enqerror ;
        
        deqerror =  0;
        enqerror = 0;
        if ( RST ) 
          begin 
             if ( ! empty_reg && DEQ )
               begin
                  deqerror =  1;
                  $display( "Warning: FIFO2: %m -- Dequeuing from empty fifo" ) ;
               end
             if ( ! full_reg && ENQ && (!DEQ || guarded) )
               begin
                  enqerror = 1;
                  $display( "Warning: FIFO2: %m -- Enqueuing to a full fifo" ) ;
               end
          end
     end // always@ (posedge CLK)   
   // synopsys translate_on
   
endmodule
