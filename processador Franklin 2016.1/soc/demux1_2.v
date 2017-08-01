module demux1_2(data_in, Sel, data_out1, data_out2);
	input[31:0] data_in;
	input Sel;
	output[31:0] data_out1, data_out2;
	
	reg[31:0] data_out1r, data_out2r;
	
	always@(*) begin
		case(Sel)
			1'b0: begin
				data_out1r = data_in;
				data_out2r = 32'bx;
			end

			1'b1: begin
				data_out1r = 32'bx;
				data_out2r = data_in;
			end
		endcase
	end
	
	assign data_out1 = data_out1r;
	assign data_out2 = data_out2r;
	
endmodule
