module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB
);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg;

   output [31:0] data_readRegA, data_readRegB;

   /* YOUR CODE HERE */
	
	// Q represent output for each 32bit register, ex. Q[1]means the first register with 32 bits.
	wire [31:0] Q_out [31:0];
	wire [31:0] enable;
	
	// Please inplement write here! Use ctrl_writeEnable and ctrl_writeReg to decide which bit of enable should be 1.
	// you can use the decoder
	wire [31:0] enable_temp;
	decoder_5_32 dec0(enable_temp, ctrl_writeReg);
	generate
		genvar m;
		for(m=0;m<32;m=m+1) begin: gen_en
			and and_gate(enable[m], enable_temp[m], ctrl_writeEnable);
		end
	endgenerate
	
	// enable is always 0, can not write to reg0
	reg_32bit reg32_0(Q_out[0], data_writeReg, clock, 1'b0, ctrl_reset);
	generate
		genvar i;
		for(i=1;i<32;i=i+1) begin: reg_file_31
			reg_32bit reg32(Q_out[i], data_writeReg, clock, enable[i], ctrl_reset);
		end
	endgenerate
	
	// read
	wire [31:0] dec_res_A;
	wire [31:0] dec_res_B;
	decoder_5_32 dec1(dec_res_A, ctrl_readRegA);
	decoder_5_32 dec2(dec_res_B, ctrl_readRegB);
	
	generate
		genvar k;
		for(k=0;k<32;k=k+1) begin: reg_read_B
			assign data_readRegB = dec_res_B[k] ? Q_out[k] : 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
		end
	endgenerate
	
	generate
		genvar j;
		for(j=0;j<32;j=j+1) begin: reg_read_A
			assign data_readRegA = dec_res_A[j] ? Q_out[j] : 32'bzzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz_zzzz;
		end
	endgenerate
	

endmodule
