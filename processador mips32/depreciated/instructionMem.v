/***************************************************
 * Module: instructionMem
 * Project: mips32
 * Description: Carrega amemoria de instrucoes com os valores
 * de entrada (rst). Recebe um address de sua memoria
 * e coloca na saida o valor contido nesse address.
 ***************************************************/
`include "parameters.v"

module instructionMem(rst, address, instruction);
    input rst;
    input [`WORD_SIZE-1:0] address;
    output [`WORD_SIZE-1:0] instruction;


    reg [`WORD_SIZE-1:0] mem [`INST_MEM_SIZE-1:0]; //vetor de palavras

    integer instructionIn;
    integer line;
    integer i;

    always @ (posedge rst) begin
        instructionIn = $fopen("mem/instruction.txt", "r");
        for (i = 0; i < `INST_MEM_SIZE; i = i + 1) begin
            $fscanf(instructionIn,"%32B", line);//le cada line em hexadecimal
            if($feof(instructionIn)) 
                i = `INST_MEM_SIZE; //migué pra sair do laço caso acabe o arquivo antes de acabar a memoria
            else 
                mem[i] = line; // guarda o valor na memoria
        end
        $fclose(instructionIn);
    end

    assign instruction = mem[address];

endmodule