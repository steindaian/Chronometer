`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:44:10 11/16/2017 
// Design Name: 
// Module Name:    slave_interface 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`define slave_addr 0
module slave_interface #(parameter WB_DATA_WIDTH=32, parameter WB_ADDR_WIDTH=11,parameter GRANULARITY = 8,
	parameter CLK_FPGA=100000000, parameter CLK_DIV = 5000000,parameter DATA_SIZE=16,parameter ADDR_SIZE= 10,
	parameter SLAVE_ADDR_WIDTH = 1) (
	input clk_i,
	input rst_i,
	input [WB_ADDR_WIDTH-1:0] addr_i,
	input [WB_DATA_WIDTH-1:0] data_i,
	output [WB_DATA_WIDTH-1:0] data_o,
	input stb_i,
	input [WB_DATA_WIDTH/GRANULARITY-1:0] sel_i,
	output ack_o,
	input cyc_i,
	input we_i,
	
	input [15:0] value
    );

wire start, wr_rd;
wire [WB_DATA_WIDTH-1:0] interface_data_o,interface_data_i;

wire wr_en;
wire [WB_DATA_WIDTH-1:0] tmp_data;

assign wr_en = (start == 1'b1 && wr_rd == 1'b1);

wb_slave slave (
	.clk_i(clk_i),
	.rst_i(rst_i),
	.addr_i(addr_i),
	.data_i(data_i),
	.data_o(data_o),
	.stb_i(stb_i),
	.sel_i(sel_i),
	.ack_o(ack_o),
	.cyc_i(cyc_i),
	.we_i(we_i),
	.start(start),
	.interface_data_o(interface_data_o),
	.interface_data_i(interface_data_i),
	.wr_rd(wr_rd),
	
	.value(value)
);

bram_inf #( .RAM_WIDTH(DATA_SIZE), .RAM_ADDR_BITS(ADDR_SIZE)) ram (
								     .clk(clk_i),
								     .wr_data(interface_data_o),
									  .rd_data(interface_data_i),
									  .rd_addr(addr_i),
									  .wr_addr(addr_i),
									  .wr_en(wr_en)
								     );




endmodule

