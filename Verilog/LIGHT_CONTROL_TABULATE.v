`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:04:44 05/27/2016 
// Design Name: 
// Module Name:    LIGHT_CONTROL_TABULATE 
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
module LIGHT_CONTROL_TABULATE(CLK, RESET, LED);
    input CLK;
    input RESET;
    output [15:0] LED;

	 reg [16:0] REG;
	 reg [27:0] DIVIDER;
	 
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
	 assign SLOW_CLK = DIVIDER[20];
	 assign SPEED = DIVIDER[27];
	 assign SHIFT_CLK = SPEED ? FAST_CLK : SLOW_CLK;
	 
	 always @(posedge SHIFT_CLK or negedge RESET)
		begin
			if(!RESET)
				REG <= {1'b0, 16'hFFFF};
			else
				begin
					case(REG)
						{1'b0, 16'hFFFF}	:	REG <= {1'b0, 16'h7FFF};
						{1'b0, 16'h7FFF}	:	REG <= {1'b0, 16'h3FFF};
						{1'b0, 16'h3FFF}	:	REG <= {1'b0, 16'h1FFF};
						{1'b0, 16'h1FFF}	:	REG <= {1'b0, 16'h0FFF};
						{1'b0, 16'h0FFF}	:	REG <= {1'b0, 16'h07FF};
						{1'b0, 16'h07FF}	:	REG <= {1'b0, 16'h03FF};
						{1'b0, 16'h03FF}	:	REG <= {1'b0, 16'h01FF};
						{1'b0, 16'h01FF}	:	REG <= {1'b0, 16'h00FF};
						{1'b0, 16'h00FF}	:	REG <= {1'b0, 16'h007F};
						{1'b0, 16'h007F}	:	REG <= {1'b0, 16'h003F};
						{1'b0, 16'h003F}	:	REG <= {1'b0, 16'h001F};
						{1'b0, 16'h001F}	:	REG <= {1'b0, 16'h000F};
						{1'b0, 16'h000F}	:	REG <= {1'b0, 16'h0007};
						{1'b0, 16'h0007}	:	REG <= {1'b0, 16'h0003};
						{1'b0, 16'h0003}	:	REG <= {1'b0, 16'h0001};
						{1'b0, 16'h0001}	:	REG <= {1'b0, 16'h0000};
						{1'b0, 16'h0000}	:	REG <= {1'b1, 16'h0001};
						{1'b1, 16'h0001}	:	REG <= {1'b1, 16'h0003};
						{1'b1, 16'h0003}	:	REG <= {1'b1, 16'h0007};
						{1'b1, 16'h0007}	:	REG <= {1'b1, 16'h000F};
						{1'b1, 16'h000F}	:	REG <= {1'b1, 16'h001F};
						{1'b1, 16'h001F}	:	REG <= {1'b1, 16'h003F};
						{1'b1, 16'h003F}	:	REG <= {1'b1, 16'h007F};
						{1'b1, 16'h007F}	:	REG <= {1'b1, 16'h00FF};
						{1'b1, 16'h00FF}	:	REG <= {1'b1, 16'h01FF};
						{1'b1, 16'h01FF}	:	REG <= {1'b1, 16'h03FF};
						{1'b1, 16'h03FF}	:	REG <= {1'b1, 16'h07FF};
						{1'b1, 16'h07FF}	:	REG <= {1'b1, 16'h0FFF};
						{1'b1, 16'h0FFF}	:	REG <= {1'b1, 16'h1FFF};
						{1'b1, 16'h1FFF}	:	REG <= {1'b1, 16'h3FFF};
						{1'b1, 16'h3FFF}	:	REG <= {1'b1, 16'h7FFF};
						{1'b1, 16'h7FFF}	:	REG <= {1'b0, 16'hFFFF};
						default				:	REG <= {1'b0, 16'hFFFF};
					endcase
				end
		end
	 
	 assign LED = REG[15:0];
		
endmodule
