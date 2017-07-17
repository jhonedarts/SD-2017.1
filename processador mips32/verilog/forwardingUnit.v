/***************************************************
 * Module: ForwardingUnit
 * Project: mips32
 * Description: Responsavel por recuperar o valor atualizado
 * de um registrador que ainda sera salvo na operação anterior
 ***************************************************/
module forwardingUnit(rs, rt, rsID, rtID, destRegEX, destRegMEM, destRegWB, regWriteEX, regWriteMEM, regWriteWB, 
		forwardRS, forwardRT, forwardRSID, forwardRTID);
	input[4:0] rs, rt, rsID, rtID, destRegEX, destRegMEM, destRegWB;
	input regWriteEX, regWriteMEM, regWriteWB;
	output [1:0] forwardRSID, forwardRTID, forwardRS, forwardRT;

	reg [1:0] forwardRSIDReg, forwardRTIDReg, forwardRSReg, forwardRTReg;

	always @(*) begin
		//rs
		if ((rs==destRegMEM)&(regWriteMEM==1'b1)) begin
			forwardRSReg = 1;
		end
		else if ((rs==destRegWB)&(regWriteWB==1'b1)) begin
			forwardRSReg = 2;
		end
		else begin
			forwardRSReg = 0;	
		end

		//rt
		if ((rt==destRegMEM)&(regWriteMEM==1'b1)) begin
			forwardRTReg = 1;
		end
		else if ((rt==destRegWB)&(regWriteWB==1'b1)) begin
			forwardRTReg = 2;
		end
		else begin
			forwardRTReg = 0;	
		end

		//rsID
		if ((rsID==destRegEX)&(regWriteEX==1'b1)) begin
			forwardRSIDReg = 1;
		end
		else if ((rsID==destRegMEM)&(regWriteMEM==1'b1)) begin
			forwardRSIDReg = 2;
		end
		else begin
			forwardRSIDReg = 0;	
		end

		//rtID
		if ((rtID==destRegEX)&(regWriteEX==1'b1)) begin
			forwardRTIDReg = 1;
		end
		else if ((rtID==destRegMEM)&(regWriteMEM==1'b1)) begin
			forwardRTIDReg = 2;
		end
		else begin
			forwardRTIDReg = 0;	
		end
	end

	assign forwardRSID = forwardRSIDReg;
	assign forwardRTID = forwardRTIDReg;
	assign forwardRS = forwardRSReg;
	assign forwardRT = forwardRTReg;
endmodule
