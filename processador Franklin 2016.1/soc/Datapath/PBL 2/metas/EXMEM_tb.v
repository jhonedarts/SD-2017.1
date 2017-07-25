
module EXMEM_tb;

	reg clk;
	reg [1:0] WB;
	reg [2:0] M;
	reg [4:0] RegRD;
	reg [31:0] ALUOut,WriteDataIn;
	wire [1:0] WBreg;
	wire [2:0] Mreg;
	wire [31:0] ALUreg,WriteDataOut;
	wire [4:0] RegRDreg;
	
	
	EXMEM exmem(
		.clk (clk),
		.WB (WB),
		.M (M),
		.ALUOut(ALUOut),
		.RegRD(RegRD),
		.WriteDataIn(WriteDataIn),
		.Mreg(Mreg),
		.WBreg(WBreg),
		.ALUreg(ALUreg),
		.RegRDreg(RegRDreg),
		.WriteDataOut(WriteDataOut)
	);
	
	//Initial input values
	initial begin
		clk = 0;
	end
	

	always begin
		#100 clk = !clk;
		WB = 0;
		M = 1;
		ALUOut = 100;
		WriteDataIn = 150;
		RegRD = 5;
		
	end
		
	
	//Always shows the values on monitor
	initial
		$monitor("Time = %dps  Clk = %d WB = %d M = %d  ALUOut = %d  WriteDataIn = %d  RegRD = %d", $time, clk, WB, M, ALUOut, WriteDataIn, RegRD);
	
endmodule