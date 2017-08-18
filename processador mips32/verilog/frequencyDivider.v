`include "parameters.v"
module frequencyDivider(
	input clk,
	output dividedClk
);
	
	reg [1:0] stage = `STAGE_START;
	reg clkReg = 0;
	assign dividedClk = clkReg;	

	always @(posedge clk) begin
		case (stage)
			`STAGE_START: begin
				clkReg <= 0;
				stage <= `STAGE_STOP;
			end
			`STAGE_STOP: begin
				clkReg <= 1;
				stage <= `STAGE_START;
			end
			default: begin
				clkReg <= 0;
				stage <= `STAGE_START;
			end
		endcase
	end
endmodule
