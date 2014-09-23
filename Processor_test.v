`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
//
// Engineer: Tim Winchester
//
// Create Date:   20:40:31 04/13/2014
// Design Name:   Processor
// Module Name:   U:/My Documents/Project/FinalProject/Processor_test.v
// Project Name:  FinalProject
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Processor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Processor_test;

	// Inputs
	reg [7:0] sw;
	reg user_btn;
	reg run_btn;
	reg clr;
	reg clk;

	// Outputs
	wire [3:0] led;

	// Instantiate the Unit Under Test (UUT)
	Processor uut (
		.sw(sw), 
		.btn({run_btn, user_btn}),
		.clr(clr), 
		.clk(clk), 
		.led(led)
	);
	
	// define OPs and FUNCTs
	localparam LOAD		= 8'b00000000;
	localparam STORE		= 8'b01000000;
	localparam MOVE		= 8'b10000000;
	localparam ADD			= 8'b11000000;
	localparam SUB			= 8'b11000001;
	localparam AND			= 8'b11000010;
	localparam NOT			= 8'b11000011;
	
	// define X parameters
	localparam X0			= 8'b00000000;
	localparam X1			= 8'b00010000;
	localparam X2			= 8'b00100000;
	localparam X3			= 8'b00110000;
	
	// define Y parameters
	localparam Y0			= 8'b00000000;
	localparam Y1			= 8'b00000100;
	localparam Y2			= 8'b00001000;
	localparam Y3			= 8'b00001100;
	
	initial begin
		// Initialize Inputs
		sw = 0;
		user_btn = 0;
		run_btn = 0;
		clr = 0;
		clk = 0;

		// Wait 100 ns for global reset to finish
		#100
        
		// Add stimulus here
		clr = 1;
		#13
		clr = 0;
		
		#200
		sw = LOAD + X0 + 4'b0001; // load 1 into R0
		user_btn = 1;
		#20;
		user_btn = 0;
		
		#200 // run the program stored in memory
		run_btn = 1;
		#20
		run_btn = 0;
		
		#400
		sw = STORE + X0; // display R0
		user_btn = 1;
		#20;
		user_btn = 0;
		
		#200
		// check the output
		if(led != 4'b1111)
			$display("Register 0 failed.");
		
		#200
		sw = STORE + X1; // display R1
		user_btn = 1;
		#20;
		user_btn = 0;
		
		#200
		// check the output
		if(led != 4'b1111)
			$display("Register 1 failed.");
		
		#200
		sw = STORE + X2; // display R2
		user_btn = 1;
		#20;
		user_btn = 0;
		
		#200
		// check the output
		if(led != 4'b1111)
			$display("Register 2 failed.");
		
		#200
		sw = STORE + X3; // display R3
		user_btn = 1;
		#20;
		user_btn = 0;
		
		#200
		// check the output
		if(led != 4'b1111)
			$display("Register 3 failed.");
	end
	
	always
		#5 clk = ~clk;
      
endmodule

