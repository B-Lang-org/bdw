
`ifdef BSV_ASSIGNMENT_DELAY
`else
 `define BSV_ASSIGNMENT_DELAY
`endif

// Dual-Ported BRAM
module BRAM2Load(CLKA,
                 WEA,
                 ADDRA,
                 DIA,
                 DOA,
                 CLKB,
                 WEB,
                 ADDRB,
                 DIB,
                 DOB
                 );

   // synopsys template
   parameter                      FILENAME   = "";
   parameter                      BINARY     = 0;
   parameter                      PIPELINED  = 0;
   parameter                      ADDR_WIDTH = 1;
   parameter                      DATA_WIDTH = 1;
   parameter                      MEMSIZE    = 1;

   
   input                          CLKA;
   input                          WEA;
   input [ADDR_WIDTH-1:0]         ADDRA;
   input [DATA_WIDTH-1:0]         DIA;
   output [DATA_WIDTH-1:0]        DOA;

   input                          CLKB;
   input                          WEB;
   input [ADDR_WIDTH-1:0]         ADDRB;
   input [DATA_WIDTH-1:0]         DIB;
   output [DATA_WIDTH-1:0]        DOB;

   reg [DATA_WIDTH-1:0]           RAM[0:MEMSIZE-1];
   reg [ADDR_WIDTH-1:0]           ADDRA_R;
   reg [ADDR_WIDTH-1:0]           ADDRB_R;
   reg [DATA_WIDTH-1:0]           DOA_R;
   reg [DATA_WIDTH-1:0]           DOB_R;

   // synopsys translate_off
   initial
   begin : init_block
`ifdef BSV_NO_INITIAL_BLOCKS
`else
      integer i;
      for (i = 0; i <= MEMSIZE; i = i + 1) begin
         RAM[i] = { ((DATA_WIDTH+1)/2) { 2'b10 } };
      end
      ADDRA_R = { ((ADDR_WIDTH+1)/2) { 2'b10 } };
      ADDRB_R = { ((ADDR_WIDTH+1)/2) { 2'b10 } };            
      DOA_R = { ((DATA_WIDTH+1)/2) { 2'b10 } };
      DOB_R = { ((DATA_WIDTH+1)/2) { 2'b10 } };            
`endif // !`ifdef BSV_NO_INITIAL_BLOCKS
      if (BINARY)
        $readmemb(FILENAME, RAM, 0, MEMSIZE-1);
      else
        $readmemh(FILENAME, RAM, 0, MEMSIZE-1);
   end
   // synopsys translate_on
   
   always @(posedge CLKA) begin
      if (WEA)
        RAM[ADDRA] <= `BSV_ASSIGNMENT_DELAY DIA;
      ADDRA_R    <= `BSV_ASSIGNMENT_DELAY ADDRA;
      DOA_R      <= `BSV_ASSIGNMENT_DELAY RAM[ADDRA_R];
   end

   always @(posedge CLKB) begin
      if (WEB)
        RAM[ADDRB] <= `BSV_ASSIGNMENT_DELAY DIB;
      ADDRB_R    <= `BSV_ASSIGNMENT_DELAY ADDRB;
      DOB_R      <= `BSV_ASSIGNMENT_DELAY RAM[ADDRB_R];
   end

   assign DOA = (PIPELINED) ? DOA_R : RAM[ADDRA_R];
   assign DOB = (PIPELINED) ? DOB_R : RAM[ADDRB_R];

endmodule // BRAM2Load



