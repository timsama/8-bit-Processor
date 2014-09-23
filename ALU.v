`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Engineer: Tim Winchester
// 
// Create Date:    00:08:11 04/13/2014 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input [3:0] X,
    input [3:0] Y,
    input [1:0] Op,
    output [3:0] O
    );
	 
	 assign O = Op[1] ?
		(Op[0] ?
			~X //Not
			: X & Y)//And
		:(Op[0] ?
			X - Y //Sub
			: X + Y); //Add
			
endmodule
