module one_seg(
	       input 	    clk,
	       input [3:0]  in,
	       output [7:0] digit
	       );



   reg [7:0] 		    SevenSeg;
   always @(*)
     case(in)
       4'h0: SevenSeg = 8'b00000011;//11111100;
       4'h1: SevenSeg = 8'b10011111;//01100000;
       4'h2: SevenSeg = 8'b00100101;//11011010;
       4'h3: SevenSeg = 8'b00001101;//11110010;
       4'h4: SevenSeg = 8'b10011001;//01100110;
       4'h5: SevenSeg = 8'b01001001;//10110110;
       4'h6: SevenSeg = 8'b01000001;//10111110;
       4'h7: SevenSeg = 8'b00011111;//11100000;
       4'h8: SevenSeg = 8'b00000001;//11111110;
       4'h9: SevenSeg = 8'b00001001;//11110110;
       4'ha: SevenSeg = 8'b00010001;//11101110;
       4'hb: SevenSeg = 8'b11000001;//00111110;
       4'hc: SevenSeg = 8'b01100011;//10011100;
       4'hd: SevenSeg = 8'b10000101;//01111010;
       4'he: SevenSeg = 8'b01100001;//10011110;
       4'hf: SevenSeg = 8'b01110001;//10001110;
       default: SevenSeg = 8'b11111111;//00000000;
     endcase

   assign digit = SevenSeg;
endmodule
