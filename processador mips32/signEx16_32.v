/***************************************************
 * Modulo: signEx16_32
 * Projeto: mips32
 * Descrição: Extende o sinal de um numero de 16 para
 * 32 bits.
 ***************************************************/
module signEx16_32(in, out);
		input[15:0] in;
		output[31:0] out;
		reg[31:0] out;
		
		always @(in)
		begin
			if(in[15] == 1'b0) begin
				out <= 16'b0000000000000000 + in;
			end
			else begin
				out <= 16'b1111111111111111 + in; 
			end
			
		end
endmodule