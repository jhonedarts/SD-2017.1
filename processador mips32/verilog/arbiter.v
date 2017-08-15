/*************************************************************
* Module: arbiter
* Project: mips32
* Description: É um controlador de barramento de entrada e saida
************************************************************/
`include "parameters.v"
 
module arbiter(address, memReadCPU, memWriteCPU, readyRx0, readyRx1, busyTX0, busyTx1, memWriteOut, enableTx0, enableTx1, clearRx0, clearRx1);
	input[`DATA_MEM_ADDR_SIZE-1:0] address 
	input readyRx0, readyRx1, busyTx0, busyTx1;
	input memReadCPU, memWriteCPU;
	output memWriteOut;
	output enableTx0, enableTx1, clearRx0, clearRx1;

	assign enableTx0 = (!busyTx0 & memWriteCPU & (address == `UART0))? 1:0;//tx uart0 desocupado & store na faixa de endereço uart0
	assign enableTx1 = (!busyTx1 & memWriteCPU & (address == `UART1))? 1:0;
	assign rx0toMem = (!(memWriteCPU|memReadCPU) & readyRx0)? 1 : 0;			//barramento livre & tem dado no rx uart0
	assign rx1toMem = (!(memWriteCPU|memReadCPU) & !readyRx0 & readyRx1)? 1:0;//barramento livre & nada no rx uart0 & dado no rx uart1
	//assign memReadOut = ;
	assign memWriteOut = (rx0toMem|rx1toMem)? 1:0;
	assign clearRx0 = (rx0toMem)? 1:0;
	assign clearRx1 = (rx1toMem)? 1:0;
endmodule