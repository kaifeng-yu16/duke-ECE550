module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
	wire [31:0] not_B;
	wire [31:0] final_B;
 
	not_gate32 not_gate1(data_operandB[31:0], not_B[31:0]);
	mux2 mux_2bit(ctrl_ALUopcode[0], data_operandB[31:0], not_B[31:0], final_B[31:0]);
	Adder32 adder_32bit(data_operandA[31:0], final_B[31:0], ctrl_ALUopcode[4:0], data_result[31:0], overflow);

endmodule
