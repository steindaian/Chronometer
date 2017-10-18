`timescale 1ns/1ps
module chronometer_tb();

   wire blink;

   reg 	clk,rst;
   
   chronometer c (
		  .clk(clk),
		  .rst(rst),
		  .blink(blink)
		  );

   initial begin
      rst = 1'b1;

      clk = 1'b0;
      #30 rst = 1'b0;
      #2000000000 $stop;
      
   end

   initial begin
      forever #10 clk = ~clk;
   end

endmodule // chronometer_tb
