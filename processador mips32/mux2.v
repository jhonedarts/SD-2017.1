/***************************************************
 * Modulo: mux2
 * Projeto: mips32
 ***************************************************/
module mux2#(parameter width)(a, b, sel, out);
	input[31:0] a, b;
	input sel;
	output[31:0] out;
	
	assign out = (Sel) ? b : a;
endmodule
