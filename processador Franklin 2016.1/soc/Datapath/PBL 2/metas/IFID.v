module IFID(reset,clk,IFIDWrite,PCplus_in,Inst_in,Inst_out,PCplus_out);
 	input reset, clk, IFIDWrite;
	input[31:0] PCplus_in, Inst_in;
	output[31:0] Inst_out, PCplus_out;
	
	reg[31:0] Inst_reg, PCplus_reg;

	assign Inst_out = Inst_reg;
	assign PCplus_out = PCplus_reg;

	always@(posedge clk or posedge reset) begin
		if(!reset) begin
			if(IFIDWrite == 1) begin
				Inst_reg = Inst_in;
				PCplus_reg = PCplus_in;
			end
		end
		else begin
			Inst_reg = 0;
			PCplus_reg = 0;
		end

	end
endmodule	
