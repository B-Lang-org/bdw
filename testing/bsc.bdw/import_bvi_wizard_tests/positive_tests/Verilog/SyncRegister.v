
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif

// A register synchronization module across clock domains.
// Uses a Handshake Pulse protocol to trigger the load on
// destination side registers
// Transfer takes 3 dCLK for destination side to see data,
// sRDY recovers takes 3 dCLK + 3 sCLK
module SyncRegister(
                    sCLK,
                    sRST,
                    dCLK,
                    sEN,
                    sRDY,
                    sD_IN,
                    dD_OUT
                    );
   parameter             width = 1 ;
   parameter             init = { width {1'b0 }} ;
   
   // Source clock domain ports
   input                 sCLK ;
   input                 sRST ;
   input                 sEN ;
   input [width -1 : 0]  sD_IN ;
   output                sRDY ;
      
   // Destination clock domain ports
   input                 dCLK ;
   output [width -1 : 0] dD_OUT ;

   wire                  dPulse ;
   reg [width -1 : 0]    sDataSyncIn ;
   reg [width -1 : 0]    dD_OUT ;

   // instantiate a Handshake Sync
   SyncHandshake sync( .sCLK(sCLK), .sRST(sRST),
                       .dCLK(dCLK),
                       .sEN(sEN), .sRDY(sRDY),
                       .dPulse(dPulse) ) ;

   always @(posedge sCLK or negedge sRST)
      begin
         if (sRST == 0)
           begin
              sDataSyncIn <= `BSV_ASSIGNMENT_DELAY init ;
           end // if (sRST == 0)
         else
           begin
              if ( sEN )
                begin
                   sDataSyncIn <= `BSV_ASSIGNMENT_DELAY sD_IN ;
                end // if ( sEN )
           end // else: !if(sRST == 0)
      end // always @ (posedge sCLK or negedge sRST)
   

   // Transfer the data to destination domain when dPulsed is asserted.
   // Setup and hold time are assured since at least 2 dClks occured since
   // sDataSyncIn have been written.
   always @(posedge dCLK or negedge sRST)
      begin
         if (sRST == 0)
           begin
              dD_OUT <= `BSV_ASSIGNMENT_DELAY init ;
           end // if (sRST == 0)
         else
            begin
               if ( dPulse )
                 begin
                    dD_OUT <= `BSV_ASSIGNMENT_DELAY sDataSyncIn ;// clock domain crossing
                 end // if ( dPulse )
            end // else: !if(sRST == 0)
      end // always @ (posedge dCLK or negedge sRST)


`ifdef BSV_NO_INITIAL_BLOCKS
`else // not BSV_NO_INITIAL_BLOCKS
   // synopsys translate_off  
   initial
      begin
         sDataSyncIn = {((width + 1)/2){2'b10}} ;
         dD_OUT      = {((width + 1)/2){2'b10}} ; 
      end // initial begin
   // synopsys translate_on
`endif // BSV_NO_INITIAL_BLOCKS


endmodule // RegisterSync

               
         
`ifdef testBluespec
module testSyncRegister() ;
   parameter dsize = 8;
   
   wire      sCLK, sRST, dCLK ;
   wire      sEN ;
   wire      sRDY ;
      
   reg [dsize -1:0]  sCNT ;
   wire [dsize -1:0] sDIN, dDOUT ;
   
   ClockGen#(20,9,10)  sc( sCLK );
   ClockGen#(11,12,26)  dc( dCLK );

   initial
     begin
        sCNT = 0;
        
        $dumpfile("SyncRegister.dump");
        $dumpvars(5) ;
        $dumpon ;
        #100000 $finish ;
     end
   
   SyncRegister #(dsize)
     dut( sCLK, sRST, dCLK, 
          sEN, sRDY, sDIN,
          dDOUT ) ;
   
   
   assign sDIN = sCNT ;
   assign sEN = sRDY ;
   
   always @(posedge sCLK)
     begin
        if (sRDY )
          begin
             sCNT <= `BSV_ASSIGNMENT_DELAY sCNT + 1;
          end
      end // always @ (posedge sCLK)

   
   
endmodule // testSyncFIFO
`endif
         
         
