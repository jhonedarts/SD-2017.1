module Loopback(
	input reset,
	input clk,
	input rx,
	output tx,
	output[4:0] c,
	output[7:0] r
);
	wire baud;
	wire busy;
	wire txd;
	wire dataReady;
	wire [31:0] data;
	reg startBit;
	//The registers
	reg[31:0] registers[0:31];
	
	assign c[0] = ~reset;
	assign r[0] = ~reset;
	assign c[4:1] = 4'b1111;
	assign r[7:1] = 7'b1111111;
	assign tx = txd;
	
	Transmitter transmitter(reset,startBit,registers[data],baud,busy,txd);
	Receiver receiver(reset,rx,baud,data,dataReady);
	BaudRate_Generator baudRate(reset, clk, baud);
	
	always@(*)begin
		if(reset == 1'b0 || dataReady == 1'b0) begin
			startBit = 1'b1;
			$readmemb("reg.dat", registers);
		end
		else if(dataReady == 1'b1)
			startBit = 1'b0;

	end
	
endmodule