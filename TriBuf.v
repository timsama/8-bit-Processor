`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Engineer: Tim Winchester
// 
// Create Date:    00:13:46 04/13/2014 
// Design Name: 
// Module Name:    TriBuf 
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
module TriBuf(
    input [3:0] In,
    output [3:0] Out,
    input enable
    );

	assign Out = enable ? In : 4'bZZZZ;

endmodule
