`timescale 1 ns / 1 ns
module SoC_tb;

	//10MHz frequency
	real clockTime = 10;
	reg reset, clk, haltDetected, finished;
	wire[31:0] instruction, memwb_pc;
	wire tx;
	
	SoC CHIP(reset,clk,1'b1,tx,instruction, memwb_pc);

	initial begin
		reset = 0;
		clk = 0;
		haltDetected = 0;
		finished = 0;
	end
	
	always begin 
		#(clockTime) clk = !clk;
		if($time >= 20)begin
			reset = 1;
			if(instruction == -1)
				haltDetected = 1;

			if(haltDetected) begin
				case(memwb_pc)
					32'bx: finished = 1;	
				endcase
			end

			if(finished)
				$finish();
		end
	end

endmodule
