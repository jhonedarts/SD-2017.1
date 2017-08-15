module FU_tb;
	
	reg[4:0] IDEX_Rs, IDEX_Rt, EXMEM_Rd, MEMWB_Rd, IFID_Rs, IFID_Rt, IDEX_Rd;
	reg EXMEM_RegWriteWB, MEMWB_RegWriteWB, UC_Branch, IDEX_RegWriteWB;
	wire[1:0] ForwardA, ForwardB, ForwardC, ForwardD;
	reg [1:0] result[0:15];


	FU FORWARDING_UNIT(
		.IDEX_Rs(IDEX_Rs), 
		.IDEX_Rt(IDEX_Rt), 
		.EXMEM_Rd(EXMEM_Rd), 
		.UC_Branch(UC_Branch),
		.IFID_Rs(IFID_Rs),
		.IFID_Rt(IFID_Rt),
		.IDEX_Rd(IDEX_Rd),
		.IDEX_RegWriteWB(IDEX_RegWriteWB),
		.EXMEM_RegWriteWB(EXMEM_RegWriteWB), 
		.MEMWB_Rd(MEMWB_Rd), 
		.MEMWB_RegWriteWB(MEMWB_RegWriteWB), 
		.ForwardA(ForwardA), 
		.ForwardB(ForwardB),
		.ForwardC(ForwardC), 
		.ForwardD(ForwardD)
	);

	initial begin
		UC_Branch = 1;
		IDEX_RegWriteWB = 1;
		EXMEM_RegWriteWB = 1;
		MEMWB_RegWriteWB = 1;
		EXMEM_Rd = 1;
		MEMWB_Rd = 2;
		IDEX_Rd = 3;

		IDEX_Rs = 3;
		IDEX_Rt = 3;

		IFID_Rs = 3;
		IFID_Rt = 3;
		
		
	end
	
	
	
	
	always begin
		#100

		


		IDEX_Rs = IDEX_Rs - 1;
		IDEX_Rt = IDEX_Rt - 1;
		IFID_Rs = IFID_Rs - 1;
		IFID_Rt = IFID_Rt - 1;
		if($time > 300)begin
			UC_Branch = 0;
			IFID_Rs = 3;
			IFID_Rt = 3;
			EXMEM_Rd = 0;
			MEMWB_Rd = 0;
			IDEX_Rd = 0;
		end
		
		$display("fa = %d, fb = %d, fc = %d, fd = %d", ForwardA, ForwardB, ForwardC, ForwardD);
		if($time >= 500)
			$finish();
		
	end


	
endmodule