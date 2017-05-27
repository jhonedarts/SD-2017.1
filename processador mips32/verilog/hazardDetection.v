/***************************************************
 * Module: HazardDetection
 * Project: mips32
 * Description: Responsavel por gerar uma bolha entre 
 * uma instrucao que usa um valor que vai ser carregado
 * na instrucao anterior. Tambem gera as bolhas necessarias
 * quando um desvio é tomado.
 ***************************************************/

module hazardDetection(rs, rt, rtEX, memRead, isBranch, isJump, pcWrite, jumpStall, ifIdFlush, idExFlush, exMemFlush);
	input[4:0] rs, rt, rtEX;
	input memRead, isBranch, isJump;
	output pcWrite, jumpStall, ifIdFlush, idExFlush, exMemFlush;

	reg jump;
	initial begin
	    jump =1'b1;//jumpStall
	end

	//uso de um registrador que vai ser alterado por um lw
	assign pcWrite = (memRead==1'b1 && (rs==rtEX || rt==rtEX))? 1'b0 : 1'b1;

	//branch
	assign idExFlush = (isBranch)? 1'b1 : 1'b0;
	assign exMemFlush = (isBranch)? 1'b1 : 1'b0;
	assign ifIdFlush = (isBranch)? 1'b1 : 1'b0;

	assign jumpStall = jump;
	
	always @(isJump or isBranch) begin
		//jump detectado no id
		if (isJump) begin
			jump = 1;			//ativa as bolhas no if  e trava o pc
		end
		//jump tomado no mem
		else if (isBranch) begin
			jump = 0;			//desativa as bolhas no if e destrava o pc
		end
	end
endmodule