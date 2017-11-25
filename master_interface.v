`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:01:01 11/09/2017 
// Design Name: 
// Module Name:    master_interface 
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
module master_interface #(parameter WB_DATA_WIDTH=32, parameter WB_ADDR_WIDTH=11,parameter GRANULARITY = 8,
	parameter CLK_FPGA=100000000, parameter CLK_DIV = 5000000,parameter DATA_SIZE=16,parameter ADDR_SIZE= 10) (
	input clk_i,
	input rst_i,
	output [WB_ADDR_WIDTH-1:0] addr_o,
	input [WB_DATA_WIDTH-1:0] data_i,
	output [WB_DATA_WIDTH-1:0] data_o,
	output stb_o,
	output [WB_DATA_WIDTH/GRANULARITY-1:0] sel_o,
	input ack_i,
	output cyc_o,
	output we_o,
	input start,
	input restart,
	input stop,
	
	output [15:0] value
    );

localparam IDLE = 2'b00;
localparam ACK_PHASE = 2'b01;
localparam DATA_PHASE = 2'b10;

reg [1:0] state_nxt ,state_reg;

wire rd_en,wr_en;
wire [ADDR_SIZE-1:0] rd_addr,wr_addr;
wire [DATA_SIZE-1:0] wr_data;
reg [DATA_SIZE-1:0] rd_data_reg,rd_data_nxt;

reg stb_reg,stb_nxt;
reg cyc_reg, cyc_nxt;
reg we_reg,we_nxt;
reg [WB_ADDR_WIDTH-1:0] addr_reg,addr_nxt;
reg [WB_DATA_WIDTH-1:0] data_reg,data_nxt;
reg [WB_DATA_WIDTH/GRANULARITY-1:0] sel_nxt,sel_reg;

wire en;

led_chronometer #( .CLK_FPGA(CLK_FPGA), .CLK_DIV(CLK_DIV), .DATA_SIZE(DATA_SIZE), .ADDR_SIZE(ADDR_SIZE)) led (
			  .clk(clk_i),
			  .rst(rst_i),
			  .start(start),
			  .stop(stop),
			  .restart(restart),
			  .wr_data(wr_data),
			  .rd_data(rd_data_reg),
			  .rd_addr(rd_addr),
			  .wr_addr(wr_addr),
			  .wr_en(wr_en),
			  .rd_en(rd_en),
			  .cs(en),
			  .rd_done(ack_i),
			  
			  .value(value)
			  );

assign addr_o = addr_reg;
assign data_o = data_reg;
assign we_o = we_reg;
assign cyc_o = cyc_reg;
assign stb_o = stb_reg;
assign sel_o = sel_reg;


always @(*) begin
	state_nxt = state_reg;
	cyc_nxt = cyc_reg;
	sel_nxt = sel_reg;
	addr_nxt = addr_reg;
	data_nxt = data_reg;
	stb_nxt = stb_reg;
	we_nxt = we_reg;
	rd_data_nxt = rd_data_reg;
	case(state_nxt)
	IDLE:begin
		if(wr_en) begin
			state_nxt = ACK_PHASE;
			addr_nxt = {en,wr_addr};
			data_nxt = wr_data;
			cyc_nxt = 1'b1;
			stb_nxt = 1'b1;
			we_nxt = 1'b1;
			sel_nxt = 4'b0011;
		end
		else if(rd_en) begin
			state_nxt = ACK_PHASE;
			addr_nxt = {en,rd_addr};
			cyc_nxt = 1'b1;
			stb_nxt = 1'b1;
			we_nxt = 1'b0;
			sel_nxt = 4'b0011;
		end
	end
	ACK_PHASE: begin
		if(ack_i) begin
			state_nxt = IDLE;
			cyc_nxt = 1'b0;
			stb_nxt = 1'b0;
			rd_data_nxt = data_i;
		end
	end
	endcase
end

always @(posedge clk_i or posedge rst_i) begin
	if(rst_i) begin
		stb_reg <= 1'b0;
		cyc_reg <= 1'b0;
		addr_reg <= 'b0;
		data_reg <= 'b0;
		sel_reg <= 'b0;
		we_reg <= 1'b0;
		state_reg <= IDLE;
		rd_data_reg <= 'b0;
	end
	else begin
		rd_data_reg <= rd_data_nxt;
		stb_reg <= stb_nxt;
		cyc_reg <=cyc_nxt;
		addr_reg <= addr_nxt;
		data_reg <= data_nxt;
		sel_reg <= sel_nxt;
		state_reg <= state_nxt;
		we_reg <= we_nxt;
	end
end

endmodule
