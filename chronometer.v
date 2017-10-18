module chronometer (
		    input rst,
		    input clk,
		    output blink
		    );

   wire 		   clk_out;

   /*clk_gen #( .FREQ_IN(50000000), .FREQ_OUT(5000000)) c_gen (
		  .clk_in(clk),
		  .rst(rst),
		  .clk_out(clk_out)
		  );
   */
   counter_top c (
		  .clk(clk_out),
		  .rst(rst),
		  .valued_reached(blink)
		  );

endmodule // chronometer
