/***************************************************
 * Module: shiftLeft
 * Project: mips32
 * Description: Desloca 2 bits a esquerda (operação lógica)
 ***************************************************/
module shiftLeft(in, out);
	input[31:0] in;
	output[31:0] out;
	
	assign out = in << 2 ;
endmodule