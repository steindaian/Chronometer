module led_chronometer #( parameter CLK_FPGA = 100000000, parameter CLK_DIV = 5000000) (
											  input 	rst,
											  input 	clk,
											  input 	start,
											  input 	stop,
											  input 	restart,

											  output [15:0] value
											  );

   wire 			     blink;
   wire 			     clk_out,clk_int;
   
   clk_gen #( .FREQ_IN(CLK_FPGA), .FREQ_OUT(CLK_DIV<<2)) c_gen1 (
		  .clk_in(clk),
		  .rst(rst),
		  .clk_out(clk_int)
		  );
   clk_gen #( .FREQ_IN(CLK_DIV<<2), .FREQ_OUT(CLK_DIV)) c_gen2 ( //just for nexys3
		  .clk_in(clk_int),
		  .rst(rst),
		  .clk_out(clk_out)
		  );
   
   /*counter_top #( .SIZE(32), .VALUE(CLK_DIV)) count (
		  .clk(clk_out),
		  .rst(rst),
		  .valued_reached(blink),
		  .start(start),
		  .stop(stop)
		  );*/
   chronometer_control #( .SIZE(32), .VALUE(CLK_DIV)) control (
				.clk(clk_out),
				.rst(rst),
				.start_d(start),
				.stop_d(stop),
				.restart_d(restart),
				.value(value)
				);


endmodule // led_chronometer
