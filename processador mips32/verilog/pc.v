/***************************************************
 * Module: PC
 * Project: mips32
 * Description: Guarda o proximo endereco e poe o atual
 * na saida.
 ***************************************************/
module pc(enable, nextpc, out);
	//enable input
	input enable;
	input[31:0] nextpc;	
	output[31:0] out;

	reg[31:0] pc;
	reg[31:0] prevPc;

	initial begin
		pc = 0;
	end
	
	always @(*) begin	
	 $display("PC enable: %b, nextpc: %d", enable, nextpc);	
		case(enable)
			1'b0: begin
				pc = prevPc;
			end	
			1'bx: begin
				prevPc = 0;
				pc = 0;
			end			
			default: begin
				prevPc = pc;
				pc = nextpc;
			end
		endcase
	end

	assign out = pc;
	
endmodule