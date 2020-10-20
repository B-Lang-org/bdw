
module WhitespaceTest(Out1, Out2, Out3, In1, In2, In3);

   // Test 0 whitespace characters between the range and the name
   input  [3:0]In1;
   output [4:1]Out1;

   // Test a tab between the range and the name
   input  [5:0]	In2;
   output [6:1]	Out2;

   // Test multiple tab and space characters
   input  [7:0]	  	In3;
   output [8:1]	   	Out3;

endmodule

