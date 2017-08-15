`include "parameters.v"
module arbiterTest(
    input clock_50MHz,
    input UART_Rx,
    input GPIO1_D[0],
    input KEY[0],
    output GPIO1_D[1],
    output UART_Tx,
    output LED_R,
    output [7:0] LEDM_R,
    output [4:0] LEDM_C
);

reg readyRx0, readyRx1, busyTx0, busyTx1, enableTx0, enableTx1, clearRx0, clearRx1, memWriteUART;
reg[7:0] writeData, writeDataUART0, writeDataUART1;
reg wrenMemData;
//cpu
reg [`DATA_MEM_ADDR_SIZE-1:0] address;
reg [7:0] writeDataCPU
reg memReadCPU, memWriteCPU;

reg [7:0] writeData;
wire [7:0] wrData;

assign writeData = (wrData>0)? wrData;

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
	.clock_50MHz (clock_50MHz),
	.txData (writeDataCPU), 	//dado pra ser transmitido no tx	
	.txEnable (enableTx0), 		//ativa o tx pra iniciar a transmicao
	.rx (UART_Rx),				//da placa
	.rxClear (clearRx0),			//reinicia o rx
	.tx (UART_Tx),				//para a placa
	.tx_busy (busyTx0),		//tx ocupado	
	.rxReady (readyRx0),		//flag de dado recebido, pronto pra passar para memoria
	.rxDataOut (writeDataUART0) 	//dado recebido
);

uart uart1(
	.clock_50MHz (clock_50MHz),
	.txData (writeDataCPU), 	//dado pra ser transmitido no tx	
	.txEnable (enableTx1), 		//ativa o tx pra iniciar a transmicao
	.rx (GPIO1_D[0]),				//da placa
	.rxClear (clearRx1),			//reinicia o rx
	.tx (GPIO1_D[1]),				//para a placa
	.tx_busy (busyTx1),		//tx ocupado	
	.rxReady (readyRx1),		//flag de dado recebido, pronto pra passar para memoria
	.rxDataOut (writeDataUART1) 	//dado recebido
);

assign wrenMemData = (memWriteUART | memWriteCPU)? 1:0;

mux3 #(.width (8)) mux3MEM(
	.a (writeDataCPU),
	.b (writeDataUART0),
	.c (writeDataUART1),
	.sel ({enableTx1,enableTx0}),
	.out (wrData)
);

always @(posedge KEY[0]) begin
	if (KEY[0]) begin
		address = `DATA_MEM_ADDR_SIZE'h860;
		writeDataCPU = writeData;
		memWriteCPU = 1;
		memReadCPU = 0;
	end
	else begin
		address = `DATA_MEM_ADDR_SIZE'h800;
		writeDataCPU = 0;
		memWriteCPU = 0;
		memReadCPU = 0;
	end
end

endmodule