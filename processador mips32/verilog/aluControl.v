/*************************************************************
 * Module: ulaControl
 * Project: mips32
 * Description: Gera os codigo de operação pra Alu
 ************************************************************/
 `include "parameters.v"
 
module aluControl (opcode, funct, aluOp);
	input [5:0] opcode, funct;
  	output reg [3:0] aluOp;

    always@(*) begin     	
    	case(opcode) 

    		`R_TYPE: begin    			
    			case(funct) 
    				`SLL:     	aluOp = `ALU_SLLV;
					`SRL:     	aluOp = `ALU_SRLV;
					`SRA:		aluOp = `ALU_SRAV;
					`SLLV:		aluOp = `ALU_SLLV;
					`SRLV:    	aluOp = `ALU_SRLV;
					`SRAV:    	aluOp = `ALU_SRAV;
					`ADDU:    	aluOp = `ALU_ADDU;
					`SUBU:    	aluOp = `ALU_SUBU;
					`AND:     	aluOp = `ALU_AND;
					`OR:     	aluOp = `ALU_OR;
					`XOR:     	aluOp = `ALU_XOR;
					`NOR:     	aluOp = `ALU_NOR;
					`SLT:     	aluOp = `ALU_SLT;
					`SLTU:  	aluOp = `ALU_SLTU;
					default: aluOp = `ALU_XXX;					
    			endcase
    		end
    		`LB,`LH,`LW,`LBU,`LHU,`SB,`SH,`SW: aluOp = `ALU_ADDU;
    		`ADDIU: aluOp = `ALU_ADDU;
    		`SLTI: aluOp = `ALU_SLT;
			`SLTIU: aluOp = `ALU_SLTU;
			`ANDI: aluOp = `ALU_AND;
			`ORI: aluOp = `ALU_OR;
			`XORI: aluOp = `ALU_XOR;
			`LUI: aluOp = `ALU_LUI;
			default: aluOp = `ALU_XXX;    		
    	endcase 
    end//always
endmodule