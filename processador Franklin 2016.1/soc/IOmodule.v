module IOmodule(
	input[31:0] address,
	input[31:0] write_data,
	input write_control,
	output[31:0] data_out,
	
	//Serial interface
	output[31:0] address0,
	output[31:0] write_data0,
	output write_control0,
	input[31:0] data_out0,
	
	//Memory
	output[31:0] address1,
	output[31:0] write_data1,
	output write_control1,
	input[31:0] data_out1
);

	reg[31:0] data_outR, address0R, write_data0R, address1R, write_data1R;
	reg write_control0R, write_control1R;
	
	assign data_out = data_outR;
	assign address0 = address0R;
	assign write_data0 = write_data0R;
	assign write_control0 = write_control0R;
	assign address1 = address1R;
	assign write_data1 = write_data1R;
	assign write_control1 = write_control1R;
	
	always@(*) begin
		if(address >= 0 && address <= 16383) begin
			//From memory
			data_outR <= data_out1;
			
			//To memory
			address1R <= address;
			write_data1R <= write_data;
			write_control1R <= write_control;
			
			//To serial interface
			address0R <= 32'bx;
			write_data0R <= 32'bx;
			write_control0R <= 32'bx;
		end
		
		else if(address >= 16384 && address <= 16584) begin
			//From Serial interface
			data_outR <= data_out0;
			
			//To serial interface
			address0R <= address;
			write_data0R <= write_data;
			write_control0R <= write_control;
			
			//To memory
			address1R <= 32'bx;
			write_data1R <= 32'bx;
			write_control1R <= 32'bx;
		end
			
		else begin
			data_outR <= 32'bx;
			address0R <= 32'bx;
			write_data0R <= 32'bx;
			write_control0R <= 32'bx;
			address1R <= 32'bx;
			write_data1R <= 32'bx;
			write_control1R <= 32'bx;
		end		
	end

endmodule