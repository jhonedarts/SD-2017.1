
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

wire readyRx0, readyRx1, busyTx0, busyTx1, enableTx0, enableTx1, rx0toMem, rx1toMem;
wire[7:0] writeDataUART0, writeDataUART1, wrData, rx0Data, rx1Data;
reg[7:0] writeData;
//reg wrenMemData;
//cpu
wire [`DATA_MEM_ADDR_SIZE-1:0] address, rx0address, rx1address;
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
assign LEDM_R_inv = {8'b0000000,clk};
//assign LEDM_R_inv = rx0Data;

arbiter arbiter(
	.clk (clk),
	.address (address), 
	.memReadCPU (memReadCPU), 
	.memWriteCPU (memWriteCPU), 
	.readyRx0 (readyRx0), 
	.readyRx1 (readyRx1), 
	.rx0toMem (rx0toMem),
	.rx1toMem (rx1toMem),
	.busyTx0 (busyTx0), 
	.busyTx1 (busyTx1),
	.memWriteOut (), 
	.enableTx0 (enableTx0), 
	.enableTx1 (enableTx1),
	.rx0address (rx0address), 
	.rx1address (rx1address),
	.rx0DataSel (rx0DataSel),
	.rx1DataSel (rx1DataSel)
);

uart uart0(
	.clk (clk),
	.txData (writeDataCPU), 	//dado pra ser transmitido no tx	
	.txEnable (enableTx0), 		//ativa o tx pra iniciar a transmicao
	.rx (UART_Rx),				//da placa
	.rxClear (rx0toMem),			//reinicia o rx
	.tx (UART_Tx),				//para a placa
	.tx_busy (busyTx0),		//tx ocupado	
	.rxReady (readyRx0),		//flag de dado recebido, pronto pra passar para memoria
	.rxDataOut (rx0Data) 	//dado recebido
);

uart uart1(
	.clk (clk),
	.txData (writeDataCPU), 	//dado pra ser transmitido no tx	
	.txEnable (enableTx1), 		//ativa o tx pra iniciar a transmicao
	.rx (PIN_E11),				//da placa
	.rxClear (rx1toMem),			//reinicia o rx
	.tx (PIN_F11),				//para a placa
	.tx_busy (busyTx1),		//tx ocupado	
	.rxReady (readyRx1),		//flag de dado recebido, pronto pra passar para memoria
	.rxDataOut (rx1Data) 	//dado recebido
);

//assign wrenMemData = (memWriteUART | memWriteCPU)? 1:0;

mux2 #(.width (8)) mux2MEM1 (
	.a (rx0Data),
	.b (8'h0c),
	.sel (rx0DataSel),
	.out (writeDataUART0)
);

mux2 #(.width (8)) mux2MEM2 (
	.a (rx1Data),
	.b (8'h0c),
	.sel (rx1DataSel),
	.out (writeDataUART1)
);

mux3 #(.width (8)) mux3MEM1(
	.a (writeDataCPU),
	.b (writeDataUART0),
	.c (writeDataUART1),
	.sel ({rx1toMem, rx0toMem}),
	.out (wrData)
);

wire[`DATA_MEM_ADDR_SIZE-1:0] writeDataMemAddress;
mux3 #(.width (`DATA_MEM_ADDR_SIZE)) mux3MEM2(
	.a (address),
	.b (rx0address),
	.c (rx1address),
	.sel ({rx1toMem, rx0toMem}),
	.out (writeDataMemAddress)
);

endmodule
