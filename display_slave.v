`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:45:52 11/24/2017 
// Design Name: 
// Module Name:    display_slave 
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
//`define slave_addr 1
module display_slave #(parameter WB_DATA_WIDTH=32, parameter WB_ADDR_WIDTH=11,parameter GRANULARITY = 8,
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
	output [3:0] an,
	output [7:0] hex_display
	
    );
	
	wire [15:0] value;
	wire [WB_DATA_WIDTH-1:0] interface_data_o;
	wire start,wr_rd;
	
	assign value = interface_data_o;
	
	display_7_seg display (
			  .clk(clk_i),
			  .rst(rst_i),
			  .data(value),
			  .hex_display(hex_display),
			  .an(an)
			  );
			  
	wb_slave #( .SLAVE_ADDR(1'b1)) slave (
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
	.interface_data_i(),
	.wr_rd(wr_rd)
);
	
endmodule
