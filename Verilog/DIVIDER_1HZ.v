`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:02:56 05/27/2016 
// Design Name: 
// Module Name:    DIVIDER_1HZ 
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
module DIVIDER_1HZ(CLK, RESET, LED);
    input CLK;
    input RESET;
    output [7:0] LED;
	 
	 reg [7:0] LED;
	 integer DIVIDER;

	 //40MHZ FREQUENCY
	 always @(posedge CLK or negedge RESET)
		begin
			if(!RESET)
				DIVIDER <= 0;
			else
				begin
					if(DIVIDER == 39999999)
						DIVIDER <= 0;
					else
						DIVIDER <= DIVIDER + 1;
						
					if(DIVIDER < 20000000)
						LED <= 8'hFF;
					else
						LED <= 8'h00;
				end
		end
		
endmodule
