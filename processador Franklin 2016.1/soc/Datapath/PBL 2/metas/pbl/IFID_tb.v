
module IFID_tb;
	reg clk, reset, IFIDWrite;
	reg[31:0] PCplus_in, Inst_in;
	wire[31:0] Inst_out, PCplus_out;
	
	IFID ifid(
		.reset (reset),
		.clk (clk),
		.IFIDWrite(IFIDWrite),
		.PCplus_in (PCplus_in),
		.Inst_in (Inst_in),
		.Inst_out (Inst_out),
		.PCplus_out (PCplus_out)
	);
	
	//Initial input values
	initial begin
		clk = 0;
		reset = 0;
		IFIDWrite = 1;
		PCplus_in = 2;
		Inst_in = 11654618;
	end
	

	always begin
		#100 clk = !clk;
		
		if($time > 1000) begin
			IFIDWrite = 0;
			reset = 0;
		end
		else
			#100 reset = !reset;
	end
		
	
	//Always shows the values on monitor
	initial
		$monitor("Time = %dps  IFIDWrite = %d  Reset = %d  Clk = %d  InstReg = %d  PCmais1Reg = %d", $time, IFIDWrite, reset, clk, Inst_out, PCplus_out);
	
endmodule