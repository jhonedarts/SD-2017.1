/*************************************************************
 * Module: ulaControl
 * Project: mips32
 * Description: Gera os codigo de operação pra Alu
 ************************************************************/
 
`include "parameters.v"

module aluControl (opcode, funct, aluOp);
	input [5:0] opcode, funct;
  	output [3:0] aluOp;

  	reg [3:0] aluOpReg;

    always@(*) begin     	
    	case(opcode) 

    		`R_TYPE: begin    			
    			case(funct) 
    				`SLL:     	aluOpReg = `ALU_SLLV;
					`SRL:     	aluOpReg = `ALU_SRLV;
					`SRA:		aluOpReg = `ALU_SRAV;
					`SLLV:		aluOpReg = `ALU_SLLV;
					`SRLV:    	aluOpReg = `ALU_SRLV;
					`SRAV:    	aluOpReg = `ALU_SRAV;
					`ADDU, `ADD:aluOpReg = `ALU_ADDU;
					`SUBU:    	aluOpReg = `ALU_SUBU;
					`AND:     	aluOpReg = `ALU_AND;
					`OR:     	aluOpReg = `ALU_OR;
					`XOR:     	aluOpReg = `ALU_XOR;
					`NOR:     	aluOpReg = `ALU_NOR;
					`SLT:     	aluOpReg = `ALU_SLT;
					`SLTU:  	aluOpReg = `ALU_SLTU;
					default: 	aluOpReg = `ALU_XXX;					
    			endcase
    		end
    		`LB,`LH,`LW,`LBU,`LHU,`SB,`SH,`SW: aluOpReg = `ALU_ADDU;
    		`ADDIU, `ADDI: aluOpReg = `ALU_ADDU;
    		`SLTI: aluOpReg = `ALU_SLT;
			`SLTIU: aluOpReg = `ALU_SLTU;
			`ANDI: aluOpReg = `ALU_AND;
			`ORI: aluOpReg = `ALU_OR;
			`XORI: aluOpReg = `ALU_XOR;
			`LUI: aluOpReg = `ALU_LUI;
			default: aluOpReg = `ALU_XXX;    		
    	endcase 
    end//always
    assign aluOp = aluOpReg;
endmodule