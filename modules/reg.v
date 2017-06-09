module register16_bit(data, clock, out);

	input [15:0] data;
	input clock;
	output reg [15:0] out;

	initial
	begin
		out = 16'd0;
	end
	
	always @(posedge clock)
	begin
		out = data;
	end

endmodule
