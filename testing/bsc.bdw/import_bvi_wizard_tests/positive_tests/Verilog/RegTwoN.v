
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif


module RegTwoN(CLK, RST, Q_OUT, D_INA, ENA, D_INB, ENB);
   // synopsys template   
   parameter width = 1;
   parameter init  = {width {1'b0}} ;

   input     CLK;
   input     RST;
   input     ENA, ENB;
   input [width - 1 : 0] D_INA;
   input [width - 1 : 0] D_INB;

   output [width - 1 : 0] Q_OUT;

   reg [width - 1 : 0]    Q_OUT;

   always@(posedge CLK)
     begin
        if (RST == 0)
          Q_OUT <= `BSV_ASSIGNMENT_DELAY init;
        else
          begin
             if (ENA)
               Q_OUT <= `BSV_ASSIGNMENT_DELAY D_INA;
             else if (ENB)
               Q_OUT <= `BSV_ASSIGNMENT_DELAY D_INB;
          end // else: !if(RST == 0)        
     end // always@ (posedge CLK)
   
`ifdef BSV_NO_INITIAL_BLOCKS
`else // not BSV_NO_INITIAL_BLOCKS
   // synopsys translate_off
   initial begin
      Q_OUT = {((width + 1)/2){2'b10}} ;
   end
   // synopsys translate_on
`endif // BSV_NO_INITIAL_BLOCKS

endmodule

