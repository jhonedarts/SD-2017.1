/***************************************************
 * Module: PC2
 * Project: mips32
 * Description: Guarda o proximo endereco e poe o atual
 * na saida.
 ***************************************************/
module pc2(enable, nextpc, out);
	//enable input
	input enable;
	input[31:0] nextpc;	
	output[31:0] out;

	reg[31:0] PC;
	reg[31:0] prevPC;
	assign out = PC;

	always @(*) begin		
		if (enable) begin
			if(nextpc==32'bxx) begin
				PC = 0;
			end else begin
				prevPC = PC;
				PC = nextpc;
			end
		end else begin
			PC = prevPC;
		end		
	end
	
endmodule