module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
	wire [31:0] not_B;
	wire [31:0] final_B;
	
	//outputs
	wire [31:0]output_adder;
	wire [31:0]output_and;
	wire [31:0]output_or;
	wire [31:0]output_SLL;
	wire [31:0]output_SRA;
	
	//extra wires for output
	wire [31:0] temp1, temp2, temp3;
	wire temp4;
	
	wire less1, less2, less3, neg_a, neg_b;
	
	// operations
	not_gate32 not_gate1(data_operandB[31:0], not_B[31:0]);
	mux2 mux_2bit(ctrl_ALUopcode[0], data_operandB[31:0], not_B[31:0], final_B[31:0]);
	Adder32 adder_32bit(data_operandA[31:0], final_B[31:0], ctrl_ALUopcode[4:0], output_adder, overflow);
	And32 and_32bit(data_operandA, data_operandB, output_and);
	bitwise_or bitwise_or1(data_operandA[31:0], data_operandB[31:0], output_or[31:0]);
	SLL sll0(data_operandA, ctrl_shiftamt, output_SLL);
	
	
	//choose from output
	mux2 m0(ctrl_ALUopcode[0], output_SLL, output_SRA, temp1);
	mux2 m1(ctrl_ALUopcode[0], output_and, output_or, temp2);
	mux2 m2(ctrl_ALUopcode[1], temp1, temp2, temp3);
	or or0(temp4, ctrl_ALUopcode[1], ctrl_ALUopcode[2]);
	mux2 m3(temp4, output_adder, temp3, data_result);
	
	//isLessThan: (a<0&&b>0) || (a>0 && b >0 && out < 0) || (a<0 && b<0 && out <0) 
	not n1(neg_a, data_operandA[31]);
	not n2(neg_b, data_operandB[31]);
	and a1(less1, neg_b, data_operandA[31]);
	and a2(less2, data_operandA[31], data_operandB[31], output_adder[31]);
	and a3(less3, neg_a, neg_b, output_adder[31]);
	or o0(isLessThan, less1, less2, less3);
	
	//isNotEqual:equal => output_adder == 0 && no ovf
	or o1(isNotEqual, output_adder[0], output_adder[1], output_adder[2], output_adder[3], output_adder[4],
			output_adder[5], output_adder[6], output_adder[7], output_adder[8], output_adder[9],
			output_adder[10], output_adder[11], output_adder[12], output_adder[13], output_adder[14],
			output_adder[15], output_adder[16], output_adder[17], output_adder[18], output_adder[19],
			output_adder[20], output_adder[21], output_adder[22], output_adder[23], output_adder[24],
			output_adder[25], output_adder[26], output_adder[27], output_adder[28], output_adder[29],
			output_adder[30], output_adder[31], overflow);

	
endmodule
