`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:27:20 11/24/2017 
// Design Name: 
// Module Name:    wb_slave 
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
module wb_slave #(parameter WB_DATA_WIDTH=32, parameter WB_ADDR_WIDTH=11,parameter GRANULARITY = 8,
parameter SLAVE_ADDR_WIDTH = 1, parameter SLAVE_ADDR = 0) (
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
	output start,
	output wr_rd,
	output [WB_DATA_WIDTH-1:0] interface_data_o,
	
	input [WB_DATA_WIDTH-1:0] interface_data_i,
	
	input [15:0] value
	
    );

localparam IDLE = 2'b00;
localparam RUN = 2'b01;

reg state_nxt,state_reg;
reg [WB_DATA_WIDTH-1:0] data_reg,data_nxt;
reg ack_reg,ack_nxt;

reg start_nxt,start_reg;
reg [WB_DATA_WIDTH-1:0] tmp_data;


assign ack_o = ack_reg;
assign data_o = data_reg;
assign start = start_reg;
assign wr_rd = we_i;
assign interface_data_o = data_i;



always @(*) begin
	state_nxt= state_reg;
	start_nxt = start_reg;
	data_nxt = data_reg;
	ack_nxt = ack_reg;
	case(state_nxt)
	IDLE:begin
		ack_nxt = 1'b0;
		if(cyc_i & stb_i & (addr_i[WB_ADDR_WIDTH-1:WB_ADDR_WIDTH-SLAVE_ADDR_WIDTH] == SLAVE_ADDR)) begin
			state_nxt = RUN;
			start_nxt = 1'b1;
		end
	end
	RUN:begin
		start_nxt = 1'b0;
		if(cyc_i & stb_i & (addr_i[WB_ADDR_WIDTH-1:WB_ADDR_WIDTH-SLAVE_ADDR_WIDTH] == SLAVE_ADDR)) begin
			state_nxt = IDLE;
			ack_nxt = 1'b1;
			if(we_i) begin
				data_nxt = data_i;
			end
			else begin
				data_nxt = interface_data_i;
			end
		end
	end	
	endcase
end

always @(posedge clk_i or posedge rst_i) begin
	if(rst_i) begin
		state_reg <= IDLE;
		start_reg <= 'b0;
		data_reg <= 'b0;
		ack_reg <= 'b0;
	end
	else begin
		state_reg <= state_nxt;
		start_reg <= start_nxt;
		data_reg <= data_nxt;
		ack_reg <= ack_nxt;
	end
end

endmodule
