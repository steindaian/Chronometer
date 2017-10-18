module one_read_one_write_bram  #(parameter RAM_WIDTH = 16,    parameter RAM_ADDR_BITS = 9)   (
											       input 			      clk,
											       input [RAM_ADDR_BITS – 1 : 0]  rd_addr,
											       output reg [RAM_WIDTH – 1 : 0] rd_data,
											       input [RAM_ADDR_BITS – 1 : 0]  wr_addr,
											       input [RAM_WIDTH – 1 : 0]      wr_data,
											       input 			      write_enable
											       );
   
   reg [RAM_WIDTH – 1 : 0] 												      ram [2**RAM_ADDR_BITS -1:0]
				       											      always
																@(posedge clk or posedge rst)
																begin
																   if(rst) begin
																      ram = {2**RAM_ADDR_BITS{1'b0}};

																end
																   else begin
																      
																      if(write_enable)
																	ram[wr_addr] <= wr_data;
																      rd_data<= ram[rd_addr];
																   end
																   
																end
endmodule
