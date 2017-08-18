/***************************************************
 * Modulo: IF_ID
 * Projeto: mips32
 * Descrição: Registradores de pipeline
 ***************************************************/
module IF_ID(rst, clk, pcIn, instIn, pcOut, instOut);
	input rst, clk;
	input[31:0] pcIn, instIn;
	output[31:0] pcOut, instOut;

	reg[31:0] pc, inst;	
	
	always @(posedge clk or posedge rst) begin
	//$display("[IF_ID] Pc: %d Inst: %h", pcIn, instIn);
		if (rst) begin
			pc <= 0;	
			inst <= 0;		
		end else begin
			pc <= pcIn;
			inst <= instIn;
		end
	end
	assign pcOut = pc;	
	assign instOut = inst;


endmodule