module bitwise_or(data_operandA, data_operandB, bitwise_or_results);
 
   input [31:0] data_operandA, data_operandB;
   output [31:0] bitwise_or_results;
 
 generate
	genvar i;
	for (i=0;i<32;i=i+1) begin: loop_bitwise_or
		or or0(bitwise_or_results[i], data_operandA[i], data_operandB[i]);
	end
 endgenerate

endmodule 
