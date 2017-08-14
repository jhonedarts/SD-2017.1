`timescale 1ns / 1ps
module uartTest2();

	reg [7:0] data;
	reg clk ;
	reg enable;

	wire tx_busy;
	wire rdy;
	wire [7:0] rxdata;

	wire loopback;
	reg rdy_clr = 0;

	//NARUTO
	  
	uart uut(
		.din(data),
		.clock_50MHZ(clk),
		.enable(enable),
		.tx(loopback),
		.tx_busy(tx_busy),
		.rx(loopback),
		.rdy(rdy),
		.rdy_clr(rdy_clr),
		.dout(rxdata)   
	);

	initial begin
		data= 8'b10101010; clk=0; enable=1; rdy_clr = 1;
		#10;
		data= 8'b10101010; clk=0; enable=0; rdy_clr = 0;
		#10;
		data= 8'b10101010; clk=0; enable=1; rdy_clr = 1;
		#10;
	end
endmodule

