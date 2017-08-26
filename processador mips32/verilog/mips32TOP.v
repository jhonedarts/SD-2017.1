/*************************************************************
 * Module: mips32TOP
 * Project: mips32
 * Description: Top Level do projeto, conecta todos o modulos
 ************************************************************/
`include "parameters.v"

module mips32TOP(
		input clock_50MHz, 
		input PIN_Y17,
	    input UART_Rx,
	    input PIN_E11,
	    input [3:0] Switch,
	    output PIN_F11,
	    output UART_Tx,
	    output [7:0] LEDM_R,
	    output [4:0] LEDM_C
    );

	wire flushIFID, rstIDIF;
	//um and com rst da placa e os comandos de flush pro ifid;
	//wires... wires everwhere

	//interStages
	wire isBranch;
	
	//IF
	wire[31:0] nextpc, currentpc, instructionIF, pc4IF; 	
	wire pcWrite;

	//ID
	wire[0:`CONTROL_SIZE-1] controlID;	
	wire[1:0] forwardRSID, forwardRTID, branchSrc, compareCode;
	wire[31:0] instructionID, rsValueID1, rtValueID1, rsValueID2, rtValueID2, offset16ID1, /*offset16ID2,*/ pc4ID, branchOffSet;
	wire[31:0] branchAddress, pc2Out;

	//EX
	wire[4:0] rsEX, rtEX, rdEX, destRegEX;
	wire[0:`CONTROL_SIZE-1] controlEX;
	wire[31:0] rsValueEX, rtValueEX, rtValueEX1, offset16EX;
	wire[31:0] operating1, operating2, aluResultEX, pc4EX;
	wire[5:0]  opcodeEX;
	wire[3:0] aluControlOut;
	wire[1:0] forwardRS, forwardRT;

	//MEM
	wire[4:0] destRegMEM;
	wire[0:4] controlMEM;
	wire[31:0] aluResultMEM, writeData, memoryDataMEM, pc4MEM;

	// I/O
	wire readyRx0, readyRx1, busyTx0, busyTx1, tx0enable, tx1enable, clearRx0, clearRx1, memWriteUART, uart0toMem, uart1toMem;
	wire[7:0] writeDataUART0, writeDataUART1, rx0Data, rx1Data;
	wire wrenMemData, uart0DataSel, uart1DataSel;
	wire [`DATA_MEM_ADDR_SIZE-1:0] uart0address, uart1address;
	wire [31:0]  writeDataMem, writeDataUART0s, writeDataUART1s;	
	wire[`DATA_MEM_ADDR_SIZE-1:0] writeDataMemAddress;
	
	//WB
	wire[0:2] controlWB;
	wire[4:0] destRegWB;
	wire[31:0] destRegValueWB, memoryDataWB, aluResultWB, pc4WB;

	//adicional
	wire clkMem, clk, rst;
	assign clkMem = clock_50MHz;
	assign rst = PIN_Y17;
	
	//leds
	wire [7:0] LEDM_R_inv;
	assign LEDM_R = ~LEDM_R_inv;
	assign LEDM_C[0] = 1'b0; // enable col 0
	assign LEDM_C[4:1] = 4'b1111; // disable cols 1~5
	assign LEDM_R_inv = rx0Data;
	

	frequencyDivider divider(clock_50MHz,clk);

	pc pc(
		.enable (pcWrite),
		.nextpc (nextpc),
		.out (currentpc)
	);

	instructionMem instructionMem(		
		.address (currentpc[`INST_MEM_ADDR_SIZE-1:0]),
		.clk (clkMem),
		.q (instructionIF)
	);

	adder adderIF (
		.a (currentpc),
		.b (32'h00000001),
		.out (pc4IF)
	);

	mux2 #(.width (32)) mux2IF1(
		.a (pc2Out),
		.b (branchAddress),
		.sel (isBranch),
		.out (nextpc)
	);

	assign rstIDIF =  ((flushIFID != 1'bx) & (rst | flushIFID))? 1:0;

	IF_ID ifid(
		.rst (flushIFID),
		.clk (clk), 
		.pcIn (pc4IF), 
		.instIn (instructionIF), 
		.pcOut (pc4ID),
		.pc2Out (pc2Out), 
		.instOut (instructionID)
	);

	hazardDetection hazardDetection(
		.rs (instructionID[25:21]), 
		.rt (instructionID[20:16]), 
		.rtEX (rtEX),
		.memRead (controlEX[4]), 
		.isBranch (isBranch), 
		.pcWrite (pcWrite), 
		.ifIdFlush (flushIFID)
	);

	unitControl unitControl(
		.opcode (instructionID[31:26]),
		.func (instructionID[5:0]),
		.controlOut(controlID), 		
		.branchSrc (branchSrc),
		.compareCode (compareCode)
	);

	adder adderID (
		.a (pc4ID),
		.b (offset16ID1),//(offset16ID2),
		.out (branchOffSet)
	);
	//branchSrc
	mux3 #(.width (32)) mux3ID3(
		.a (branchOffSet),//branch
		.b ({pc4ID[31:26],instructionID[25:0]-26'd1048576}),//jump
		.c (rsValueID2),//jump r
		.sel (branchSrc),
		.out (branchAddress)
	);

	registerFile registerFile(
		.clk (clk), 
		.rst (rst), 
		.rs (instructionID[25:21]), 
		.rt (instructionID[20:16]),
		.rWriteValue (destRegValueWB), 
		.rWriteAddress (destRegWB), 
		.regWrite (controlWB[2]), 
		.rsData (rsValueID1), 
		.rtData (rtValueID1)
	);
	//fowardRS ID
	mux3 #(.width (32)) mux3ID1(
		.a (rsValueID1),
		.b (aluResultEX),
		.c (aluResultMEM),
		.sel (forwardRSID),
		.out (rsValueID2)
	);
	//fowardRT ID
	mux3 #(.width (32)) mux3ID2(
		.a (rtValueID1),
		.b (aluResultEX),
		.c (aluResultMEM),
		.sel (forwardRTID),
		.out (rtValueID2)
	);

	compare compare(
		.rs (rsValueID2), 
		.rt (rtValueID2), 
		.code (compareCode), 
		.isBranch (isBranch)
	);

	signEx16 signEx16(
		.in (instructionID[15:0]),
		.out (offset16ID1)
	);
	/*
	shiftLeft shiftLeft(
		.in (offset16ID1),
		.out (offset16ID2)
	);
	*/

	ID_EX idex(
		.rst (rst), 
		.clk (clk), 
		.opcodeIn (instructionID[31:26]), 
		.pcIn (pc4ID),
		.controlIn (controlID),  
		.rsValueIn (rsValueID1), 
		.rtValueIn (rtValueID1), 
		.offset16In (offset16ID1), 
		.rsIn (instructionID[25:21]),
		.rtIn (instructionID[20:16]), 
		.rdIn (instructionID[15:11]), 
		.opcodeOut (opcodeEX), 
		.pcOut (pc4EX),
		.controlOut (controlEX), 
		.rsValueOut (rsValueEX), 
		.rtValueOut (rtValueEX), 
		.offset16Out (offset16EX), 
		.rsOut (rsEX), 
		.rtOut (rtEX), 
		.rdOut (rdEX)
	);
	//rsForward no EX
	mux3 #(.width (32)) mux3EX1(
		.a (rsValueEX),
		.b (aluResultMEM),
		.c (destRegValueWB),
		.sel (forwardRS),
		.out (operating1)
	);
	//rtForward no EX
	mux3 #(.width (32)) mux3EX2(
		.a (rtValueEX),
		.b (aluResultMEM),
		.c (destRegValueWB),
		.sel (forwardRT),
		.out (rtValueEX1)
	);
	//RegDest
	mux3 #(.width (5)) mux3EX3(
		.a (rdEX),
		.b (rtEX),
		.c (5'b11111),//ra
		.sel (controlEX[5:6]),
		.out (destRegEX)
	);
	//aluSrc
	mux2 #(.width (32)) mux2EX1 (
		.a (offset16EX),
		.b (rtValueEX1),
		.sel (controlEX[7]),
		.out (operating2)
	);

	alu alu (
		.a (operating1),
		.b (operating2),
		.sel (aluControlOut), //sinal que vem da aluControl
		.result (aluResultEX)
	);

	aluControl aluControl (
		.opcode (opcodeEX),
		.funct (offset16EX[31:26]),
		.aluOp (aluControlOut)
	);

	forwardingUnit forwardUnit (
		.rs (rsEX), 
		.rt (rtEX),
		.rsID (instructionID[25:21]), 
		.rtID (instructionID[20:16]), 
		.destRegEX (destRegEX),
		.destRegMEM (destRegMEM), 
		.destRegWB (destRegWB), 
		.regWriteEX (controlEX[2]),
		.regWriteMEM (controlMEM[2]), 
		.regWriteWB (controlWB[2]), 
		.forwardRS (forwardRS), 
		.forwardRT (forwardRT),
		.forwardRSID (forwardRSID), 
		.forwardRTID (forwardRTID)
	);

	EX_MEM exmem (
		.rst (rst), 
		.clk (clk), 
		.controlIn (controlEX[0:4]), 
		.pcIn (pc4EX),
		.aluResultIn (aluResultEX), 
		.rtValueIn (rtValueEX1), 
		.destRegIn (destRegEX), 
		.controlOut (controlMEM),
		.pcOut (pc4MEM),
		.aluResultOut (aluResultMEM),
		.rtValueOut (writeData),
		.destRegOut (destRegMEM)
	);
	// ---------------  I/O  --------------

	arbiter arbiter(
		.clk (clk),
		.address (aluResultMEM[`DATA_MEM_ADDR_SIZE-1:0]), 
		.memReadCPU (controlMEM[4]), 
		.memWriteCPU (controlMEM[3]), 
		.readyRx0 (readyRx0), 
		.readyRx1 (1'b0),//(readyRx1), 
		.uart0toMem (uart0toMem),
		.uart1toMem (uart1toMem),
		.busyTx0 (busyTx0), 
		.busyTx1 (1'b0),//(busyTx1),
		.memWriteOut (memWriteUART), 
		.tx0enable (tx0enable), 
		.tx1enable (tx1enable),
		.uart0address (uart0address),
		.uart1address (uart1address),
		.uart0DataSel (uart0DataSel), 
		.uart1DataSel (uart1DataSel)
	);

	uart uart0(
		.clk (clk),
		.txData (writeData[7:0]), 	//dado pra ser transmitido no tx	
		.txEnable (tx0enable), 		//ativa o tx pra iniciar a transmicao
		.rx (UART_Rx),				//da placa
		.rxClear (uart0toMem),			//reinicia o rx
		.tx (UART_Tx),				//para a placa
		.tx_busy (busyTx0),		//tx ocupado	
		.rxReady (readyRx0),		//flag de dado recebido, pronto pra passar para memoria
		.rxDataOut (rx0Data) 	//dado recebido
	);

	uart uart1(
		.clk (clk),
		.txData (writeData[7:0]), 	//dado pra ser transmitido no tx	
		.txEnable (tx1enable), 		//ativa o tx pra iniciar a transmicao
		.rx (PIN_E11),				//da placa
		.rxClear (uart1toMem),			//reinicia o rx
		.tx (PIN_F11),				//para a placa
		.tx_busy (busyTx1),		//tx ocupado	
		.rxReady (readyRx1),		//flag de dado recebido, pronto pra passar para memoria
		.rxDataOut (rx1Data) 	//dado recebido
	);
	
	assign wrenMemData = (memWriteUART | controlMEM[3])? 1:0;

	mux2 #(.width (8)) mux2MEM1 (
		.a (rx0Data),
		.b (8'h0c),
		.sel (uart0DataSel),
		.out (writeDataUART0)
	);

	signEx8 signExMEM1(
		.in (writeDataUART0),
		.out (writeDataUART0s)
	);

	mux2 #(.width (8)) mux2MEM2 (
		.a (rx1Data),
		.b (8'h0c),
		.sel (uart1DataSel),
		.out (writeDataUART1)
	);

	signEx8 signExMEM2(
		.in (writeDataUART1),
		.out (writeDataUART1s)
	);

	mux3 #(.width (32)) mux3MEM1(
		.a (writeData),
		.b (writeDataUART0s),
		.c (writeDataUART1s),
		.sel ({uart1toMem, uart0toMem}),
		.out (writeDataMem)
	);

	mux3 #(.width (`DATA_MEM_ADDR_SIZE)) mux3MEM2(
		.a (aluResultMEM[`DATA_MEM_ADDR_SIZE-1:0]),
		.b (uart0address),//rx
		.c (uart1address),
		.sel ({uart1toMem, uart0toMem}),
		.out (writeDataMemAddress)
	);
	// ------------------------------------

	dataMem dataMem (
		.clk (clkMem), 
		.address (writeDataMemAddress), 
		.data (writeDataMem), 
		.wren (wrenMemData), 
		.rden (controlMEM[4]), 
		.q (memoryDataMEM)
	);

	MEM_WB memwb(
		.rst (rst), 
		.clk (clk), 
		.controlIn (controlMEM[0:2]), 
		.pcIn (pc4MEM),
		.memDataIn (memoryDataMEM), 
		.aluResultIn (aluResultMEM), 
		.destRegIn (destRegMEM), 
		.controlOut (controlWB),
		.pcOut (pc4WB), 
		.memDataOut (memoryDataWB), 
		.aluResultOut (aluResultWB),
		.destRegOut (destRegWB)
	);
	//regSrc
	mux3 #(.width (32)) mux3WB(
		.a (aluResultWB),
		.b (memoryDataWB),
		.c (pc4MEM),
		.sel (controlWB[0:1]),
		.out (destRegValueWB)
	);

endmodule