/*************************************************************
 * Module: ula
 * Project: mips32
 * Description: Só pra compilar o top
 ************************************************************/
module alu(a,b, sel, flagZero, result);
	input[31:0] a, b;
	input[5:0] sel;
	output flagZero;
	output[31:0] result;

endmodule