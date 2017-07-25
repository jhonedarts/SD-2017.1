module comparator(A, B, equal, result);
	input[31:0] A, B;
	input equal;
	output result;
	assign result = (equal&(A == B)) | (~equal&(A != B));
endmodule
