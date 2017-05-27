/***************************************************
 * Modulo: MEM_WB
 * Projeto: mips32
 * Descrição: Registradores de pipeline
 ***************************************************/
module MEM_WB(rst, clk, controlIn, memDataIn, aluResultIn, destRegIn, controlOut, memDataOut, aluResultOut, destRegOut);
	input rst, clk;
	input[1:0] controlIn;
	input[4:0]destRegIn;
	input[31:0] memDataIn, aluResultIn;
	output[1:0] controlOut;
	output[4:0] destRegOut;
	output[31:0] memDataOut, aluResultOut;

	reg[1:0] control;//wb
	reg[4:0] destReg; 
	reg[31:0] memData, aluResult;


	assign controlOut = control;
	assign destRegOut = destReg;
	assign memDataOut = memData;	
	assign aluResultOut = aluResult;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			control <= 0;
			memData <= 0;
			aluResult <= 0;
			destReg <= 0;
		end else begin
			control <= controlIn;
			memData <= memDataIn;
			aluResult <= aluResultIn;
			destReg <= destRegIn;
		end
	end


endmodule