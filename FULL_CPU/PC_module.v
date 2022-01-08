module PC_module (data_readRegB, target, immediate, isLessThan, isNotEqual, 
		bne, blt, bex, Jp, jr,clock, reset, PC, PC_plus_one);
		input [31:0] data_readRegB;
		input [26:0] target;
		input [16:0] immediate;
		input isLessThan, isNotEqual,bne, blt, bex, Jp, jr;
		input clock, reset;
		output reg [11:0] PC;
		output [11:0] PC_plus_one;
		
		wire [11:0] PC_new;
		assign PC_plus_one = PC + 12'b1;
		
		wire Br;
		wire is_blt, is_bne;
		assign is_bne = bne && isNotEqual;
		assign is_blt = blt && isNotEqual && (!isLessThan);
		assign Br = is_blt || is_bne;
		
		wire [11:0] Br_in2, Br_out;
		assign Br_in2 = immediate + PC_plus_one;
		assign Br_out = Br ? Br_in2 : PC_plus_one;
		
		wire Jp_sig, bex_out;
		assign bex_out = isNotEqual && bex;
		assign Jp_sig = Jp || bex_out;	
		
		assign PC_new = jr ? data_readRegB : (Jp_sig ? target : Br_out);
		
		always @ (posedge clock or posedge reset)
		begin
			if (reset)
				PC <= 12'b0;
			else 
				PC <= PC_new;
		end

endmodule
