module IDEX(clk,PCplus,WB,M,EX,Data1,Data2,imm,Rs,Rt,Rd,PCplus_out,WB_out,M_out,EX_out,Data1_out,
Data2_out,imm_out,Rs_out,Rt_out,Rd_out);

	//Clock
 	input clk;
	//Micro commands input
	input [2:0] WB;
 	input [2:0] M;
 	input [7:0] EX;
	//Registers input
 	input [4:0] Rs,Rt,Rd;
	//Data input
 	input [31:0] Data1,Data2,imm,PCplus;
	
	//Micro commands output
 	output [2:0] WB_out;
 	output [2:0] M_out;
 	output [7:0] EX_out;
	//Micro commands output
 	output [4:0] Rs_out,Rt_out,Rd_out;
	//Data output
 	output [31:0] Data1_out,Data2_out,imm_out,PCplus_out;
	
	//Registers
 	reg [2:0] WB_reg;
 	reg [2:0] M_reg;
 	reg [7:0] EX_reg;
 	reg [31:0] Data1_reg,Data2_reg,imm_reg, PCplus_reg;
 	reg [4:0] Rs_reg,Rt_reg,Rd_reg;
	
	//Change values on ascendant board
 	always@(posedge clk) begin
	 	 WB_reg <= WB;
		 M_reg <= M;
		 EX_reg <= EX;
		 Data1_reg <= Data1;
		 Data2_reg <= Data2;
		 imm_reg <= imm;
		 Rs_reg <= Rs;
		 Rt_reg <= Rt;
		 Rd_reg <= Rd;
		 PCplus_reg <= PCplus;
 	end

	assign WB_out = WB_reg;
	assign M_out = M_reg;
	assign EX_out = EX_reg;
	assign Rs_out = Rs_reg;
	assign Rt_out = Rt_reg;
	assign Rd_out = Rd_reg;
	assign Data1_out = Data1_reg;
	assign Data2_out = Data2_reg;
	assign imm_out = imm_reg;
	assign PCplus_out = PCplus_reg;
endmodule