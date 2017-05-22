/***************************************************
 * Modulo: IF_ID
 * Projeto: mips32
 * Descrição: Registradores de pipeline
 ***************************************************/
module IF_ID(reset, clock, pcIn, instIn, pcOut, instOut);
	input reset;
	input clock;
	input[31:0] pcIn
	input[31:0] instIn;
	output[31:0] pcOut;
	output[31:0] instOut;

	reg[31:0] pc, isnt;
	assign pcOut = pc;	
	assign instOut = inst;
	
	always @(posedge clock or posedge reset) begin
		if (reset) begin
			pc = 0;	
			inst = 0;		
		end
		pc = pcIn;
		inst = instIn;
	end


endmodule