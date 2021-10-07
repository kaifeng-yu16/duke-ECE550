module decoder_5_32(out, in);
	input [4:0] in;
	output [31:0] out;
	
	wire [1:0] out1;
	wire [3:0] out2;
	wire [7:0] out3;
	wire [15:0] out4;
	
	assign out1 = in[0] ? 2'b10 : 2'b01;
	assign out2[3:2] = in[1] ? out1 : 2'b00;
	assign out2[1:0] = in[1] ? 2'b00 : out1;
	assign out3[7:4] = in[2] ? out2 : 4'b0000;
	assign out3[3:0] = in[2] ? 4'b0000 : out2;
	assign out4[15:8] = in[3] ? out3 : 8'b00000000;
	assign out4[7:0] = in[3] ? 8'b00000000 : out3;
	assign out[31:16] = in[4] ? out4 : 2'h00;
	assign out[15:0] = in[4] ? 2'h00 : out4;

endmodule 
	