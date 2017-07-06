/***************************************************
 * Module: compare
 * Project: mips32
 * Description: Responsavel por fazer comparações para 
 *  tomar ou nao os desvios
 ***************************************************/
module compare (rs, rt, code, isBranch);
	input[4:0] rs, rt;
	input[2:0] code;
	output isBranch;

	always @(*) begin
		case(opcode)
			3'b000: begin //nenhum
				isBranch = 0;
			end	
			3'b001: begin //beq
				if (rs == rt) begin
					isBranch = 1;
				end else begin
					isBranch = 0;
				end
			end 
			3'b010: begin //bne
				if (rs != rt) begin
					isBranch = 1;
				end else begin
					isBranch = 0;
				end
			end
			3'b011: begin //bgt
				if (rs > rt) begin
					isBranch = 1;
				end else begin
					isBranch = 0;
				end
			end
			3'b100: begin //ble
				if (rs < rt) begin
					isBranch = 1;
				end else begin
					isBranch = 0;
				end
			end
			3'b101: begin //j, jal, jr
				isBranch = 1;
			end	
					
		endcase
	end
endmodule