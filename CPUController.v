`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Engineer: Tim Winchester
// 
// Create Date:    21:46:36 04/12/2014 
// Design Name: 
// Module Name:    CPUController 
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
module CPUController(
	 input clk,
    input clr,
    input user_btn,
    input run_btn,
    input [7:0] InstructionUser,
    input [7:0] InstructionRun,
    output [1:0] ALUOp,
    output [6:0] Enable,
    output [5:0] Tristate,
	 output clearRegs,
	 output reg [9:0] counter,
	 output [3:0] InstrBus
    );

	parameter End = 10'b1111111111;

	reg idle, counter_zero, counter_huge, fetch_instr, save_instr;
	reg store, move, load, ALUin, ALUexec, ALUout, clear;
	reg [5:0] Instruction;
	
	// determine the next state (one-hot encoding)
	always @(posedge clk)
	begin
		if (clr)
		begin
			idle = 1'b1;
			counter_zero = 1'b0;
			counter_huge = 1'b0;
			fetch_instr = 1'b0;
			save_instr = 1'b0;
			store = 1'b0;
			move = 1'b0;
			load = 1'b0;
			ALUin = 1'b0;
			ALUexec = 1'b0;
			ALUout = 1'b0;
			clear = 1'b0;
		end
		if (idle)
		begin
			if (user_btn) // set the counter beyond the program length if in user mode
			begin
				idle = 1'b0;
				counter_huge = 1'b1;
			end
			else if (run_btn) // set the counter to the beginning if in run mode
			begin
				idle = 1'b0;
				counter_zero = 1'b1;
			end
			else ;
		end
		else if (counter_huge) // wait until we get a spacer to continue
			if (~user_btn)
			begin
				counter_huge = 1'b0;
				save_instr = 1'b1;
			end
			else ;
		else if (counter_zero) // wait until we get a spacer to continue
			if (~run_btn)
			begin
				counter_zero = 1'b0;
				fetch_instr = 1'b1;
			end
			else ;
		else if (fetch_instr) // the next state from fetch_instr depends on the top two bits
		begin
			fetch_instr = 1'b0;
			if(~InstructionRun[7] & ~InstructionRun[6])
				load = 1'b1;
			else if(~InstructionRun[7] & InstructionRun[6])
				store = 1'b1;
			else if(InstructionRun[7] & ~InstructionRun[6])
				move = 1'b1;
			else if(InstructionRun[7] & InstructionRun[6])
				ALUin = 1'b1;
			else ;
		end
		else if (save_instr) // the next state from save_inst depends on the top two bits
		begin
			save_instr = 1'b0;
			if(~InstructionUser[7] & ~InstructionUser[6])
				load = 1'b1;
			else if(~InstructionUser[7] & InstructionUser[6])
				store = 1'b1;
			else if(InstructionUser[7] & ~InstructionUser[6])
				move = 1'b1;
			else if(InstructionUser[7] & InstructionUser[6])
				ALUin = 1'b1;
			else ;
		end
		else if (ALUin) // just move to the next state; combinational/ALU does the heavy lifting here
		begin
			ALUin = 1'b0;
			ALUexec = 1'b1;
		end
		else if (ALUexec) // just move to the next state; combinational/ALU does the heavy lifting here
		begin
			ALUexec = 1'b0;
			ALUout = 1'b1;
		end
		else if (ALUout) // just move to the next state; combinational/ALU does the heavy lifting here
		begin
			ALUout = 1'b0;
			clear = 1'b1;
		end
		else if (load) // load will execute through combinational logic, just move to the next state
		begin
			load = 1'b0;
			clear = 1'b1;
		end
		else if (store) // store will execute through combinational logic, just move to the next state
		begin
			store = 1'b0;
			clear = 1'b1;
		end
		else if (move) // move will execute through combinational logic, just move to the next state
		begin
			move = 1'b0;
			clear = 1'b1;
		end
		else if (clear)  // when in the clear state, fetch the next run mode instruction if the counter
		begin            // has not exceeded the end of the program (it always will when in user mode)
			clear = 1'b0; // which allows for a single instruction to execute at a time
			if (counter < End)
				fetch_instr = 1'b1;
			else
				idle = 1'b1;
		end
		else ;
	end
	
	// assign registers based on state
	always @(posedge clk)
	if(counter_zero)
		counter = 10'b0000000001;
	else if(counter_huge)
		counter = End;
	else if(fetch_instr)
	begin // take instructions from memory when in run mode
		Instruction[0] = InstructionRun[0];
		Instruction[1] = InstructionRun[1];
		Instruction[2] = InstructionRun[2];
		Instruction[3] = InstructionRun[3];
		Instruction[4] = InstructionRun[4];
		Instruction[5] = InstructionRun[5];
	end
	else if(save_instr)
	begin // take instructions from the user when in user mode
		Instruction[0] = InstructionUser[0];
		Instruction[1] = InstructionUser[1];
		Instruction[2] = InstructionUser[2];
		Instruction[3] = InstructionUser[3];
		Instruction[4] = InstructionUser[4];
		Instruction[5] = InstructionUser[5];
	end
	else if (clear) // whenever an instruction has been completed, increment the counter
		counter = counter + 1'b1;
	else ;
	
	// determine when to clear the registers
	assign clearRegs = clr;
	
	// determine what operation to have the ALU perform
	assign ALUOp[1] = ALUexec ? Instruction[1] : 1'b0;
	assign ALUOp[0] = ALUexec ? Instruction[0] : 1'b0;
	
	// determine when the registers can output to the bus
	assign Tristate[0] = ((move | ALUin) & ~Instruction[3] & ~Instruction[2])
						 | ((ALUexec | store) & ~Instruction[5] & ~Instruction[4]);
	assign Tristate[1] = ((move | ALUin) & ~Instruction[3] &  Instruction[2])
						 | ((ALUexec | store) & ~Instruction[5] &  Instruction[4]);
	assign Tristate[2] = ((move | ALUin) &  Instruction[3] & ~Instruction[2])
						 | ((ALUexec | store) &  Instruction[5] & ~Instruction[4]);
	assign Tristate[3] = ((move | ALUin) &  Instruction[3] &  Instruction[2])
						 | ((ALUexec | store) &  Instruction[5] &  Instruction[4]);
	assign Tristate[4] = ALUout;
	assign Tristate[5] = load;
	
	// determine when the registers can accept input from the bus
	assign Enable[0] = (ALUout | load | move) & ~Instruction[5] & ~Instruction[4];
	assign Enable[1] = (ALUout | load | move) & ~Instruction[5] &  Instruction[4];
	assign Enable[2] = (ALUout | load | move) &  Instruction[5] & ~Instruction[4];
	assign Enable[3] = (ALUout | load | move) &  Instruction[5] &  Instruction[4];
	assign Enable[4] = ALUin;
	assign Enable[5] = ALUexec;
	assign Enable[6] = store;
	
	// make the bottom 4 bits available to the bus when needed
	assign InstrBus[0] = Instruction[0];
	assign InstrBus[1] = Instruction[1];
	assign InstrBus[2] = Instruction[2];
	assign InstrBus[3] = Instruction[3];

endmodule
