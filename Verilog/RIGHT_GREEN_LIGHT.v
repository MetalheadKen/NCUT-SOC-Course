`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:12:51 05/30/2016 
// Design Name: 
// Module Name:    RIGHT_GREEN_LIGHT 
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
module RIGHT_GREEN_LIGHT(CLK, RESET, LED, SEGMENT, ENABLE);
    input CLK;
    input RESET;
    output [5:0] LED;
    output [7:0] SEGMENT;
    output [5:0] ENABLE;

	 //reg [5:0] LED;
	 reg [31:0] DIVIDER;
	 reg [2:0] COUNT;
	 reg [7:0] RED;
	 reg [7:0] GREEN;
	 reg [7:0] YELLOW;
	 reg [5:0] ENABLE;
	 reg [3:0] DECODE;
	 reg [7:0] SEGMENT;
	 
	 //DIVIDER
	 always @(posedge CLK or negedge RESET)
		begin
			if(!RESET)
				DIVIDER <= 32'h00000000;
			else
				DIVIDER <= DIVIDER + 1'b1;
		end

	 assign SCAN_CLK 	= DIVIDER[11];
	 assign SHIFT_CLK = DIVIDER[23];
	 //assign MODE 		= DIVIDER[29];
	 
	 //DOWN COUNT
	 always @(posedge SHIFT_CLK or negedge RESET)
		begin
			if(!RESET)
				begin
					RED <= 8'h30;
					YELLOW <= 8'h00;
					GREEN <= 8'h00;
				end
			else
				begin
					if(RED > 8'h00)
						begin
							if(RED[3:0] == 4'h0)
								begin
									RED[3:0] <= 4'h9;
									RED[7:4] <= RED[7:4] - 1'b1;
								end
							else
								RED[3:0] <= RED[3:0] - 1'b1;
								
							if(RED == 8'h01)
								YELLOW <= 8'h05;
						end
					
					if(YELLOW > 8'h00)
						begin
							if(YELLOW[3:0] == 4'h0)
								begin
									YELLOW[3:0] <= 4'h9;
									YELLOW[7:4] <= YELLOW[7:4] - 1'b1;
								end
							else
								YELLOW[3:0] <= YELLOW[3:0] - 1'b1;
						
							if(YELLOW == 8'h01)
								GREEN <= 8'h40;
						end
				 
					if(GREEN > 8'h00)
						begin
							if(GREEN[3:0] == 4'h0)
								begin
									GREEN[3:0] <= 4'h9;
									GREEN[7:4] <= GREEN[7:4] - 1'b1;
								end
							else
								GREEN[3:0] <= GREEN[3:0] - 1'b1;
								
							if(GREEN == 8'h01)
								RED <= 8'h30;
						end
				end
		end
	 
	 /*//LED SELECT
	 always @(GREEN or RED or YELLOW)
		begin
			case(RED)
				8'h00		:	LED <= 6'b110101;
				//default	:	LED <= 6'b110011;
			endcase
				
			case(YELLOW)
				8'h00		:	LED <= 6'b011110;
				//default	:	LED <= 6'b110101;
			endcase
			
			case(GREEN)
				8'h00		:	LED <= 6'b110011;
				//default	:	LED <= 6'b011110;
			endcase	
		end*/
		
	 assign LED = (RED > 8'h00) 	 ? 6'b110011 :
					  (YELLOW > 8'h00) ? 6'b110101 :
					  (GREEN > 8'h00)  ? 6'b011110 :
					  6'b111111;
		
	 //ROTATE
	 always @(posedge SCAN_CLK or negedge RESET)
		begin
			if(!RESET)
				ENABLE <= 6'b111110;
			else
				ENABLE <= {ENABLE[4:0], ENABLE[5]};
		end
	 
	 //ENABLE THING
	 always @(ENABLE)
		begin
			case(ENABLE)
				6'b111110	:	DECODE <= GREEN[3:0];
				6'b111101	:	DECODE <= GREEN[7:4];
				6'b111011	:	DECODE <= YELLOW[3:0];
				6'b110111	:	DECODE <= YELLOW[7:4];
				6'b101111	:	DECODE <= RED[3:0];
				default		:	DECODE <= RED[7:4];				
			endcase
		end
	 
	 //DECODER
	 always @(DECODE)
		begin
			case(DECODE)
				4'h0		: SEGMENT <= 8'b11000000;
				4'h1		: SEGMENT <= 8'b11111001;
				4'h2		: SEGMENT <= 8'b10100100;
				4'h3		: SEGMENT <= 8'b10110000;
				4'h4		: SEGMENT <= 8'b10011001;
				4'h5		: SEGMENT <= 8'b10010010;
				4'h6		: SEGMENT <= 8'b10000010;
				4'h7		: SEGMENT <= 8'b11011000;
				4'h8		: SEGMENT <= 8'b10000000;
				4'h9		: SEGMENT <= 8'b10010000;				
				default	: SEGMENT <= 8'b11111111;
			endcase
		end
		
endmodule
