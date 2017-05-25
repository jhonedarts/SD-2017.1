/***************************************************
 * Module: ForwardingUnit
 * Project: mips32
 * Description: Responsavel por recuperar o valor atualizado
 * de um registrador que ainda sera salvo na operação anterior
 ***************************************************/
module forwardingUnit(rs, rt, destRegMEM, destRegWB, regWriteMEM, regWriteWB, forwardRS, forwardRT);
	input[4:0] rs, rt, destRegMEM, destRegWB;
	input regWriteMEM, regWriteWB;
	output reg [1:0] forwardRS, forwardRT;

	always @(*) begin
		if ((rs==destRegMEM)&&(regWriteMEM==1'b1)) begin
			forwardRS = 1;
		end
		else if ((rs==destRegWB)&&(regWriteWB==1'b1)) begin
			forwardRS = 2;
		end
		else begin
			forwardRS = 0;	
		end

		if ((rt==destRegMEM)&&(regWriteMEM==1'b1)) begin
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
