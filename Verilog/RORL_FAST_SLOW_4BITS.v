`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:16:58 05/27/2016 
// Design Name: 
// Module Name:    RORL_FAST_SLOW_4BITS 
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
module RORL_FAST_SLOW_4BITS(CLK, RESET, LED);
    input CLK;
    input RESET;
    output [15:0] LED;

	 reg [15:0] LED;
	 reg [29:0] DIVIDER;
	 
	 always @(posedge CLK or negedge RESET)
		begin
			if(!RESET)
				DIVIDER <= {28'h0000000, 2'b00};
			else
				DIVIDER <= DIVIDER + 1'b1;
		end
	
	 assign FAST_CLK = DIVIDER[21];
	 assign SLOW_CLK = DIVIDER[23];
	 assign MODE = DIVIDER[28];
	 assign SPEED_CLK = MODE ? FAST_CLK : SLOW_CLK;
	 
	 assign ROTATE_CLK = DIVIDER[29];
	 
	 always @(posedge SPEED_CLK or negedge RESET)
		begin
			if(!RESET)
				LED <= 16'hFFF0;
			else
				begin
					if(ROTATE_CLK)
						LED <= {LED[0], LED[15:1]};
					else
						LED <= {LED[14:0], LED[15]};
				end
		end

endmodule
