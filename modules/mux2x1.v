module stimulus;

	reg [15:0] IN0, IN1;
	reg S;
	wire [15:0] OUTPUT;
	
	mux2_to_1 mymux(OUTPUT, IN0, IN1, S);
	
	initial
	begin
		// set input lines
		IN0 = 4'd3; IN1 = 4'd12;
		#1 $display("IN0= %d, IN1= %d\n",IN0,IN1);
		// choose IN0
		S = 0;
		#1 $display("S = %b OUTPUT = %d \n", S, OUTPUT);
		// choose IN1
		S = 1;
		#1 $display("S = %b OUTPUT = %d \n", S, OUTPUT);
	end
	
endmodule


module mux2_to_1 (out, i0, i1, s);
	
	input [15:0] i0, i1;
	input s;

	output reg [15:0] out;
	
	initial 
		out = 16'd0;
		
	always @(s, i0, i1)
	begin	
	
		case (s)
			1'b0 : out = i0;
			1'b1 : out = i1;
			default : $display("Invalid signal");	
		endcase
	end	
	
endmodule
