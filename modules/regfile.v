module stimulus;
	reg [3:0] Aaddr, Baddr, Caddr;
	reg [15:0] C;
	wire [15:0] A, B;
	reg clN, CLK, LOAD;

	reg_file myregfile(A, B, Aaddr, Baddr, C, Caddr, LOAD, clN, CLK);
  
	initial
		CLK = 1'b0;
	always
		#5 CLK = ~CLK;

	initial
	begin
		//clearing the register file and getting reg4(A) and reg5(B) values
		Aaddr = 4'd4; Baddr = 4'd5; clN = 0; LOAD = 0;
		#6 $display("A = %d, B = %d", A, B);

		//loading reg4 the value of C. now, A gives the value of C (since reg4 is read to A)
		//NCL must be set to 1 to avoid regfile being cleared. LOAD is set to 1 to load C value
		Caddr = 4'd4; C = 16'd15; clN = 1; LOAD = 1;
		#10 $display("A = %d, B = %d", A, B);

		//loading reg5 the value of C. now, B gives the value of C (since reg5 is read to B)
		Caddr = 4'd5; C = 16'd30; LOAD = 1;
		#10 $display("A = %d, B = %d", A, B);

		//value of C doesn't get written to reg5 since LOAD is not set to 1 (so B gives the same previous reading)
		C = 16'd50; LOAD = 0;
		#10 $display("A = %d, B = %d", A, B);

		//clearing the regfile again
		clN = 0;
		#10 $display("A = %d, B = %d", A, B);

	end

endmodule

module reg_file(A, B, Aaddr, Baddr, C, Caddr, load, clear, clk);
	input [3:0] Aaddr, Baddr, Caddr;
	input [15:0] C;
	input load, clear, clk;
	output reg [15:0] A, B;

	reg [15:0] regdata [15:0];

	integer i;
	
	initial
	begin
		#2 regdata[0] = 16'd5;
		regdata[1] = 16'd7;
	end
				
	always @ (posedge clk, clear) 
		begin
			if (load == 1) 
				regdata[Caddr] = C;

			if (clear == 0) 
				begin
					i = 0;
					for (i = 0;  i < 16; i = i + 1) 
						regdata[i] = 16'd0;
				end

			A = regdata[Aaddr]; 
			B = regdata[Baddr];
		end

endmodule