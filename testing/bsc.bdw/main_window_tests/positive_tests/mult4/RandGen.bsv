import GetPut::*;
import FIFO::*;
import LFSR::*;

// The first part of this file defines a random number generator.  The
// algorithm uses the library LFSR (Linear Feedback Shift Register) package.
// This produces reasonable pseudo-random numbers for many purposes (though
// not good enough for cryptography).  The package defines several versions of
// mkLFSR, with different widths of output.  We want 6-bit random numbers, so
// we will use the 16-bit version, and take the most significant six bits.

// The interface for LFSR is defined as follows:
//
// interface LFSR #(type a);
//     method Action seed(a x1);
//     method a value();
//     method Action next();
// endinterface: LFSR
//
// The seed method must be called first, to prime the algorithm.  Then values
// may be read using the value method, and the algorithm stepped on to the
// next value by the next method.

// The interface for the random number generator is also parameterized on bit
// length.  It is a "get" interface, defined in the GetPut package.

typedef Get#(Bit#(n)) RandI#(type n);

// This next module is the random number generator itself.  It produces 16-bit
// random numbers by taking the middle bits of a 32-bit number (this is
// because the outer bits of an LFSR sequence tend to be in a less random
// sequence).  But we want the values of our numbers to be of random
// lengths (so that the time taken by our tasks will also be random); so,
// since the values of random numbers of a given wordlength are all roughly
// the same (why?), we use a second random sequence (of 4-bit values taken
// from the middle bits of a 16-bit sequence) to shift the values from the
// first sequence by a random amount.

module mkRn_16(RandI#(16));
  // First we instantiate the LFSR module
  LFSR#(Bit#(32)) lfsr32 <- mkLFSR_32;
  LFSR#(Bit#(16)) lfsr16 <- mkLFSR_16;

  // Next comes a FIFO for storing the results until needed
  FIFO#(Bit#(16)) fi();
  mkFIFO thefi(fi);

  // A boolean flag for ensuring that we first seed the LFSR module
  Reg#(Bool) starting();
  mkReg#(True) thestarting(starting);

  // This rule fires first, and sends a suitable seed to the module.
  rule start
  (starting);
      starting <= False;
      (lfsr32.seed)('h1010101);
      (lfsr16.seed)('h11);
  endrule: start

  // After that, the following rule runs as often as it can, retrieving
  // results from the LFSR modules, and enqueing the appropriately shifted
  // values on the FIFO.
   rule run (!starting);
      let v = lfsr32.value[24:9];
      let s = lfsr16.value[9:6];
      (fi.enq)(v >> s);
      lfsr32.next;
      lfsr16.next;
  endrule: run

  // The interface for mkRn_16 is a Get interface.  We can produce this from a
  // FIFO using the fifoToGet function.  We therefore don't need to define any
  // new methods explicitly in this module: we can simply return the produced
  // Get interface as the "result" of this module instantiation.
  return fifoToGet(fi);
endmodule
