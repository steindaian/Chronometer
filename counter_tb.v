
module counter_tb();

reg clk, rst;
wire valued_reached;


counter_top c (
	.clk(clk),
	.rst(rst),
	.valued_reached(valued_reached)
);

initial begin
	rst = 1'b1;
	clk = 1'b0;
	#10 rst = 1'b0;
	#10000000 $stop;
end

initial begin
	forever #10 clk = ~clk;
end

endmodule