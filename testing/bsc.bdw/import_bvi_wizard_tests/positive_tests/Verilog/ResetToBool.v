
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif


module ResetToBool( RST, VAL);
   // synopsys template
   
   input  RST;
   output VAL;
   
   assign VAL = (RST == 1'b0);
   
endmodule
