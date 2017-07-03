/***************************************************
 * Module: UnitControl
 * Project: mips32
 * Description: Controla o fluxo dos dados pelo pipeline.
 * Lendo o opcode gera os sinais de controle para modulos 
 * especificos
 ***************************************************/
`include "parameters.v"

module unitControl (opcode, controlOut, isJump, branchSrc, compareCode);
	input[5:0] opcode;
	output reg [`CONTROL_SIZE-1:0] controlOut;
	output reg isJump;
	output reg[1:0] branchSrc;
	output reg[2:0] compareCode;
	//  ID
	// X : isJump		Se for um jump(1) //vai pro hazardDetection pra segurar NOP ate tomar o desvio
	// X : branchSrc	imediato + pc+4(0) ou imediato 26 bits(1) ou valor do registrador source(2) - branch address
	// X : compareCode 	codigo usado pra fazer a comparacao de valores pra poder tomar o desvio 
	//					| 000:beq, 001:bne, 010:bgt, 011:ble, 100:j jal jr  |
	//controlOut :
	//  EX	
	// 6 : AluSrc		imediato(0) ou registador(1)
	// 5 : RegDest		resgistrador rt(0) ou rd(1) ou rs(2) pra escrita
	// 4 : RegDest
	//  MEM
	// 3 : MemRead		habilita a leitura na memoria(1)
	// 2 : MemWrite		habilita a escrita na memoria(1)
	//  WB
	// 1 : RegWrite		habilita a escrita no banco de registradores(1)
	// 0 : MemToReg		valor que sai da ula(0) ou que sai da memoria de dados(1)

	always @(*) begin
		case(opcode)
			6'bx: begin 
				controlOut = 8'b00000000;
			end
			`J: begin 
				controlOut = 8'b00100001;
				isJump = 1'b1;
			end
		endcase
		
	end
endmodule