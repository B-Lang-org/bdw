package Mult1;

import Mult::*;

// Simple (naive) binary multiplier

(* synthesize *)
module mkMult1( Mult_IFC );
   Reg#(Tout)    product <- mkReg(?);
   Reg#(Tout)    mcand   <- mkReg(?);
   Reg#(Tin)     mplr    <- mkReg(0);
   Reg#(Bool)    available   <- mkReg(True);

   rule cycle ( mplr != 0 );
      if (mplr[0] == 1) product <= product + mcand;
      mcand   <= mcand << 1;
      mplr    <= mplr  >> 1;
   endrule
   
   method Action start(Tin m1, Tin m2) if (available);
      available <= False;
      product <= 0;
      mcand   <= {0, m1};
      mplr    <= m2;
   endmethod

   method result() if (mplr == 0);
      actionvalue
	 available <= True;
	 return (product);
      endactionvalue
   endmethod
   
endmodule: mkMult1
        
endpackage: Mult1
