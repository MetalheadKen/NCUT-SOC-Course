`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:14:51 04/27/2016 
// Design Name: 
// Module Name:    DEBOUNCER 
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
module DEBOUNCER(CLK, ROW0, COL0, RESET, SEGMENT, ENABLE);
    input CLK;
    input ROW0;
    input RESET;
	 output COL0;
    output [7:0] SEGMENT;
    output [5:0] ENABLE;
	 
	 reg [23:0] DIVID;
	 reg [7:0] UP_BCD;
	 reg [7:0] DOWN_BCD;
	 reg [5:0] ENABLE;
	 reg [3:0] DECODE_BCD;
	 reg [7:0] SEGMENT;
	 reg FLAG;
	 reg [7:0] DISPLAY_COUNT;
	 reg ROW0;
	 
	 //DIVIDER
	 always @(posedge CLK or negedge RESET)
		begin
			if(!RESET)
				DIVID <= 24'h000000;
			else
				DIVID <= DIVID + 1'b1;
		end
		
	 assign COUNT_CLK = DIVID[23];
	 assign SCAN = DIVID[11];
	 assign DISPLAY_CLK = DIVID[18];
	 assign COL0 = 1'b0;
	 
	 //00~59 UP COUNT
	 always @(posedge COUNT_CLK or negedge RESET)
		begin
			if(!RESET)
				UP_BCD <= 8'h00;
			else
				begin
					if(UP_BCD[3:0] == 4'h9)
						begin
							UP_BCD[3:0] <= 4'h0;
							UP_BCD[7:4] <= UP_BCD[7:4] + 1'b1;
						end
					else
						UP_BCD[3:0] <= UP_BCD[3:0] + 1'b1;
						
					if(UP_BCD == 8'h59)
						UP_BCD <= 8'h00;
				end
		end
		
	 //30~00 DOWN COUNT
	 always @(posedge COUNT_CLK or negedge RESET)
		begin
			if(!RESET)
				DOWN_BCD <= 8'h00;
			else
				begin
					if(DOWN_BCD[3:0] == 4'h0)
						begin
							DOWN_BCD[3:0] <= 4'h9;
							DOWN_BCD[7:4] <= DOWN_BCD[7:4] - 1'b1;
						end
					else
						DOWN_BCD[3:0] <= DOWN_BCD[3:0] - 1'b1;
						
					if(DOWN_BCD == 8'h00)
						DOWN_BCD <= 8'h30;
				end
		end
		
	 //ROTATE
	 always @(posedge SCAN or negedge RESET)
		begin
			if(!RESET)
				ENABLE <= 6'b111110;
			else
				ENABLE <= {4'b1111, ENABLE[0], ENABLE[1]};
		end
		
	 //MULX
	 always @(ENABLE or UP_BCD or DOWN_BCD or FLAG)
		begin
			if(FLAG)
					case(ENABLE)
						6'b111110	:	DECODE_BCD <= UP_BCD[3:0];
						default		:	DECODE_BCD <= UP_BCD[7:4];
					endcase
			else
					case(ENABLE)
						6'b111110	:	DECODE_BCD <= DOWN_BCD[3:0];
						default		:	DECODE_BCD <= DOWN_BCD[7:4];
					endcase
		end
		
	 //DECODER
	 always @(DECODE_BCD)
		begin
			case(DECODE_BCD)
				4'h0	  : SEGMENT <= 8'b11000000;
				4'h1	  : SEGMENT <= 8'b11111001;
				4'h2	  : SEGMENT <= 8'b10100100;
				4'h3	  : SEGMENT <= 8'b10110000;
				4'h4	  : SEGMENT <= 8'b10011001;
				4'h5	  : SEGMENT <= 8'b10010010;
				4'h6	  : SEGMENT <= 8'b10000010;
				4'h7	  : SEGMENT <= 8'b11011000;
				4'h8	  : SEGMENT <= 8'b10000000;
				4'h9	  : SEGMENT <= 8'b10010000;
				default : SEGMENT <= 8'b11111111;				
			endcase
		end
		
	 //ONE CLICK CIRCUIT
	 always @(posedge DISPLAY_CLK or negedge RESET)
		begin
			if(!RESET)
				begin
					FLAG <= 1'b1;
					DISPLAY_COUNT <= 8'h00;
				end
			else
				begin
					if(ROW0 == 1'b0)
						begin
							DISPLAY_COUNT <= 8'hFF;
							FLAG <= 1'b0;
						end
					
					if(DISPLAY_COUNT > 8'h00)
						DISPLAY_COUNT <= DISPLAY_COUNT - 1'b1;
					else
						FLAG <= 1'b1;
				end
		end

endmodule
