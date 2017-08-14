/*************************************************************
* Module: arbiter
* Project: mips32
* Description: É um controlador de barramento de entrada e saida
************************************************************/
`include "parameters.v"
 
module arbiter(address, memReadCPU, memWriteCPU, readyRx0, readyRx1, memReadOut, memWriteOut, enableTX0, enableTX1);
	input[31:0] address //low bit representa qual uart, e o high se houve um sw na faixa e endereco
	input readyRx0, readyRx1;
	input memReadCPU, memWriteCPU;
	output memReadOut, memWriteOut;
	output enableTX0, enableTX1;
	output[7:0] memData;
	output[31:0] memAddress;

	reg enableTX0reg, enableTX1reg;

	assign enableTX0 = enableTX0reg;
	assign enableTX1 = enableTX1reg;

	always @(*) begin
		if(memWriteCPU) begin //escrita para i/o
			case (address) //faixa de endereco
				`UART0: begin
					//verificar se esta ocupada (txbusy)
					enableTX0reg = 1;
				end
				`UART1: begin
					//verificar se esta ocupada (txbusy)
					enableTX1reg = 1;
				end
				default: begin
					enableTX0reg = 0;
					enableTX1reg = 0;
				end
			endcase
		end
		if (~(memWrite|memRead)) begin//se o barramento ta livre
			if (readyRx0) begin //dado ta pronto (recebido) da uart 0
				//habilitar o acesso ao barramento pra uart0 para gravar o dado na memoria
			end
			else if (readyRx1) begin //dado ta pronto (recebido) da uart 1
				//habilitar o acesso ao barramento pra uart1 para gravar o dado na memoria
			end
		end
	end

endmodule