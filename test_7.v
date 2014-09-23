`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:52:53 04/13/2014
// Design Name:   LED_7SEG
// Module Name:   U:/My Documents/Project/FinalProject/test_7.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: LED_7SEG
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_7;

	// Inputs
	reg clock;
	reg clear;
	reg [3:0] data0;
	reg [3:0] data1;
	reg [3:0] data2;
	reg [3:0] data3;

	// Outputs
	wire decimal;
	wire [3:0] enable;
	wire [6:0] segs;

	// Instantiate the Unit Under Test (UUT)
	LED_7SEG uut (
		.clock(clock), 
		.clear(clear), 
		.data0(data0), 
		.data1(data1), 
		.data2(data2), 
		.data3(data3), 
		.decimal(decimal), 
		.enable(enable), 
		.segs(segs)
	);

	initial begin
		// Initialize Inputs
		clock = 0;
		clear = 0;
		data0 = 0;
		data1 = 0;
		data2 = 0;
		data3 = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

