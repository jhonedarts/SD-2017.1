module Transmitter(
	input reset,
	input startBit,
	input[31:0] data,
	input clk,
	output busy,
	output tx
);
	reg[5:0] byteNumber;
	reg tx_reg;
	reg busy_reg;
	reg[4:0] state;
	
	assign tx = tx_reg;
	assign busy = busy_reg;
	
	always@(posedge clk) begin
		
		if(reset == 1'b0) begin
			byteNumber <= 0;
			tx_reg <= 1;
			busy_reg <= 0;
			state <= 0;
		end
		
		else begin
			case(state) 
				4'b0000: //Start bit state
					begin
						if(byteNumber == 32) begin 
							byteNumber = 0;
							busy_reg = 1'b0;
						end
						if(startBit == 0 || byteNumber > 0) begin
							tx_reg <= 1'b0;
							busy_reg <= 1'b1;
							state <= 4'b0001;
						end	
						else
							tx_reg <= 1'b1;
					end
				
				4'b0001: //Send data[0] state 
					begin
						tx_reg <= data[byteNumber+0];
						state <= 4'b0010;
					end
					
				4'b0010: //Send data[1] state 
					begin
						tx_reg <= data[byteNumber+1];
						state <= 4'b0011;
					end
					
				4'b0011: //Send data[2] state 
					begin
						tx_reg <= data[byteNumber+2];
						state <= 4'b0100;
					end
				
				4'b0100: //Send data[3] state 
					begin
						tx_reg <= data[byteNumber+3];
						state <= 4'b0101;
					end
				4'b0101: //Send data[4] state 
					begin
						tx_reg <= data[byteNumber+4];
						state <= 4'b0110;
					end
				4'b0110: //Send data[5] state 
					begin
						tx_reg <= data[byteNumber+5];
						state <= 4'b0111;
					end
				4'b0111: //Send data[6] state 
					begin
						tx_reg <= data[byteNumber+6];
						state <= 4'b1000;
					end
				4'b1000: //Send data[7] state 
					begin
						tx_reg <= data[byteNumber+7];
						state <= 4'b1001;
					end
				4'b1001: //Stop bit state
					begin
						tx_reg <= 1'b1;
						state <= 4'b0000;
						byteNumber <= byteNumber + 8;
					end
					
			endcase
		end
	end
	
endmodule