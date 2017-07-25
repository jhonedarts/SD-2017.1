
module IDEX_tb;

	reg clk;
	reg [1:0] WB;
	reg [2:0] M;
	reg [3:0] EX;
	reg [4:0] RegRs,RegRt,RegRd;
	reg [31:0] Data1,Data2,imm_value;
	wire[1:0] WBreg;
	wire[2:0] Mreg;
	wire [3:0] EXreg;
	wire [4:0] RegRsreg,RegRtreg,RegRdreg;
	wire [31:0] Data1reg,Data2reg,imm_valuereg;
	
	IDEX idex(
		.clk (clk),
		.WB(WB),
		.M(M),
		.EX(EX),
		.Data1(Data1),
		.Data2(Data2),
		.imm_value(imm_value),
		.RegRs(RegRs),
		.RegRt(RegRt),
		.RegRd(RegRd),
		.WBreg(WBreg),
		.Mreg(Mreg),
		.EXreg(EXreg),
		.Data1reg(Data1reg),
		.Data2reg(Data2reg),
		.imm_valuereg(imm_valuereg),
		.RegRsreg(RegRsreg),
		.RegRtreg(RegRtreg),
		.RegRdreg(RegRdreg)
	);
	
	//Initial input values
	initial begin
		clk = 0;
	end
	

	always begin
		#100 clk = !clk;
		WB = 0;
		M = 2;
		EX = 6;
		RegRs = 4;
		RegRt = 5;
		RegRd = 6;
		Data1 = 7;
		Data2 = 8;
		imm_value = 9;
	end
		
	
	//Always shows the values on monitor
	initial
		$monitor("Time = %dps  Clk = %d  WB = %d  M = %d  EX = %d  RegRs = %d  RegRt = %d  RegRd = %d  Data1 = %d  Data2 = %d  imm_value = %d", $time, clk, WB, M, EX, RegRs, RegRt, RegRd, Data1, Data2, imm_value);
	
endmodule