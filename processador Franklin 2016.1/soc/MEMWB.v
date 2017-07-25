module MEMWB(clk,PCplus,WB,MemData,ALUresult,Rd,PCplus_out,WB_out,MemData_out,ALUresult_out,Rd_out);
 	input clk;
 	input [2:0] WB;
 	input [4:0] Rd;
 	input [31:0] MemData,ALUresult,PCplus;

 	output [2:0] WB_out;
 	output [31:0] MemData_out,ALUresult_out,PCplus_out;
 	output [4:0] Rd_out;

 	reg [2:0] WB_reg;
 	reg [31:0] MemData_reg,ALUresult_reg,PCplus_reg;
 	reg [4:0] Rd_reg;

 	always@(posedge clk)begin
 		WB_reg <= WB;
 		MemData_reg <= MemData;
 		ALUresult_reg <= ALUresult;
 		Rd_reg <= Rd;
		PCplus_reg <= PCplus;
 	end

	assign  WB_out = WB_reg;
 	assign  MemData_out = MemData_reg;
	assign  ALUresult_out = ALUresult_reg;
 	assign  Rd_out = Rd_reg;
	assign PCplus_out = PCplus_reg;

endmodule