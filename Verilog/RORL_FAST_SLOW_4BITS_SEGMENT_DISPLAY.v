`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:50:49 05/31/2016 
// Design Name: 
// Module Name:    RORL_FAST_SLOW_4BITS_SEGMENT_DISPLAY 
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
module RORL_FAST_SLOW_4BITS_SEGMENT_DISPLAY(CLK, RESET, SEGMENT, ENABLE, LED);
    input CLK;
    input RESET;
    output [7:0] SEGMENT;
    output [5:0] ENABLE;
    output [15:0] LED;

	 reg [15:0] LED;
	 reg [31:0] DIVIDER;
	 reg [5:0] 	ENABLE;
	 reg [2:0] 	DECODE;
	 reg [7:0] 	SEGMENT;
	 
	 //DIVIDER
	 always @(posedge CLK or negedge RESET)
		begin
			if(!RESET)
				DIVIDER <= 32'h00000000;
			else
				DIVIDER <= DIVIDER + 1'b1;
		end
		
	 assign SCAN_CLK 	= DIVIDER[11];
	 assign FAST_CLK 	= DIVIDER[19];
	 assign SLOW_CLK 	= DIVIDER[21];
	 assign SPEED	  	= DIVIDER[28];
	 assign MODE 		= DIVIDER[29];
	 assign SHIFT_CLK = (SPEED) ? FAST_CLK : SLOW_CLK;
	 
	 //LED LEFT RIGHT SHIFT
	 always @(posedge SHIFT_CLK or negedge RESET)
		begin
			if(!RESET)
				LED <= 16'hFFF0;
			else
				if(MODE)
					LED <= {LED[0], LED[15:1]};
				else
					LED <= {LED[14:0], LED[15]};
		end

	 //ROTATE
	always @(posedge SCAN_CLK or negedge RESET)
		begin
			if(!RESET)
				ENABLE <= 6'b111110;
			else
				ENABLE <= {ENABLE[4:0], ENABLE[5]};
		end

	 //ENABLE
	 always @(ENABLE or DECODE)
		begin
			case(ENABLE)
				6'b111110 : DECODE <= {2'b00, SPEED};
				6'b111101 : DECODE <= {3'b010};
				6'b111011 : DECODE <= {3'b011};
				6'b110111 : DECODE <= {3'b011};
				6'b101111 : DECODE <= {3'b010};
				default	 : DECODE <= {2'b10, MODE};
			endcase
		end

	 //DECODER
	 always @(DECODE)
		begin
			case(DECODE)
				3'o0	  : SEGMENT <= 8'b10010010;
				3'o1	  : SEGMENT <= 8'b10001110;
				3'o2	  : SEGMENT <= 8'b11111111;
				3'o3	  : SEGMENT <= 8'b01111111;
				3'o4	  : SEGMENT <= 8'b11000011;
				3'o5	  : SEGMENT <= 8'b10001001;
				default : SEGMENT <= 8'b11111111;
			endcase
		end

endmodule
