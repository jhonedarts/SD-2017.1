module UC(reset, opcode, funct, jump_flag, branch_flag, jal_flag, jr_flag, microcode);
	
	input reset;
	input[5:0] opcode, funct;
	output jump_flag, branch_flag, jal_flag, jr_flag;
	output[13:0] microcode;

	reg[13:0] microcode_reg;
	reg[3:0] flags_reg;
	
	assign microcode = microcode_reg;
	assign jump_flag = flags_reg[3];
	assign branch_flag = flags_reg[2];
	assign jal_flag = flags_reg[1];
	assign jr_flag = flags_reg[0];
	
	always@(*) begin
		if(reset == 0)begin
			microcode_reg = 14'b0;
			flags_reg = 4'b0;
		end
	
		else begin
			microcode_reg[5:0] = opcode;
			case(opcode)
				6'bx: begin 
					microcode_reg = 14'b0;
					flags_reg = 4'b0;
				end
				
				//R_type 1
				6'b000000: begin
					//Jr
					if(opcode == 6'b000000 && funct == 6'b001000) begin
						microcode_reg[13:6] = 8'b00010000;
						flags_reg = 4'b1001;
					end
					
					//Another instruction
					else begin
						microcode_reg[13:6] = 8'b01000001;
						flags_reg = 4'b0000;
					end
				end

				//R_type 2
				6'b011100: begin
					microcode_reg[13:6] = 8'b01000001;
					flags_reg = 4'b0000;
				end

				//J
				6'b000010: begin
					microcode_reg[13:6] = 8'b00010000;
					flags_reg = 4'b1000;
				end

				//Jal
				6'b000011: begin
					microcode_reg[13:6] = 8'b11010001;
					flags_reg = 4'b1010;
				end

				//addi
				6'b001000: begin
					microcode_reg[13:6] = 8'b01000010;
					flags_reg = 4'b0000;
				end

				//slti
				6'b001010: begin
					microcode_reg[13:6] = 8'b01000010;
					flags_reg = 4'b0000;
				end

				//beq
				6'b000100: begin
					microcode_reg[13:6] = 8'b00010000;
					flags_reg = 4'b0100;
				end

				//bne
				6'b000101: begin
					microcode_reg[13:6] = 8'b00010000;
					flags_reg = 4'b0100;
				end

				//lw
				6'b100011: begin
					microcode_reg[13:6] = 8'b01101010;
					flags_reg = 4'b0000;
				end

				//sw
				6'b101011: begin
					microcode_reg[13:6] = 8'b00000110;
					flags_reg = 4'b0000;
				end
			endcase
		end
	end

endmodule
