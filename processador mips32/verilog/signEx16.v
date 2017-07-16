/***************************************************
 * Modulo: signEx16
 * Projeto: mips32
 * Descrição: Extende o sinal de um numero de 16 para
 * 32 bits.
 ***************************************************/
module signEx16(in, out);
	input[15:0] in;
	output[31:0] out;
			
	assign out = (in[15]==1'b1) ? {16'b1111111111111111, in} : {16'b0000000000000000, in};
endmodule