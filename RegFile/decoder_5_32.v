module decoder_5_32(out, in);
	input [4:0] in;
	output [31:0] out;
	
	wire [15:0] out_temp;
	
	decoder_4_16 dec(out_temp, in[3:0]);	
	assign out[31:16] = in[4] ? out_temp: 4'h0000;
	assign out[15:0] = in[4] ? 4'h0000 : out_temp;
endmodule 

module decoder_4_16(out, in);
	input [3:0] in;
	output [15:0] out;
	
	wire [7:0] out_temp;
	
	decoder_3_8 dec(out_temp, in[2:0]);	
	assign out[15:8] = in[3] ? out_temp : 2'h00;
	assign out[7:0] = in[3] ? 2'h00 : out_temp;
endmodule

module decoder_3_8(out, in);
	input [2:0] in;
	output [7:0] out;
	
	wire [3:0] out_temp;
	
	decoder_2_4 dec(out_temp, in[1:0]);	
	assign out[7:4] = in[2] ? out_temp : 1'h0;
	assign out[3:0] = in[2] ? 1'h0 : out_temp;	
endmodule

module decoder_2_4(out, in);
	input [1:0] in;
	output [3:0] out;
	
	wire [1:0] out_temp;
	
	decoder_1_2 dec(out_temp, in[0]);
	assign out[3:2] = in[1] ? out_temp : 2'b00;
	assign out[1:0] = in[1] ? 2'b00 : out_temp;
endmodule

module decoder_1_2(out, in);
	input in;
	output [1:0] out;
	
	assign out[1] = in ? 1'b1 : 1'b0;
	assign out[0] = in ? 1'b0 : 1'b1;
endmodule 