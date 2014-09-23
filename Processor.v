`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Engineer: Tim Winchester
// 
// Create Date:    19:53:28 04/13/2014 
// Design Name: 
// Module Name:    Processor 
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
module Processor(
    input [7:0] sw,
    input [1:0] btn,
    input clr,
    input clk,
    output [3:0] led,
	 output decimal,
	 output [3:0] EnableSegs,
	 output [6:0] segs
    );
	 
	 reg [7:0] InstructionRun;
	 wire [1:0] ALUOp;
	 wire [6:0] Enable;
	 wire [5:0] Tristate;
	 wire clearRegs;
	 wire [9:0] counter;
	 wire [3:0] InstrBus;
	 wire DB_user_btn;
	 wire DB_run_btn;
	 
	 // debounce the two input buttons
	 DeBouncer DB_0(clk, clr, btn[0], DB_user_btn);
	 DeBouncer DB_1(clk, clr, btn[1], DB_run_btn);
	 //assign DB_user_btn = btn[0];
	 //assign DB_run_btn = btn[1];
	 
	 // declare the CPU controller and have it stop at "line" 14 of the stored instructions
	 CPUController #(14) cpu(
		.clk(clk), 
		.clr(clr), 
		.user_btn(DB_user_btn), 
		.run_btn(DB_run_btn),
		.InstructionUser(sw), 
		.InstructionRun(InstructionRun), 
		.ALUOp(ALUOp), 
		.Enable(Enable), 
		.Tristate(Tristate), 
		.clearRegs(clearRegs),
		.counter(counter),
		.InstrBus(InstrBus)
		);
	 
	 // declare the main bus
	 wire [3:0] Bus;
	 
	 // declare register-specific buses
	 wire [3:0] R0_Out;
	 wire [3:0] R1_Out;
	 wire [3:0] R2_Out;
	 wire [3:0] R3_Out;
	 wire [3:0] R4_Out;
	 wire [3:0] R5_Out;
	 wire [3:0] R6_Out;
	 wire [3:0] ALUOut;
	 
	 // declare the tri-state buffers
	 TriBuf TB_0(.In(R0_Out), .Out(Bus), .enable(Tristate[0]));
	 TriBuf TB_1(.In(R1_Out), .Out(Bus), .enable(Tristate[1]));
	 TriBuf TB_2(.In(R2_Out), .Out(Bus), .enable(Tristate[2]));
	 TriBuf TB_3(.In(R3_Out), .Out(Bus), .enable(Tristate[3]));
	 TriBuf TB_4(.In(R5_Out), .Out(Bus), .enable(Tristate[4]));
	 TriBuf TB_5(.In(InstrBus), .Out(Bus), .enable(Tristate[5]));
	 
	 // declare the D Flip-flops
	 DFF R0(.In(Bus), .Out(R0_Out), .enable(Enable[0]), .clk(clk), .reset(clearRegs));
	 DFF R1(.In(Bus), .Out(R1_Out), .enable(Enable[1]), .clk(clk), .reset(clearRegs));
	 DFF R2(.In(Bus), .Out(R2_Out), .enable(Enable[2]), .clk(clk), .reset(clearRegs));
	 DFF R3(.In(Bus), .Out(R3_Out), .enable(Enable[3]), .clk(clk), .reset(clearRegs));
	 DFF R4(.In(Bus), .Out(R4_Out), .enable(Enable[4]), .clk(clk), .reset(clearRegs));
	 DFF R5(.In(ALUOut), .Out(R5_Out), .enable(Enable[5]), .clk(clk), .reset(clearRegs));
	 DFF R6(.In(Bus), .Out(R6_Out), .enable(Enable[6]), .clk(clk), .reset(clearRegs));
	 
	 // declare the ALU
	 ALU alu(.X(Bus), .Y(R4_Out), .Op(ALUOp), .O(ALUOut));
	 
	 // hook up the leds
	 assign led = R6_Out;
	 
	 LED_7SEG seg7(
		.clock(clk), 
		.clear(clearRegs), 
		.data0(R0_Out), 
		.data1(R1_Out), 
		.data2(R2_Out), 
		.data3(R3_Out),
		.decimal(decimal),
		.enable(EnableSegs),
		.segs(segs));
	 
	 // define the instructions "stored in memory"
	 always @(counter)
	 begin
		case (counter)
			1:  InstructionRun = 8'b10010000; // MOVE from R0 to R1
			2:  InstructionRun = 8'b00000001; // LOAD 1 into R0
			3:  InstructionRun = 8'b10100100; // MOVE R1 to R2
			4:  InstructionRun = 8'b10110100; // MOVE R1 to R3
			5:  InstructionRun = 8'b11010011; // NOT to flip the bits in R1
			6:  InstructionRun = 8'b11010000; // ADD R0 to R1 (adding one) -- R1 complete
			7:  InstructionRun = 8'b00000000; // LOAD 0 into R0
			8:  InstructionRun = 8'b11001001; // SUB R2 from 0
			9:  InstructionRun = 8'b10100000; // MOVE result from R0 into R2 -- R2 complete
			10: InstructionRun = 8'b00001111; // LOAD 15 into R0
			11: InstructionRun = 8'b11110011; // NOT R3 into ~R3
			12: InstructionRun = 8'b11110001; // SUB ~R3 from 15 -- R3 complete
			13: InstructionRun = 8'b01110000; // STORE R3 in the LEDs
			14: InstructionRun = 8'b11000110; // AND the final result into R0 -- R0 complete
			// should all give the same result, namely the two's complement inverse of the
			// original input
			default: InstructionRun = 8'b01110000; // STORE R3 in the LEDs if no instruction specified
		endcase
	 end
endmodule
