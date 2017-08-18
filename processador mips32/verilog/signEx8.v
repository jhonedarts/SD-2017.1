/***************************************************
 * Modulo: signEx16
 * Projeto: mips32
 * Descrição: Extende o sinal de um numero de 16 para
 * 32 bits.
 ***************************************************/
module signEx8(in, out);
	input[7:0] in;
	output[31:0] out;
			
	assign out = (in[7]==1'b1) ? {24'b111111111111111111111111, in} : {24'b000000000000000000000000, in};
endmodule