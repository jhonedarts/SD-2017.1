/*************************************************************
 * Module: mips32TOP
 * Project: mips32
 * Description: Top Level do projeto, conecta todos o modulos
 ************************************************************/
`include "parameters.v"

module mips32TOP(clk,rst,memWr, memRd,memAddr, memDataIn, brDataIn, brAddr, brWrite, isBrnch, compCode, brancSrc);
	input clk, rst;
	output memWr, memRd, brWrite, isBrnch;
	output reg [31:0] memAddr, memDataIn,  brDataIn;
	output reg [4:0] brAddr;
	output reg [1:0] compCode, brancSrc;

	assign memWr = controlMEM[3];
	assign memRd = controlMEM[2];
	assign memDataIn = writeData;
	assign memAddr = aluResultMEM[`DATA_MEM_ADDR_SIZE-1:0];
	assign brDataIn = destRegValueWB;
	assign brAddr = destRegWB;
	assign brWrite = controlWB[2];
	assign isBrnch = isBranch;	
	assign compCode = compareCode;
	assign brancSrc = branchSrc;
	
	wire rstIFID, flushIFID;
	or(rstIFID, rst, flushIFID);//um and com rst da placa e os comandos de flush pro ifid;
	//wires... wires everwhere

	//interStages
	wire isBranch;
	//IF
	wire[31:0] nextpc, currentpc, instructionIF, pc4IF; 
	
	wire pcWrite;
	//ID
	wire[`CONTROL_SIZE-1:0] controlID;	
	wire[1:0] forwardRSID, forwardRTID, branchSrc, compareCode;
	wire[31:0] instructionID, rsValueID1, rtValueID1, rsValueID2, rtValueID2, offset16ID1, offset16ID2, pc4ID, branchOffSet;
	wire[31:0] branchAddress;
	//EX
	wire[4:0] rsEX, rtEX, rdEX, destRegEX;
	wire[`CONTROL_SIZE-1:0] controlEX;
	wire[31:0] opcodeEX, rsValueEX, rtValueEX, rtValueEX1, offset16EX;
	wire[31:0] operating1, operating2, aluResultEX, pc4EX;
	wire[5:0] aluControlOut;
	wire[1:0] forwardRS, forwardRT;
	//MEM
	wire[4:0] destRegMEM;
	wire[4:0] controlMEM;
	wire[31:0] aluResultMEM, writeData, memoryDataMEM, pc4MEM;
	
	//WB
	wire[2:0] controlWB;
	wire[4:0] destRegWB;
	wire[31:0] destRegValueWB, memoryDataWB, aluResultWB, pc4WB;	


	PC pc(
		.enable (pcWrite),
		.nextpc (nextpc),
		.out (currentpc)
	);

	instructionMem instructionMem(		
		.address (currentpc[`INST_MEM_ADDR_SIZE-1:0]),
		.clock (clk),
		.q (instructionIF)
	);

	adder adderIF (
		.a (currentpc),
		.b (32'h00000004),
		.out (pc4IF)
	);

	mux2 #(.width (32)) mux2IF1(
		.a (branchAddress),
		.b (pc4IF),
		.sel (isBranch),
		.out (nextpc)
	);

	IF_ID ifid(
		.rst (rstIFID), 
		.clk (clk), 
		.pcIn (pc4IF), 
		.instIn (instructionIF), 
		.pcOut (pc4ID), 
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
		.isJump (isJump),
		.branchSrc (branchSrc),
		.compareCode (compareCode)
	);

	adder adderID (
		.a (pc4ID),
		.b (offset16ID2),
		.out (branchOffSet)
	);

	mux3 #(.width (32)) mux3ID3(
		.a (branchOffSet),//branch
		.b ({pc4ID[31:26],instructionID[25:0]}),//jump
		.c (rsValueID2),//jump r
		.sel (branchSrc),
		.out (branchAddress)
	);

	registerFile registerFile(
		.clk (clk), 
		.rst (rst), 
		.rs (instructionID[25:21]), 
		.rt (instructionID[20:16]),
		.rWriteValue (destReg), 
		.rWriteAddress (destRegValueWB), 
		.regWrite (controlWB[2]), 
		.rsData (rsValueID1), 
		.rtData (rtValueID1)
	);

	mux3 #(.width (32)) mux3ID1(
		.a (rsValueID1),
		.b (aluResultEX),
		.c (aluResultMEM),
		.sel (forwardRSID),
		.out (rsValueID2)
	);

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

	shiftLeft shiftLeft(
		.in (offset16ID1),
		.out (offset16ID2)
	);

	ID_EX idex(
		.rst (rst), 
		.clk (clk), 
		.opcodeIn (instructionID[31:26]), 
		.pcIn (pc4ID),
		.controlIn (controlID),  
		.rsValueIn (rsValueID1), 
		.rtValueIn (rtValueID1), 
		.offset16In (offset16ID), 
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
		.b (destRegValueWB),
		.c (aluResultMEM),
		.sel (forwardRS),
		.out (operating1)
	);
	//rtForward no EX
	mux3 #(.width (32)) mux3EX2(
		.a (rtValueEX),
		.b (destRegValueWB),
		.c (aluResultMEM),
		.sel (forwardRT),
		.out (rtValueEX1)
	);
	//RegDest
	mux3 #(.width (5)) mux3EX3(
		.a (rdEX),
		.b (rtEX),
		.c (5'b11111),//ra
		.sel (controlEX[6:5]),
		.out (destRegEX)
	);

	mux2 #(.width (32)) mux2EX1 (
		.a (rtValueEX1),
		.b (offset16EX),
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
		.controlIn (controlEX[4:0]), 
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

	dataMem dataMem (
		.clock (clk), 
		.address (aluResultMEM[`DATA_MEM_ADDR_SIZE-1:0]), 
		.data (writeData), 
		.wren (controlMEM[3]), 
		.rden (controlMEM[2]), 
		.q (memoryDataMEM)
	);

	MEM_WB memwb(
		.rst (rst), 
		.clk (clk), 
		.controlIn (controlMEM[2:0]), 
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

	mux3 #(.width (32)) mux3WB(
		.a (memoryDataWB),
		.b (aluResultWB),
		.c (pc4MEM),
		.sel (controlWB[1:0]),
		.out (destRegValueWB)
	);


endmodule