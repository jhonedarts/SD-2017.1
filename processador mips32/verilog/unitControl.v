/***************************************************
 * Module: UnitControl
 * Project: mips32
 * Description: Controla o fluxo dos dados pelo pipeline.
 * Lendo o opcode gera os sinais de controle para modulos 
 * especificos
 ***************************************************/
`include "parameters.v"

module unitControl (opcode, function, controlOut, isJump, branchSrc, compareCode);
	input[5:0] opcode, function;
	output reg [`CONTROL_SIZE-1:0] controlOut;
	output reg isJump;
	output reg[1:0] branchSrc;
	output reg[2:0] compareCode;
	//  ID
	// X : isJump		Se for um jump(1) //vai pro hazardDetection pra segurar NOP ate tomar o desvio
	// X : branchSrc	imediato + pc+4(0) ou imediato 26 bits(1) ou valor do registrador source(2) - branch address
	// X : compareCode 	codigo usado pra fazer a comparacao de valores pra poder tomar o desvio 
	//					| 000:nenhum, 001:beq, 010:bne, 011:bgt, 100:ble, 101:j jal jr  |
	//controlOut :
	//  EX	
	// 7 : AluSrc		imediato(0) ou registador(1)
	// 6 : RegDest		resgistrador rd(0) ou rt(1) ou $ra(2) pra escrita
	// 5 : RegDest
	//  MEM
	// 4 : MemRead		habilita a leitura na memoria(1)
	// 3 : MemWrite		habilita a escrita na memoria(1)
	//  WB
	// 2 : RegWrite		habilita a escrita no banco de registradores(1)
	// 1 : RegSrc
	// 0 : RegSrc		valor que sai da ula(0) ou que sai da memoria de dados(1) ou pc+4(2)

	always @(*) begin
		case(opcode)
			6'bx: begin //impedancia
				controlOut = 7'b00000000;
				isJump = 1'b0;
				branchSrc = 2'b00;
				compareCode = 3'b000;

			end
			`R_TYPE: begin
				case (function)
					`AND: begin
						controlOut = 7'b00100001;
						isJump = 1'b0;
						branchSrc = 2'b00;
						compareCode = 3'b000;
					end
				endcase
			end
			`ANDI: begin 
				controlOut = 7'b00100010;
				isJump = 1'b0;
				branchSrc = 2'b00;
				compareCode = 3'b000;
			end
			`JAL: begin
				controlOut = 7'b10100100;
				isJump = 1'b1;
				branchSrc = 2'b00;
				compareCode = 3'b101
			end
		endcase
		
	end
endmodule