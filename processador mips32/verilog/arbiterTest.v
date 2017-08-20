
`include "parameters.v"
module arbiterTest(
    input clock_50MHz,
    input UART_Rx,
    input PIN_E11,
    input [3:0] Switch,
    output PIN_F11,
    output UART_Tx,
    output [7:0] LEDM_R,
    output [4:0] LEDM_C
);

wire readyRx0, readyRx1, busyTx0, busyTx1, tx0enable, tx1enable, uart0toMem, uart1toMem;
wire[7:0] writeDataUART0, writeDataUART1, wrData, rx0Data, rx1Data;
reg[7:0] writeData;
//reg wrenMemData;
//cpu
wire [`DATA_MEM_ADDR_SIZE-1:0] address, uart0address, uart1address;
wire [7:0] writeDataCPU;
wire memReadCPU, memWriteCPU;

frequencyDivider divider(clock_50MHz,clk);

assign address = (Switch[0])? `UART0 : `DATA_MEM_ADDR_SIZE'h800;
assign writeDataCPU = (Switch[0])? writeData : 8'd00;
assign memReadCPU = 0;
assign memWriteCPU = (Switch[0])? 1:0;


always @(posedge clk) begin
	if(wrData!=0 & wrData!= 8'h0c)begin
		writeData = wrData;
	end
end

wire [7:0] LEDM_R_inv;
assign LEDM_R = ~LEDM_R_inv;

assign LEDM_C[0] = 1'b0; // enable col 0
assign LEDM_C[4:1] = 4'b1111; // disable cols 1~5
assign LEDM_R_inv = rx0Data;

arbiter arbiter(
	.clk (clk),
	.address (address), 
	.memReadCPU (memReadCPU), 
	.memWriteCPU (memWriteCPU), 
	.readyRx0 (readyRx0), 
	.readyRx1 (readyRx1), 
	.uart0toMem (uart0toMem),
	.uart1toMem (uart1toMem),
	.busyTx0 (busyTx0), 
	.busyTx1 (busyTx1),
	.memWriteOut (), 
	.tx0enable (tx0enable), 
	.tx1enable (tx1enable),
	.uart0address (uart0address), 
	.uart1address (uart1address),
	.uart0DataSel (uart0DataSel),
	.uart1DataSel (uart1DataSel)
);

uart uart0(
	.clk (clk),
	.txData (writeDataCPU), 	//dado pra ser transmitido no tx	
	.txEnable (tx0enable), 		//ativa o tx pra iniciar a transmicao
	.rx (UART_Rx),				//da placa
	.rxClear (uart0toMem),			//reinicia o rx
	.tx (UART_Tx),				//para a placa
	.tx_busy (busyTx0),		//tx ocupado	
	.rxReady (readyRx0),		//flag de dado recebido, pronto pra passar para memoria
	.rxDataOut (rx0Data) 	//dado recebido
);

uart uart1(
	.clk (clk),
	.txData (writeDataCPU), 	//dado pra ser transmitido no tx	
	.txEnable (tx1enable), 		//ativa o tx pra iniciar a transmicao
	.rx (PIN_E11),				//da placa
	.rxClear (uart1toMem),			//reinicia o rx
	.tx (PIN_F11),				//para a placa
	.tx_busy (busyTx1),		//tx ocupado	
	.rxReady (readyRx1),		//flag de dado recebido, pronto pra passar para memoria
	.rxDataOut (rx1Data) 	//dado recebido
);

//assign wrenMemData = (memWriteUART | memWriteCPU)? 1:0;

mux2 #(.width (8)) mux2MEM1 (
	.a (rx0Data),
	.b (8'h0c),
	.sel (uart0DataSel),
	.out (writeDataUART0)
);

mux2 #(.width (8)) mux2MEM2 (
	.a (rx1Data),
	.b (8'h0c),
	.sel (uart1DataSel),
	.out (writeDataUART1)
);

mux3 #(.width (8)) mux3MEM1(
	.a (writeDataCPU),
	.b (writeDataUART0),
	.c (writeDataUART1),
	.sel ({uart1toMem, uart0toMem}),
	.out (wrData)
);

wire[`DATA_MEM_ADDR_SIZE-1:0] writeDataMemAddress;
mux3 #(.width (`DATA_MEM_ADDR_SIZE)) mux3MEM2(
	.a (address),
	.b (uart0address),
	.c (uart1address),
	.sel ({uart1toMem, uart0toMem}),
	.out (writeDataMemAddress)
);

endmodule
