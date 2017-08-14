`include "parameters.v"

module tx(
  input wire [7:0] dados_transmissao,// dados que transmissão
  input wire wr_en,//habilitador 
  input wire clock_50,//clock da fpga
  input wire tick, // clock ou um sinal que controla se o tx está ativado 
  output reg tx, // RESPONSAVEL POR ENVIAR OS BITS 
  output wire tx_busy // informar que ainda está sendo usado o tx 
);

reg [7:0] dados = 8'h00;
reg [2:0] contador = 3'h0;
reg [1:0] estado = `ESTADO_INTERFACE; // ele inicia no idle .. ou seja interface pois kkk os dados são enviados por la

always @(posedge clock_50) begin
	case (estado)
	/*
		verifica se está sendo enviado ... algo da interface 
	*/
	`ESTADO_INTERFACE: begin
		if (wr_en) begin
			estado <= `ESTADO_START;//logo quando vai enviar os dados ele ja começa o start no primeiro sinal de clock
			dados <= dados_transmissao;
			contador <= 3'h0;
		end
    	else tx <= 1'b1;
	end
	`ESTADO_START: begin
		if (tick) begin//INICIA O START BIT INFORMANDO PARA O ENVIO DE DADOS
			tx <= 1'b0; // RESETA  O TX ... PARA RECEBER A INFORMAÇÃO
			estado <= `ESTADO_TRAB;//MUDA PARA O ESTADO ...
		end
	end
	`ESTADO_TRAB: begin
		if (tick) begin
			if (contador == 3'h7)
				estado <= `ESTADO_STOP;
			else
				contador <= contador + 3'h1;// UM CONTADOR DE 8 BITS ... ENVIANDO UM BIX POR VEZ
			    tx <= dados[contador];
		end
	end
	`ESTADO_STOP: begin
		if (tick) begin
			tx <= 1'b1;//ULTIMO SINAL DE BIT INFORMAR QUE TERMINOU ... DE ENVIAR E VAI PARA INFERFACE ESPERANDO A UART ATIVAR 
			estado <= `ESTADO_INTERFACE;
		end
	end
	default: begin
		tx <= 1'b1;// CASO NÃO ENCONTRE O ESTADO ELE SEMPRE VOLTA PRO PRIMEIRO ESTADO QUE É A INTERFACE 
		estado <= `ESTADO_INTERFACE;
	end
	endcase
end

assign tx_busy = (estado != `ESTADO_INTERFACE);

endmodule

