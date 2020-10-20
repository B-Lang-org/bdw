
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif


module McpRegUN(CLK, RST, SET, val, get);
   // synopsys template   
   parameter width = 1;
   parameter delay = 0;

   input     CLK;
   input     RST;
   input     SET;
   input [width - 1 : 0] val;
   output [width - 1 : 0] get;

   reg [width - 1 : 0]    get;

`ifdef DC
`else
   wire [width - 1 : 0]   #delay delayed_val = val;
   wire [width - 1 : 0]   output_val = (val === delayed_val ? val : {width{1'bx}});
`endif
   
   always@(posedge CLK /* or negedge RST */)
     begin
        if (RST == 0)
          begin
             get <= `BSV_ASSIGNMENT_DELAY {((width + 1)/2){2'b10}} ;
          end
        else begin
           if (SET)
             begin
`ifdef DC      
                get <= `BSV_ASSIGNMENT_DELAY val;
`else
                get <= `BSV_ASSIGNMENT_DELAY output_val;
`endif
             end // if (SET)
        end // else: !if(RST == 0)
     end // always@ (posedge CLK or negedge RST)


`ifdef BSV_NO_INITIAL_BLOCKS
`else // not BSV_NO_INITIAL_BLOCKS
   // synopsys translate_off
   initial begin
      get = {((width + 1)/2){2'b10}} ;
   end
   // synopsys translate_on
`endif // BSV_NO_INITIAL_BLOCKS
   
endmodule

