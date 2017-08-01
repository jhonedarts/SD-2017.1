module IDEX(clk,WB,M,EX,Data1,Data2,imm_value,RegRs,RegRt,RegRd,WBreg,Mreg,EXreg,Data1reg,
Data2reg,imm_valuereg,RegRsreg,RegRtreg,RegRdreg);

 input clk;
 input [1:0] WB;
 input [2:0] M;
 input [3:0] EX;
 input [4:0] RegRs,RegRt,RegRd;
 input [31:0] Data1,Data2,imm_value;
 output [1:0] WBreg;
 output [2:0] Mreg;
 output [3:0] EXreg;
 output [4:0] RegRsreg,RegRtreg,RegRdreg;
 output [31:0] Data1reg,Data2reg,imm_valuereg;

 reg [1:0] WBreg;
 reg [2:0] Mreg;
 reg [3:0] EXreg;
 reg [31:0] Data1reg,Data2reg,imm_valuereg;
 reg [4:0] RegRsreg,RegRtreg,RegRdreg;

 initial begin
	 WBreg = 0; 
	 Mreg = 0;
	 EXreg = 0;
	 Data1reg = 0;
	 Data2reg = 0;
	 imm_valuereg = 0;
	 RegRsreg = 0;
	 RegRtreg = 0;
	 RegRdreg = 0;
 end

 always@(posedge clk)
 begin
	 WBreg <= WB;
	 Mreg <= M;
	 EXreg <= EX;
	 Data1reg <= Data1;
	 Data2reg <= Data2;
	 imm_valuereg <= imm_value;
	 RegRsreg <= RegRs;
	 RegRtreg <= RegRt;
	 RegRdreg <= RegRd;
 end

endmodule