module bram_inf  #(parameter RAM_WIDTH = 16,    parameter RAM_ADDR_BITS = 9)   (
											       input 			      clk,
											       input [RAM_ADDR_BITS-1 : 0]  rd_addr,
											       output reg [RAM_WIDTH-1 : 0] rd_data,
											       input [RAM_ADDR_BITS-1 : 0]  wr_addr,
											       input [RAM_WIDTH-1 : 0]      wr_data,
											       input 			      write_enable
											       );
   
   reg [RAM_WIDTH- 1 : 0] 												      ram [2**RAM_ADDR_BITS-1:0];
				       											      always @(posedge clk)
																begin
																   
																      
																      if(write_enable)
																	ram[wr_addr] <= wr_data;
																      rd_data<= ram[rd_addr];
																   
																   
																end
endmodule
