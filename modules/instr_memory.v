module stimulus;
	reg [15:0] addr;
	wire [15:0] instruction;
	reg CLK;

	instr_memory mypro(addr, CLK, instruction);
  
	initial
		CLK = 1'b0;
	always
		#5 CLK = ~CLK;

	initial
	begin
		addr = 10'd0;
		#6 $display("instruction = %h", instruction);
	end

endmodule

module instr_memory(addr, clock, instruction);
	input [15:0] addr;
	input clock;
	output reg [15:0] instruction;

	reg [7:0] memory [1023:0]; //this memory is byte addressable 

	//loading some instructions
	initial
	begin
		memory[0] = 8'h20;
		memory[1] = 8'h12;
		memory[2] = 8'h20;
		memory[3] = 8'h12; 
		memory[4] = 8'h20;
		memory[5] = 8'h12;
	end
	
	always @ (posedge clock) 
	begin
		instruction = {memory[addr], memory[addr + 1]}; //two bytes are read from the memory to get the complete instruction
	end

endmodule