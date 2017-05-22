/***************************************************
 * Module: memoriaInstrucao
 * Project: mips32
 * Description: Carrega amemoria de instrucoes com os valores
 * de entrada (reset). Recebe um endereco de sua memoria
 * e coloca na saida o valor contido nesse endereco.
 ***************************************************/
`include "parametros.v"

module memoriaInstrucao(reset, endereco, instrucao);
    input reset;
    input [`WORD_SIZE-1:0] endereco;
    output [`WORD_SIZE-1:0] instrucao;


    reg [`WORD_SIZE-1:0] mem [`INST_MEM_SIZE-1:0]; //vetor de palavras

    integer inst_in;
    integer linha;
    integer i;

    always @ (posedge reset) begin
        inst_in = $fopen("entrada/instrucoes.txt", "r");
        for (i = 0; i < `INST_MEM_SIZE; i = i + 1) begin
            $fscanf(inst_in,"%08H", linha);//le cada linha em hexadecimal
            if($feof(inst_in)) 
                i = `INST_MEM_SIZE; //migué pra sair do laço caso acabe o arquivo antes de acabar a memoria
            else 
                mem[i] = linha; // guarda o valor na memoria
        end
        $fclose(inst_in);
    end

    assign instrucao = mem[endereco];

endmodule