/***************************************************
 * Modulo: MEM_WB
 * Projeto: mips32
 * Descrição: Registradores de pipeline
 ***************************************************/
module MEM_WB(rst, clk, controlIn, pcIn, memDataIn, aluResultIn, destRegIn, controlOut, pcOut, memDataOut, aluResultOut, destRegOut);
	input rst, clk;
	input[0:2] controlIn;
	input[4:0] destRegIn;
	input[31:0] pcIn, memDataIn, aluResultIn;
	output[0:2] controlOut;
	output[4:0] destRegOut;
	output[31:0] pcOut, memDataOut, aluResultOut;

	reg[0:2] control;//wb
	reg[4:0] destReg; 
	reg[31:0] pc, memData, aluResult;


	assign controlOut = control;
	assign pcOut = pc;
	assign destRegOut = destReg;
	assign memDataOut = memData;	
	assign aluResultOut = aluResult;

	always @(posedge clk or posedge rst) begin
	$display("[MEM_WB] control: %b pc: %h memData: %d aluResult: %h destReg: %d", controlIn, pcIn, memDataIn, aluResultIn, destRegIn);
		if (rst) begin
			control <= 0;
			pc <= 0;
			memData <= 0;
			aluResult <= 0;
			destReg <= 0;
		end else begin
			control <= controlIn;
			pc = pcIn;
			memData <= memDataIn;
			aluResult <= aluResultIn;
			destReg <= destRegIn;
		end
	end


endmodule