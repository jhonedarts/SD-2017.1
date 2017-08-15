module tx_tb;
	reg clk, startBit, reset;
	reg[31:0] data_in;
	wire tx, busy;

	initial begin
		data_in = 32'd58875532;
		clk = 1;
		startBit = 1;
		reset = 0;
	end

	Transmitter txd(reset,startBit,data_in,clk,busy,tx);
	
	always begin
		#100 clk = !clk;
		if($time >= 200)
			reset = 1;
		if($time == 500)
			startBit = 0;
		if($time == 1000)
			startBit = 1;
		
	end
endmodule