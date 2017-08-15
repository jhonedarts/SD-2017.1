module SoC(reset, clk, rx, tx, c, r);

	input reset, clk, rx;
	output tx;
	output[4:0] c;
	output[7:0] r;

	wire dividedClk;
	FrequencyDivider divider(clk,dividedClk);

	//MEMORY-------------------------------------------------------
	wire[31:0] MEM_address, MEM_readData;
	wire [31:0] MEM_data_out1, MEM_data_out2;
	wire [31:0] SELECT_CORRECTOR_out;
	//-------------------------------------------------------------
	
	//IF-----------------------------------------------------------
	//PC
	wire[31:0] PC_in, PC_out;
	
	//IF/ID
	wire[31:0] IFID_instOut, IFID_pcPlusOut, PCPlus;
	//-------------------------------------------------------------

	//ID-----------------------------------------------------------
	//Mux
	wire[31:0] UC_MUX_out, MUX_IDEXRd_out, MUX_JUMP_out;
	
	//HAZARD DETECTION
	wire HDU_IFIDwrite;

	//GPR
	wire[31:0] GPR_rd1, GPR_rd2;
	
	//REG COMP
	wire COMP_result;

	//SIGN EXTEND
	wire[31:0] SIGNE_immediate;

	//UC
	wire UC_jump, UC_branch, UC_jal, UC_jr;
	wire[13:0] UC_microcode;
	
	//ID/EX
	wire[2:0] IDEX_WBout;
	wire[2:0] IDEX_Mout;
	wire[7:0] IDEX_EXout;
	wire[31:0] IDEX_Data1out, IDEX_Data2out, IDEX_immOut, IDEX_PCplusOut;
	wire[4:0] IDEX_RsOut, IDEX_RtOut, IDEX_RdOut;
	//-------------------------------------------------------------
	
	//EX-----------------------------------------------------------
	//Muxs
	wire[31:0] MUX_FBout, MUX_FCout, MUX_FDout, MUX_EXflushWB_out, MUX_EXflushM_out, MUX_RD_out;
	
	//FORWARD UNIT
	wire [1:0] ForwardA_out, ForwardB_out, ForwardC_out, ForwardD_out;
	
	//ALU
	wire[31:0] ALU_A, ALU_B, ALU_result;
	wire[3:0] ALU_operation;
	wire ALU_zeroFlag, ALU_overflowFlag;

	//EX/MEM
	wire[31:0] EXMEM_ALUresultOut, EXMEM_writeDataOut, EXMEM_PCplusOut;
	wire[4:0] EXMEM_RdOut;
	wire[2:0] EXMEM_Mout;
	wire[2:0] EXMEM_WBout;
	//-------------------------------------------------------------

	//WB----------------------------------------------------------
	//Mux
	wire[31:0] MUX_ReturnDataOut;
	
	//MEM/WB
	wire[2:0] MEMWB_WBout;
	wire[31:0] MEMWB_memDataOut, MEMWB_PCplusOut, MEMWB_ALUresultOut;
	wire[4:0] MEMWB_RdOut;
	//-------------------------------------------------------------
	
	wire[31:0] UART_dataOut, IO_dataOut, IO_address0, IO_writeData0, IO_address1, IO_writeData1;
	wire IO_writeControl1, IO_writeControl0, txd;

	IOmodule IO(
		.address(MEM_address),
		.write_data(EXMEM_writeDataOut),
		.write_control(EXMEM_Mout[0]),
		.data_out(IO_dataOut),
		.address0(IO_address0),
		.write_data0(IO_writeData0),
		.write_control0(IO_writeControl0),
		.data_out0(UART_dataOut),
		.address1(IO_address1),
		.write_data1(IO_writeData1),
		.write_control1(IO_writeControl1),
		.data_out1(MEM_readData)
	);

	InterfaceSerial UART(
		.reset(reset),
		.clk(dividedClk),
		.data_in(IO_writeData0),
		.control(IO_writeControl0),
		.rx(rx),
		.tx(txd),
		.data_out(UART_dataOut)
	);

	
	//Creates Memory
	memory MEMORY(
		.clk(~clk),
		.address(IO_address1[13:0]), 
		.data_out(MEM_readData), 
		.write_data(IO_writeData1), 
		.mem_write(IO_writeControl1)
	);
	
	//Creates the mux to mem address bus
	mux2_1 MUX_MEM(
		.A(PC_out),
		.B(EXMEM_ALUresultOut),
		.Sel(SELECT_CORRECTOR_out[0]),
		.out(MEM_address)
	);
	
	//Creates the mux to mem data bus
	demux1_2 DEMUX_MEM(
		.data_in(IO_dataOut),
		.Sel(SELECT_CORRECTOR_out[0]),
		.data_out1(MEM_data_out1),
		.data_out2(MEM_data_out2)
	);

	dontCare_corrector SELECT_CORRECTOR(
		.in({{31{EXMEM_Mout[0] | EXMEM_Mout[1]}}, EXMEM_Mout[0] | EXMEM_Mout[1]}), 
		.out(SELECT_CORRECTOR_out)
	);
	
	//IF blocks--------------------------------------------------------
	//Mux address to jump
	mux2_1 MUX_JUMP(
		.A({6'b0, IFID_instOut[25:0]}),
		.B(GPR_rd1),
		.Sel(UC_jr),
		.out(MUX_JUMP_out)
	);
	
	//Creates PC MUX
	mux4_1 MUX_PC(
		.A(IFID_pcPlusOut),
		.B(MUX_JUMP_out),
		.C((IFID_pcPlusOut - 1'b1) + $signed(SIGNE_immediate)),
		.D(32'bx),
		.Sel({(UC_branch&COMP_result), UC_jump}),
		.out(PC_in)
	);

	dontCare_corrector PC_CORRECTOR(
		.in(PCPlus), 
		.out(IFID_pcPlusOut)
	);

	//Creates PC
	PC PC(
		.enable(HDU_IFIDwrite),
		.data_in(PC_in),
		.address (PC_out)
	);

	//Creates IF/ID
	IFID IFID(
		.reset(reset),
		.clk(dividedClk),
		.IFIDWrite(HDU_IFIDwrite),
		.PCplus_in(PC_out + 1),
		.Inst_in(MEM_data_out1),
		.Inst_out(IFID_instOut),
		.PCplus_out(PCPlus)
	);
	
	//ID blocks--------------------------------------------------------
	HDU HAZARD(
		.reset(reset),
		.IDEX_memRead(EXMEM_Mout[1] | EXMEM_Mout[0] | IDEX_Mout[1] | IDEX_Mout[0]), 
		.ID_BranchOrJump(IDEX_Mout[2]),
		.IFID_write(HDU_IFIDwrite)
	);

	//Creates GPR
	GPR GPR(
		.reset(reset),
		.clk(dividedClk),
		.read_register1 (IFID_instOut[25:21]),
		.read_register2 (IFID_instOut[20:16]),
		.write_register (MEMWB_RdOut),
		.r_data1 (GPR_rd1),
		.r_data2 (GPR_rd2),
		.w_data (MUX_ReturnDataOut),
		.regWrite (MEMWB_WBout[1])
	);
	
	//Creates REG COMPARATOR
	comparator BRANCH_COMP	(
		.A(MUX_FCout),
		.B(MUX_FDout),
		.equal(~IFID_instOut[26]),
		.result(COMP_result)
	);
	
	//Creates SIGN EXTENDS
	signExtend SE(
		.in(IFID_instOut[15:0]), 
		.out(SIGNE_immediate)
	);

	//Creates UC
	UC UC(
		.reset(reset),		
		.opcode(IFID_instOut[31:26]),
		.funct(IFID_instOut[5:0]), 
		.jump_flag(UC_jump),
		.branch_flag(UC_branch),  
		.jal_flag(UC_jal), 
		.jr_flag(UC_jr), 
		.microcode(UC_microcode)
	);

	//Creates UC MUX ID
	mux2_1 MUX_IDflush(
		.A({18'b0, UC_microcode}),
		.B(32'b0),
		.Sel(~HDU_IFIDwrite),
		.out(UC_MUX_out)
	);
	
	//Creates RD to EX
	mux2_1 MUX_IDEXRd(
		.A({27'b0, IFID_instOut[15:11]}),
		.B(32'b11111),
		.Sel(UC_jal),
		.out(MUX_IDEXRd_out)
	);

	//Creates ID/EX
	IDEX IDEX(
		.clk (dividedClk),
		.PCplus(PCPlus),
		.WB(UC_MUX_out[13:11]),
		.M({UC_MUX_out[10]&(UC_jump|COMP_result), UC_MUX_out[9:8]}),
		.EX(UC_MUX_out[7:0]),
		.Data1(MUX_FCout),
		.Data2(MUX_FDout),
		.imm(SIGNE_immediate),
		.Rs(IFID_instOut[25:21]),
		.Rt(IFID_instOut[20:16]),
		.Rd(MUX_IDEXRd_out[4:0]),
		.PCplus_out(IDEX_PCplusOut),
		.WB_out(IDEX_WBout),
		.M_out(IDEX_Mout),
		.EX_out(IDEX_EXout),
		.Data1_out(IDEX_Data1out),
		.Data2_out(IDEX_Data2out),
		.imm_out(IDEX_immOut),
		.Rs_out(IDEX_RsOut),
		.Rt_out(IDEX_RtOut),
		.Rd_out(IDEX_RdOut)
	);
	
	//EX blocks--------------------------------------------------------
	//Creates RD_MUX
	mux2_1 MUX_RD(
		.A({27'b0, IDEX_RtOut}),
		.B({27'b0, IDEX_RdOut}),
		.Sel(IDEX_EXout[6]),
		.out(MUX_RD_out)
	);
	
	//Creates FORWARD UNIT
	FU FORWARDING_UNIT(
		.reset(reset),
		.IDEX_Rs(IDEX_RsOut), 
		.IDEX_Rt(IDEX_RtOut), 
		.EXMEM_Rd(EXMEM_RdOut),
		.UC_Branch(UC_branch),
		.IFID_Rs(IFID_instOut[25:21]),
		.IFID_Rt(IFID_instOut[20:16]),
		.IDEX_Rd(MUX_RD_out[4:0]),
		.IDEX_RegWriteWB(IDEX_WBout[1]), 
		.EXMEM_RegWriteWB(EXMEM_WBout[1]), 
		.MEMWB_Rd(MEMWB_RdOut), 
		.MEMWB_RegWriteWB(MEMWB_WBout[1]), 
		.ForwardA(ForwardA_out), 
		.ForwardB(ForwardB_out),
		.ForwardC(ForwardC_out), 
		.ForwardD(ForwardD_out)
	);

	//Creates MUX Forwarding A
	mux4_1 MUX_FA(
		.A(IDEX_Data1out),
		.B(MUX_ReturnDataOut),
		.C(EXMEM_ALUresultOut),
		.D(32'bx),
		.Sel(ForwardA_out),
		.out(ALU_A)
	);
	
	//Creates MUX Forwarding B
	mux4_1 MUX_FB(
		.A(IDEX_Data2out),
		.B(MUX_ReturnDataOut),
		.C(EXMEM_ALUresultOut),
		.D(32'bx),
		.Sel(ForwardB_out),
		.out(MUX_FBout)
	);

	//Creates MUX Forwarding C
	mux4_1 MUX_FC(
		.A(GPR_rd1),
		.B(MUX_ReturnDataOut),
		.C(EXMEM_ALUresultOut),
		.D(ALU_result),
		.Sel(ForwardC_out),
		.out(MUX_FCout)
	);

	//Creates MUX Forwarding D
	mux4_1 MUX_FD(
		.A(GPR_rd2),
		.B(MUX_ReturnDataOut),
		.C(EXMEM_ALUresultOut),
		.D(ALU_result),
		.Sel(ForwardD_out),
		.out(MUX_FDout)
	);

	//Creates ALU IMMEDIATE MUX
	mux2_1 MUX_IMMEDIATE(
		.A(MUX_FBout),
		.B(IDEX_immOut),
		.Sel(IDEX_EXout[7]),
		.out(ALU_B)
	);
	//Creates ALU DEC
	ALUdec ALUDEC(
		.funct(IDEX_immOut[5:0]), 
		.opcode(IDEX_EXout[5:0]), 
		.ALUop(ALU_operation)
	);
	
	//Creates ALU
	ALU ALU(
		.reset(reset),
		.clkACC(dividedClk),
		.A(ALU_A),
		.B(ALU_B),
		.ALUop(ALU_operation),
		.ALUresult(ALU_result), 
		.zero(ALU_zeroFlag), 
		.overflow(ALU_overflowFlag)
	);
	
	//Creates EX/MEM block
	EXMEM EXMEM(
		.clk (dividedClk),
		.PCplus(IDEX_PCplusOut),
		.WB (IDEX_WBout),
		.M (IDEX_Mout),
		.ALUresult(ALU_result),
		.Rd(MUX_RD_out[4:0]),
		.WriteData(MUX_FBout),
		.PCplus_out(EXMEM_PCplusOut),
		.M_out(EXMEM_Mout),
		.WB_out(EXMEM_WBout),
		.ALUresult_out(EXMEM_ALUresultOut),
		.Rd_out(EXMEM_RdOut),
		.WriteData_out(EXMEM_writeDataOut)
	);
	//M/WB blocks-----------------------------------------------------
	//Creates MEMWB
	MEMWB MEMWB(
		.clk (dividedClk),
		.PCplus(EXMEM_PCplusOut),
		.WB (EXMEM_WBout),
		.MemData(MEM_data_out2),
		.ALUresult(EXMEM_ALUresultOut),
		.Rd(EXMEM_RdOut),
		.PCplus_out(MEMWB_PCplusOut),
		.WB_out(MEMWB_WBout),
		.MemData_out(MEMWB_memDataOut),
		.ALUresult_out(MEMWB_ALUresultOut),
		.Rd_out(MEMWB_RdOut)
	);

	//Creates MUX_ReturnData
	mux4_1 MUX_ReturnData(
		.A(MEMWB_ALUresultOut),
		.B(MEMWB_memDataOut),
		.C(MEMWB_PCplusOut),
		.D(32'b00),
		.Sel({MEMWB_WBout[2],MEMWB_WBout[0]}),
		.out(MUX_ReturnDataOut)
	);
	//----------------------------------------------------------------
	
	assign c[0] = ~reset;
	assign r[0] = ~reset;
	assign c[4:1] = 4'b1111;
	assign r[7:1] = 7'b1111111;
	assign tx = txd;
endmodule
