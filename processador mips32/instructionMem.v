/***************************************************
 * Module: memoriaInstrucao
 * Project: mips32
 * Description: Carrega amemoria de instrucoes com os valores
 * de entrada (rst). Recebe um address de sua memoria
 * e coloca na saida o valor contido nesse address.
 ***************************************************/
`include "parametros.v"

module memoriaInstrucao(rst, address, instruction);
    input rst;
    input [`WORD_SIZE-1:0] address;
    output [`WORD_SIZE-1:0] instruction;


    reg [`WORD_SIZE-1:0] mem [`INST_MEM_SIZE-1:0]; //vetor de palavras

    integer inst_in;
    integer line;
    integer i;

    always @ (posedge rst) begin
        inst_in = $fopen("entrada/instrucoes.txt", "r");
        for (i = 0; i < `INST_MEM_SIZE; i = i + 1) begin
            $fscanf(inst_in,"%08H", line);//le cada line em hexadecimal
            if($feof(inst_in)) 
                i = `INST_MEM_SIZE; //migué pra sair do laço caso acabe o arquivo antes de acabar a memoria
            else 
                mem[i] = line; // guarda o valor na memoria
        end
        $fclose(inst_in);
    end

    assign instruction = mem[address];

endmodule