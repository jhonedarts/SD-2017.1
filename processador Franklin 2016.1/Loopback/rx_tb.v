
module rx_tb;
	reg clk, rx, reset;
	wire dataReady;
	wire[31:0] data;

	initial begin
		clk = 1;
		rx = 1;
		reset = 0;
	end

	Receiver rxd(reset, rx,clk,data,dataReady);
	
	always begin
		#100 clk = !clk;
		if($time >= 200)
			reset = 1;
		if($time >= 500)
			rx = 0;
		
	end
endmodule