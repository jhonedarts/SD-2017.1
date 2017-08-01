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

	reg[31:0] pc;
	reg[31:0] prevPc;
	
	always @(*) begin	
	 $display("[PC] enable: %b, nextpc: %d", enable, nextpc);	
		if (enable) begin
			if (nextpc === 32'bx) begin				
				prevPc = 0;
				pc = 0;				
			end else begin				
				prevPc = pc;
				pc = nextpc;
			end	
			
		end	else begin
			pc = prevPc;
		end
	end

	assign out = pc;
	
endmodule