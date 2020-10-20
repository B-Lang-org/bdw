
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif


module MakeReset (
		  CLK,
		  RST,
                  ASSERT,
		  ASSERT_OUT,

                  DST_CLK,
                  OUT_RST
                  );
  
   parameter          RSTDELAY = 2  ; // Width of reset shift reg
   parameter          init = 1 ;

   input              CLK ;
   input              RST ;
   input              ASSERT ;
   output             ASSERT_OUT ;

   input              DST_CLK ;
   output             OUT_RST ;

   reg                rst ;
   wire               OUT_RST ;

   assign ASSERT_OUT = !rst ;

   SyncReset #(RSTDELAY) rstSync (.CLK(DST_CLK),
				  .IN_RST(rst),
				  .OUT_RST(OUT_RST));

   always@(posedge CLK or negedge RST) begin
      if (RST == 0)
        rst <= `BSV_ASSIGNMENT_DELAY init;
      else 
        begin 
           if (ASSERT)
             rst <= `BSV_ASSIGNMENT_DELAY 1'b0;
           else // if (rst == 1'b0)
             rst <= `BSV_ASSIGNMENT_DELAY 1'b1;
        end // else: !if(RST == 0)
   end // always@ (posedge CLK or negedge RST)

`ifdef BSV_NO_INITIAL_BLOCKS
`else // not BSV_NO_INITIAL_BLOCKS
   // synopsys translate_off
   initial begin
      #0 ;
      rst = 1'b1 ;
   end
   // synopsys translate_on
`endif // BSV_NO_INITIAL_BLOCKS

endmodule // MakeReset
