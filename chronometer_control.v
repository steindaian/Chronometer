module chronometer_control #( parameter SIZE = 32, parameter VALUE = 5000000, parameter ADDR_SIZE = 4, parameter DATA_SIZE = 16) (
									       input 	     rst,
									       input 	     clk,
									       input 	     start_d,
									       input 	     stop_d,
									       input 	     restart_d,
									       output [15:0] value
									       );

   localparam IDLE = 2'b00;
   localparam RUN = 2'b01;
   localparam STOP = 2'b10;
   localparam START = 2'b11;
   reg [1:0] 										     state_nxt, state_reg;
   reg [15:0] 										     value_nxt, value_reg;
   reg [SIZE-1:0] 									     cnt_nxt,cnt_reg;
   
   wire 										     start,stop,restart;
   wire [DATA_SIZE-1:0] 										     rd_data;
   reg [DATA_SIZE-1:0] 											     wr_data;
   reg [ADDR_SIZE-1:0] 											     wr_addr_reg,wr_addr_nxt,rd_addr_reg,rd_addr_nxt;
   reg 													     wr_en_reg,wr_en_nxt;
   


   bram_inf #( .RAM_WIDTH(DATA_SIZE), .RAM_ADDR_BITS(ADDR_SIZE)) ram (
								     .clk(clk),
								     .rd_addr(rd_addr_reg),
								     .rd_data(rd_data),
								     .wr_data(wr_data),
								     .wr_addr(wr_addr_reg),
								     .write_enable(wr_en_reg)
								     );
   
		
   assign start = start_d & ~restart_d & ~stop_d;
   assign stop = ~start_d & ~restart_d & stop_d;
   assign restart = ~start_d & restart_d & ~stop_d;
   
   //high to low transaction for start here
   assign value = value_reg;

   always @(*) begin
      value_nxt = value_reg;
      state_nxt = state_reg;
      cnt_nxt = cnt_reg;
      rd_addr_nxt = rd_addr_reg;
      wr_en_nxt = wr_en_reg;
      wr_addr_nxt = wr_addr_reg;
      case(state_nxt)
	IDLE : begin
	   value_nxt = 'b0; 
	   cnt_nxt = 'b1;
	   if(start == 1'b1) begin
		 state_nxt = RUN;		 
	   end
	end
	START: begin
	   value_nxt = rd_data;
	   if(cnt_reg == VALUE) begin
		 value_nxt = value_nxt + 1;
		 cnt_nxt = 'b1;
	   end
	   cnt_nxt = cnt_reg + 1;
	   state_nxt = RUN;
	   if(cnt_nxt == VALUE) begin
		 value_nxt = value_nxt + 1;
		 cnt_nxt = 'b1;
	   end
	end
	RUN : begin
	   if(stop) begin
	      state_nxt = STOP;
	      wr_en_nxt = 1'b1;
	      wr_data = value_reg;
	      
	      rd_addr_nxt = wr_addr_reg;
	      
	   end
	   else if(restart) begin
	      state_nxt = IDLE;	      
	   end
	   else begin
	      cnt_nxt = cnt_reg+1;
	      if(cnt_nxt == VALUE) begin
		 value_nxt = value_nxt + 1;
		 cnt_nxt = 'b1;
	      end
	   end
	end // case: RUN
	STOP: begin
	   wr_en_nxt = 1'b0;
	   wr_addr_nxt = wr_addr_reg + 1;
	   if(start) begin
	      state_nxt = START;
	      cnt_nxt = cnt_reg+1;
	   end
	   else if(restart) begin
	      state_nxt = IDLE;
	   end
	end
      endcase // case (state_nxt)
   end // always @ (*)
   
   
   always @(posedge clk or posedge rst) begin
      if(rst) begin
	 state_reg <= IDLE;
	 value_reg <= 'b0;
	 cnt_reg <= 'b1;
	 wr_en_reg <= 1'b0;
	 rd_addr_reg <= 'b0;
	 wr_addr_reg <= 'b0;
	 
      end
      else begin
	 state_reg <= state_nxt;
	 value_reg <= value_nxt;
	 wr_en_reg <= wr_en_nxt;
	 wr_addr_reg <= wr_addr_nxt;
	 rd_addr_reg <= rd_addr_nxt;
	 
	 cnt_reg <= cnt_nxt;
      end
   end

endmodule // chronometer_control
