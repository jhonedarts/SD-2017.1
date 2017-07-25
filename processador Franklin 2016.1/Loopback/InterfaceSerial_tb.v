module InterfaceSerial_tb;
	reg reset, clk, control, rx;
	reg [31:0] data_in;
	wire tx;
	wire[31:0] data_out;
	integer i = 10;
	
	InterfaceSerial is(reset,clk,data_in,control,rx,tx,data_out);
	initial begin
		reset = 0;
		clk = 0;
		control = 0;
		rx = 1;
		data_in = 4294967295;
	end

	always begin
		#100 clk = !clk;
		if($time >= 200)
			reset = 1;
		if(i != 0) begin
			if(!clk) begin
				control = !control;
				i  = i - 1;
			end
		end
	end


endmodule

