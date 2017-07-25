`ifndef OPCODE
`define OPCODE

// Opcode
`define RTYPE   6'b000000
// Load/store
`define LB      6'b100000
`define LH      6'b100001
`define LW      6'b100011
`define LBU     6'b100100
`define LHU     6'b100101
`define SB      6'b101000
`define SH      6'b101001
`define SW      6'b101011
// I-type
`define ADDIU   6'b001001
`define SLTI    6'b001010
`define SLTIU   6'b001011
`define ANDI    6'b001100
`define ORI     6'b001101
`define XORI    6'b001110
`define LUI     6'b001111 

// Funct (R-type)
`define ADD     6'b000000 //troquei
`define DIV     6'b000010 //troquei
`define MUL     6'b000011 //troquei
`define SUB     6'b000100 //troquei
`define MFHI    6'b000110 //troquei
`define SRAV    6'b000111
`define ADDU    6'b100001
`define SUBU    6'b100011
`define AND     6'b100100
`define OR      6'b100101
`define XOR     6'b100110
`define NOR     6'b100111
`define SLT     6'b101010
`define SLTU    6'b101011

`endif //OPCODE
