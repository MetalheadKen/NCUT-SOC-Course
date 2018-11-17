`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:33:05 05/27/2016 
// Design Name: 
// Module Name:    PILI_LIGHT_FAST_SLOW 
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
module PILI_LIGHT_FAST_SLOW(CLK, RESET, LED);
    input CLK;
    input RESET;
    output [15:0] LED;

	 reg [15:0] LED;
	 reg [27:0] DIVIDER;
	 reg DIRECTION;
	 
	 //DIVIDER
	 always @(posedge CLK or negedge RESET)
		begin
			if(!RESET)
				DIVIDER <= 28'h0000000;
			else
				DIVIDER <= DIVIDER + 1'b1;
		end
	 
	 //ASSIGN SPEED CLOCK
	 assign FAST_CLK = DIVIDER[19];
	 assign SLOW_CLK = DIVIDER[21];
	 assign SPEED = DIVIDER[27];
	 assign ROTATE_CLK = SPEED ? FAST_CLK : SLOW_CLK;
	 
	 always @(posedge ROTATE_CLK or negedge RESET)
		begin
			if(!RESET)
				begin
					DIRECTION = 1'b1;
					LED <= 16'h3FFF;
				end
			else
				begin
					if(LED == 16'h3FFF)
						DIRECTION = 1'b1;
					else if(LED == 16'hFFFC)
						DIRECTION = 1'b0;
					
					if(DIRECTION)
						LED <= {LED[0], LED[15:1]};
					else
						LED <= {LED[14:0], LED[15]};
				end
		end

endmodule
