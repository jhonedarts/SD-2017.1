`include "parameters.v"

module tx(
  input wire [7:0] dados_transmissao,// dados que transmissão
  input wire wr_en,//habilitador 
  input wire clk,//clock da fpga
  input wire tick, // clock ou um sinal que controla se o tx está ativado 
  output reg tx, // RESPONSAVEL POR ENVIAR OS BITS 
  output wire txBusy // informar que ainda está sendo usado o tx 
);

reg [7:0] dados = 8'h00;
reg [2:0] contador = 3'h0;
reg [1:0] estado = `STAGE_INTERFACE; // ele inicia no idle .. ou seja interface pois kkk os dados são enviados por la

always @(posedge clk) begin
	//$display("estado: %d  tx0Enable: ", estado, wr_en);
	case (estado)
	/*
		verifica se está sendo enviado ... algo da interface 
	*/
	`STAGE_INTERFACE: begin
		if (wr_en) begin
			estado <= `STAGE_START;//logo quando vai enviar os dados ele ja começa o start no primeiro sinal de clock
			dados <= dados_transmissao;
			contador <= 3'h0;
		end
    	else tx <= 1'b1;
	end
	`STAGE_START: begin	
		//$display("start");
		if (tick) begin//INICIA O START BIT INFORMANDO PARA O ENVIO DE DADOS
			tx <= 1'b0; // RESETA  O TX ... PARA RECEBER A INFORMAÇÃO
			//$display("tx: %d",tx);
			estado <= `STAGE_WORK;//MUDA PARA O STAGE ...
		end
	end
	`STAGE_WORK: begin
		//$display("work");
		if (tick) begin
			if (contador == 3'h7)
				estado <= `STAGE_STOP;
			else
				contador <= contador + 3'h1;// UM CONTADOR DE 8 BITS ... ENVIANDO UM BIX POR VEZ
			    tx <= dados[contador];
		end
	end
	`STAGE_STOP: begin
		if (tick) begin
			tx <= 1'b1;//ULTIMO SINAL DE BIT INFORMAR QUE TERMINOU ... DE ENVIAR E VAI PARA INFERFACE ESPERANDO A UART ATIVAR 
			estado <= `STAGE_INTERFACE;
			$display("[TX] enviou!!");
		end
	end
	default: begin
		tx <= 1'b1;// CASO NÃO ENCONTRE O STAGE ELE SEMPRE VOLTA PRO PRIMEIRO STAGE QUE É A INTERFACE 
		estado <= `STAGE_INTERFACE;
	end
	endcase
end

assign txBusy = (estado != `STAGE_INTERFACE);

endmodule

