
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
	output reg valued_reached
    );

reg [SIZE-1:0] count_ff;




always @(posedge clk or posedge rst) begin
	if(rst) begin
		count_ff <= 'b1;
		valued_reached <= 1'b0;  
	end
	else begin
		if(count_ff == VALUE) begin
			valued_reached <= 1'b1;
			count_ff <= 'b1;
		end
		else begin
			count_ff <= count_ff + 1;
			valued_reached <= 1'b0;
		end
	end
end

endmodule
