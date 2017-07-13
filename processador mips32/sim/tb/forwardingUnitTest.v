`timescale 1ns / 1ps

module forwardingUnitTest ();

    parameter Halfcycle = 5;
    localparam Cycle = 2*Halfcycle;
    reg Clock, Reset;
    initial Clock = 0;
    always #(Halfcycle) Clock = ~Clock;

    reg[4:0] rs, rt, rsID, rtID, destRegEX, destRegMEM, destRegWB; //in
	reg regWriteEX, regWriteMEM, regWriteWB; //in
	wire[1:0] forwardRS, forwardRT, forwardRSID, forwardRTID; //out
	reg[1:0] REFforwardRS, REFforwardRT, REFforwardRSID, REFforwardRTID;
	integer i;

	forwardingUnit fu(
		.rs(rs), 
		.rt(rt), 
		.rsID(rsID), 
		.rtID(rtID), 
		.destRegEX(destRegEX), 
		.destRegMEM(destRegMEM), 
		.destRegWB(destRegWB), 
		.regWriteEX(regWriteEX), 
		.regWriteMEM(regWriteMEM), 
		.regWriteWB(regWriteWB), 
		.forwardRS(forwardRS), 
		.forwardRT(forwardRT), 
		.forwardRSID(forwardRSID), 
		.forwardRTID(forwardRTID)
	);

	task checkOutput; begin
		//rs
        if ((rs==destRegMEM)&&(regWriteMEM==1'b1)) begin
			REFforwardRS = 1;
		end
		else if ((rs==destRegWB)&&(regWriteWB==1'b1)) begin
			REFforwardRS = 2;
		end
		else begin
			REFforwardRS = 0;	
		end

		//rt
		if ((rt==destRegMEM)&&(regWriteMEM==1'b1)) begin
			REFforwardRT = 1;
		end
		else if ((rt==destRegWB)&&(regWriteWB==1'b1)) begin
			REFforwardRT = 2;
		end
		else begin
			REFforwardRT = 0;	
		end

		//rsID
		if ((rsID==destRegEX)&&(regWriteEX==1'b1)) begin
			REFforwardRSID = 1;
		end
		else if ((rsID==destRegMEM)&&(regWriteMEM==1'b1)) begin
			REFforwardRSID = 2;
		end
		else begin
			REFforwardRSID = 0;	
		end

		//rtID
		if ((rtID==destRegEX)&&(regWriteEX==1'b1)) begin
			REFforwardRTID = 1;
		end
		else if ((rtID==destRegMEM)&&(regWriteMEM==1'b1)) begin
			REFforwardRTID = 2;
		end
		else begin
			REFforwardRTID = 0;	
		end

		if (REFforwardRS==forwardRS && REFforwardRT==forwardRT && REFforwardRSID==forwardRSID && REFforwardRTID==forwardRTID) begin
			$display("\nTEST %d PASSED", i);	
			$display("Forward in EX stage:");
			$display("RS: %b  RT: %b", rs, rt);
			$display("destRegMEM: %b  destRegWB: %b", destRegMEM, destRegWB);
			$display("regWriteMEM: %b  regWriteWB: %b\n", regWriteMEM, regWriteWB);
			$display("Saida Esperada: forwardRS: %b, forwardRT: %b", REFforwardRS, REFforwardRT);
			$display("Saida Obtida:   forwardRS: %b, forwardRT: %b", forwardRS, forwardRT);
			$display("Forward in ID stage:");
			$display("RSID: %b  RTID: %b", rsID, rtID);
			$display("destRegEX: %b  destRegMEM: %b", destRegEX, destRegMEM);
			$display("regWriteEX: %b  regWriteMEM: %b", regWriteEX, regWriteMEM);
			$display("Saida Esperada: forwardRSID: %b, forwardRTID: %b", REFforwardRSID, REFforwardRTID);
			$display("Saida Obtida:   forwardRSID: %b, forwardRTID: %b", forwardRSID, forwardRTID);		
		end else begin
			$display("\nTEST %d FAILED", i);		
			$display("Forward in EX stage:");
			$display("RS: %b  RT: %b", rs, rt);
			$display("destRegMEM: %b  destRegWB: %b", destRegMEM, destRegWB);
			$display("regWriteMEM: %b  regWriteWB: %b\n", regWriteMEM, regWriteWB);
			$display("Saida Esperada: forwardRS: %b, forwardRT: %b", REFforwardRS, REFforwardRT);
			$display("Saida Obtida:   forwardRS: %b, forwardRT: %b", forwardRS, forwardRT);
			$display("Forward in ID stage:");
			$display("RSID: %b  RTID: %b", rsID, rtID);
			$display("destRegEX: %b  destRegMEM: %b", destRegEX, destRegMEM);
			$display("regWriteEX: %b  regWriteMEM: %b", regWriteEX, regWriteMEM);
			$display("Saida Esperada: forwardRSID: %b, forwardRTID: %b", REFforwardRSID, REFforwardRTID);
			$display("Saida Obtida:   forwardRSID: %b, forwardRTID: %b", forwardRSID, forwardRTID);
			$finish();
		end
	end endtask

	localparam loops = 500; // quantidade de testes aleatorios

    // Testing logic:
    initial begin
	    $display("\n\n ALL INSTRUCTIONS TESTS RANDOM");
	    for(i = 0; i < loops; i = i + 1)
	    begin
	        rs = {$random} % 6'b100000;
	        rt = {$random} % 6'b100000;
	        rsID = {$random} % 6'b100000;
	        rtID = {$random} % 6'b100000;
	        destRegEX = {$random} % 6'b100000;
	        destRegMEM = {$random} % 6'b100000;
	        destRegWB = {$random} % 6'b100000;
	        regWriteEX = {$random} % 2'b10;
	        regWriteMEM = {$random} % 2'b10;
	        regWriteWB = {$random} % 2'b10;
			#1;
			checkOutput();
		end
	
		$display("\n\n CASUAL TESTS");

		i = 0;
	    rs = 5'b11111;
	    rt = 5'b11111;
	    rsID = 5'b11111;
	    rtID = 5'b11111;
	    destRegEX = 5'b11111;
	    destRegMEM = 5'b11111;
	    destRegWB = 5'b11111;
	    regWriteEX = 1'b1;
	    regWriteMEM = 1'b1;
	    regWriteWB = 1'b1;
	    #1;
		checkOutput();

		i = 1;
	    rs = 5'b11111;
	    rt = 5'b11111;
	    rsID = 5'b11111;
	    rtID = 5'b11111;
	    destRegEX = 5'b11111;
	    destRegMEM = 5'b11111;
	    destRegWB = 5'b11111;
	    regWriteEX = 1'b0;
	    regWriteMEM = 1'b1;
	    regWriteWB = 1'b1;
	    #1;
		checkOutput();

		i = 2;
	    rs = 5'b11111;
	    rt = 5'b11111;
	    rsID = 5'b11111;
	    rtID = 5'b11111;
	    destRegEX = 5'b11111;
	    destRegMEM = 5'b11111;
	    destRegWB = 5'b11111;
	    regWriteEX = 1'b0;
	    regWriteMEM = 1'b0;
	    regWriteWB = 1'b1;
	    #1;
		checkOutput();

		i = 3;
	    rs = 5'b11111;
	    rt = 5'b11111;
	    rsID = 5'b11011;
	    rtID = 5'b10111;
	    destRegEX = 5'b10111;
	    destRegMEM = 5'b01011;
	    destRegWB = 5'b01101;
	    regWriteEX = 1'b1;
	    regWriteMEM = 1'b1;
	    regWriteWB = 1'b0;
	    #1;
		checkOutput();

		i = 4;
	    rs = 5'b11111;
	    rt = 5'b11111;
	    rsID = 5'b11011;
	    rtID = 5'b10111;
	    destRegEX = 5'b10111;
	    destRegMEM = 5'b01011;
	    destRegWB = 5'b01101;
	    regWriteEX = 1'b0;
	    regWriteMEM = 1'b0;
	    regWriteWB = 1'b0;
	    #1;
		checkOutput();

		i = 5;
	    rs = 5'b11111;
	    rt = 5'b01111;
	    rsID = 5'b11011;
	    rtID = 5'b10111;
	    destRegEX = 5'b10111;
	    destRegMEM = 5'b01011;
	    destRegWB = 5'b01111;
	    regWriteEX = 1'b0;
	    regWriteMEM = 1'b0;
	    regWriteWB = 1'b1;
	    #1;
		checkOutput();
		
		$display("\n\nALL TESTS PASSED!");
		$finish();
	end
endmodule