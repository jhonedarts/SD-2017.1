/***************************************************
 * Module: dataMem
 * Project: mips32
 * Description: Implentação de uma memória RAM para
 * palavras de 32 bits
 ***************************************************/

`include "parameters.v"

module data_mem (clk, rst, address, writeData, write, read, dataOut);
	input clk, rst, write, read; 
	input [`WORD_SIZE:0] address, writeData;
	output [31:0] dataOut;

	reg [31:0] memory [`DATA_MEM_SIZE-1:0];
	integer ramIn; // Arquivo de entrada
	integer ramOut; // Arquivo de saida
	integer i;
	reg [31:0] data;

	always @ (posedge clk or posedge rst) begin
		if (rst) begin
			ramOut = $fopen("mem/dataOut.txt", "w");
			for (i = 0; i < `DATA_MEM_SIZE; i = i + 1) begin
				$fwrite(ramOut,"%32B\n", memory[i]); 			//transcreve os valores da memoria pro txt
			end
			$fclose(ramOut);

			ramIn = $fopen("mem/dataIn.txt", "r");
			for (i = 0; i < `DATA_MEM_SIZE; i = i + 1) begin
				$fscanf(ramIn,"%32B", data);				//transcreve os valores da txt pra memoria
				if($feof(ramIn)) 
					i = `DATA_MEM_SIZE;						//outro migué pra sair do laco quando acabar o arquivo
				else 
					memory[i] = data;							//memoria sendo carregada
			end
			$fclose(ramIn);
		end 

		else if(write) begin 	//escrita
			memory[address] <= writeData;
		end 
		else if(read) begin 		//leitura
			dataOut = memory[address];
		end
	end

endmodule
