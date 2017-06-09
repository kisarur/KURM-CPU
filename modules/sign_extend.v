module stimulus;

	reg [3:0] in;
	wire [15:0] out;
	
	sign_extend4_to_16 mys(in, out);
	
	initial
	begin
		in = 4'b1101;
		#1 $display("out=%b\n", out);
		
		in = 4'b0101;
		#1 $display("out=%b\n", out);
	end
	
endmodule


module sign_extend4_to_16(in, out);

	input [3:0] in;
	output reg [15:0] out;
	
	always @(in)
	begin
		out[3:0] = in[3:0];
		out[15:4] = {in[3], in[3], in[3], in[3], in[3], in[3], in[3], in[3], in[3], in[3], in[3], in[3]};
	end
	
endmodule
