module display_chronometer #( parameter WB_DATA_WIDTH=32, parameter WB_ADDR_WIDTH=11,parameter GRANULARITY = 8,
parameter CLK_FPGA = 100000000, 
parameter CLK_DIV=5000000, parameter CLK_DISPLAY = 1000, 
parameter ADDR_SIZE = 4, parameter DATA_SIZE = 16) (
			    input clk,
			    input rst,
			    input start,
			    input stop,
			    input restart,
			    output [7:0] hex_display,
			    output [3:0] an
			    );

   wire 				 start_d;//,restart_d,stop_d;
   wire [WB_ADDR_WIDTH-1:0] m_addr,s1_addr,s0_addr;
	wire [WB_DATA_WIDTH-1:0] m_data_o,m_data_i,s0_data_o,s0_data_i,s1_data_i,s1_data_o;
	wire m_ack,m_cyc,m_stb,m_we,s0_ack,s0_cyc,s0_stb,s0_we,s1_we,s1_cyc,s1_stb,s1_ack;
	wire [WB_DATA_WIDTH/GRANULARITY-1:0] m_sel,s0_sel,s1_sel;
   
	wire clk_int, clk_i;
	wire [15:0] value; //debug
	
   debounce sta (
		 .clk(clk_i),
		 .rst(rst),
		 .in(start),
		 .out(start_d)
		 );
   
	clk_gen #( .FREQ_IN(CLK_FPGA), .FREQ_OUT(CLK_DIV<<2)) c_gen1 (
		  .clk_in(clk),
		  .rst(rst),
		  .clk_out(clk_int)
		  );
   clk_gen #( .FREQ_IN(CLK_DIV<<2), .FREQ_OUT(CLK_DIV)) c_gen2 ( //just for nexys3
		  .clk_in(clk_int),
		  .rst(rst),
		  .clk_out(clk_i)
		  );
		  
   master_interface m (
		.clk_i(clk_i),
		.rst_i(rst),
		.addr_o(m_addr),
		.data_i(m_data_i),
		.data_o(m_data_o),
		.sel_o(m_sel),
		.stb_o(m_stb),
		.cyc_o(m_cyc),
		.we_o(m_we),
		.ack_i(m_ack),
		.start(start_d),
		.restart(restart),
		.stop(stop),
		
		.value(value) //debug
		);
	
	wb_conbus_top w(
		.clk_i(clk_i),
		.rst_i(rst),
		.m0_dat_i(m_data_o),
		.m0_dat_o(m_data_i),
		.m0_adr_i(m_addr), 
		.m0_sel_i(m_sel), 
		.m0_we_i(m_we), 
		.m0_cyc_i(m_cyc),
		.m0_stb_i(m_stb), 
		.m0_ack_o(m_ack), 
		.m0_err_o(),
		.m0_rty_o(),
		.m0_cab_i(),
		.value(value), //debug
		
		.s0_dat_i(s0_data_o),
		.s0_dat_o(s0_data_i),
		.s0_adr_o(s0_addr),
		.s0_sel_o(s0_sel),
		.s0_we_o(s0_we),
		.s0_cyc_o(s0_cyc),
		.s0_stb_o(s0_stb),
		.s0_ack_i(s0_ack),
		.s0_err_i(),
		.s0_rty_i(), 
		.s0_cab_o(),
		
		.s1_dat_i(s1_data_o),
		.s1_dat_o(s1_data_i),
		.s1_adr_o(s1_addr),
		.s1_sel_o(s1_sel),
		.s1_we_o(s1_we),
		.s1_cyc_o(s1_cyc),
		.s1_stb_o(s1_stb),
		.s1_ack_i(s1_ack),
		.s1_err_i(),
		.s1_rty_i(), 
		.s1_cab_o()
		
		);

	slave_interface s0(
		.clk_i(clk_i),
		.rst_i(rst),
		.addr_i(s0_addr),
		.data_i(s0_data_i),
		.data_o(s0_data_o),
		.sel_i(s0_sel),
		.stb_i(s0_stb),
		.cyc_i(s0_cyc),
		.ack_o(s0_ack),
		.we_i(s0_we),
		
		.value(value) //debug
		);
		
		display_slave s1(
		.clk_i(clk_i),
		.rst_i(rst),
		.addr_i(s1_addr),
		.data_i(s1_data_i),
		.data_o(s1_data_o),
		.sel_i(s1_sel),
		.stb_i(s1_stb),
		.cyc_i(s1_cyc),
		.ack_o(s1_ack),
		.we_i(s1_we),
		.an(an),
		.hex_display(hex_display)
		);
		/*slave_interface s(
		.clk_i(clk),
		.rst_i(rst),
		.addr_i(m_addr),
		.data_i(m_data_o),
		.data_o(m_data_i),
		.sel_i(m_sel),
		.stb_i(m_stb),
		.cyc_i(m_cyc),
		.ack_o(m_ack),
		.we_i(m_we)
		);*/
   /*display_7_seg display (
			  .clk(clk_i),
			  .rst(rst),
			  .data(value),
			  .hex_display(hex_display),
			  .an(an)
			  );*/
endmodule // display_chronometer

			 
/*led_chronometer #( .CLK_FPGA(CLK_FPGA), .CLK_DIV(CLK_DIV), .DATA_SIZE(DATA_SIZE), .ADDR_SIZE(ADDR_SIZE)) led (
			  .clk(clk),
			  .rst(rst),
			  .start(start_d),
			  .stop(stop),
			  .restart(restart),
			  .value(value),
			  .wr_data(wr_data),
			  .rd_data(rd_data),
			  .rd_addr(rd_addr),
			  .wr_addr(wr_addr),
			  .wr_en(wr_en)
			  );
	bram_inf #( .RAM_WIDTH(DATA_SIZE), .RAM_ADDR_BITS(ADDR_SIZE)) ram (
								     .clk(clk),
								     .wr_data(wr_data),
									  .rd_data(rd_data),
									  .rd_addr(rd_addr),
									  .wr_addr(wr_addr),
									  .wr_en(wr_en)
								     );*/