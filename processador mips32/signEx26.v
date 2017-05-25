/***************************************************
 * Modulo: signEx26
 * Projeto: mips32
 * Descrição: Extende o sinal de um numero de 26 para
 * 32 bits.
 ***************************************************/
 module signEx26(in, out);
		input[25:0] in;
		output[31:0] out;
		reg[31:0] out;
		
		always @(in)
		begin
			if(in[25] == 1'b0) begin
				out <= 16'b000000 + in;
			end
			else begin
				out <= 16'b111111 + in; 
			end
			
		end
endmodule