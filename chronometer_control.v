module chronometer_control #( parameter SIZE = 32, parameter VALUE = 5000000, 
parameter ADDR_SIZE = 10, parameter DATA_SIZE = 16) (
									       input 	     rst,
									       input 	     clk,
									       input 	     start_d,
									       input 	     stop_d,
									       input 	     restart_d,
											 input blink,
									       output [15:0] value,
											 
											 output [ADDR_SIZE-1 : 0]  rd_addr,
											 input  [DATA_SIZE-1 : 0] rd_data,
											 output [ADDR_SIZE-1 : 0]  wr_addr,
											 output [DATA_SIZE-1 : 0]      wr_data,
											 output 			      wr_en,
											 output rd_en,
											 output cs,
											 input rd_done
									       );

   localparam IDLE = 3'b000;
   localparam RUN = 3'b001;
   localparam STOP = 3'b010;
   localparam START = 3'b011;
	localparam PRE_START = 3'b100;
	
   reg [2:0] 										     state_nxt, state_reg;
   reg [15:0] 										     value_nxt, value_reg;
   reg [SIZE-1:0] 									     cnt_nxt,cnt_reg;
   
   wire 										     start,stop,restart;

   reg [DATA_SIZE-1:0] 											     wr_data_nxt,wr_data_reg;
   reg [ADDR_SIZE-1:0] 											     wr_addr_reg,wr_addr_nxt,rd_addr_reg,rd_addr_nxt;
   reg 													     wr_en_reg,wr_en_nxt,rd_en_nxt,rd_en_reg;
   reg cs_nxt,cs_reg;
	
	assign wr_en = wr_en_reg;
	assign wr_data = wr_data_reg;
	assign rd_addr = rd_addr_reg;
	assign wr_addr = wr_addr_reg;
   assign rd_en = rd_en_reg;
   
		
   assign start = start_d & ~restart_d & ~stop_d;
   assign stop = ~start_d & ~restart_d & stop_d;
   assign restart = ~start_d & restart_d & ~stop_d;
   
	assign cs = cs_reg;
   //high to low transaction for start here
   assign value = value_reg;

   always @(*) begin
      value_nxt = value_reg;
      state_nxt = state_reg;
      cnt_nxt = cnt_reg;
      rd_addr_nxt = rd_addr_reg;
      wr_en_nxt = wr_en_reg;
      wr_addr_nxt = wr_addr_reg;
		wr_data_nxt = wr_data_reg;
		rd_en_nxt = rd_en_reg;
		cs_nxt = cs_reg;
      case(state_nxt)
	IDLE : begin
		value_nxt = 'b0;
		cnt_nxt = 'b0;
		wr_en_nxt = 1'b1;
		cs_nxt = 1'b1;
		wr_data_nxt = value_nxt;
	   if(start == 1'b1) begin
			wr_en_nxt = 1'b0;
		 state_nxt = RUN;		 
	   end
		
	end
	START: begin
		rd_en_nxt = 1'b0;
		if(rd_done) begin
			state_nxt = RUN;
			value_nxt = rd_data;
		end
	end
	RUN : begin
	   if(stop) begin
	      state_nxt = STOP;
	      wr_en_nxt = 1'b1;
	      wr_data_nxt = value_reg;
	      cs_nxt = 1'b0;
	      rd_addr_nxt = wr_addr_reg;  
	   end
	   else if(restart) begin
	      state_nxt = IDLE;	      
	   end
	   else begin
			state_nxt = RUN;
			cnt_nxt = cnt_reg+1;
			wr_en_nxt = 1'b0;
	      if(cnt_reg == VALUE) begin
				 value_nxt = value_reg + 1;
				 cnt_nxt = 'b1;
				 wr_en_nxt = 1'b1;
				 wr_data_nxt = value_nxt;
				 cs_nxt = 1'b1;
	      end
	   end
	end // case: RUN
	STOP: begin
		wr_en_nxt = 1'b0;
		if(start) begin
			state_nxt = START;
			wr_addr_nxt = wr_addr_reg + 1;
			rd_en_nxt = 1'b1;
			cs_nxt = 1'b0;
		end
		else if(restart) begin
			state_nxt = IDLE;
			wr_addr_nxt = wr_addr_reg + 1;
		end
	end	
      endcase // case (state_nxt)
   end // always @ (*)
   
   
   always @(posedge clk or posedge rst) begin
      if(rst) begin
	 state_reg <= IDLE;
	 value_reg <= 'b0;
	 cnt_reg <= 'b0;
	 wr_en_reg <= 1'b0;
	 rd_en_reg <= 1'b0;
	 rd_addr_reg <= 'b0;
	 wr_addr_reg <= 'b0;
	 wr_data_reg <= 'b0;
	 cs_reg <= 1'b0;
      end
      else begin
		wr_data_reg <= wr_data_nxt;
	 state_reg <= state_nxt;
	 value_reg <= value_nxt;
	 wr_en_reg <= wr_en_nxt;
	 wr_addr_reg <= wr_addr_nxt;
	 rd_addr_reg <= rd_addr_nxt;
	 rd_en_reg <= rd_en_nxt;
	 cnt_reg <= cnt_nxt;
	 cs_reg <= cs_nxt;
      end
   end

endmodule // chronometer_control
