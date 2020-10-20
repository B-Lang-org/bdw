
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif

// Standard register with asynchronous reset
module RegA(CLK, RST, Q_OUT, D_IN, EN);
   // synopsys template   

   parameter width = 1;
   parameter init = { width {1'b0}} ;

   input     CLK;
   input     RST;
   input     EN;
   input [width - 1 : 0] D_IN;
   output [width - 1 : 0] Q_OUT;

   reg [width - 1 : 0]    Q_OUT;

   always@(posedge CLK or negedge RST) begin
      if (RST == 0)
        Q_OUT <= `BSV_ASSIGNMENT_DELAY init;
      else
        begin
           if (EN)
             Q_OUT <= `BSV_ASSIGNMENT_DELAY D_IN;
        end 
   end // always@ (posedge CLK or negedge RST)
   

`ifdef BSV_NO_INITIAL_BLOCKS
`else // not BSV_NO_INITIAL_BLOCKS
   // synopsys translate_off
   initial begin
      Q_OUT = {((width + 1)/2){2'b10}} ;
   end
   // synopsys translate_on
`endif // BSV_NO_INITIAL_BLOCKS

endmodule

