/*************************************************************
 * Module: mips32TOP
 * Project: mips32
 * Description: Top Level do projeto, conecta todos o modulos
 ************************************************************/
`include "parameters.v"

module mips32TOP(clk,rst);
	input clk, rst;

	wire rstIFID, rstIDEX, rstEXMEM, flushIFID;
	or(rstIFID, rst, flushIFID);//um and com rst da placa e os comandos de flush pro ifid;
	//wires... wires everwhere

	//interStages
	wire isBranch;
	//IF
	wire[31:0] nextpc, currentpc, instructionIF, instructionIF1, pc4IF; 
	
	wire pcWrite;
	//ID
	wire[`CONTROL_SIZE-1:0] controlID;	
	wire[1:0] forwardRSID, forwardRTID, branchSrc;
	wire[2:0] compareCode;
	wire isJump, jumpStall;
	wire[31:0] instructionID, rsValueID1, rtValueID1, rsValueID2, rtValueID2, offset16ID1, offset16ID2, pc4ID, branchOffSet, branchAddress;
	//EX
	wire[4:0] rsEX, rtEX, rdEX, destRegEX;
	wire[`CONTROL_SIZE-1:0] controlEX;
	wire[31:0] opcodeEX, rsValueEX, rtValueEX, rtValueEX1, offset16EX;
	wire[31:0] operating1, operating2, aluResultEX;
	wire[5:0] aluControlOut;
	wire[1:0] forwardRS, forwardRT;
	//MEM
	wire[4:0] destRegMEM;
	wire[3:0] controlMEM;
	wire[31:0] aluResultMEM, writeData, aluResultMEM, memoryDataMEM;
	
	//WB
	wire[1:0] controlWB;
	wire[4:0] destRegWB;
	wire[31:0] destRegValueWB, memoryDataWB, aluResultWB;

	PC pc(
		.enable (pcWrite),
		.nextpc (nextpc),
		.out (currentpc)
	);

	instructionMem instructionMem(
		.rst (rst),
		.address (currentpc),
		.instruction (instructionIF)
	);

	adder adderIF (
		.a (currentpc),
		.b (32'd4),
		.out (pc4IF)
	);

	mux2 #(.width (32)) mux2IF1(
		.a (branchAddress),
		.b (pc4IF),
		.sel (isBranch),
		.out (nextpc)
	);

	mux2 #(.width (32)) mux2IF2(
		.a (instructionIF),
		.b (`NOP),
		.sel (jumpStall),
		.out (instructionIF1)
	);

	IF_ID ifid(
		.rst (rstIFID), 
		.clk (clk), 
		.pcIn (pc4IF), 
		.instIn (instructionIF1), 
		.pcOut (pc4ID), 
		.instOut (instructionID)
	);

	hazardDetection hazardDetection(
		.rs (instructionID[25:21]), 
		.rt (instructionID[20:16]), 
		.rtEX (rtEX),
		.memRead (controlEX[2]), 
		.isBranch (isBranch), 
		.isJump (isJump),  
		.pcWrite (pcWrite), 
		.jumpStall (jumpStall), 
		.ifIdFlush (flushIFID)
	);

	unitControl unitControl(
		.opcode (instructionID[31:26]),
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
		.b ({pc4ID[31,26] instructionID[25,0]),//jump
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
		.regWrite (controlWB[1]), 
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
		.rst (rstIDEX), 
		.clk (clk), 
		.opcodeIn (instructionID[31:26]), 
		.controlIn (controlID),  
		.rsValueIn (rsValueID1), 
		.rtValueIn (rtValueID1), 
		.offset16In (offset16ID), 
		.rsIn (instructionID[25:21]),
		.rtIn (instructionID[20:16]), 
		.rdIn (instructionID[15:11]), 
		.opcodeOut (opcodeEX), 
		.controlOut (controlEX), 
		.rsValueOut (rsValueEX), 
		.rtValueOut (rtValueEX), 
		.offset16Out (offset16EX), 
		.rsOut (rsEX), 
		.rtOut (rtEX), 
		.rdOut (rdEX)
	);

	mux3 #(.width (32)) mux3EX1(
		.a (rsValueEX),
		.b (destRegValueWB),
		.c (aluResultMEM),
		.sel (forwardRS),
		.out (operating1)
	);

	mux3 #(.width (32)) mux3EX2(
		.a (rtValueEX),
		.b (destRegValueWB),
		.c (aluResultMEM),
		.sel (forwardRT),
		.out (rtValueEX1)
	);

	mux3 #(.width (5)) mux3EX3(
		.a (rtEX),
		.b (rdEX),
		.c (5'b11111),
		.sel (controlEX[5:4]),
		.out (destRegEX)
	);

	mux2 #(.width (32)) mux2EX1 (
		.a (rtValueEX1),
		.b (offset16EX),
		.sel (controlEX[6]),
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
		.aluControlOut (aluControlOut)
	);

	forwardUnit forwardUnit (
		.rs (rsEX), 
		.rt (rtEX),
		.rsID (instructionID[25:21]), 
		.rtID (instructionID[20:16]), 
		.destRegEX (destRegEX),
		.destRegMEM (destRegMEM), 
		.destRegWB (destRegWB), 
		.regWriteEX (controlEX[1]),
		.regWriteMEM (controlMEM[1]), 
		.regWriteWB (controlWB[1]), 
		.forwardRS (forwardRS), 
		.forwardRT (forwardRT),
		.forwardRS (forwardRSID), 
		.forwardRT (forwardRTID)
	);

	EX_MEM exmem (
		.rst (rstEXMEM), 
		.clk (clk), 
		.controlIn (controlEX[3:0]), 
		.aluResultIn (aluResultEX), 
		.rtValueIn (rtValueEX1), 
		.destRegIn (destRegEX), 
		.controlOut (controlMEM), 
		.aluResultOut (aluResultMEM),
		.rtValueOut (writeData),
		.destRegOut (destRegMEM)
	);

	dataMem dataMem (
		.clk (clk), 
		.rst (rst), 
		.address (aluResultMEM), 
		.writeData (writeData), 
		.write (controlMEM[2]), 
		.read (controlMEM[3]), 
		.dataOut (memoryDataMEM)
	);

	MEM_WB memwb(
		.rst (rst), 
		.clk (clk), 
		.controlIn (controlMEM[1:0]), 
		.memDataIn (memoryDataMEM), 
		.aluResultIn (aluResultMEM), 
		.destRegIn (destRegMEM), 
		.controlOut (controlWB), 
		.memDataOut (memoryDataWB), 
		.aluResultOut (aluResultWB),
		.destRegOut (destRegWB)
	);

	mux2 #(.width (32)) mux2WB(
		.a (memoryDataWB),
		.b (aluResultWB),
		.sel (controlWB[0]),
		.out (destRegValueWB)
	);


endmodule