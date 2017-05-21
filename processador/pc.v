/***************************************************
 * Module: PC
 * Project: mips32
 * Description: Guarda o proximo endereco e poe o atual
 * na saida.
 ***************************************************/
module PC(enable, proxEndereco, out);
	//enable input
	input enable;
	input[31:0] data_in;	
	output[31:0] out;

	reg[31:0] PC;	
	assign out = PC;

	always @ (*) begin
		case(proxEndereco)
			32'bxx: PC = 0;
			default: begin
				if(enable)
					PC = proxEndereco;
			end
		endcase
	end
	
endmodule