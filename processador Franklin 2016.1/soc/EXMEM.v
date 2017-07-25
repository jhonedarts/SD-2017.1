module EXMEM(clk,PCplus,WB,M,ALUresult,Rd,WriteData,PCplus_out,M_out,WB_out,ALUresult_out,Rd_out,WriteData_out);
 
 	input clk;
 	input [2:0] WB;
 	input [2:0] M;
 	input [4:0] Rd;
 	input [31:0] ALUresult,WriteData,PCplus;
	
 	output [2:0] WB_out;
 	output [2:0] M_out;
 	output [31:0] ALUresult_out,WriteData_out,PCplus_out;
 	output [4:0] Rd_out;

 	reg [2:0] WB_reg;
 	reg [2:0] M_reg;
 	reg [31:0] ALUresult_reg,WriteData_reg,PCplus_reg;
 	reg [4:0] Rd_reg;

 	always@(posedge clk) begin
 		WB_reg <= WB;
 		M_reg <= M;
 		ALUresult_reg <= ALUresult;
 		Rd_reg <= Rd;
 		WriteData_reg <= WriteData;
		PCplus_reg <= PCplus;
 	end

	assign  WB_out = WB_reg;
 	assign  M_out = M_reg;
 	assign  ALUresult_out = ALUresult_reg;
	assign  WriteData_out = WriteData_reg;
 	assign  Rd_out = Rd_reg;
	assign PCplus_out = PCplus_reg;
endmodule