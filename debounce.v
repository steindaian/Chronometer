module debounce #(parameter SIZE = 1) (
				       input 		 clk,
				       input 		 rst,
				       input [SIZE-1:0]  in,
				       output [SIZE-1:0] out
				       );

   reg [SIZE-1:0] 					 q1,q2;

   always @(posedge clk or posedge rst) begin
      if(rst) begin
	 q1 <= 'b0;
	 q2 <= 'b0;
      end
      else begin
	 q1 <= in;
	 q2 <= q1;
      end
   end

   assign out = q2;

endmodule // debounce

   
