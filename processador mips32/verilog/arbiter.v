/*************************************************************
* Module: arbiter
* Project: mips32
* Description: É um controlador de barramento de entrada e saida
************************************************************/
`include "parameters.v"
 
module arbiter(clk, address, memReadCPU, memWriteCPU, readyRx0, readyRx1, busyTx0, busyTx1, memWriteOut, 
		rx0toMem, rx1toMem, enableTx0, enableTx1, rx0address, rx1address, rx0DataSel, rx1DataSel);
	input clk;
	input[`DATA_MEM_ADDR_SIZE-1:0] address;
	input readyRx0, readyRx1, busyTx0, busyTx1;
	input memReadCPU, memWriteCPU;
	output [`DATA_MEM_ADDR_SIZE-1:0] rx0address, rx1address;
	output memWriteOut, rx0toMem, rx1toMem;
	output enableTx0, enableTx1, rx0DataSel, rx1DataSel;
//novo
	wire flag0, flag1;

	reg readyRx0b = 0;
	reg readyRx1b = 0;
	reg [1:0] stage = `STAGE_START;

	assign enableTx0 = (memWriteCPU & (address == `UART0))? 1:0;//tx uart0 desocupado & store na faixa de endereço uart0
	assign enableTx1 = (memWriteCPU & (address == `UART1))? 1:0;

	assign rx0toMem = (!(memWriteCPU|memReadCPU) & flag0)? 1:0;			//barramento livre & tem dado no rx uart0
	assign rx1toMem = (!(memWriteCPU|memReadCPU) & !flag0 & flag1)? 1:0;//barramento livre & nada no rx uart0 & dado no rx uart1
	//assign memReadOut = ;
	assign memWriteOut = (rx0toMem|rx1toMem)? 1:0;
	assign rx0address = (!readyRx0 & readyRx0b)? `UART0+8 : `UART0+4;
	assign rx1address = (!readyRx1 & readyRx1b)? `UART1+8 : `UART1+4;

	assign rx0DataSel = (!readyRx0 & readyRx0b)? 1:0;
	assign rx1DataSel = (!readyRx1 & readyRx1b)? 1:0;

	assign flag0 = (readyRx0 | readyRx0b)?1:0;	
	assign flag1 = (readyRx1 | readyRx1b)?1:0;
	
	always @(posedge clk) begin
		$display("[ARBITER] address: %h enableTx0: %b", address, busyTx0, enableTx0);
		case (stage)
			`STAGE_START: begin
				if (rx0toMem|rx1toMem) begin
					stage <= `STAGE_WORK;				
					readyRx0b <= readyRx0;
					readyRx1b <= readyRx1;
				end
			end
			`STAGE_WORK: begin
				if (rx0toMem|rx1toMem) begin
					stage <= `STAGE_START;				
					readyRx0b <= readyRx0;
					readyRx1b <= readyRx1;
				end
			end
			default: stage <= `STAGE_START;
		endcase
	end
endmodule