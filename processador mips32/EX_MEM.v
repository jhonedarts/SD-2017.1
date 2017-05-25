/***************************************************
 * Modulo: EX_MEM
 * Projeto: mips32
 * Descrição: Registradores de pipeline
 ***************************************************/
module EX_MEM(rst, clk, flagZeroIn, controlIn, branchAddressIn, aluResultIn, rtValueIn, destRegIn, flagZeroOut, controlOut, 
	branchAddressOut, rtValueOut destRegOut);
	input rst, clk, flagZeroIn;
	input[4:0] controlIn, destRegIn;
	input[31:0] branchAddressIn, aluResultIn, rtValueIn;
	output flagZeroOut;
	output[4:0] controlOut, destRegOut;
	output[31:0] branchAddressOut, aluResultOut, rtValueOut;

	reg flagZero;
	reg[4:0] control, destReg; //mem e wb
	reg[31:0] branchAddress, aluResult, rtValue;

	assign flagZeroOut = flagZero;
	assign controlOut = control;
	assign branchAddressOut = branchAddress;	
	assign aluResultOut = aluResult;
	assign rtValueOut = rtValue;
	assign destRegOut = destReg;

	always @(posedge clk or posedge rst) begin
		if (reset) begin
			flagZero = 0;
			control = 0;
			branchAddress = 0;
			aluResult = 0;
			rtValue = 0;
			destReg = 0;
		end else begin
			flagZero = flagZeroIn;
			control = controlIn;
			branchAddress = branchAddressIn;
			aluResult = aluResultIn;
			rtValue = rtValueIn;
			destReg = destRegIn;
		end
	end


endmodule