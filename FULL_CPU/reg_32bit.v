module reg_32bit(out, in, clk, en, clr);
	input [31:0] in;
	input clk, en, clr;
	output [31:0] out;
	
	generate
		genvar i;
		for(i=0;i<32;i=i+1) begin: reg_32
			dffe_ref dffe(out[i], in[i], clk, en, clr);
		end
	endgenerate
endmodule  