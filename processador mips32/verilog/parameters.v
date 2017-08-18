/***************************************************
 * Modulo: parametros
 * Projeto: mips32
 * Description: parametros de opcode e controle
 ***************************************************/

`define WORD_SIZE   			32 // Tamanho da instrucao
`define DATA_MEM_ADDR_SIZE		14 // Tamanho da memoria de dados
`define INST_MEM_ADDR_SIZE      10 // Tamanho da memoria de instrucao
`define CONTROL_SIZE 			8 // Tamanho do microcodigo gerado pela UCd
`define WIDTH16_EXT1			16'b1111111111111111
`define WIDTH16_EXT0			16'b0000000000000000
`define WIDTH8_EXT1				8'b11111111
`define WIDTH8_EXT0				8'b00000000

/***************** Interface Serial ****************/
`define CLK_PROCESSOR       25000000 //clock da placa dividido por 2
`define UART0				32'h00000860
`define UART1				32'h00000880
`define BAUDRATE			115200
//Estados da uart
`define STAGE_INTERFACE	2'b00
`define STAGE_START 	2'b01
`define STAGE_WORK 		2'b10
`define STAGE_STOP 		2'b11


/******************** opcode ***********************/
`define NOP 32'h20000000 // addi r0,r0,0 (NOP)
`define R_TYPE  6'h00
`define J 		6'h02
`define JAL     6'h03
`define BEQ     6'h04
`define BNE     6'h05
`define ADDI    6'h08
`define ANDI    6'h0C
`define ORI     6'h0D
`define SLTI    6'h0A

`define LB      6'h20
`define LH      6'h21
`define LW      6'h23
`define LBU     6'h24
`define LHU     6'h25
`define SB      6'h28
`define SH      6'h29
`define SW      6'h2B

`define ADDIU   6'h09
`define SLTIU   6'h0B
`define XORI    6'h0E
`define LUI     6'h0F
/******************* funct *********************/
`define ADD 	6'h20
`define SUB  	6'h22
`define AND  	6'h24
`define OR   	6'h25
`define NOT  	6'h21
`define XOR  	6'h26
`define NOR  	6'h27
`define XNOR 	6'h28
`define NAND 	6'h1B
`define SLT  	6'h2A
`define JR   	6'h08

`define SLL     6'h00
`define SRL     6'h02
`define SRA     6'h03
`define SLLV    6'h04
`define SRLV    6'h06
`define SRAV    6'h07
`define ADDU    6'h21
`define SUBU    6'h23
`define SLTU    6'h2B
/******************* AluCodes *********************/
`define ALU_ADDU 4'd0
`define ALU_SUBU 4'd1
`define ALU_SLT  4'd2
`define ALU_SLTU 4'd3
`define ALU_AND  4'd4
`define ALU_OR   4'd5
`define ALU_XOR  4'd6
`define ALU_LUI  4'd7
`define ALU_SLLV  4'd8
`define ALU_SRLV  4'd9
`define ALU_SRAV  4'd10
`define ALU_NOR  4'd11
`define ALU_XXX  4'd15
