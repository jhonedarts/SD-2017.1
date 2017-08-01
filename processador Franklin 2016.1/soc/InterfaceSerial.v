module InterfaceSerial(
	input reset,
	input clk,
	input[31:0] data_in,
	input control,
	input rx,
	output tx,
	output[31:0] data_out
);
	
	reg[31:0] FIFO_buffer[0:199];
	reg[7:0] insertion_position;
	reg[31:0] send_data;
	wire[31:0] receive_data;
	integer i;
	
	wire baud;
	wire busy;
	wire txd;
	wire dataReady;
	reg startBit;
	
	assign tx = txd;
	assign data_out = receive_data;
	
	Transmitter transmitter(reset,startBit,send_data,baud,busy,txd);
	Receiver receiver(reset,rx,baud,receive_data,dataReady);
	BaudRate_Generator baudRate(reset, clk, baud);
	
	initial begin
		insertion_position = 0;
		startBit = 1'b1;
	end
	
	always@(*)begin
		if(reset == 0) begin
			insertion_position = 0;
			startBit = 1'b1;
		end
		
		else begin
			@(posedge control or negedge busy) begin

				//Inserts a data on buffer
				if(control) begin
					send_data <= data_in;
					FIFO_buffer[insertion_position] <= data_in;
					if(insertion_position == 0)
						startBit <= 1'b0;
					insertion_position = insertion_position + 1;
				end
					
				//Removes a data on buffer
				else if(!busy) begin
					insertion_position = insertion_position - 1;
					
					for(i = 0; i < 200; i = i + 1)
						FIFO_buffer[insertion_position] <= FIFO_buffer[insertion_position + 1];
							
					if(insertion_position == 0)
						startBit <= 1'b1;
				end
			end
		end
	end


endmodule