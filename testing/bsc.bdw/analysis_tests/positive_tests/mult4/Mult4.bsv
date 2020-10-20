package Mult4;

import Mult::*;
import Mult1::*;
import Mult2::*;

import FIFO::*;
import GetPut::*;
import CompletionBuffer::*;

typedef Tuple2#(Tin,Tin) Args;

typedef 8 BuffSize;
typedef CBToken#(BuffSize) Token;

module mkFarm#(module#(Mult_IFC) mkM) (Mult_IFC);

   let n = div(valueof(BuffSize),2); // make the buffer twice the size of the
                                     // farm.
   // Declare the array of servers and instantiate them:
   Mult_IFC mults[n];
   for (Integer i=0; i<n; i=i+1)
      begin
         let s <- mkM;
         mults[i] = s;
      end

   FIFO#(Args) infifo <- mkFIFO;
   CompletionBuffer#(BuffSize,Tout) cbuff <- mkCompletionBuffer;

   // an array of flags telling which servers are available:
   Reg#(Bool) free[n];
   // an array of tokens for the jobs in progress on the servers:
   Reg#(Token) tokens[n];
   for (Integer i=0; i<n; i=i+1)
      begin
         // Instantiate the elements of the two arrays:
         let f <- mkReg(True);
         free[i] = f;
         let t <- mkRegU;
         tokens[i] = t;

         let s = mults[i];

         // The rules for sending tasks to this particular server, and for
         // dealing with returned results:
         rule start_server (f); // start only if flag says it's free
            let new_t <- cbuff.reserve.get;
            
            match {.a1, .a2} = infifo.first;
            infifo.deq;

            f <= False;
            t <= new_t;
            s.start(a1,a2);
         endrule

         rule end_server (!f);
            // TASK: complete this method.
            let x <- s.result;
	    cbuff.complete.put(tuple2(t,x));
	    f <= True;
         endrule
      end

   method Action start (m1, m2);
      // TASK: complete this method.
      infifo.enq(tuple2(m1,m2));      
   endmethod

   method result = cbuff.drain.get;
endmodule

// Make a farm of "naive" servers:
module mkMult1Farm(Mult_IFC);
   let ifc <- mkFarm(mkMult1);
   return ifc;
endmodule

// Do the same for the farm of Booth servers:
module mkMult2Farm(Mult_IFC);
   let ifc <- mkFarm(mkMult2);
   return ifc;
endmodule
         
endpackage   
