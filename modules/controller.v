module stimulus;
	reg [3:0] Instr_op_code;
	wire RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite; //control signals
	wire [2:0] ALUOp; //ALU control signal

	controller mycontroller(Instr_op_code, RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
  
	initial
	begin
		
		//testing ADD instruction
		Instr_op_code = 4'h2;
		#6 $display("RegDst = %b, Jump = %b, Branch = %b, MemRead = %b, MemtoReg = %b, ALUOp = %b, MemWrite = %b, ALUSrc = %b, RegWrite = %b", RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

		//testing SUB instruction
		Instr_op_code = 4'h6;
		#10 $display("RegDst = %b, Jump = %b, Branch = %b, MemRead = %b, MemtoReg = %b, ALUOp = %b, MemWrite = %b, ALUSrc = %b, RegWrite = %b", RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

		//testing AND instruction
		Instr_op_code = 4'h0;
		#10 $display("RegDst = %b, Jump = %b, Branch = %b, MemRead = %b, MemtoReg = %b, ALUOp = %b, MemWrite = %b, ALUSrc = %b, RegWrite = %b", RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

		//testing OR instruction
		Instr_op_code = 4'h1;
		#10 $display("RegDst = %b, Jump = %b, Branch = %b, MemRead = %b, MemtoReg = %b, ALUOp = %b, MemWrite = %b, ALUSrc = %b, RegWrite = %b", RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

		//testing SLT instruction
		Instr_op_code = 4'h7;
		#10 $display("RegDst = %b, Jump = %b, Branch = %b, MemRead = %b, MemtoReg = %b, ALUOp = %b, MemWrite = %b, ALUSrc = %b, RegWrite = %b", RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

		//testing LW instruction
		Instr_op_code = 4'h8;
		#10 $display("RegDst = %b, Jump = %b, Branch = %b, MemRead = %b, MemtoReg = %b, ALUOp = %b, MemWrite = %b, ALUSrc = %b, RegWrite = %b", RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

		//testing SW instruction
		Instr_op_code = 4'hA;
		#10 $display("RegDst = %b, Jump = %b, Branch = %b, MemRead = %b, MemtoReg = %b, ALUOp = %b, MemWrite = %b, ALUSrc = %b, RegWrite = %b", RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

		//testing BNE instruction
		Instr_op_code = 4'hE;
		#10 $display("RegDst = %b, Jump = %b, Branch = %b, MemRead = %b, MemtoReg = %b, ALUOp = %b, MemWrite = %b, ALUSrc = %b, RegWrite = %b", RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

		//testing JMP instruction
		Instr_op_code = 4'hF;
		#10 $display("RegDst = %b, Jump = %b, Branch = %b, MemRead = %b, MemtoReg = %b, ALUOp = %b, MemWrite = %b, ALUSrc = %b, RegWrite = %b", RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);

	end
	
endmodule

module controller(Op_code, RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);
	input [3:0] Op_code;
	output reg RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
	output reg [2:0] ALUOp; //this is to be directly connected to the ALU control input
							//000 - AND, 
							//001 - OR, 
							//010 - ADD, 
							//011 - SUB, 
							//111 - SET_ON_LESS_THAN
	
	always @(Op_code)
	begin
		case (Op_code)
			4'd2 : {RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite} = 11'b10000010001; //ADD instruction
			4'd6 : {RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite} = 11'b10000011001; //SUB instruction
			4'd0 : {RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite} = 11'b10000000001; //AND instruction
			4'd1 : {RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite} = 11'b10000001001; //OR instruction
			4'd7 : {RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite} = 11'b10000111001; //SLT instruction
			4'd8 : {RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite} = 11'b00011010011; //LW instruction
			4'd10 : {RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite} = 11'b00000010110; //SW instruction
			4'd14 : {RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite} = 11'b00100011000; //BNE instruction
			4'd15 : {RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite} = 11'b01000000000; //JMP instruction
			default : $display("Invalid signal");
		endcase
	end
endmodule

