`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:24:03 05/27/2016 
// Design Name: 
// Module Name:    DIVIDERS 
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
module DIVIDERS(CLK, RESET, LED);
    input CLK;
    input RESET;
    output [7:0] LED;

	 wire [7:0] LED;
	 reg [28:0] DIVIDER;
	 
	 //DIVIDER
	 always @(posedge CLK or negedge RESET)
		begin
			if(!RESET)
				DIVIDER <= {28'h0000000, 1'b0};
			else
				DIVIDER <= DIVIDER + 1'b1;
		end
		
	 assign LED[0] = DIVIDER[21];
	 assign LED[1] = DIVIDER[22];
	 assign LED[2] = DIVIDER[23];
	 assign LED[3] = DIVIDER[24];
	 assign LED[4] = DIVIDER[25];
	 assign LED[5] = DIVIDER[26];
	 assign LED[6] = DIVIDER[27];
	 assign LED[7] = DIVIDER[28];

endmodule
