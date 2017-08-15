`timescale 1 ns / 1 ns
module baud_tb;
	reg clk, reset;
	wire baud;
	integer bitsSended;
	
	BaudRate_Generator br(reset,clk, baud);
	initial begin
		reset = 0;
		clk = 0;
		bitsSended = 0;
	end
	
	always begin
		#10 clk = !clk;
		if($time == 20)
			reset = 1;
	end

	always@(posedge baud)
		bitsSended = bitsSended + 1;	
endmodule