/***************************************************
 * Module: PC
 * Project: mips32
 * Description: Guarda o proximo endereco e poe o atual
 * na saida.
 ***************************************************/
module PC(enable, nextpc, out);
	//enable input
	input enable;
	input[31:0] nextpc;	
	output[31:0] out;

	reg[31:0] PC;
	reg[31:0] prevPC;
	assign out = PC;

	always @ (*) begin
		case(nextpc)
			32'bxx: PC = 0;
			default: begin
				if(enable) begin
					prevPC = PC;
					PC = nextpc;
				end else begin
					PC = prevPC;
				end
			end
		endcase
	end
	
endmodule