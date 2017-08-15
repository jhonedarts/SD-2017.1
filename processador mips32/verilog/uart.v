module uart(
	input wire clock_50MHZ,
	input wire [7:0] txData, 	//dado pra ser transmitido no tx	
	input wire txEnable, 		//ativa o tx pra iniciar a transmicao
	input wire rx,				//da placa
	input wire rxClear,			//reinicia o rx
	output wire tx,				//para a placa
	output wire tx_busy,		//tx ocupado	
	output wire rxReady,		//flag de dado recebido, pronto pra passar para memoria
	output wire[7:0] rxDataOut 	//dado recebido
);

	wire rxclk, txclk;

	baudRate baudrate(
		.clk_50m(clock_50MHZ),
		.rxclk_en(rxclk),
		.txclk_en(txclk)
	);

	tx transmiter(				
		.dados_transmissao(txData),
        .wr_en(txEnable),
        .clock_50(clock_50MHZ),
        .tick(txclk),
        .tx(tx),
        .txBusy(txBusy)
	);

	rx receiver(	  
		.rx(rx),
		.clear(rxClear),
		.clock(clock_50MHZ),
		.tick(rxclk),
		.rdy(rxReady),
		.out_rx(rxDataOut)		
	);
endmodule
