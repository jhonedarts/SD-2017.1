/***************************************************
 * Module: registerFile
 * Project: mips32
 * Description: Banco de registradores contendo os
 * 32 registradores de proposito geral.
 ***************************************************/

module registerFile (clk, rst, rs, rt, rWriteValue, rWriteAddress, regWrite, rsData, rtData);
	input clk, rst, regWrite;
	input [4:0] rs, rt, rWriteAddress;
	input [31:0] rWriteValue;
	output [31:0] rsData, rtData;

	reg [31:0] registers [31:1];
	wire [31:0] rsDatareg, rtDatareg;

	integer i;
	
	initial begin
	    for (i=1; i<32; i=i+1) begin
	        registers[i] <= 0;
	    end
	end
	
	always @ (posedge clk or posedge rst) begin
		if(rst) begin
			 
	        for (i=1; i<32; i=i+1) begin
	            registers[i] <= 0;
	        end
		end else begin
			if(regWrite!=0) begin //escrita
				registers[rWriteAddress] <= rWriteValue;
			end 
		end
	end
	//leitura
	assign rsDatareg = (rs==rWriteAddress)? rWriteValue:registers[rs];
	assign rtDatareg = (rt==rWriteAddress)? rWriteValue:registers[rt];
	assign rsData = (rs == 0) ? 32'h00000000 : rsDatareg;
	assign rtData = (rt == 0) ? 32'h00000000 : rtDatareg;

endmodule
