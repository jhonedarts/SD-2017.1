/***************************************************
 * Modulo: parametros
 * Projeto: mips32
 * Description: parametros de opcode e controle
 ***************************************************/

`define WORD_SIZE   		32 // Tamanho da instrucao
`define DATA_MEM_SIZE     1024 // Tamanho da memoria de dados
`define INST_MEM_SIZE      512 // Tamanho da memoria de instrucao
`define CONTROL_SIZE 		10 // Tamanho do microcodigo gerado pela UC

/***************** Instrucao NOP *******************/
`define NOP 32'h20000000 // addi r0,r0,0

/**************** Codigo das flags *****************/
`define FL_ZERO     5'b00000
`define FL_TRUE     5'b00001
`define FL_NEG      5'b00010
`define FL_OVERFLOW 5'b00011
`define FL_NEGZERO  5'b00100
`define FL_CARRY    5'b00101

/******************** opcode ***********************/
/* imcompleto... */
`define R_TYPE  6'h00
`define J 		6'h02
`define JAL     6'h03
`define LW  	6'h23
`define SW	    6'h2B
`define BEQ     6'h04
`define BNE     6'h05
`define ADDI    6'h08
`define ANDI    6'h0C
`define ORI     6'h0D
`define SLTI    6'h0A
`define LCL     6'h01
`define LCH     6'h07
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
`define LSL  	6'h00
`define LSR  	6'h02
`define ASL  	6'h04
`define ASR  	6'h03
`define SLT  	6'h2A
`define JR   	6'h08
