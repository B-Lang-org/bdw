package Mult4Tb;

import Mult::*;
import Mult4::*;
import RandGen::*;
import GetPut::*;
import FIFO::*;

(* synthesize *)
module mkMult4Tb (Empty);

   let maxTestCount = 100;
   let n = valueof(BuffSize);

   // The farms
   Mult_IFC farm1 <- mkMult1Farm;
   Mult_IFC farm2 <- mkMult2Farm;

   // counter for number of tests:
   Reg#(int) ctr <- mkReg(0);

   Get#(Tin) rndm <- mkRn_16;
   FIFO#(Tin) m1fifo <- mkFIFO;
   FIFO#(Tin) m2fifo <- mkFIFO;

   FIFO#(Tin) m1displayfifo <- mkSizedFIFO(n);
   FIFO#(Tin) m2displayfifo <- mkSizedFIFO(n);
   
   // RULES ----------------

   // rules to fill the two input fifos:
   rule fill_m1fifo;
      let x <- rndm.get;
      m1fifo.enq(x);
      m1displayfifo.enq(x);
   endrule

   rule fill_m2fifo;
      let x <- rndm.get;
      m2fifo.enq(x);
      m2displayfifo.enq(x);
   endrule
   
   rule rule_tb_start_task;
      let m1 = m1fifo.first;  m1fifo.deq;
      let m2 = m2fifo.first;  m2fifo.deq;
      $display("    Inputs:  m1 = %d, m2 = %d", m1, m2);
      farm1.start (m1, m2);
      farm2.start (m1, m2);
   endrule
 
   rule rule_tb_end_task (ctr < maxTestCount);
      let m1 = m1displayfifo.first;  m1displayfifo.deq;
      let m2 = m2displayfifo.first;  m2displayfifo.deq;
      let z1 <- farm1.result();
      let z2 <- farm2.result();
      if (z1==z2)
	 $display("    Results: (%d * %d = ) %d, %d", m1, m2, z1, z2);
      else
	 $display("    Results: (%d * %d = ) %d, %d -- ERROR", m1, m2, z1, z2);
      ctr <= ctr+1;
   endrule
   
   rule stop (ctr >= maxTestCount);
      $finish(0);
   endrule
   
   
endmodule: mkMult4Tb

endpackage: Mult4Tb
