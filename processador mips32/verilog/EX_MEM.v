/***************************************************
 * Modulo: EX_MEM
 * Projeto: mips32
 * Descrição: Registradores de pipeline
 ***************************************************/
module EX_MEM(rst, clk, controlIn, pcIn, aluResultIn, rtValueIn, destRegIn, controlOut, 
	pcOut, aluResultOut, rtValueOut, destRegOut);

	input rst, clk;
	input[4:0] destRegIn;
	input[0:4] controlIn;
	input[31:0] pcIn, aluResultIn, rtValueIn;
	output[4:0] destRegOut;
	output[0:4] controlOut;
	output[31:0] pcOut, aluResultOut, rtValueOut;

	reg[4:0] destReg; //mem e wb
	reg[0:4] control;
	reg[31:0] pc, aluResult, rtValue;

	assign controlOut = control;
	assign pcOut = pc;
	assign aluResultOut = aluResult;
	assign rtValueOut = rtValue;
	assign destRegOut = destReg;

	always @(posedge clk or posedge rst) begin
	$display("[EX_MEM] Control: %b Pc: %h aluResult: %d rtValue: %d destReg: %d", controlIn, pcIn, aluResultIn, rtValueIn, destRegIn);
		if (rst) begin
			control <= 0;
			pc <= 0;
			aluResult <= 0;
			rtValue <= 0;
			destReg <= 0;
		end else begin
			control <= controlIn;
			pc <= pcIn;
			aluResult <= aluResultIn;
			rtValue <= rtValueIn;
			destReg <= destRegIn;
		end
	end


endmodule