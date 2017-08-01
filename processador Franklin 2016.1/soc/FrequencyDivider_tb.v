
module FrequencyDivider_tb;
	reg clk;
	wire dividedClk;
	
	FrequencyDivider fd(reset,clk,dividedClk);

	initial 
		clk = 0;
	
	
	always 
		#100 clk = !clk;
	
endmodule