
`ifdef BSV_ASSIGNMENT_DELAY
`else
 `define BSV_ASSIGNMENT_DELAY
`endif

// Single-Ported BRAM
module BRAM1Load(CLK,
                 WE,
                 ADDR,
                 DI,
                 DO
                 );

   // synopsys template
   parameter                      FILENAME   = "";
   parameter                      BINARY     = 0;
   parameter                      PIPELINED  = 0;
   parameter                      ADDR_WIDTH = 1;
   parameter                      DATA_WIDTH = 1;
   parameter                      MEMSIZE    = 1;

   
   input                          CLK;
   input                          WE;
   input [ADDR_WIDTH-1:0]         ADDR;
   input [DATA_WIDTH-1:0]         DI;
   output [DATA_WIDTH-1:0]        DO;

   reg [DATA_WIDTH-1:0]           RAM[0:MEMSIZE-1];
   reg [ADDR_WIDTH-1:0]           ADDR_R;
   reg [DATA_WIDTH-1:0]           DO_R;
      
   // synopsys translate_off
   initial
   begin : init_block
`ifdef BSV_NO_INITIAL_BLOCKS
`else
      integer i;
      for (i = 0; i <= MEMSIZE; i = i + 1) begin
         RAM[i] = { ((DATA_WIDTH+1)/2) { 2'b10 } };
      end
      ADDR_R = { ((ADDR_WIDTH+1)/2) { 2'b10 } };
      DO_R = { ((DATA_WIDTH+1)/2) { 2'b10 } };
`endif // !`ifdef BSV_NO_INITIAL_BLOCKS
      if (BINARY)
        $readmemb(FILENAME, RAM, 0, MEMSIZE-1);
      else
        $readmemh(FILENAME, RAM, 0, MEMSIZE-1);
   end
   // synopsys translate_on

   always @(posedge CLK) begin
      if (WE)
        RAM[ADDR] <= `BSV_ASSIGNMENT_DELAY DI;
      ADDR_R    <= `BSV_ASSIGNMENT_DELAY ADDR;
      DO_R      <= `BSV_ASSIGNMENT_DELAY RAM[ADDR_R];
   end

   assign DO = (PIPELINED) ? DO_R : RAM[ADDR_R];

endmodule // BRAM1Load



