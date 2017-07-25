module EXMEM(clk,WB,M,ALUOut,RegRD,WriteDataIn,Mreg,WBreg,ALUreg,RegRDreg,WriteDataOut);
 input clk;
 input [1:0] WB;
 input [2:0] M;
 input [4:0] RegRD;
 input [31:0] ALUOut,WriteDataIn;
 output [1:0] WBreg;
 output [2:0] Mreg;
 output [31:0] ALUreg,WriteDataOut;
 output [4:0] RegRDreg;
 reg [1:0] WBreg;
 reg [2:0] Mreg;
 reg [31:0] ALUreg,WriteDataOut;
 reg [4:0] RegRDreg;

 initial begin
 WBreg=0;
 Mreg=0;
 ALUreg=0;
 WriteDataOut=0;
 RegRDreg=0;
 end


 always@(posedge clk)
 begin
 WBreg <= WB;
 Mreg <= M;
 ALUreg <= ALUOut;
 RegRDreg <= RegRD;
 WriteDataOut <= WriteDataIn;
 end
endmodule