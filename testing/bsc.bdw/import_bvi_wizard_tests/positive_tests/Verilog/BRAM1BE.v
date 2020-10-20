
`ifdef BSV_ASSIGNMENT_DELAY
`else
 `define BSV_ASSIGNMENT_DELAY
`endif

// Single-Ported BRAM with byte enables
module BRAM1BE(CLK,
               WE,
               ADDR,
               DI,
               DO
               );

   // synopsys template
   parameter                      PIPELINED  = 0;
   parameter                      ADDR_WIDTH = 1;
   parameter                      DATA_WIDTH = 1;
   parameter                      CHUNKSIZE  = 1;
   parameter                      WE_WIDTH   = 1;
   parameter                      MEMSIZE    = 1;

   
   input                          CLK;
   input [WE_WIDTH-1:0]           WE;
   input [ADDR_WIDTH-1:0]         ADDR;
   input [DATA_WIDTH-1:0]         DI;
   output [DATA_WIDTH-1:0]        DO;

   reg [DATA_WIDTH-1:0]           RAM[0:MEMSIZE-1];
   reg [ADDR_WIDTH-1:0]           ADDR_R;
   reg [DATA_WIDTH-1:0]           DO_R;

   reg [DATA_WIDTH-1:0]           DATA;
   
   integer                        j;
   
      
`ifdef BSV_NO_INITIAL_BLOCKS
`else
   // synopsys translate_off
   integer                        i;
   initial
   begin : init_block
      for (i = 0; i < MEMSIZE; i = i + 1) begin
         RAM[i] = { ((DATA_WIDTH+1)/2) { 2'b10 } };
      end
      ADDR_R = { ((ADDR_WIDTH+1)/2) { 2'b10 } };
      DO_R = { ((DATA_WIDTH+1)/2) { 2'b10 } };
   end
   // synopsys translate_on
`endif // !`ifdef BSV_NO_INITIAL_BLOCKS

   // iverilog does not support the full verilog-2001 language.  This fixes that for simulation.
`ifdef __ICARUS__
   reg [DATA_WIDTH-1:0] MASK, IMASK;
   
   always @(WE or DI or ADDR) begin
      DATA  = RAM[ADDR];
      MASK  = 0;
      IMASK = 0;
      
      for(j = WE_WIDTH-1; j >= 0; j = j - 1) begin
         if (WE[j]) MASK = (MASK << 8) | { { DATA_WIDTH-CHUNKSIZE { 1'b0 } }, { CHUNKSIZE { 1'b1 } } };
         else       MASK = (MASK << 8);
      end
      IMASK = ~MASK;

      DATA = (DATA & IMASK) | (DI & MASK);
   end
   
`else
   always @(WE or DI or ADDR) begin
      for(j = 0; j < WE_WIDTH; j = j + 1) begin
         if (WE[j]) DATA[j*CHUNKSIZE +: CHUNKSIZE] = DI[j*CHUNKSIZE +: CHUNKSIZE];
         else       DATA[j*CHUNKSIZE +: CHUNKSIZE] = RAM[ADDR][j*CHUNKSIZE +: CHUNKSIZE];
      end
   end
`endif // !`ifdef __ICARUS__
   
   always @(posedge CLK) begin
      if (|WE)
        RAM[ADDR] <= `BSV_ASSIGNMENT_DELAY DATA;
      ADDR_R    <= `BSV_ASSIGNMENT_DELAY ADDR;
      DO_R      <= `BSV_ASSIGNMENT_DELAY RAM[ADDR_R];
   end

   assign DO = (PIPELINED) ? DO_R : RAM[ADDR_R];
   
endmodule // BRAM1BE


