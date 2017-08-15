module uartTest(
    input clock_50MHz,
    input UART_Rx,
    output UART_Tx,
    output LED_R,
    output [7:0] LEDM_R,
    output [4:0] LEDM_C
);

wire Rx_data_ready, tx_busy, rdy;
wire [7:0] Rx_Data;

wire [7:0] LEDM_R_inv;

assign LEDM_R = ~LEDM_R_inv;

assign LEDM_C[0] = 1'b0; // enable col 0
assign LEDM_C[4:1] = 4'b1111; // disable cols 1~5

assign LEDM_R_inv = Rx_Data;

uart uart(
	.clock_50MHz(clock_50MHz),
	.txData(Rx_Data), 		//dado pra ser transmitido no tx	
	.txEnable(rdy), 		//ativa o tx pra iniciar a transmicao
	.rx(UART_Rx),			//da placa
	.rxClear(rdy),			//reinicia o rx
	.tx(UART_Tx), 			//para a placa
	.txBusy(tx_busy),		//tx ocupado	
	.rxReady(rdy),			//flag de dado recebido, pronto pra passar para memoria
	.rxDataOut(Rx_Data) 	//dado recebido
);

endmodule
