`timescale 1ns / 1ps

module hazardDetectionTest ();

    parameter Halfcycle = 5;
    localparam Cycle = 2*Halfcycle;
    reg Clock, Reset;
    initial Clock = 0;
    always #(Halfcycle) Clock = ~Clock;

    reg[4:0] rs, rt, rtEX; //in
	reg memRead, isBranch; //in
	reg pcWrite, ifIdFlush; //out
	reg REFpcWrite, REFifIdFlush;
	integer i;

	hazardDetection hd(
		.rs(rs),
		.rt(rt), 
		.rtEX(rtEX), 
		.memRead(memRead), 
		.isBranch(isBranch), 
		.pcWrite(pcWrite), 
		.ifIdFlush(ifIdFlush)
	);

	task checkOutput;
		REFpcWrite = (memRead==1'b1 && (rs==rtEX || rt==rtEX))? 1'b0 : 1'b1;
		REFifIdFlush = (isBranch || !(memRead==1'b1 && (rs==rtEX || rt==rtEX)))? 1'b1 : 1'b0;
		if (REFpcWrite==pcWrite && REFifIdFlush==ifIdFlush) begin
			$display("\nTEST %d PASSED\n", i);		
			$display("RS: %b\n", rs);
			$display("RT: %b\n", rt);
			$display("RT(ex): %b\n", rtEX);
			$display("Saida Esperada: pcWrite: %b, ifIdFlush: %b\n", REFpcWrite, REFifIdFlush);
			$display("Saida Obtida:   pcWrite: %b, ifIdFlush: %b\n", pcWrite, ifIdFlush);	
		end else begin
			$display("\nTEST %d FAILED\n", i);	
			$display("RS: %b\n", rs);
			$display("RT: %b\n", rt);
			$display("RT(ex): %b\n", rtEX);
			$display("Saida Esperada: pcWrite: %b, ifIdFlush: %b\n", REFpcWrite, REFifIdFlush);
			$display("Saida Obtida:   pcWrite: %b, ifIdFlush: %b\n", pcWrite, ifIdFlush);	
			$finish();
		end
	endtask

	localparam loops = 500; // quantidade de testes aleatorios

    // Testing logic:
    initial begin
	    $display("\n\n ALL INSTRUCTIONS TESTS RANDOM");
	    for(i = 0; i < loops; i = i + 1)
	    begin
	        /////////////////////////////////////////////
	        // Put your random tests inside of this loop
	        // and hard-coded tests outside of the loop
	        // (see comment below)
	        // //////////////////////////////////////////
	        
	        rs = {$random} % 5'b11111;
	        rt = {$random} % 5'b11111;
	        rtEX = {$random} % 5'b11111;
	        memRead = {$random} % 1'b1;
	        isBranch = {$random} % 1'b1;
			#1;
			checkOutput();
		end
	end

	$display("\n\n CASUAL TESTS");
	
	i = 0;
    rs = 5'b01111;
    rt = 5'b00000;
    rtEX = 5'b01111;
    memRead = 1'b1;
    isBranch = 1'b0;
	#1;
	checkOutput();

	i = 1;
    rs = 5'b00000;
    rt = 5'b01100;
    rtEX = 5'b01100;
    memRead = 1'b1;
    isBranch = 1'b0;    
	#1;
	checkOutput();

	i = 2;
    rs = 5'b00000;
    rt = 5'b01100;
    rtEX = 5'b01100;
    memRead = 1'b1;
    isBranch = 1'b1;
	#1;
	checkOutput();

	i = 3;
    rs = 5'b00111;
    rt = 5'b01000;
    rtEX = 5'b01100;
    memRead = 1'b0;
    isBranch = 1'b1;
	#1;
	checkOutput();

	i = 4;
    rs = 5'b11111;
    rt = 5'b11111;
    rtEX = 5'b11111;
    memRead = 1'b1;
    isBranch = 1'b1;
	#1;
	checkOutput();

	$display("\n\nALL TESTS PASSED!");
	$finish();

endmodule