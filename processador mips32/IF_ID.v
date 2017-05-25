/***************************************************
 * Modulo: IF_ID
 * Projeto: mips32
 * Descrição: Registradores de pipeline
 ***************************************************/
module IF_ID(rst, clk, pcIn, instIn, pcOut, instOut);
	input rst, clk;
	input[31:0] pcIn, instIn, pcOut, instOut;

	reg[31:0] pc, isnt;
	assign pcOut = pc;	
	assign instOut = inst;
	
	always @(posedge clk or posedge rst) begin
		if (reset) begin
			pc <= 0;	
			inst <= 0;		
		end else begin
			pc <= pcIn;
			inst <= instIn;
		end
	end


endmodule