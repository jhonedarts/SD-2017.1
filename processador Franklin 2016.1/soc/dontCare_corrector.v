module dontCare_corrector(in, out);
	input[31:0] in;
	output[31:0] out;
	reg[31:0] outReg;
	assign out = outReg;

	initial outReg = 0;

	always @(*) begin
		outReg = 0;
		case(in)
			1'bx: outReg = 0;
			1'bz: outReg = 0;
			default: outReg = in;
		endcase
	end
endmodule
