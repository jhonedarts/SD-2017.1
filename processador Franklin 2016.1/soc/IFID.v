/**
	This code implements the IF/ID pipeline register

*/
module IFID(reset, clk, IFIDWrite, PCplus_in, Inst_in, Inst_out, PCplus_out);
 	
	//Reset, clock and hazard detection control write.
	input reset, clk, IFIDWrite;
	//Next PC and instruction input.
	input[31:0] PCplus_in, Inst_in;
	//Instruction and next PC output
	output[31:0] Inst_out, PCplus_out;
	
	//Instruction and next PC registers
	reg[31:0] Inst_reg, PCplus_reg, unlocked;

	assign Inst_out = Inst_reg;
	assign PCplus_out = PCplus_reg;
	
	always@(posedge clk) begin
		if(reset == 0) 
			unlocked <= 1;
		else begin
			//If a new board
			if(IFIDWrite & unlocked) begin
				if(Inst_in == -1) begin
					Inst_reg <= 32'bx;
					PCplus_reg <= 32'bx;
					unlocked <= 0;
				end
				else begin
					Inst_reg <= Inst_in;
					PCplus_reg <= PCplus_in;
				end
			end
		end
	end

	
endmodule	
