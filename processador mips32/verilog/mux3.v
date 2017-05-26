/***************************************************
 * Modulo: mux3
 * Projeto: mips32
 ***************************************************/
module mux3 #(parameter width)(a, b, c, sel, out);
	input[width-1:0] a, b, c;
	input sel[1:0];
	output[width-1:0] out;

	always @* begin
		case (sel)
	        2'b00    : out = a;
	        2'b01    : out = b;
	        2'b10    : out = c;
	        default : out = a;
	    endcase
    end
endmodule
