module UC_tb;
	reg[5:0] opcode[0:10], funct;
	reg [13:0] result[0:10];
	wire jump_flag, branch_flag, jal_flag, jr_flag;
	wire[13:0] microcode;
	integer i = 0;

	UC UC(opcode[i], funct, jump_flag, branch_flag, jal_flag, jr_flag, microcode);

	initial begin
		funct = 6'b000000;//other R_type
		opcode[0] = 6'b000000; //R type 1
		opcode[1] = 6'b000000; //R type 1 - jr
		opcode[2] = 6'b011100; //R type 2
		opcode[3] = 6'b001000; //addi
		opcode[4] = 6'b001010; //slti
		opcode[5] = 6'b000100; //beq
		opcode[6] = 6'b000101; //bne
		opcode[7] = 6'b100011; //lw
		opcode[8] = 6'b101011; //sw
		opcode[9] = 6'b000010; //j
		opcode[10] = 6'b000011; //jal
		//microcode
		result[0] = 4160; 
		result[1] = 1024;
		result[2] = 4188;
		result[3] = 4232;
		result[4] = 4234;
		result[5] = 1028;
		result[6] = 1029;
		result[7] = 6819;
		result[8] = 427;
		result[9] = 1026;
		result[10] = 13379;
	end
	
	always	begin
		
		if(i == 1)	
			funct = 6'b001000;
		
	 	#100 i = i + 1;

		
		

		if(microcode == result[i-1])
			$monitor("INTERATION %d PASS, EXPECTED VALUE = %d, RESULT = %d", i, microcode, result[i]);
		else
			$monitor("INTERATION %d NOT PASS, EXPECTED VALUE = %d, RESULT = %d", i, microcode, result[i]);


		if($time >= 1100)
			$finish();
	end
	
	
endmodule