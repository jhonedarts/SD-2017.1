/***************************************************
 * Module: UnitControl
 * Project: mips32
 * Description: Controla o fluxo dos dados pelo pipeline.
 * Lendo o opcode gera os sinais de controle para modulos 
 * especificos
 ***************************************************/
`include "parameters.v"

module unitControl (opcode, func, controlOut, branchSrc, compareCode);
	input[5:0] opcode, func;
	output [0:`CONTROL_SIZE-1] controlOut;
	output [1:0] branchSrc;
	output [1:0] compareCode;

	reg [0:`CONTROL_SIZE-1] controlReg;
	reg [1:0] branchSrcReg, compareCodeReg;
	//  ID
	// X : branchSrc	imediato + pc+4(0) ou imediato 26 bits(1) ou valor do registrador source(2) - branch address
	// X : compareCode 	codigo usado pra fazer a comparacao de valores pra poder tomar o desvio 
	//					| 00:nenhum, 01:beq, 10:bne, 11:j jal jr  |
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


	always @(opcode or func) begin
		$display("Opcode: %b",opcode);
		case(opcode)			
			`R_TYPE: begin
				if(func == `JR) begin

						controlReg = 8'b00000000; //pode mudar caso o valor saia do pc+4, o 1 indica que habilita escrita no registrador.
						branchSrcReg = 2'b10;      // esse pode mudar se não for salvar em registrador.
						compareCodeReg = 2'b11;
				end
				// outras instruçoes do tipo R
				else begin

						controlReg = 8'b00100001;
						branchSrcReg = 2'b00;
						compareCodeReg = 2'b00;		

				end
			end
			`J: begin
				controlReg = 8'b00000000; // considerei que sai do pc+4 e que não tem registrador de destino por isso coloquei 11 que não é nenhum.
				branchSrcReg = 2'b01;
				compareCodeReg = 2'b11;
			end

			`ADDI: begin 
				controlReg = 8'b00100010;
				branchSrcReg = 2'b00;
				compareCodeReg = 2'b00;
			end	

			`ANDI: begin 
				controlReg = 8'b00100010;
				branchSrcReg = 2'b00;
				compareCodeReg = 2'b00;
			end
			`ORI: begin
				controlReg = 8'b00100010;
				branchSrcReg = 2'b00;
				compareCodeReg = 2'b00;
			end
			
			`SLTI: begin
				controlReg = 8'b00100010;
				branchSrcReg = 2'b00;
				compareCodeReg = 2'b00;
			end
			
			`BEQ: begin
				controlReg = 8'b00000000;
				branchSrcReg = 2'b00;
				compareCodeReg = 2'b01;
			end
			
			`BNE: begin
				controlReg = 8'b00000000;
				branchSrcReg = 2'b00;
				compareCodeReg = 2'b10;		
			end	
			`JAL: begin
				controlReg = 8'b10100100;
				branchSrcReg = 2'b01;
				compareCodeReg = 2'b11;
			end

			`LW: begin
				controlReg = 8'b01101010;
				branchSrcReg = 2'b00;
				compareCodeReg = 2'b00;
			end	

			`SW: begin
				controlReg = 8'b00010000;
				branchSrcReg = 2'b00;
				compareCodeReg = 2'b00;
			end	
			default: begin //impedancia
				controlReg = 8'b00000000;
				branchSrcReg = 2'b00;
				compareCodeReg = 2'b00;
			end

		endcase
		
	end//always
	assign controlOut = controlReg;
	assign branchSrc = branchSrcReg;
	assign compareCode = compareCodeReg;
endmodule