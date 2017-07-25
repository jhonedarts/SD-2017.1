`include "Opcode.vh"
`include "ALUop.vh"

module ALUdec(funct, opcode, ALUop);

  	input [5:0] funct, opcode;
  	output [3:0] ALUop;
	reg [3:0] ALUop_reg;

	always@(*) begin
		if(opcode == `RTYPE1) begin
			  case(funct)
				`ADD:
					ALUop_reg = `ALU_ADD;
				`SUB:
					ALUop_reg = `ALU_SUB;
				`DIV:
					ALUop_reg = `ALU_DIV;
				`MFHI:
					ALUop_reg = `ALU_MFHI;
				`SLT:
					ALUop_reg = `ALU_SLT;
				`JR:
					ALUop_reg = `ALU_ADD;
				default:
					ALUop_reg = `ALU_XXX;
			  endcase			
		end

		else if(opcode == `RTYPE2) begin
			  
			case(funct)
				`MUL:
					ALUop_reg = `ALU_MUL;
				default:
					ALUop_reg = `ALU_XXX;
			endcase			
		end

		else begin
			case(opcode)
				`ADDI:
					ALUop_reg = `ALU_ADD;
				`SLTI:
					ALUop_reg = `ALU_SLT;
				`LW:
					ALUop_reg = `ALU_ADD;
				`SW:
					ALUop_reg = `ALU_ADD;
				default:
					ALUop_reg = `ALU_XXX;
			  endcase	
		end
		
	end
	assign ALUop = ALUop_reg;
	
endmodule
