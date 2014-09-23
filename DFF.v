`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:09:28 04/13/2014 
// Design Name: 
// Module Name:    DFF 
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
module DFF(
    input [3:0] In,
    output reg [3:0] Out,
    input enable,
    input clk,
    input reset
    );

	 always @(posedge clk)
	 begin
		if(reset)
			Out = 4'b0000;
		else if(enable)
			Out = In;		
	 end

endmodule
