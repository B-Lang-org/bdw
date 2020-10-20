
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif

// N -bit counter with load, set and 2 increment
module Counter(CLK,
               RST,
               Q_OUT, 
               DATA_A, ADDA, 
               DATA_B, ADDB, 
               DATA_C, SETC, 
               DATA_F, SETF);
   // synopsys template   

   parameter width = 1;
   parameter init = 0;

   input                 CLK;
   input                 RST;
   input [width - 1 : 0] DATA_A;
   input                 ADDA;
   input [width - 1 : 0] DATA_B;
   input                 ADDB;
   input [width - 1 : 0] DATA_C;
   input                 SETC;
   input [width - 1 : 0] DATA_F;
   input                 SETF;
   
   output [width - 1 : 0] Q_OUT;


   
   reg [width - 1 : 0]    q_state ;
   
   assign                 Q_OUT = q_state ;
   
   always@(posedge CLK /*or negedge RST*/ ) begin
    if (RST == 0)
      q_state  <= `BSV_ASSIGNMENT_DELAY init;
    else
      begin
         if ( SETF )
           q_state <= `BSV_ASSIGNMENT_DELAY DATA_F ;
         else
           q_state <= `BSV_ASSIGNMENT_DELAY (SETC ? DATA_C : q_state ) + (ADDA ? DATA_A : {width {1'b0}}) + (ADDB ? DATA_B : {width {1'b0}} ) ;
      end // else: !if(RST == 0)      
   end // always@ (posedge CLK)

`ifdef BSV_NO_INITIAL_BLOCKS
`else // not BSV_NO_INITIAL_BLOCKS
   // synopsys translate_off
   initial begin
      q_state = {((width + 1)/2){2'b10}} ; 
   end
   // synopsys translate_on
`endif // BSV_NO_INITIAL_BLOCKS

endmodule

