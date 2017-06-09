module stimulus;
	reg [15:0] addr;
	reg [15:0] writeData;
	reg memRead, memWrite, CLK;
	
	wire [15:0] readData;

	data_memory mydata(addr, memRead, memWrite, writeData, CLK, readData);
  
	initial
		CLK = 1'b0;
	always
		#5 CLK = ~CLK;

	initial
	begin
		addr = 16'd0; memRead = 1; memWrite = 0; // garbage value should be read
		#6 $display("ReadData = %d", readData);
		
		memRead = 0; memWrite = 1; writeData = 16'd15;
		#10 ;//memory[0] is loaded with writeData
		
		memRead = 1; memWrite = 0; //above written data is read
		#10 $display("ReadData = %d", readData);
	end

endmodule

module data_memory(addr, memRead, memWrite, writeData, clock, readData);
	input [15:0] addr;
	input [15:0] writeData;
	input memRead, memWrite, clock;
	
	output reg [15:0] readData;

	reg [15:0] memory [1023:0]; //this memory is word addresseble (each word is 16 bits)

	initial
	begin
		memory[0] = 16'd2;
		memory[1] = 16'd10;
	end
	
	always @ (posedge clock) 
		begin
			if (memWrite == 1) 
				memory[addr] = writeData;

			if (memRead == 1) 
				readData = memory[addr];
		end

endmodule