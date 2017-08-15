module BaudRate_Generator(
	input reset,
	input clk,
	output baudtick
);
	
	reg[13:0] count;
	reg baudtick_reg;

	assign baudtick = baudtick_reg;
	always @(posedge clk) begin
		
		if(reset == 1'b0) begin
			count <= 0;
			baudtick_reg <= 1'b0;
		end
		
		else begin
			count <= count + 1;
			if(count == 10415) begin
				baudtick_reg <= 1'b1;
				count <= 0;
			end
			else
				baudtick_reg <= 1'b0;
		end
		
	end
	
endmodule