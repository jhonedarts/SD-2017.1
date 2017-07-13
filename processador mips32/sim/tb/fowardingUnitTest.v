`timescale 1ns / 1ps

module FowardingUnitTest ();

    parameter Halfcycle = 5;
    localparam Cycle = 2*Halfcycle;
    reg Clock, Reset;
    initial Clock = 0;
    always #(Halfcycle) Clock = ~Clock;

    reg[4:0] rs, rt, rsID, rtID, destRegEX, destRegMEM, destRegWB; //in
	reg regWriteEX, regWriteMEM, regWriteWB; //in
	reg[1:0] forwardRS, forwardRT, forwardRSID, forwardRTID; //out
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

	task checkOutput;
		//rs
        if ((rs==destRegMEM)&&(regWriteMEM==1'b1)) begin
			REFforwardRS = 1'b01;
		end
		else if ((rs==destRegWB)&&(regWriteWB==1'b1)) begin
			REFforwardRS = 1'b10;
		end
		else begin
			REFforwardRS = 1'b00;	
		end

		//rt
		if ((rt==destRegMEM)&&(regWriteMEM==1'b1)) begin
			REFforwardRT = 1'b01;
		end
		else if ((rt==destRegWB)&&(regWriteWB==1'b1)) begin
			REFforwardRT = 1'b10;
		end
		else begin
			REFforwardRT = 1'b00;	
		end

		//rsID
		if ((rsID==destRegEX)&&(regWriteEX==1'b1)) begin
			REFforwardRSID = 1'b01;
		end
		else if ((rsID==destRegMEM)&&(regWriteMEM==1'b1)) begin
			REFforwardRSID = 1'b10;
		end
		else begin
			REFforwardRSID = 1'b00;	
		end

		//rtID
		if ((rtID==destRegEX)&&(regWriteEX==1'b1)) begin
			REFforwardRTID = 1'b01;
		end
		else if ((rtID==destRegMEM)&&(regWriteMEM==1'b1)) begin
			REFforwardRTID = 1'b10;
		end
		else begin
			REFforwardRTID = 1'b00;	
		end

		if (REFforwardRS==forwardRS && REFforwardRT==forwardRT && REFforwardRSID==forwardRSID && REFforwardRTID==forwardRTID) begin
			$display("\nTEST %d PASSED\n", i);	
			$display("Forward in EX stage:\n");
			$display("RS: %b  RT: %b\n", rs, rt);
			$display("destRegMEM: %b  destRegWB: %b\n", destRegMEM, destRegWB);
			$display("regWriteMEM: %b  regWriteWB: %b\n", regWriteMEM, regWriteWB);
			$display("Saida Esperada: forwardRS: %b, forwardRT: %b\n", REFforwardRS, REFforwardRT);
			$display("Saida Obtida:   forwardRS: %b, forwardRT: %b\n", forwardRS, forwardRT);
			$display("Forward in ID stage:\n");
			$display("RSID: %b  RTID: %b\n", rsID, rtID);
			$display("destRegEX: %b  destRegMEM: %b\n", destRegEX, destRegMEM);
			$display("regWriteEX: %b  regWriteMEM: %b\n", regWriteEX, regWriteMEM);
			$display("Saida Esperada: forwardRSID: %b, forwardRTID: %b\n", REFforwardRSID, REFforwardRTID);
			$display("Saida Obtida:   forwardRSID: %b, forwardRTID: %b\n", forwardRSID, forwardRTID);		
		end else begin
			$display("\nTEST %d FAILED\n", i);		
			$display("Forward in EX stage:\n");
			$display("RS: %b  RT: %b\n", rs, rt);
			$display("destRegMEM: %b  destRegWB: %b\n", destRegMEM, destRegWB);
			$display("regWriteMEM: %b  regWriteWB: %b\n", regWriteMEM, regWriteWB);
			$display("Saida Esperada: forwardRS: %b, forwardRT: %b\n", REFforwardRS, REFforwardRT);
			$display("Saida Obtida:   forwardRS: %b, forwardRT: %b\n", forwardRS, forwardRT);
			$display("Forward in ID stage:\n");
			$display("RSID: %b  RTID: %b\n", rsID, rtID);
			$display("destRegEX: %b  destRegMEM: %b\n", destRegEX, destRegMEM);
			$display("regWriteEX: %b  regWriteMEM: %b\n", regWriteEX, regWriteMEM);
			$display("Saida Esperada: forwardRSID: %b, forwardRTID: %b\n", REFforwardRSID, REFforwardRTID);
			$display("Saida Obtida:   forwardRSID: %b, forwardRTID: %b\n", forwardRSID, forwardRTID);
			$finish();
		end
	endtask

	localparam loops = 500; // quantidade de testes aleatorios

    // Testing logic:
    initial begin
	    $display("\n\n ALL INSTRUCTIONS TESTS RANDOM");
	    for(i = 0; i < loops; i = i + 1)
	    begin
	        rs = {$random} % 5'b11111;
	        rt = {$random} % 5'b11111;
	        rsID = {$random} % 5'b11111;
	        rtID = {$random} % 5'b11111;
	        destRegEX = {$random} % 5'b11111;
	        destRegMEM = {$random} % 5'b11111;
	        destRegWB = {$random} % 5'b11111;
	        regWriteEX = {$random} % 1'b1;
	        regWriteMEM = {$random} % 1'b1;
	        regWriteWB = {$random} % 1'b1;
			#1;
			checkOutput();
		end
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

endmodule