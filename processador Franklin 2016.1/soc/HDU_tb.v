
module HDU_tb;
	reg IDEX_memRead;
	wire IFID_write;
	
	HDU hazard(IDEX_memRead, IFID_write);

	initial 
		IDEX_memRead = 0;
	
	always
		#100  IDEX_memRead = !IDEX_memRead;
	

endmodule