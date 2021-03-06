/***************************************************
 * Module: compare
 * Project: mips32
 * Description: Responsavel por fazer comparações para 
 *  tomar ou nao os desvios
 ***************************************************/
module compare (rs, rt, code, isBranch);
	input[31:0] rs, rt;
	input[1:0] code;
	output isBranch;
						//J, JAL, JR       //BNE 						//BEQ
	assign isBranch = ((code==2'b11) | (code==2'b10 & rs != rt) | (code==2'b01 & rs == rt)) ? 1 : 0;
	/*
	always @(*) begin
		case(code)
			2'b00: begin //nenhum
				isBranch = 0;
			end	
			2'b01: begin //beq
				if (rs == rt) begin
					isBranch = 1;
				end else begin
					isBranch = 0;
				end
			end 
			2'b10: begin //bne
				if (rs != rt) begin
					isBranch = 1;
				end else begin
					isBranch = 0;
				end
			end
			2'b11: begin //j, jal, jr
				isBranch = 1;
			end	
					
		endcase
	end*/
endmodule