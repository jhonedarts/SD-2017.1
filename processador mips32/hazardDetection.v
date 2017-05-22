/***************************************************
 * Module: HazardDetection
 * Project: mips32
 * Description: Responsavel por gerar uma bolha entre 
 * uma instrucao que usa um valor que vai ser carregado
 * na instrucao anterior. Tambem gera as bolhas necessarias
 * quando um desvio é tomado.
 ***************************************************/

module hazardDetection(rs, rt, rtEx, memRead, isBranch, pcWrite, idExFlush, exMemFlush);
	input reg[4:0] rs, rt, rtEx;
	input memRead, isBranch;
	output pcWrite, idExFlush, exMemFlush;

	//uso de um registrador que vai ser alterado por um lw
	assign pcWrite = (memRead==1'b1 && (rs==rtEx || rt==rtEx))? 1'b0 : 1'b1;

	//branch
	assign idExFlush = (isBranch)? 1'b1 : 1'b0;
	assign exMemFlush = (isBranch)? 1'b1 : 1'b0;

endmodule