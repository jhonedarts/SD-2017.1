/***************************************************
 * Module: ControlUnit
 * Project: mips32
 * Description: Controla o fluxo dos dados pelo pipeline.
 * Lendo o opcode gera os sinais de controle para modulos 
 * especificos
 ***************************************************/

module controlUnit (opcode, controlOut, opcodeOut);
	input reg[5:0] opcode;
	output reg [`CONTROL_SIZE-1:0] controlOut;
	output reg[5:0] opcodeOut;
	// X : opcodeOut 	repassa o opcode para ser usado na AluControl	
	//  ID
	// X : isJump		Se for um jump(1) //vai pro hazardDetection pra segurar NOP ate tomar o desvio
	//controlOut :
	//  EX
	// 0 : branchSrc 	imediato + pc+4(0) ou imediato 26 bits(1) ou valor do registrador source(2) - branch address
	// 1 : AluSrc		imediato(0) ou registador(1)
	// 2 : RegDest		resgistrador rt(0) ou rd(1) pra escrita
	//  MEM
	// 3 : MemRead		habilita a leitura na memoria(1)
	// 4 : MemWrite		habilita a escrita na memoria(1)
	// 5 : Branch		indica que é um desvio, branchs ou jumps(1)
	//  WB
	// 6 : RegWrite		habilita a escrita no banco de registradores(1)
	// 7 : MemToReg		valor que sai da ula(0) ou que sai da memoria de dados(1)

	assign opcodeOut = opcode;

	always @(*) begin
		case(opcode)
			6'bx: begin 
				controlOut = 8'b00000000
			end
			`J: begin 
				controlOut = 8'b10000100
			end
		endcase
		
	end
endmodule