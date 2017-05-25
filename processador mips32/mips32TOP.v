/*************************************************************
 * Module: mips32TOP
 * Project: mips32
 * Description: Top Level do projeto, conecta todos o modulos
 ************************************************************/
`include "parameters.v"

module mips32TOP(clk,rst);
	input clk, rst;

	wire rstIFID, rstIDEX, EXMEM, flushIFID, flushIDEX, flushEXMEM;
	assign rstIFID = and (rst, flushIFID);//um and com rst da placa e os comandos de flush pro ifid;
	assign rstIDEX = and (rst, flushIDEX);
	assign rstEXMEM = and (rst, flushEXMEM);
	//wires... wires everwhere

	//interStages
	wire isBranch;
	//IF
	wire[31:0] nextpc, currentpc, instructionIF, instructionIF1, pc4IF; 
	
wire pcWrite;
	//ID
	wire[`CONTROL_SIZE-1:0] controlID;
	wire isJump, jumpStall;
	wire[31:0] instructionID, rsValueID, rtValueID, offset16ID, offset26ID, pc4ID;
	//EX
	wire[4:0] rsEX, rtEX, rdEX, destRegEX;
	wire[`CONTROL_SIZE-1:0] controlEX;
	wire[31:0] pc4EX, opcodeEX, rsValueEX, rtValueEX, rtValueEX1, offset16EX, offset26EX, offset16EX1, offset26EX1;
	wire[31:0] operating1, operating2, branchAddressEX1, branchAddressEX2, aluResultEX;
	wire[] aluControlOut;
	wire flagZeroEX;
	wire[1:0] forwardRS, forwardRT;
	//MEM
	wire flagZeroMEM;
	wire[4:0] controlMEM, destRegMEM;
	wire[31:0] destRegValueMEM, writeData, aluResultMEM, memoryDataMEM;
	
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

	mux2 #(.width 32) mux2IF1(
		.a (branchAddress)
		.b (pc4IF)
		.sel (isBranch)
		.out (nextpc)
	);

	mux2 #(.width 32) mux2IF2(
		.a (instructionIF)
		.b (`NOP)
		.sel (jumpStall)
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
		.memRead (controlEX[3]), 
		.isBranch (isBranch), 
		.isJump (isJump),  
		.pcWrite (pcWrite), 
		.jumpStall (jumpStall), 
		.ifIdFlush (flushIFID), 
		.idExFlush (flushIDEX), 
		.exMemFlush (flushEXMEM)
	);

	unitControl unitControl(
		.opcode (instructionID[31:26]),
		.controlOut(controlID), 
		.isJump (isJump)
	);

	registerFile registerFile(
		.clk (clk), 
		.rst (rst), 
		.rs (instructionID[25:21]), 
		.rt (instructionID[20:16]),
		.rWriteValue (destReg), 
		.rWriteAddress (destRegValueWB), 
		.regWrite (controlWB[1]), 
		.rsData (rsValueID), 
		.rtData (rtValueID)
	);

	signEx16 signEx16(
		.in (instructionID[15:0]),
		.out (offset16ID)
	);

	signEx26 signEx26(
		.in (instructionID[25:0]),
		.out (offset26ID)
	);

	ID_EX idex(
		.rst (rstIDEX), 
		.clk (clk), 
		.opcodeIn (instructionID[31:26]), 
		.controlIn (controlID), 
		.pcIn (pc4ID), 
		.rsValueIn (rsValueID), 
		.rtValueIn (rtValueID), 
		.offset16In (offset16ID), 
		.offset26In (offset26ID), 
		.rsIn (instructionID[25:21]),
		.rtIn (instructionID[20:16]), 
		.rdIn (instructionID[15:11]), 
		.opcodeOut (opcodeEX), 
		.controlOut (controlEX), 
		.pcOut (pc4EX), 
		.rsValueOut (rsValueEX), 
		.rtValueOut (rtValueEX), 
		.offset16Out (offset16EX), 
		.offset26Out (offset26EX), 
		.rsOut (rsEX), 
		.rtOut (rtEX), 
		.rdOut (rdEX)
	);

	mux3 #(.width 32) mux3EX1(
		.a (rsValueEX),
		.b (destRegValueWB),
		.c (destRegValueMEM),
		.sel (forwardRS),
		.out (operating1)
	);

	mux3 #(.width 32) mux3EX2(
		.a (rtValueEX),
		.b (destRegValueWB),
		.c (destRegValueMEM),
		.sel (forwardRT),
		.out (rtValueEX1)
	);

	mux3 #(.width 5) mux3EX3(
		.a (rtEX),
		.b (rdEX),
		.c (rsEX),
		.sel (controlEX[5:6]),
		.out (destRegEX)
	);

	shiftLeft shiftLeft(
		.in (offset16EX)
		.out (offset16EX1)
	);

	shiftLeft shiftLeft(
		.in (offset26EX)
		.out (offset26EX1)
	);

	mux2 #(.width 32) mux2EX1 (
		.a (rtValueEX1),
		.b (offset16EX1),
		.sel (controlEX[7]),
		.out (operating2)
	);

	adder adderEX (
		.a (offset16EX1),
		.b (pc4EX),
		.out (branchAddressEX1)
	);

	mux3 #(.width 32) mux3EX4 (
		.a (branchAddressEX1),
		.b (offset26EX1),
		.c (operating1),
		.sel (controlEX[8:9]),
		.out (branchAddressEX2)
	);

	alu alu (
		.a (operating1),
		.b (operating2),
		.sel (aluControlOut), //sinal que vem da aluControl
		.flagZero (flagZeroEX),
		.result (aluResultEX)
	);

	aluControl aluControl (
		.opcode (opcodeEX),
		.function (offset16EX[26:31]),
		.aluControlOut (aluControlOut)
	);

	forwardUnit forwardUnit (
		.rs (rsEX), 
		.rt (rtEX), 
		.destRegMEM (destRegMEM), 
		.destRegWB (destRegWB), 
		.regWriteMEM (controlMEM[1]), 
		.regWriteWB (controlWB[1]), 
		.forwardRS (forwardRS), 
		.forwardRT (forwardRT)
	);

	EX_MEM exmem (
		.rst (rstEXMEM), 
		.clk (clk), 
		.flagZeroIn (flagZeroEX), 
		.controlIn (controlEX[0:4]), 
		.branchAddressIn (branchAddressEX2), 
		.aluResultIn (aluResultEX), 
		.rtValueIn (rtValueEX1), 
		.destRegIn (destRegEX), 
		.flagZeroOut (flagZeroMEM), 
		.controlOut (controlMEM), 
		.branchAddressOut (branchAddress), 
		.aluResultOut (aluResultMEM),
		.rtValueOut (writeData),
		.destRegOut (destRegMEM)
	);

	assign isBranch = and(flagZeroMEM, controlMEM[2]) ;

	dataMem dataMem (
		.clk (clk), 
		.rst (rst), 
		.address (aluResultMEM), 
		.writeData (writeData), 
		.write (controlMEM[3]), 
		.read (controlMEM[4]), 
		.dataOut (memoryDataMEM)
	);

	MEM_WB memwb(
		.rst (rst), 
		.clk (clk), 
		.controlIn (controlMEM[0:1]), 
		.memDataIn (memoryDataMEM), 
		.aluResultIn (aluResultMEM), 
		.destRegIn (destRegMEM), 
		.controlOut (controlWB), 
		.memDataOut (memoryDataWB), 
		.aluResultOut (aluResultWB)
		.destRegOut (destRegWB)
	);

	mux2 #(.width 32) mux2WB(
		.a (memoryDataWB),
		.b (aluResultWB),
		.sel (controlWB[0]),
		.out (destRegValueWB)
	);


endmodule