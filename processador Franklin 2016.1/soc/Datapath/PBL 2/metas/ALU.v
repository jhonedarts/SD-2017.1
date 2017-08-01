// Universidade Estadual de Feira de Santana 
// TEC499 - MI - Sistemas Digitais
// Lab 3, 2016.1
//
// Module: ALU.v
// Desc:   32-bit ALU for the MIPS150 Processor
// Inputs: 
// 	A: 32-bit value
// 	B: 32-bit value
// 	ALUop: Selects the ALU's operation 
// 						
// Outputs:
// 	Out: The chosen function mapped to A and B.

`include "Opcode.vh"
`include "ALUop.vh"

module ALU(
    input [31:0] A,B,
    input [3:0] ALUop,
    output wire [31:0] Out
	output reg zero, overflow
);

    // Implement your ALU here, then delete this comment

always@(ALUop)
	begin
		case(ALUop)
		`ALU_ADD: 
		Out = A + B;
		
		`ALU_DIV: 
		Out = 32'bxx;
        HI = A / B;
        LO = A % B;
		
		`ALU_MUL: 
		Out = A * B;
		
		`ALU_SUB: 
		Out = A < B;
		
		`ALU_MFHI: 
		Out = HI;
		
		`ALU_XXX: 
		Out = 32'b0;
		endcase
		
		if( Out = 0)
		begin
			zero = 1;
		else
			zero = 0;
		end;
		
		if ( Out > 4.294.967.295)
		begin
			overflow = 1;
		else
			overflow = 0;
		end
		
endmodule
