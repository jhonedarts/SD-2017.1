/***************************************************
 * Modulo: IF_ID
 * Projeto: mips32
 * Descrição: Registradores de pipeline
 ***************************************************/
module IF_ID(rst, clk, pcIn, instIn, pcOut, pc2Out, instOut);
	input rst, clk;
	input[31:0] pcIn, instIn;
	output[31:0] pcOut, pc2Out, instOut;

	reg[31:0] pc, inst;
	reg[31:0] pc2 = 0;
	reg[31:0] pc2reg = 0;	
	
	always @(posedge clk or posedge rst) begin
	//$display("[IF_ID] nextpc: %d Inst: %b rst %b", pcIn, instIn, rst);
		if (rst) begin
			pc <= 0;	
			inst <= 0;
			pc2 <=pc2reg;		
		end else begin
			pc2reg <= pc;
			pc2 <= pcIn;
			pc <= pcIn;
			inst <= instIn;
		end
	end
	assign pc2Out = pc2;
	assign pcOut = pc;	
	assign instOut = inst;


endmodule