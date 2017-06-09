module stimulus;
	reg [2:0] control;
	reg signed [15:0] x, y;
	reg c_in;
	wire signed [15:0] z;
	wire c_out, lt, eq, gt, overflow;

	alu myalu(x, y, z, c_in, c_out, lt, eq, gt, overflow, control);
	
	initial
	begin
	
		//Note: x and y are signed numbers. output z is also a signed number.
		//But, comparisons are done thinking that x and y are unsigned numbers. (i.e. lt and gt are unsigned comparisons)
	
		//add
		c_in = 0; 
		x = 16'd5; y = 16'd10; control = 3'b010;
		#5 $display("Add\nx = %d, y = %d, c_in = %b, z = %d, c_out = %b, lt = %b, eq = %b, gt = %b, overflow = %b", x, y, c_in, z, c_out, lt, eq, gt, overflow);
		
		//add expecting a carry out
		x = 16'hFFFF; y = 16'h1;
		#5 $display("x = %d, y = %d, c_in = %b, z = %d, c_out = %b, lt = %b, eq = %b, gt = %b, overflow = %b", x, y, c_in, z, c_out, lt, eq, gt, overflow);
		
		//add expecting an overflow
		x = 16'h7FFF; y = 16'h1; //adding 1 to maximum positive number
		#5 $display("x = %d, y = %d, c_in = %b, z = %d, c_out = %b, lt = %b, eq = %b, gt = %b, overflow = %b\n", x, y, c_in, z, c_out, lt, eq, gt, overflow);
		
		
		//subtract
		x = 16'd5; y = 16'd10; control = 3'b011;
		#5 $display("Subtract\nx = %d, y = %d, c_in = %b, z = %d, c_out = %b, lt = %b, eq = %b, gt = %b, overflow = %b", x, y, c_in, z, c_out, lt, eq, gt, overflow);
		
		//subtract expecting an overflow
		x = 16'h8000; y = 16'h1; //subtracting 1 from maximum negative number
		#5 $display("x = %d, y = %d, c_in = %b, z = %d, c_out = %b, lt = %b, eq = %b, gt = %b, overflow = %b\n", x, y, c_in, z, c_out, lt, eq, gt, overflow);
		
		
		//and
		x = 16'h0123; y = 16'hF1F2; control = 3'b000;
		#5 $display("And\nx = %b, y = %b, z = %b \n", x, y, z);
		
		//or
		x = 16'h0123; y = 16'hF1F2; control = 3'b001;
		#5 $display("Or\nx = %b, y = %b, z = %b \n", x, y, z);
		
		//set-on-less-than
		x = 16'd9; y = 16'd10; control = 3'b111;
		#5 $display("SLT\nx = %d, y = %d, z = %b \n", x, y, z);
		
	end

endmodule

module alu(x, y, z, c_in, c_out, lt, eq, gt, overflow, c);
	input [15:0] x, y;
	input [2:0] c;
	input c_in;
	
	output reg [15:0] z;
	output reg c_out, lt, eq, gt, overflow;
	
	always @(c, x, y, c_in)
	begin
		case (c)
			3'b000 : z = x & y; 					//And
			3'b001 : z = x | y; 					//Or
			3'b010 : begin
						{c_out, z} = x + y + c_in; 	//Add
						overflow = (x[15] == y[15]) && (z[15] != x[15]); //setting overflow bit
					end	
			3'b011 : begin
						{c_out, z} = x + ~y + 1; 	//Subtract
						overflow = (x[15] != y[15]) && (z[15] != x[15]); //setting overflow bit
					end	
			3'b111 : z = x < y; 					//Set-on-less-than
		endcase
		
		lt = x < y;		//less than (is x < y?)
		eq = x == y;	//equal (is x = y?)
		gt = x > y;		//greater than (is x > y?)
	end
endmodule