/***************************************************
 * Modulo: ID_EX
 * Projeto: mips32
 * Descrição: Registradores de pipeline
 ***************************************************/
module ID_EX(rst, clk, opcodeIn, controlIn, pcIn, rsValueIn, rtValueIn, offset16In, offset26In, rsIn, rtIn, rdIn, 
	opcodeOut, controlOut, pcOut, rsValueOut, rtValueOut, offset16Out, offset26Out, rsOut, rtOut, rdOut);
	input rst, clk;
	input[5:0] opcodeIn;
	input[`CONTROL_SIZE-1:0] controlIn;
	input[31:0] pcIn, rsValueIn, rtValueIn, offset16In, offset26In;
	input[4:0] rsIn, rtIn, rdIn;
	output[5:0] opcodeOut;
	output[`CONTROL_SIZE-1:0] controlOut;
	output[31:0] pcOut, rsValueOut, rtValueOut, offset16Out, offset26Out;
	output[4:0] rsOut, rtOut, rdOut;	

	reg[5:0] opcode;
	reg[`CONTROL_SIZE-1:0] control; //ex, mem e wb
	reg[31:0] pc, rsValue, rtValue, offset16, offset26;
	reg[4:0] rs, rt, rd;

	assign opcodeOut = opcode;
	assign controlOut = control;
	assign pcOut = pc;	
	assign rsValueOut = rsValue;
	assign rtValueOut = rtValue;
	assign offset16Out = offset16;
	assign offset26Out = offset26;
	assign rsOut = rs;
	assign rtOut = rt;
	assign rdOut = rd;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			opcode <= 0;
			control <= 0;
			pc <= 0;
			rsValue <= 0;
			rtValue <= 0;
			offset16 <= 0;
			offset26 <= 0;
			rs <= 0;
			rt <= 0;
			rd <= 0;
		end else begin
			opcode <= opcodeIn;
			control <= controlIn;
			pc <= pcIn;
			rsValue <= rsValueIn;
			rtValue <= rtValueIn;
			offset16 <= offset16In;
			offset26 <= offset26In;
			rs <= rsIn;
			rt <= rtIn;
			rd <= rdIn;
		end
	end


endmodule