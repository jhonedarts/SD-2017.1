/***************************************************
 * Module: HazardDetection
 * Project: mips32
 * Description: Responsavel por gerar uma bolha entre 
 * uma instrucao que usa um valor que vai ser carregado
 * na instrucao anterior. Tambem gera as bolhas necessarias
 * quando um desvio é tomado.
 ***************************************************/

module hazardDetection(rs, rt, rtEx, memRead, isBranch, isJump, pcWrite, jumpStall, ifIdFlush, idExFlush, exMemFlush);
	input reg[4:0] rs, rt, rtEx;
	input memRead, isBranch, isJump;
	output pcWrite, jumpStall, ifIdFlush, idExFlush, exMemFlush;

	initial begin
	    pcWrite =1'b1;
	    jumpStall =1'b0;
	end

	//uso de um registrador que vai ser alterado por um lw
	assign pcWrite = (memRead==1'b1 && (rs==rtEx || rt==rtEx))? 1'b0 : 1'b1;

	//branch
	assign idExFlush = (isBranch)? 1'b1 : 1'b0;
	assign exMemFlush = (isBranch)? 1'b1 : 1'b0;
	assign ifIdFlush = (isBranch)? 1'b1 : 1'b0;

	//jump detectado no id
	assign jumpStall = (isJump)? 1'b1;//ativa as bolhas no if
	assign pcWrite = (isJump)? 1'b0;//trava o pc
	//jump tomado no mem
	assign jumpStall = (isBranch)? 1'b0;//desativa as bolhas no if
	assign pcWrite = (isBranch)? 1'b1;//destrava o pc


endmodule