module HDU(reset, IDEX_memRead, ID_BranchOrJump, IFID_write);
	input reset, IDEX_memRead, ID_BranchOrJump;
	output IFID_write;

	reg IFID_writeReg;
	
	assign IFID_write = IFID_writeReg;
	
	always@(*) begin
		if(reset == 0)
			IFID_writeReg = 1;
			
		else begin
			if(IDEX_memRead | ID_BranchOrJump)
				IFID_writeReg = 0;
			else
				IFID_writeReg = 1;
		end
	end
	

endmodule
