
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif


// A one bit data synchronization module, where data is synchronized
// by passing through 2 registers of the destination clock
module SyncBit (
                sCLK,
                sRST,
                dCLK,
                sEN,
                sD_IN,
                dD_OUT
                );
   parameter init = 1'b0;       // initial value for all registers
      
   // Signals on source clock (sCLK)
   input     sCLK;
   input     sRST;
   input     sEN;
   input     sD_IN;
   
   // Signals on destination clock (dCLK)
   input     dCLK;
   output    dD_OUT;
   
   reg       sSyncReg;
   reg       dSyncReg1, dSyncReg2;
   
   assign    dD_OUT = dSyncReg2 ;

   always @(posedge sCLK or negedge sRST)
      begin
         if (sRST ==0)
            begin
               sSyncReg <= `BSV_ASSIGNMENT_DELAY init ;
            end // if (sRST ==0)
         else
            begin
               if ( sEN )
                 begin
                    sSyncReg <= `BSV_ASSIGNMENT_DELAY (sD_IN == 1'b1) ? 1'b1 : 1'b0  ;
                 end // if ( sEN )
            end // else: !if(sRST ==0)
      end // always @ (posedge sCLK or negedge sRST)

   always @(posedge dCLK or negedge sRST)
      begin
         if (sRST ==0)
            begin
               dSyncReg1 <= `BSV_ASSIGNMENT_DELAY init ;
               dSyncReg2 <= `BSV_ASSIGNMENT_DELAY init ;
            end // if (sRST ==0)
         else
            begin
               dSyncReg1 <= `BSV_ASSIGNMENT_DELAY sSyncReg ; // clock domain crossing
               dSyncReg2 <= `BSV_ASSIGNMENT_DELAY dSyncReg1 ;
            end // else: !if(sRST ==0)
      end // always @ (posedge dCLK or negedge sRST)

   
`ifdef BSV_NO_INITIAL_BLOCKS
`else // not BSV_NO_INITIAL_BLOCKS
   // synopsys translate_off  
   initial
      begin
         sSyncReg  = init ;
         dSyncReg1 = init ;
         dSyncReg2 = init ;
      end // initial begin
   // synopsys translate_on
`endif // BSV_NO_INITIAL_BLOCKS

endmodule // BitSync
