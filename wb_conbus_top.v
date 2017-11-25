`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:07:23 04/01/2012 
// Design Name: 
// Module Name:    wb_conbus_top 
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

`define			dw	 32		// Data bus Width
`define			aw	 11		// Address bus Width
`define			sw   `dw / 8	// Number of Select Lines          byte select width
`define			mbusw  `aw + `sw + `dw +4 	//address width + byte select width + dat width + cyc + we + stb +cab , input from master interface
`define			sbusw	 3	//  ack + err + rty, input from slave interface
`define			mselectw  1// number of masters
`define			sselectw  2	// number of slavers
`define 		WB_USE_TRISTATE 0

module wb_conbus_top(
	clk_i, rst_i,

	// Master Interfaces
	m0_dat_i, m0_dat_o, m0_adr_i, m0_sel_i, m0_we_i, m0_cyc_i,
	m0_stb_i, m0_ack_o, m0_err_o, m0_rty_o, m0_cab_i,



	// Slave  Interface
	s0_dat_i, s0_dat_o, s0_adr_o, s0_sel_o, s0_we_o, s0_cyc_o,
	s0_stb_o, s0_ack_i, s0_err_i, s0_rty_i, s0_cab_o,
	
	s1_dat_i, s1_dat_o, s1_adr_o, s1_sel_o, s1_we_o, s1_cyc_o,
	s1_stb_o, s1_ack_i, s1_err_i, s1_rty_i, s1_cab_o,
	
	//master arbitrer pins,
	value
    );

parameter		s0_addr_w = 1 ;			// slave 0 address decode width
parameter		s0_addr = 1'b0;			// slave 0 address
parameter		s1_addr_w = 1 ;			// slave 1 address decode width
parameter		s1_addr = 1'b1;			// slave 1 address

////////////////////////////////////////////////////////////////////
//
// Module IOs
//

input		clk_i, rst_i;
// Master Interfaces
input		[`dw-1 : 0]		m0_dat_i;
output	[`dw-1:0]		m0_dat_o;
input		[`aw-1 : 0]		m0_adr_i; 
input		[`sw-1 : 0]		m0_sel_i; 
input							m0_we_i; 
input							m0_cyc_i;
input							m0_stb_i;
input							m0_cab_i;
output						m0_ack_o;
output						m0_err_o;
output						m0_rty_o;

input [15:0] value;

// Slave 0 Interface
input		[`dw-1:0]		s0_dat_i;
output	[`dw-1:0]		s0_dat_o;
output	[`aw-1:0]		s0_adr_o;
output	[`sw-1:0]		s0_sel_o;
output						s0_we_o;
output						s0_cyc_o;
output						s0_stb_o;
output						s0_cab_o;
input							s0_ack_i;
input							s0_err_i;
input							s0_rty_i;


// Slave 1 Interface
input		[`dw-1:0]		s1_dat_i;
output	[`dw-1:0]		s1_dat_o;
output	[`aw-1:0]		s1_adr_o;
output	[`sw-1:0]		s1_sel_o;
output						s1_we_o;
output						s1_cyc_o;
output						s1_stb_o;
output						s1_cab_o;
input							s1_ack_i;
input							s1_err_i;
input							s1_rty_i;


wire	[`sselectw -1:0]	i_ssel_dec;

/*`ifdef	WB_USE_TRISTATE //for simulation
	wire	[`mbusw -1:0]	i_bus_m; 
	`else *///for synthesis
		wire		[`mbusw -1:0]	i_bus_m;		// internal share bus, master data and control to slave
//`endif

wire	[`dw -1:0]		i_dat_s;	// internal share bus , slave data to master
wire	[`sbusw -1:0]	i_bus_s;	// internal share bus , slave control to master

////////////////////////////////////////////////////////////////////
//
// Master output Interfaces

assign	m0_dat_o = i_dat_s;
assign  {m0_ack_o, m0_err_o, m0_rty_o} = i_bus_s; //& /*3'h0;*/ {3{i_gnt_arb[0]}};


assign  i_bus_s = {s0_ack_i | s1_ack_i, s0_err_i | s1_err_i, s0_rty_i | s1_rty_i};

////////////////////////////////
//	Slave output interface

assign  {s0_adr_o, s0_sel_o, s0_dat_o, s0_we_o, s0_cab_o,s0_cyc_o} = i_bus_m[`mbusw -1:1];
assign	 s0_stb_o = i_bus_m[0] & i_ssel_dec[0];    // stb_o = cyc_i & stb_i & i_ssel_dec


assign  {s1_adr_o, s1_sel_o, s1_dat_o, s1_we_o, s1_cab_o, s1_cyc_o} = i_bus_m[`mbusw -1:1];
assign	s1_stb_o = i_bus_m[0] & i_ssel_dec[1];
 
///////////////////////////////////////

//	Master and Slave input interface
/*
`ifdef	WB_USE_TRISTATE //for simulation
	// input from master interface
	assign	i_bus_m = i_gnt_arb[0] ? {m0_adr_i, m0_sel_i, m0_dat_i, m0_we_i, m0_cab_i, m0_cyc_i, m0_stb_i} : 72'bz ;
	assign	i_bus_m = i_gnt_arb[1] ? {m1_adr_i, m1_sel_i, m1_dat_i, m1_we_i, m1_cab_i,m1_cyc_i, m1_stb_i} : 72'bz ;
	assign	i_bus_m = i_gnt_arb[2] ? {m2_adr_i, m2_sel_i, m2_dat_i,  m2_we_i, m2_cab_i, m2_cyc_i, m2_stb_i} : 72'bz ;
	// input from slave interface
	assign  i_dat_s = i_ssel_dec[0] ? s0_dat_i: 32'bz;
`else //for synthesis*/
	assign i_bus_m = {m0_adr_i, m0_sel_i, m0_dat_i, m0_we_i, m0_cab_i, m0_cyc_i,m0_stb_i};
					
	assign	i_dat_s = i_ssel_dec[0] ? s0_dat_i :
				  i_ssel_dec[1] ? s1_dat_i : 0; 
//`endif

//
// arbitor 
//

//////////////////////////////////
// 		address decode logic

wire [1:0]	m0_ssel_dec;
assign i_ssel_dec = m0_ssel_dec;
		

//	decode all master address before arbitor for running faster	

assign m0_ssel_dec[0] = (m0_adr_i[`aw -1 : `aw - s0_addr_w ] == s0_addr);
assign m0_ssel_dec[1] = (m0_adr_i[`aw -1 : `aw - s1_addr_w ] == s1_addr);


endmodule

