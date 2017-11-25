`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:09:05 04/01/2012 
// Design Name: 
// Module Name:    wb_conbus_arb 
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


module wb_conbus_arb(
		clk, rst, req, gnt, grant_master
    );

input		clk;
input		rst;
input	[2:0]	req;		// Req input
output	[2:0]	gnt; 		// Grant output
//input		next;		// Next Target
input [2:0] grant_master;

parameter	[1:0] grant0 = 3'h0, grant1 = 3'h1, grant2 = 3'h2;

reg [1:0]	state, state_next;

assign	gnt = state;

always@(posedge clk or posedge rst)
	if(rst)		
		state <= grant0;
	else		
		state <= state_next;

///////////////////////////////////////////////////////////////////////
//
// Next State Logic
//   - implements priority arbitration algorithm
//   - switches grant if current req is dropped or next is asserted
//   - parks at last grant
//

always@(state,req, grant_master)
   begin
	state_next = state;	// Default Keep State

	if(grant_master[0])
		begin
			state_next = grant0;
		end
	else
		if(grant_master[1])
			begin
				state_next = grant1;
			end
		else
			if(grant_master[2])
				begin
					state_next=grant2;
				end
			else
					case(state)		// synopsys parallel_case full_case
						grant0:     //high priority
							// if this req is dropped or next is asserted, check for other req's
							if(!req[0] )
								begin
								if(req[1])	state_next = grant1; //medium priority
								else
								if(req[2])	state_next = grant2; //low priority
								end
							grant1:
							// if this req is dropped or next is asserted, check for other req's
							if(!req[1] )  //medium priority
								begin
								if(req[2])	state_next = grant0; //high priority
								else
								if(req[0])	state_next = grant2; //low priority
								end
							grant2:
							// if this req is dropped or next is asserted, check for other req's
							if(!req[2] ) //low priority
								begin
								if(req[0])	state_next = grant0; //high priority
								else
								if(req[1])	state_next = grant1; //medium priority
								end
						endcase
   end
endmodule
