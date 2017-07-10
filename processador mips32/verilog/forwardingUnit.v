/***************************************************
 * Module: ForwardingUnit
 * Project: mips32
 * Description: Responsavel por recuperar o valor atualizado
 * de um registrador que ainda sera salvo na operação anterior
 ***************************************************/
module forwardingUnit(rs, rt, rsID, rtID, destRegEX, destRegMEM, destRegWB, regWriteEX, regWriteMEM, regWriteWB, forwardRS, forwardRT, forwardRSID, forwardRTID);
	input[4:0] rs, rt, rsID, rtID, destRegEX, destRegMEM, destRegWB;
	input regWriteEX, regWriteMEM, regWriteWB;
	output reg [1:0] forwardRSID, forwardRTID, forwardRS, forwardRT;

	always @(*) begin
		//rs
		if ((rs==destRegMEM)&&(regWriteMEM==1'b1)) begin
			forwardRS = 1;
		end
		else if ((rs==destRegWB)&&(regWriteWB==1'b1)) begin
			forwardRS = 2;
		end
		else begin
			forwardRS = 0;	
		end

		//rt
		if ((rt==destRegMEM)&&(regWriteMEM==1'b1)) begin
			forwardRT = 1;
		end
		else if ((rt==destRegWB)&&(regWriteWB==1'b1)) begin
			forwardRT = 2;
		end
		else begin
			forwardRT = 0;	
		end

		//rsID
		if ((rsID==destRegEX)&&(regWriteEX==1'b1)) begin
			forwardRSID = 1;
		end
		else if ((rsID==destRegMEM)&&(regWriteMEM==1'b1)) begin
			forwardRSID = 2;
		end
		else begin
			forwardRSID = 0;	
		end

		//rtID
		if ((rtID==destRegEX)&&(regWriteEX==1'b1)) begin
			forwardRTID = 1;
		end
		else if ((rtID==destRegMEM)&&(regWriteMEM==1'b1)) begin
			forwardRTID = 2;
		end
		else begin
			forwardRTID = 0;	
		end
	end
endmodule
