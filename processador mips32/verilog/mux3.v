/***************************************************
 * Modulo: mux3
 * Projeto: mips32
 ***************************************************/
module mux3 #(parameter width)(a, b, c, sel, out);
	input[width-1:0] a, b, c;
	input[1:0] sel;
	output[width-1:0] out;

assign out = (a&{width{(~sel[0] & ~sel[1])}}) | (b&{width{(~sel[1] & sel[0])}}) | (c&{width{(sel[1] & ~sel[0])}});
endmodule
