
`include "Opcode.vh"
`include "ALUop.vh"

module ALU(reset,clkACC,A,B,ALUop,ALUresult, zero, overflow);
	
	input clkACC, reset;
	input[31:0] A, B;
	input[3:0] ALUop;

	output[31:0] ALUresult;
	output zero, overflow;
	
	reg[31:0] ALUresult_reg;
	reg zero_reg, overflow_reg;

	reg[31:0] HI, LO;

	always@(*) begin
		if(reset == 0) begin
			HI = 0;
			LO = 0;
		end
		
		else begin
			case(ALUop)
				`ALU_ADD: 
					ALUresult_reg = $signed(A) + $signed(B);
				
				`ALU_SUB:
					ALUresult_reg = $signed(A) - $signed(B);
				
				`ALU_MFHI: 
					ALUresult_reg = $signed(HI);

				`ALU_DIV: begin
					if(!clkACC) begin
									HI = $signed(A) % $signed(B);
											  LO = $signed(A) / $signed(B);
					end		
					ALUresult_reg = 32'bx;
				 end
			
				`ALU_MUL:
					ALUresult_reg = $signed(A) * $signed(B);


				`ALU_SLT: 
					ALUresult_reg = {31'b0, ($signed(A) < $signed(B))};
			
				default: 
					ALUresult_reg = 32'bx;
			endcase

			if(ALUresult_reg == 0)
				zero_reg = 1;
			else
				zero_reg = 0;
			
			if ( ALUresult_reg > 4294967295)
				overflow_reg = 1;
			else
				overflow_reg = 0;
		end
	end
	
	assign ALUresult = ALUresult_reg;
	assign zero = zero_reg; 
	assign overflow = overflow_reg;

endmodule
