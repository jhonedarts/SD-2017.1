/*
	This code is the register bank implementation.
	
*/
module GPR(reset, clk, read_register1, read_register2, write_register, r_data1, r_data2, w_data, regWrite);
	
	//The read and write registers addresses
	input[4:0] read_register1,  read_register2,  write_register;
	//The data to write
	input[31:0] w_data;
	//Control signal to write in a register
	input regWrite, clk, reset;
	//Data outputs
	output[31:0] r_data1, r_data2;
	//The registers
	reg[31:0] registers[0:31];
	
	//Write in a register if the control signal = 1 and clock = 1
	always @ (*) begin
		if(reset == 0)
			$readmemb("reg.dat", registers);
			
		else begin
			if(clk) begin
				if(regWrite) begin
					registers[write_register] <= w_data;
					registers[0] <= 0;
				end
			end
		end
	end
	assign r_data1 = registers[read_register1];
	assign r_data2 = registers[read_register2];
	
endmodule