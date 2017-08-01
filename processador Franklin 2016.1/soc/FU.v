
module FU(reset, IDEX_Rs, IDEX_Rt, EXMEM_Rd, EXMEM_RegWriteWB, MEMWB_Rd, UC_Branch, IFID_Rs, IFID_Rt, IDEX_Rd, IDEX_RegWriteWB, MEMWB_RegWriteWB, ForwardA, ForwardB, ForwardC, ForwardD);
	
	input[4:0] IDEX_Rs, IDEX_Rt, EXMEM_Rd, MEMWB_Rd, IFID_Rs, IFID_Rt, IDEX_Rd;
	input reset, EXMEM_RegWriteWB, MEMWB_RegWriteWB, UC_Branch, IDEX_RegWriteWB;
	output[1:0] ForwardA, ForwardB, ForwardC, ForwardD;

	reg[1:0] ForwardA_reg, ForwardB_reg, ForwardC_reg, ForwardD_reg;
	assign ForwardA = ForwardA_reg;
	assign ForwardB = ForwardB_reg;
	assign ForwardC = ForwardC_reg;
	assign ForwardD = ForwardD_reg;
	
	always@(*) begin
	
		if(reset == 0)begin
			ForwardA_reg = 0;
			ForwardB_reg = 0;
			ForwardC_reg = 0;
			ForwardD_reg = 0;
		end
		
		else begin
			//ALU executions-------------------------------------------------------------------------
			//Forward A(In RS register)
			//Foward with the ALU result wire(not load operation)
			if((EXMEM_RegWriteWB)&&(EXMEM_Rd != 0)&&(EXMEM_Rd == IDEX_Rs))
				ForwardA_reg = 2'b10;
			//Foward with the loaded memory data wire(only load)
			else if((MEMWB_RegWriteWB)&&(MEMWB_Rd != 0)&&(MEMWB_Rd == IDEX_Rs)&&(EXMEM_Rd != IDEX_Rs))
				ForwardA_reg = 2'b01;
			//Not forward A	
			else
				ForwardA_reg = 2'b00;
			
			//Forward B(In RT register)
			//Foward with the ALU result wire
			if((EXMEM_RegWriteWB)&&(EXMEM_Rd != 0)&&(EXMEM_Rd == IDEX_Rt))
				ForwardB_reg = 2'b10;
			//Foward with the loaded memory data wire(only load)
			else if((MEMWB_RegWriteWB)&&(MEMWB_Rd != 0)&&(MEMWB_Rd == IDEX_Rt)&&(EXMEM_Rd != IDEX_Rt))
				ForwardB_reg = 2'b01;
			//Not forward B
			else
				ForwardB_reg = 2'b00; 

			
			//If a branch will be checked
			if(UC_Branch) begin
				
				//Forward C(In RS register)
				if((IDEX_RegWriteWB)&&(IDEX_Rd != 0)&&(IDEX_Rd == IFID_Rs))
					ForwardC_reg = 2'b11;
				else if((EXMEM_RegWriteWB)&&(EXMEM_Rd != 0)&&(EXMEM_Rd == IFID_Rs)&&(IDEX_Rd != IFID_Rs))
					ForwardC_reg = 2'b10;
				else if((MEMWB_RegWriteWB)&&(MEMWB_Rd != 0)&&(MEMWB_Rd == IFID_Rs)&&(EXMEM_Rd != IFID_Rs)&&(IDEX_Rd != IFID_Rs))
					ForwardC_reg = 2'b01;
				else
					ForwardC_reg = 2'b00;

				//Forward D(In RT register)
				if((IDEX_RegWriteWB)&&(IDEX_Rd != 0)&&(IDEX_Rd == IFID_Rt))
					ForwardD_reg = 2'b11;
				else if((EXMEM_RegWriteWB)&&(EXMEM_Rd != 0)&&(EXMEM_Rd == IFID_Rt)&&(IDEX_Rd != IFID_Rt))
					ForwardD_reg = 2'b10;
				else if((MEMWB_RegWriteWB)&&(MEMWB_Rd != 0)&&(MEMWB_Rd == IFID_Rt)&&(EXMEM_Rd != IFID_Rt)&&(IDEX_Rd != IFID_Rt))
					ForwardD_reg = 2'b01;
				else
					ForwardD_reg = 2'b00;
			
			end
			else begin
				ForwardC_reg = 2'b00;
				ForwardD_reg = 2'b00;
			end
		end
	end
endmodule
