module MEMORY_Loopback(
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
	wire [31:0] MEM_data;
	reg startBit;

	
	assign c[0] = ~reset;
	assign r[0] = ~reset;
	assign c[4:1] = 4'b1111;
	assign r[7:1] = 7'b1111111;
	assign tx = txd;
	

	memory MEMORY(
		.clk(clk),
		.address(data), 
		.data_out(MEM_data), 
		.write_data(32'b11111111111111111111111111111111), 
		.mem_write(1'b0)
	);
	
	Transmitter transmitter(reset,startBit,MEM_data,baud,busy,txd);
	Receiver receiver(reset,rx,baud,data,dataReady);
	BaudRate_Generator baudRate(reset, clk, baud);
	
	always@(*)begin
		if(reset == 1'b0 || dataReady == 1'b0)
			startBit = 1'b1;
		else if(dataReady == 1'b1)
			startBit = 1'b0;

	end
	
endmodule