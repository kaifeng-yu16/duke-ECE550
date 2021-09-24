module And32(A, B, Sum); 
	input [31:0] A;
	input [31:0] B;
	output [31:0] Sum;

	generate
		genvar i;
		for(i=0;i<32;i=i+1) begin: loop_and
			and and0(Sum[i], A[i], B[i]);
		end
	endgenerate
	
endmodule 
