/***************************************************
 * Module: HazardDetection
 * Project: mips32
 * Description: Responsavel por gerar uma bolha entre 
 * uma instrucao que usa um valor que vai ser carregado
 * na instrucao anterior. Tambem gera as bolhas necessarias
 * quando um desvio é tomado.
 ***************************************************/

module hazardDetection(rs, rt, rtEX, memRead, isBranch, pcWrite, ifIdFlush);
	input[4:0] rs, rt, rtEX;
	input memRead, isBranch;
	output pcWrite, ifIdFlush;

	
	//uso de um registrador que vai ser alterado por um lw
	assign pcWrite = (memRead==1'b1 && (rs==rtEX || rt==rtEX))? 1'b0 : 1'b1;

	//branch
	assign ifIdFlush = (isBranch || !(memRead==1'b1 && (rs==rtEX || rt==rtEX)))? 1'b1 : 1'b0;
endmodule