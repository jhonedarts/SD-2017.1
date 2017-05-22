/***************************************************
 * Module: ControlUnit
 * Project: mips32
 * Description: Controla o fluxo dos dados pelo pipeline.
 * Lendo o opcode gera os sinais de controle para modulos 
 * especificos
 ***************************************************/

module controlUnit (opcode, controlOut);
	input reg[5:0] opcode;
	output reg [8:0] controlOut;
	//controlOut :
	// EX
	//0 : AluOP		
	//1 : AluOP
	//2 : AluSrc	1 se for do tipo i
	//3 : RegDest
	// MEM
	//4 : MemRead
	//5 : MemWrite
	//6 : Branch
	// WB
	//7 : RegWrite
	//8 : MemToReg


endmodule