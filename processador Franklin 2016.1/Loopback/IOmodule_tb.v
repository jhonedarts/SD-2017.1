module IOmodule_tb;
	reg[31:0] address;
	reg[31:0] write_data;
	reg write_control;
	wire[31:0] data_out;
	
	//Serial interface
	wire[31:0] address0;
	wire[31:0] write_data0;
	wire write_control0;
	reg[31:0] data_out0;
	
	//Memory
	wire[31:0] address1;
	wire[31:0] write_data1;
	wire write_control1;
	reg[31:0] data_out1;
	
	IOmodule IO(address,write_data,write_control,data_out,address0,write_data0,write_control0,data_out0,address1,write_data1,write_control1,data_out1);
	initial begin
		address = 0;
		write_data = 10;
		write_control = 1;
		data_out0 = 20;
		data_out1 = 30;
	end

	always begin
		 #100 address = address + 1;
		 if(address == 16585)
			$finish();
	end
endmodule
