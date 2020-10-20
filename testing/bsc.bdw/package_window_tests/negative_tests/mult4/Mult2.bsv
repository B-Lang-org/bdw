package Mult2; 

import Mult::*;

// Multiplier using Booth encoding

typedef Bit#(17) TinPlusOne;

function Tout boothenc (Bit#(3) n, Tout tmp);
   case ( n )
      0: return 0;
      1: return tmp;
      2: return tmp;
      3: return 2*tmp;
      4: return -(2*tmp);
      5: return (-tmp);
      6: return (-tmp);
      7: return 0;
   endcase
endfunction

(* synthesize *)
module mkMult2( Mult_IFC );
   Reg#(Tout)      product <- mkReg(?);
   Reg#(TinPlusOne)  mcand   <- mkReg(0);
   Reg#(Tout)      mplr    <- mkReg(?);
   Reg#(Bool)    available   <- mkReg(True);

   rule cycle ( mcand != 0 );
      Tout tmp = boothenc( mcand[2:0], mplr );
      product <= product + tmp;
      mplr    <= mplr  << 2;
      mcand   <= mcand >> 2;
   endrule
   
   method Action start (Tin m1, Tin m2) if (available);
      available <= False;
      product <= 0;
      mplr    <= zeroExtend(m1);
      mcand   <= { m2, 1'b0 };
   endmethod

   method result () if (mcand == 0);
      actionvalue
	 available <= True;
	 return product;
      endactionvalue
   endmethod
   
endmodule
        
endpackage
