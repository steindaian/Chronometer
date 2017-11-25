module led_chronometer #( parameter CLK_FPGA = 100000000, parameter CLK_DIV = 5000000, parameter ADDR_SIZE = 4, parameter DATA_SIZE = 16) (
											  input 	rst,
											  input 	clk,
											  input 	start,
											  input 	stop,
											  input 	restart,

											  //output [15:0] value,
											  
											  output [ADDR_SIZE-1 : 0]  rd_addr,
											 input  [DATA_SIZE-1 : 0] rd_data,
											 output [ADDR_SIZE-1 : 0]  wr_addr,
											 output [DATA_SIZE-1 : 0]      wr_data,
											 output 			      wr_en,
											 output rd_en,
											 output cs,
											 input rd_done,
											 
											 output [15:0] value
											  );

   wire 			     blink;
   wire 			     clk_out,clk_int;
   
   
   
   /*counter_top #( .SIZE(32), .VALUE(CLK_DIV)) count (
		  .clk(clk_out),
		  .rst(rst),
		  .valued_reached(blink)
		  );*/
   chronometer_control #( .SIZE(32), .VALUE(CLK_DIV), .DATA_SIZE(DATA_SIZE), .ADDR_SIZE(ADDR_SIZE)) control (
				.clk(clk),
				.rst(rst),
				.start_d(start),
				.stop_d(stop),
				.restart_d(restart),
				//.value(value),
				.wr_data(wr_data),
			  .rd_data(rd_data),
			  .rd_addr(rd_addr),
			  .wr_addr(wr_addr),
			  .wr_en(wr_en),
			  .rd_en(rd_en),
			  .cs(cs),
			  .rd_done(rd_done),
			  
			  .value(value)
				);


endmodule // led_chronometer
