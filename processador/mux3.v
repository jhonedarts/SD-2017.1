/***************************************************
 * Modulo: mux3_1
 * Projeto: mips32
 ***************************************************/
module mux3_1(a, b, c, sel, out);
	input[31:0] a, b, c;
	input sel[1:0];
	output[31:0] out;

	always @* begin
		case (sel)
	        2'b00    : out = a;
	        2'b01    : out = b;
	        2'b10    : out = c;
	        default : out = a;
	    endcase
    end
endmodule
