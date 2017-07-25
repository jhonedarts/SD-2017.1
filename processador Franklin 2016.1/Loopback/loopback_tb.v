module loopback_tb;
	reg clk, startBit, finish, reset;
	reg[31:0] data_in;
	wire[31:0] data_out;
	wire tx, dataReady, busy;

	initial begin
		data_in = 4294967295;
		clk = 0;
		finish = 0;
		startBit = 1;
		reset = 0;
	end

	Transmitter txd(reset, startBit,data_in,clk,busy,tx);
	Receiver rxd(reset, tx,clk,data_out,dataReady);
	
	always begin
		#100 clk = !clk;
		if($time >= 200)
			reset = 1;
		if(busy == 0)
			startBit = 0;
		else
			startBit = 1;

		if(finish)
			$finish();
		if($time >= 500)
			startBit = 0;
		if(dataReady == 1'b1) begin
			if(data_out == data_in)
				$monitor("TEST PASSED: sends %h receives %h", data_in, data_out);
			else
				$monitor("TEST FAILED: sends %h receives %h", data_in, data_out);
			finish = 1;
		end
	end
endmodule