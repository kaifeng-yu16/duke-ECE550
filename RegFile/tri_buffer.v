module tri_buffer(buffer_out, buffer_in, select);
	output [31:0] buffer_out;
	input select;
	input [31:0] buffer_in;
	
	assign buffer_out = select ? buffer_in : 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
endmodule 