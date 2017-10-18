
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:15:15 10/03/2017 
// Design Name: 
// Module Name:    counter_top 
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
module counter_top #( parameter SIZE = 32, parameter VALUE = 5000000)(
	input clk,
	input rst,
	output valued_reached,
	input start,
	input stop
    );

reg [SIZE-1:0] count_d, count_ff;
reg ok_ff, ok_d;


assign valued_reached = ok_ff; 

always @(*) begin
	ok_d = ok_ff;
	count_d = count_ff;
	if(count_d == VALUE  ) begin
		ok_d = 1'b1;
		count_d = 'b1;
	end
	else begin
		ok_d = 1'b0;
		count_d = count_d + 1;
	end
		if(stop) begin
		ok_d = 1'b0;
	end
end

always @(posedge clk or posedge rst) begin
	if(rst || start) begin
		ok_ff <= 0;
		count_ff <= 1'b1;

	end
	else begin
		count_ff <= count_d;
		ok_ff <= ok_d;
	end
end

endmodule
