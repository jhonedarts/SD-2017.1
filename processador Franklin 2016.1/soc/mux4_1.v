module mux4_1(A, B, C, D, Sel, out);
	input[31:0] A, B, C, D;
	input[1:0] Sel;
	output[31:0] out;
	assign out = (A&{32{(~Sel[0] & ~Sel[1])}}) | (B&{32{(~Sel[1] & Sel[0])}}) | (C&{32{(Sel[1] & ~Sel[0])}}) | (D&{32{(Sel[1] & Sel[0])}});
endmodule
