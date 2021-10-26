module div_4(clk_4, clk, reset);

	input clk, reset;
	output reg clk_4;

	reg cnt;

	always @ (posedge clk or posedge reset)
	begin
		if (reset)
		begin
			clk_4 <= 1'b0;
			cnt <= 1'b0;
		end
		else 
		begin
			if (cnt == 1'b1) 
			begin
				cnt <= 1'b0;
				clk_4 <= ~clk_4;
			end
			else 
				cnt <= cnt + 1'b1;
		end
	end
endmodule 