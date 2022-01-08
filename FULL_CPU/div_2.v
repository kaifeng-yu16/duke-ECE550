module div_2 (clk_2, clk, reset);
	input clk, reset;
	output reg clk_2;
	
	always @ (posedge clk or posedge reset)
	begin
		if (reset)
			clk_2 <= 1'b0;
		else
			clk_2 <= ~clk_2;
	end
endmodule
	