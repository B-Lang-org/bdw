
`ifdef BSV_ASSIGNMENT_DELAY
`else
`define BSV_ASSIGNMENT_DELAY
`endif


module main();

   reg CLK;
   // reg CLK_GATE;
   reg RST;
   reg [31:0] cycle;
   reg        do_dump;
   reg        do_cycles;

   `TOP top(.CLK(CLK), /* .CLK_GATE(CLK_GATE), */ .RST(RST));

   initial begin
      // CLK_GATE = 1'b1;
      // CLK = 1'b0;    // This line will cause a neg edge of clk at t=0!
      // RST = 1'b0;  // This needs #0, to allow always blocks to wait
      cycle = 0;

      do_dump = $test$plusargs("bscvcd") ;
      do_cycles = $test$plusargs("bsccycle") ;

      if (do_dump)
        begin
           $dumpfile("dump.vcd");
           // $dumpon; unneeded
           $dumpvars;
        end
      #0
      RST = 1'b0;
      #1;
      CLK = 1'b1;
      // $display("reset");
      #1;
      RST = 1'b1;
      // $display("reset done");
      //  #200010;
      //  $finish;
   end

   always
     begin
        #1
        if (do_cycles)
	  $display("cycle %0d", cycle) ;
        cycle = cycle + 1 ;
        #4;
        CLK = 1'b0 ;
        #5;
        CLK = 1'b1 ;
   end

endmodule
