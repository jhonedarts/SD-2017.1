module INTERFACE_Loopback(
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
	

	InterfaceSerial UART(
		.reset(reset),
		.clk(clk),
		.data_in(2),
		.control(rx),
		.rx(1'b1),
		.tx(txd),
		.data_out()
	);
	
	always@(*)begin
		if(reset == 1'b0 || dataReady == 1'b0)
			startBit = 1'b1;
		else if(dataReady == 1'b1)
			startBit = 1'b0;

	end
	
endmodule