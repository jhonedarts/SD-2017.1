/***************************************************
 * Module: ForwardingUnit
 * Project: mips32
 * Description: Responsavel por recuperar o valor atualizado
 * de um registrador que ainda sera salvo na operação anterior
 ***************************************************/
module forwardingUnit(rs, rt, destRegMem, destRegWB, regWriteMem, regWriteWB, forwardRS, forwardRT);
	input[4:0] rs, rt, destRegMem, destRegWB;
	input regWriteMem, regWriteWB;
	output forwardRS, forwardRT;

	always @(*) begin
		if ((rs==destRegMem)&&(regWriteMem==1'b1)) begin
			forwardRS = 1;
		end
		else if ((rs==destRegWB)&&(regWriteWB==1'b1)) begin
			forwardRS = 2;
		end
		else begin
			forwardRS = 0;	
		end

		if ((rt==destRegMem)&&(regWriteMem==1'b1)) begin
			forwardRT = 1;
		end
		else if ((rt==destRegWB)&&(regWriteWB==1'b1)) begin
			forwardRT = 2;
		end
		else begin
			forwardRT = 0;	
		end
	end
endmodule
