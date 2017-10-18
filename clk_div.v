/////////////////////////////////////////////////////////////////////
// Clock divider with pulse output and compensation.               //
// Only works for division rates greater than or equal to 2.       //
/////////////////////////////////////////////////////////////////////

module clk_div
	(
		clk_in,
		rst,
		clk_out
	);

// inputs
input clk_in;
input rst;

// outputs
output clk_out;

// Parameters
parameter FREQ_IN=50; // in Hz (only integers)
parameter FREQ_OUT=9; // in Hz (only integers)

localparam DIV_RATE=FREQ_IN/FREQ_OUT;
localparam COMPENSATION=FREQ_IN%FREQ_OUT;

integer count_ff, count_nxt;
integer compensation_ff, compensation_nxt;

reg clk_out_ff, clk_out_nxt;
	
// continuous assignments for outputs
assign clk_out = clk_out_ff;
	
// combinational logic
always @(*) begin
	count_nxt        = count_ff;
	clk_out_nxt      = clk_out_ff;
	compensation_nxt = compensation_ff;
	if (count_ff < DIV_RATE) begin
		count_nxt = count_ff + 1;
		clk_out_nxt = 1'b0;
	end
	else begin
		clk_out_nxt = 1'b1;
		compensation_nxt = compensation_ff + COMPENSATION;
		if (compensation_nxt >= FREQ_OUT) begin
			compensation_nxt = compensation_nxt - FREQ_OUT;
			count_nxt = 0;
		end
		else begin
			count_nxt = 1;
		end
	end
end

// synchronous output
always @(posedge clk_in or posedge rst) begin
	if (rst) begin
		count_ff        <= 1;
		clk_out_ff      <= 1'b0;
		compensation_ff <= 0;
	end
	else begin
		count_ff        <= count_nxt;
		clk_out_ff      <= clk_out_nxt;
		compensation_ff <= compensation_nxt;
	end
end

endmodule
