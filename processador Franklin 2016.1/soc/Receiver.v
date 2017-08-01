module Receiver(
	input reset,
	input rx,
	input clk,
	output[31:0] data,
	output dataReady
);
	reg[5:0] byteNumber;
	reg dataReady_reg;
	reg[31:0] data_reg;
	reg[3:0] state;
	
	assign dataReady = dataReady_reg;
	assign data = data_reg;
	
	always@(posedge clk) begin
		if(reset == 1'b0) begin
			byteNumber <= 0;
			dataReady_reg <= 0;
			data_reg <= 0;
			state <= 0;
		end
		
		else begin
			case(state) 
				4'b0000: //wait Start bit state
					begin
						if(byteNumber == 32)
							byteNumber = 0;
						dataReady_reg <= 0;
						if(rx == 1'b0) 
							state <= 4'b0001;		
					end
				
				4'b0001: //Receive data[0] state 
					begin
						data_reg[byteNumber+0] <= rx;
						state <= 4'b0010;
					end
					
				4'b0010: //Receive data[1] state 
					begin
						data_reg[byteNumber+1] <= rx;
						state <= 4'b0011;
					end
					
				4'b0011: //Receive data[2] state 
					begin
						data_reg[byteNumber+2] <= rx;
						state <= 4'b0100;
					end
				
				4'b0100: //Receive data[3] state 
					begin
						data_reg[byteNumber+3] <= rx;
						state <= 4'b0101;
					end
				4'b0101: //Receive data[4] state 
					begin
						data_reg[byteNumber+4] <= rx;
						state <= 4'b0110;
					end
				4'b0110: //Receive data[5] state 
					begin
						data_reg[byteNumber+5] <= rx;
						state <= 4'b0111;
					end
				4'b0111: //Receive data[6] state 
					begin
						data_reg[byteNumber+6] <= rx;
						state <= 4'b1000;
					end
				4'b1000: //Receive data[7] state 
					begin
						data_reg[byteNumber+7] <= rx;
						state <= 4'b1001;
					end
				4'b1001: //Stop bit state
					begin
						dataReady_reg <= 1;
						byteNumber = byteNumber + 8;
						state <= 4'b0000;
					end
					
			endcase
		end
	end
	
endmodule