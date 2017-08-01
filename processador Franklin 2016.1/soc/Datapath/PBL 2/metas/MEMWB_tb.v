
module MEMWB_tb;


	reg clk;
	reg [1:0] WB;
	reg [4:0] RegRD;
	reg [31:0] Memout,ALUOut;
	wire [1:0] WBreg;
	wire [31:0] Memreg,ALUreg;
	wire [4:0] RegRDreg;
 

	MEMWB memwb(
		.clk (clk),
		.WB (WB),
		.Memout(Memout),
		.ALUOut(ALUOut),
		.RegRD(RegRD),
		.WBreg(WBreg),
		.Memreg(Memreg),
		.ALUreg(ALUreg),
		.RegRDreg(RegRDreg)
	);
	
	//Initial input values
	initial begin
		clk = 0;
	end
	

	always begin
		#100 clk = !clk;
		WB = 0;
		RegRD = 1;
		Memout = 32;
		ALUOut = 33;
	end
		
	
	//Always shows the values on monitor
	initial
		$monitor("Time = %dps  Clk = %d ", $time, clk);
	
endmodule