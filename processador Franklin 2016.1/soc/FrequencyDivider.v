module FrequencyDivider(
	input clk,
	output dividedClk
);
	reg clkReg;
	initial clkReg = 0;
	assign dividedClk = clkReg;
	always@(posedge clk) 
		clkReg <= !clkReg;	
endmodule
