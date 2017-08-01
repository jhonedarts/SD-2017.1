module mux2_1(A, B, Sel, out);
	input[31:0] A, B;
	input Sel;
	output[31:0] out;
	assign out = (A&{32{~Sel}}) | (B&{32{Sel}});
endmodule
