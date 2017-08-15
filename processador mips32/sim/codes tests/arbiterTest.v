module arbiterTest(
    input clock_50MHz,
    input UART_Rx,
    output UART_Tx,
    output LED_R,
    output [7:0] LEDM_R,
    output [4:0] LEDM_C
);

reg readyRx0, readyRx1, busyTx0, busyTx1, enableTx0, enableTx1, clearRx0, clearRx1, memWriteUART;
reg[8:0] writeDataMem, writeDataUART0, writeDataUART1;
reg wrenMemData;
//cpu
reg [31:0] address;
reg memReadCPU, memWriteCPU;

wire [7:0] LEDM_R_inv;

assign LEDM_R = ~LEDM_R_inv;

assign LEDM_C[0] = 1'b0; // enable col 0
assign LEDM_C[4:1] = 4'b1111; // disable cols 1~5

assign LEDM_R_inv = Rx_Data;

arbiter arbiter(
	.address (address), 
	.memReadCPU (memReadCPU), 
	.memWriteCPU (memWriteCPU), 
	.readyRx0 (readyRx0), 
	.readyRx1 (readyRx1), 
	.busyTx0 (busyTx0), 
	.busyTx1 (busyTx1),
	.memWriteOut (memWriteUART), 
	.enableTx0 (enableTx0), 
	.enableTx1 (enableTx1),
	.clearRx0 (clearRx0),
	.clearRx1 (clearRx1)
);

uart uart0(
	.clock_50MHZ (clock),
	.txData (writeData), 	//dado pra ser transmitido no tx	
	.txEnable (enableTx0), 		//ativa o tx pra iniciar a transmicao
	.rx (UART_Rx),				//da placa
	.rxClear (clearRx0),			//reinicia o rx
	.tx (UART_Tx),				//para a placa
	.tx_busy (busyTx0),		//tx ocupado	
	.rxReady (readyRx0),		//flag de dado recebido, pronto pra passar para memoria
	.rxDataOut (writeDataUART0) 	//dado recebido
);

uart uart1(
	.clock_50MHZ (clock),
	.txData (writeData), 	//dado pra ser transmitido no tx	
	.txEnable (enableTx1), 		//ativa o tx pra iniciar a transmicao
	.rx (UART_Rx),				//da placa
	.rxClear (clearRx1),			//reinicia o rx
	.tx (UART_Tx),				//para a placa
	.tx_busy (busyTx1),		//tx ocupado	
	.rxReady (readyRx1),		//flag de dado recebido, pronto pra passar para memoria
	.rxDataOut (writeDataUART1) 	//dado recebido
);

assign wrenMemData = (memWriteUART | memWriteCPU)? 1:0;

mux3 #(.width (8)) mux3MEM(
	.a (writeData),
	.b (writeDataUART0),
	.c (writeDataUART1),
	.sel ({enableTx1,enableTx0}),
	.out (writeDataMem)
);


endmodule