module control (ALUinB, DMwe, Rwe, Rdst, Rwd, opcode);

	input [4:0] opcode;
	output ALUinB, DMwe, Rwe, Rdst, Rwd;
	
	assign ALUinB = (opcode == 5'b00000) ? 1'b0 : 1'b1;
	assign DMwe = (opcode == 5'b00111) ? 1'b1 : 1'b0;
	assign Rwe = (opcode == 5'b00111) ? 1'b0 : 1'b1;
	assign Rdst = (opcode == 5'b00111) ? 1'b1 : 1'b0;
	assign Rwd = (opcode == 5'b01000) ? 1'b1 : 1'b0;
endmodule
	