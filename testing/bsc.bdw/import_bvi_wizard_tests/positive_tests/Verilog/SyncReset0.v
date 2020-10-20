
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif


module SyncReset0 (
		   IN_RST,
		   OUT_RST
		   );

   input   IN_RST ;
   output  OUT_RST ;

   assign  OUT_RST = IN_RST ;

endmodule
