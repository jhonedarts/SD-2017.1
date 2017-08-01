// Universidade Estadual de Feira de Santana 
// TEC499 - MI - Sistemas Digitais
// Lab 3, 2016.1
//
// Module: ALUdecoder
// Desc:   Sets the ALU operation
// Inputs: 
// 	opcode: the top 6 bits of the instruction
//    funct: the funct, in the case of r-type instructions
// Outputs: 
// 	ALUop: Selects the ALU's operation

`include "Opcode.vh"
`include "ALUop.vh"

module ALUdec(
  input [5:0] funct, opcode,
  output reg [3:0] ALUop
);

    // Implement your ALU decoder here, then delete this comment
	if(opcode == `RTYPE)
	begin
		  case(funct)
			`ADD:
				ALUop = ALU_ADD;
			`DIV:
				ALUop = ALU_DIV;
			`MUL:
				ALUop = ALU_MUL;
			`SUB:
				ALUop = ALU_SUB;
			`MFHI:
				ALUop = ALU_MFHI;
			default:
				ALUop = ALU_XXX;
		  endcase
	/*else
			case(opcode)
				`ADDIU:
					ALUop = ALU_ADDU;
				`SLTI:
					ALUop = ALU_SLT;
				`SLTIU:
					ALUop = ALU_SLTU;
				`ANDI:
					ALUop = ALU_AND;
				`ORI:
					ALUop = ALU_OR;
				`XORI:
					ALUop = ALU_XOR;
				`LUI:
					ALUop = ALU_LUI;
			endcase*/
			
	end
	
	
endmodule
