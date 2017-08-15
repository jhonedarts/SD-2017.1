// Universidade Estadual de Feira de Santana 
// TEC499 - MI - Sistemas Digitais
// Lab 3, 2016.1
//
// Module: ALUdecoder
// Desc:   Sets the ALU operation
// Inputs: 
// 	opcode: the top 6 bits of the instruction
//    funct: the funct, in the case of r-type instructions
// Outputs: 
// 	ALUop: Selects the ALU's operation

`include "Opcode.vh"
`include "ALUop.vh"

module ALUdec(
  input [5:0] funct, opcode,
  output reg [3:0] ALUop
);

    // Implement your ALU decoder here, then delete this comment

    always @(*) begin
      case(opcode)
        `RTYPE: begin
          case(funct)
            `SLL: ALUop = `ALU_SLL;
            `SRL:  ALUop = `ALU_SRL;
            `SRA:  ALUop = `ALU_SRA;
            `SLLV: ALUop = `ALU_SLL;
            `SRLV: ALUop = `ALU_SRL;
            `SRAV: ALUop = `ALU_SRA;
            `ADDU: ALUop = `ALU_ADDU;
            `SUBU: ALUop = `ALU_SUBU;
            `AND:  ALUop = `ALU_AND;
            `OR:   ALUop = `ALU_OR;
            `XOR:  ALUop = `ALU_XOR;
            `NOR:  ALUop = `ALU_NOR;
            `SLT:  ALUop = `ALU_SLT;
            `SLTU: ALUop = `ALU_SLTU;
          endcase
        end

        `LB: ALUop = `ALU_ADDU;
        `LBU: ALUop = `ALU_ADDU;
        `LH: ALUop = `ALU_ADDU;
        `LHU: ALUop = `ALU_ADDU;
        `LW: ALUop = `ALU_ADDU;
        `SB: ALUop = `ALU_ADDU;
        `SH: ALUop = `ALU_ADDU;
        `SW: ALUop = `ALU_ADDU;

        `LUI: ALUop = `ALU_LUI;
        `ADDIU: ALUop = `ALU_ADDU;
        `ORI: ALUop = `ALU_OR;
        `ANDI: ALUop = `ALU_AND;
        `XORI: ALUop = `ALU_XOR;
        `SLTI: ALUop = `ALU_SLT;
        `SLTIU: ALUop = `ALU_SLTU;
      endcase
    end
endmodule
