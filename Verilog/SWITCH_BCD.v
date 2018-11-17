`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:07:56 05/25/2016 
// Design Name: 
// Module Name:    SWITCH_BCD 
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
module SWITCH_BCD(CLK, RESET, DIP, SEGMENT, ENABLE);
    input CLK;
    input RESET;
    input [7:0] DIP;
    output [7:0] SEGMENT;
    output [5:0] ENABLE;

	 reg [23:0] DIVID;
	 reg [7:0] BCD;
	 reg [5:0] ENABLE;
	 reg [7:0] SEGMENT;
	 reg [3:0] DECODE;
	 
	 wire [7:0] DIP1;
	 
	 always @(posedge CLK or negedge RESET)
		begin
			if(!RESET)
				DIVID <= 24'h000000;
			else
				DIVID <= DIVID + 1'b1;
		end
	
	 assign COUNT_CLK = DIVID[23];
	 assign SCAN_CLK = DIVID[11];
	 assign DIP1[3:0] = (DIP[3:0] > 4'h9) ? 4'h0 : DIP[3:0];
	 assign DIP1[7:4] = (DIP[7:4] > 4'h9) ? 4'h0 : DIP[7:4];
	 
	 always @(posedge COUNT_CLK or negedge RESET)
		begin
			begin
				if(!RESET)
					BCD <= DIP1;
				else
					begin
						BCD <= BCD + 1'b1;
						
						if(BCD[3:0] == 4'h9)
							begin
								BCD[3:0] <= 4'h0;
								BCD[7:4] <= BCD[7:4] + 1'b1;
							end
						
						if(BCD == 8'h99)
							BCD <= DIP1;
					end
			end
		end

	 always @(posedge SCAN_CLK or negedge RESET)
		begin
			if(!RESET)
				ENABLE <= 6'b111110;
			else
				ENABLE <= {4'b1111, ENABLE[0], ENABLE[1]};
		end
		
	 always @(ENABLE or BCD)
		begin
			case(ENABLE)
				6'b111110	:	DECODE = BCD[3:0];
				default		:	DECODE = BCD[7:4];
			endcase
		end
	
	 always @(DECODE)
		begin
			case(DECODE)
				4'h0		:	SEGMENT = 8'b11000000;
				4'h1		:	SEGMENT = 8'b11111001;
				4'h2		:	SEGMENT = 8'b10100100;
				4'h3		:	SEGMENT = 8'b10110000;
				4'h4		:	SEGMENT = 8'b10011001;
				4'h5		:	SEGMENT = 8'b10010010;
				4'h6		:	SEGMENT = 8'b10000010;
				4'h7		:	SEGMENT = 8'b11111000;
				4'h8		:	SEGMENT = 8'b10000000;
				4'h9		:	SEGMENT = 8'b10010000;
				default	:	SEGMENT = 8'b11111111;				
			endcase
		end
		
endmodule
