/***************************************************
 * Module: PC
 * Project: mips32
 * Description: Guarda o proximo endereco e poe o atual
 * na saida.
 ***************************************************/
module PC(clk, rst, enable, nextpc, out);
	//enable input
	input clk, rst, enable;
	input[31:0] nextpc;	
	output[31:0] out;

	reg[31:0] PC;
	reg[31:0] prevPC;
	assign out = PC;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			// reset
			PC = 0;			
		end
		else begin 
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
	end
	
endmodule