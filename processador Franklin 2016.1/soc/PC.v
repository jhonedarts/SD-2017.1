/*
	This code is the PC implementation.
*/

module PC(enable, data_in, address);
	//enable input
	input enable;
	input[31:0] data_in;
	
	//Saves the PC address
	reg[31:0] PC;
	
	//Sends the PC addres
	output[31:0] address;
	assign address = PC;

	always @ (*) begin
		case(data_in)
			32'bxx: PC = 0;
			default: begin
				if(enable)
					PC = data_in;
			end
		endcase
	end
	
endmodule