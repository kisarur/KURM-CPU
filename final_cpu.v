module stimulus;
	reg CLOCK;

	micro_processor myProcessor(CLOCK);

	initial
		CLOCK = 1'b0;
	always
		#15 CLOCK = ~CLOCK;


endmodule

module micro_processor(clock);

	reg clk2;
	initial
		clk2 = 1'b0;
	always
		#5 clk2 = ~clk2;

	
	input clock;

	//PC
	wire [15:0]  PCaddr_in, instr_addr;
	register16_bit PC(PCaddr_in, clock, instr_addr);


	//ALU to increment PC
	reg [15:0] increment = 16'd2; 
	wire [15:0] incremented_addr;
	wire c_out, lt, eq, gt, overflow;
	reg c_in = 0;
	alu PC_increment(instr_addr, increment, incremented_addr, c_in, c_out, lt, eq, gt, overflow, 3'b010);


	//Instruction Memory
	wire [15:0] instruction;
	instr_memory instruction_mem(instr_addr, clk2, instruction);


	//Controller
	wire RegDst, Jump, Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
	wire [2:0] ALUOp;
	controller main_controller(instruction[15:12], RegDst, Jump, Branch, MemRead, MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite);


	//Registers
	wire [15:0] reg_write_data, reg1_read_data, reg2_read_data;
	wire [3:0] write_reg; wire [11:0] extra_out_bits;
	mux2_to_1 RegDst_control({extra_out_bits, write_reg}, {12'd0, instruction[7:4]}, {12'd0, instruction[3:0]}, RegDst);
	
	reg clearN;
	initial
	begin
		clearN = 1'b0;
		#1 clearN = 1'b1;
	end
	reg_file registers(reg1_read_data, reg2_read_data, instruction[11:8], instruction[7:4], reg_write_data, write_reg, RegWrite, clearN, clk2);


	//Sign Extender
	wire [15:0] sign_extended;
	sign_extend4_to_16 sign_extend(instruction[3:0], sign_extended);


	//ALU
	wire [15:0] ALUSrc_ctrl_out;
	mux2_to_1 ALUSrc_control(ALUSrc_ctrl_out, reg2_read_data, sign_extended, ALUSrc);

	wire [15:0] ALU_result;
	wire c_out2, lt2, ALU_zero_out, gt2, overflow2;
	reg c_in2 = 0;
	alu ALU(reg1_read_data, ALUSrc_ctrl_out, ALU_result, c_in2, c_out2, lt2, ALU_zero_out, gt2, overflow2, ALUOp);
	

	//Data Memory
	wire [15:0] read_data;
	data_memory data_mem(ALU_result, MemRead, MemWrite, reg2_read_data, clk2, read_data);
	mux2_to_1 MemtoReg_control(reg_write_data, ALU_result, read_data, MemtoReg);


	//Jump and Branch
	wire [15:0] jump_addr;
	assign jump_addr = {incremented_addr[15:13], instruction[11:0], 1'b0}; //jump address calculation

	wire [15:0] branch_addr;
	wire c_out3, lt3, eq3, gt3, overflow3;
	reg c_in3 = 0;
	alu branch_addr_calc(incremented_addr, {sign_extended[14:0], 1'b0}, branch_addr, c_in3, c_out3, lt3, eq3, gt3, overflow3, 3'b010); //branch address calculation

	wire [15:0] branch_ctrl_out;
	mux2_to_1 branch_control(branch_ctrl_out, incremented_addr, branch_addr, (Branch & ~ALU_zero_out));

	mux2_to_1 jump_control(PCaddr_in, branch_ctrl_out, jump_addr, Jump);

	
endmodule
