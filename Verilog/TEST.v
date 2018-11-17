`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:58:03 05/26/2016 
// Design Name: 
// Module Name:    TEST 
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
module TEST(CLK, RESET, LED, DIP);
    input CLK;
    input RESET;
    output [15:0] LED;
    input [1:0] DIP;
	 
	 reg [23:0] DIVIDER;
	 reg [15:0] LED;
	 
	 //DIVIDER
	 always @(posedge CLK or negedge RESET)
		begin
			if(!RESET)
				DIVIDER <= 24'h000000;
			else
				DIVIDER <= DIVIDER + 1'b1;
		end
	 
	 assign FAST_CLK = DIVIDER[21];
	 assign SLOW_CLK = DIVIDER[23];
	 assign SPEED_CLK = DIP[0] ? SLOW_CLK : FAST_CLK;
	 //assign SPEED_CLK = (DIP[0] == 1'b0) ? DIVIDER[21] : DIVIDER[23];
	 
	 always @(posedge SPEED_CLK or negedge RESET)
		begin
			if(!RESET)
				LED <= 16'hFFFE;
				
			else
				begin
					if(DIP[1] == 1'b0)
						LED <= {LED[14:0], LED[15]};
					else
						LED <= {LED[0], LED[15:1]};
				end
		end

endmodule
