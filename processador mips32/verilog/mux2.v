/***************************************************
 * Modulo: mux2
 * Projeto: mips32
 ***************************************************/
module mux2#(parameter width)(a, b, sel, out);
	input[width-1:0] a, b;
	input sel;
	output[width-1:0] out;
	
	assign out = (sel) ? b : a;
endmodule
