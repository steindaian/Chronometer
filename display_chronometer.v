module display_chronometer #( parameter CLK_FPGA = 100000000, parameter CLK_DIV=5000000, parameter CLK_DISPLAY = 1000) (
			    input clk,
			    input rst,
			    input start,
			    input stop,
			    input restart,
			    output [7:0] hex_display,
			    output [3:0] an
			    );

   wire [15:0] 				 value;
   wire 				 clk_1khz;
   wire 				 start_d;//,restart_d,stop_d;
   
   /*clk_div #( .FREQ_IN(CLK_FPGA), .FREQ_OUT(CLK_DISPLAY) ) div (
							 .clk_in(clk),
							 .rst(rst),
							 .clk_out(clk_1khz)
							 );*/
   
   debounce sta (
		 .clk(clk),
		 .rst(rst),
		 .in(start),
		 .out(start_d)
		 );
   
   led_chronometer #( .CLK_FPGA(CLK_FPGA), .CLK_DIV(CLK_DIV)) led (
			  .clk(clk),
			  .rst(rst),
			  .start(start_d),
			  .stop(stop),
			  .restart(restart),
			  .value(value)
			  );

   display_7_seg display (
			  .clk(clk),
			  .rst(rst),
			  .data(value),
			  .hex_display(hex_display),
			  .an(an)
			  );
endmodule // display_chronometer

			 
