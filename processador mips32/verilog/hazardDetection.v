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
	assign pcWrite = (memRead & (rs==rtEX | rt==rtEX))? 0:1;

	//branch
	assign ifIdFlush = (memRead & (rs==rtEX | rt==rtEX))? 1:0;
endmodule