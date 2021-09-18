module not_gate32(in, out);
	input [31:0] in;
	output [31:0] out;
	
	generate
		genvar i;
		for(i=0;i<32;i=i+1) begin: loop_not
			not not0(out[i], in[i]);
		end
	endgenerate
	
endmodule 