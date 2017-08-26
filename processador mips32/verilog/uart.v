module uart(
	input clk,
	input [7:0] txData, 	//dado pra ser transmitido no tx	
	input txEnable, 		//ativa o tx pra iniciar a transmicao
	input rx,				//da placa
	input rxClear,			//reinicia o rx
	output tx,				//para a placa
	output tx_busy,		//tx ocupado	
	output rxReady,		//flag de dado recebido, pronto pra passar para memoria
	output [7:0] rxDataOut 	//dado recebido
);

	wire rxclk, txclk;

	baudRate baudrate(
		.clk (clk),
		.rxclk_en(rxclk),
		.txclk_en(txclk)
	);

	tx transmiter(				
		.dados_transmissao(txData),
        .wr_en(txEnable),
        .clk (clk),
        .tick(txclk),
        .tx(tx),
        .txBusy(tx_busy)
	);

	rx receiver(	  
		.rx(rx),
		.clear(rxClear),
		.clk (clk),
		.tick(rxclk),
		.rdy(rxReady),
		.out_rx(rxDataOut)		
	);
endmodule
