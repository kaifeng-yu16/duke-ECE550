module Adder32(A, B, c_in, Sum, Ovf); //It is a CSA
	input [31:0] A;
	input [31:0] B;
	input [4:0] c_in;
	output [31:0] Sum;
	output Ovf;
	
	wire select;
	wire [7:0] select0;
	wire [7:0] select1;
	wire cout0, cout1;
	wire Cout, Cin; // for last bit
	wire tmp1, tmp2, tmp3, tmp4;
	
	CSA16 adder1(A[15:0], B[15:0], c_in[0], Sum[15:0], select);
	CSA16 adder2(A[31:16], B[31:16], 0, select0, cout0);
	CSA16 adder3(A[31:16], B[31:16], 1, select1, cout1);
	
	assign Cout = select? cout1 : cout0;
	assign Sum[31:16] = select? select1 : select0; 
	
	// Compute Ovf using CI != CO
	// first compute Cin for last bit using A[30] B[30] Sum[30]
	// Cin = (A[30] and B[30]) or ((A[30] xor B[30]) and not Sum[30])
	and and1(tmp1, A[30], B[30]);
	xor xor1(tmp2, A[30], B[30]);
	not not1(tmp3, Sum[30]);
	and and2(tmp4, tmp3, tmp2);
	or or1(Cin, tmp4, tmp1);
	
	//next coutpute if CI == CO
	xor xor2(Ovf, Cin, Cout);
	
endmodule

module CSA16(A, B, Cin, Sum, Cout);
	input [15:0] A;
	input [15:0] B;
	input Cin;
	output [15:0]Sum;
	output Cout;
	
	wire select;
	wire [7:0] select0;
	wire [7:0] select1;
	wire cout0, cout1;
	
	CSA8 adder1(A[7:0], B[7:0], Cin, Sum[7:0], select);
	CSA8 adder2(A[15:8], B[15:8], 0, select0, cout0);
	CSA8 adder3(A[15:8], B[15:8], 1, select1, cout1);
	
	assign Cout = select? cout1 : cout0;
	assign Sum[15:8] = select? select1 : select0; 
	 
endmodule
	
	
module CSA8(A, B, Cin, Sum, Cout);
	input [7:0] A;
	input [7:0] B;
	input Cin;
	output [7:0]Sum;
	output Cout;
	 
	wire select;
	wire [3:0] select0;
	wire [3:0] select1;
	wire cout0, cout1;
	
	RCA4 adder1(A[3:0], B[3:0], Cin, Sum[3:0], select);
	RCA4 adder2(A[7:4], B[7:4], 0, select0, cout0);
	RCA4 adder3(A[7:4], B[7:4], 1, select1, cout1);
	
	assign Cout = select? cout1 : cout0;
	assign Sum[7:4] = select? select1 : select0; 
	
endmodule 


module RCA4(A, B, Cin, Sum, Cout);
	input [3:0] A;
	input [3:0] B;
	input Cin;
	output [3:0]Sum;
	output Cout;
	
	wire temp_cout[2:0];
	
	full_adder fa1(A[0], B[0], Cin, Sum[0], temp_cout[0]);
	full_adder fa2(A[1], B[1], temp_cout[0], Sum[1], temp_cout[1]);
	full_adder fa3(A[2], B[2], temp_cout[1], Sum[2], temp_cout[2]);
	full_adder fa4(A[3], B[3], temp_cout[2], Sum[3], Cout);
	 
endmodule 


module full_adder(a, b, Cin, Sum, Cout);
	input a, b, Cin;
	output Cout, Sum;
	wire temp1, temp2, temp3;
	xor xor1(temp1, a, b);
	xor xor2(Sum, temp1, Cin);
	and and1(temp2, Cin, temp1);
	and and2(temp3, a, b);
	or or1(Cout, temp2, temp3);
endmodule