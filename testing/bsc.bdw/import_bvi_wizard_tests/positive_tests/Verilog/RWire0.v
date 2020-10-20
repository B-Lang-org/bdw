
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif


module RWire0(WHAS, WSET);
   // synopsys template   
   input                    WSET;
   output                   WHAS;

   assign WHAS = WSET;

endmodule
