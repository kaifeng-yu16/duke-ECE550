module SLL(A, amt, Sum);
	input [31:0] A;
	input [4:0] amt;
	output [31:0] Sum;
	
	wire [31:0] layer0, layer1, layer2, layer3;
	//layer0  <<1
	generate
		genvar i;
		for(i=31;i>0;i=i-1) begin: loop_0
			assign layer0[i] = amt[0]? A[i - 1]: A[i];
		end
	endgenerate
	assign layer0[0] = amt[0]? 1'b0: A[0];
	
	//layer1  <<2
	generate
		//genvar i;
		for(i=31;i>1;i=i-1) begin: loop_1
			assign layer1[i] = amt[1]? layer0[i - 2]: layer0[i];
		end
	endgenerate
	assign layer1[1] = amt[1]? 1'b0: layer0[1];
	assign layer1[0] = amt[1]? 1'b0: layer0[0];
	
	//layer2  <<4
	generate
		//genvar i;
		for(i=31;i>3;i=i-1) begin: loop_2i
			assign layer2[i] = amt[2]? layer1[i - 4]: layer1[i];
		end
	endgenerate
	generate
		genvar j;
		for(j=3;j>=0;j=j-1) begin: loop_2j
			assign layer2[j] = amt[2]? 1'b0: layer1[j];
		end
	endgenerate
	
	//layer3  <<8
	generate
		//genvar i;
		for(i=31;i>7;i=i-1) begin: loop_3i
			assign layer3[i] = amt[3]? layer2[i - 8]: layer2[i];
		end
	endgenerate
	generate
		//genvar j;
		for(j=7;j>=0;j=j-1) begin: loop_3j
			assign layer3[j] = amt[3]? 1'b0: layer2[j];
		end
	endgenerate
	
	//layer4  <<16
	generate
		//genvar i;
		for(i=31;i>15;i=i-1) begin: loop_4i
			assign Sum[i] = amt[4]? layer3[i - 16]: layer3[i];
		end
	endgenerate
	generate
		//genvar j;
		for(j=15;j>=0;j=j-1) begin: loop_4j
			assign Sum[j] = amt[4]? 1'b0: layer3[j];
		end
	endgenerate
	
	
endmodule 
