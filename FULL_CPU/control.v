module control (Jp, ALUinB, ALUop, DMwe, Rwe, Rdst, Rwd, blt, 
		bne, jal, jr, bex, setx, A, B, C, is_add, is_addi, is_sub, 
		opcode, ALUop_in, overflow);

	input [4:0] opcode, ALUop_in;
	input overflow;
	output [4:0] ALUop;
	output Jp, ALUinB, DMwe, Rwe, Rdst, Rwd;
	output blt, bne, jal, jr, bex, setx, A, B, C;
	output is_add, is_addi, is_sub;

	assign is_add = (opcode == 5'b00000 && ALUop_in == 5'b00000) ? 1'b1 : 1'b0;
	assign is_addi = (opcode == 5'b00101) ? 1'b1 : 1'b0;
	assign is_sub = (opcode == 5'b00000 && ALUop_in == 5'b00001) ? 1'b1 : 1'b0;
	
	assign Jp = (opcode == 5'b00001 || opcode == 5'b00011) ? 1'b1 : 1'b0;
	assign ALUinB = (opcode == 5'b00101 || opcode == 5'b00111 || opcode == 5'b01000) ? 1'b1 : 1'b0;
	assign ALUop = (opcode == 5'b00000) ? ALUop_in : 
			((opcode == 5'b00101 || opcode == 5'b00111 || opcode == 01000) ? 5'b00000 : 5'b00001);
	assign DMwe = (opcode == 5'b00111) ? 1'b1 : 1'b0;
	assign Rwe = (opcode == 5'b00000 || opcode == 5'b00101 || opcode == 5'b01000 || opcode == 5'b00011
			|| opcode == 5'b10101) ? 1'b1 : 1'b0;
	assign Rdst = (opcode == 5'b00000) ? 1'b0 : 1'b1;
	assign Rwd = (opcode == 5'b01000) ? 1'b1 : 1'b0;
	assign blt = (opcode == 5'b00110) ? 1'b1 : 1'b0;
	assign bne = (opcode == 5'b00010) ? 1'b1 : 1'b0;
	assign jal = (opcode == 5'b00011) ? 1'b1 : 1'b0;
	assign jr = (opcode == 5'b00100) ? 1'b1 : 1'b0;
	assign bex = (opcode == 5'b10110) ? 1'b1 : 1'b0;
	assign setx = (opcode == 5'b10101) ? 1'b1 : 1'b0;
	assign A = bex | C;
	assign B = overflow & (is_add | is_addi | is_sub);
	assign C = setx | B;
	
	
endmodule
	