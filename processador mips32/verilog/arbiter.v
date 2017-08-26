/*************************************************************
* Module: arbiter
* Project: mips32
* Description: É um controlador de barramento de entrada e saida
************************************************************/
`include "parameters.v"
 
module arbiter(clk, address, memReadCPU, memWriteCPU, readyRx0, readyRx1, busyTx0, busyTx1, memWriteOut, 
		uart0toMem, uart1toMem, tx0enable, tx1enable, uart0address, uart1address, uart0DataSel, uart1DataSel);
	input clk;
	input[`DATA_MEM_ADDR_SIZE-1:0] address;
	input readyRx0, readyRx1, busyTx0, busyTx1;
	input memReadCPU, memWriteCPU;
	output [`DATA_MEM_ADDR_SIZE-1:0] uart0address, uart1address;
	output memWriteOut, uart0toMem, uart1toMem;
	output tx0enable, tx1enable, uart0DataSel, uart1DataSel;
//novo
	wire flag0, flag1, tx0flag, tx1flag;
	wire [`DATA_MEM_ADDR_SIZE-1:0] rx0address, rx1address, tx0address, tx1address;

	reg readyRx0b = 0;
	reg readyRx1b = 0;
	reg busyTx0reg = 0;
	reg busyTx1reg = 0;
	reg [1:0] stage = `STAGE_INTERFACE;	
	reg [1:0] stage0 = `STAGE_INTERFACE;

	assign tx0enable = (!busyTx0 & !busyTx0reg & memWriteCPU & (address == `UART0))? 1:0;//tx uart0 desocupado & store na faixa de endereço uart0
	assign tx1enable = (!busyTx1 & !busyTx1reg & memWriteCPU & (address == `UART1))? 1:0;

	assign uart0toMem = (!(memWriteCPU|memReadCPU) & flag0)? 1:0;			//barramento livre & tem dado no rx uart0
	assign uart1toMem = (!(memWriteCPU|memReadCPU) & !flag0 & flag1)? 1:0;//barramento livre & nada no rx uart0 & dado no rx uart1
	assign memWriteOut = (uart0toMem|uart1toMem)? 1:0;
	assign rx0address = (!readyRx0 & readyRx0b)? `UART0+8 : `UART0+4;
	assign rx1address = (!readyRx1 & readyRx1b)? `UART1+8 : `UART1+4;
	assign tx0address = (tx0flag)? `UART0+12 : `UART0;
	assign tx1address = (tx1flag)? `UART1+12 : `UART1;
	assign uart0address = (tx0flag)? tx0address: rx0address;
	assign uart1address = (tx1flag)? tx1address: rx1address;

	assign uart0DataSel = ((!readyRx0 & readyRx0b)|tx0flag)? 1:0;
	assign uart1DataSel = ((!readyRx1 & readyRx1b)|tx1flag)? 1:0;

	assign tx0flag = (!busyTx0 & busyTx0reg)? 1:0;
	assign tx1flag = (!busyTx1 & busyTx1reg)? 1:0;

	assign flag0 = (readyRx0|readyRx0b|tx0flag)?1:0;	
	assign flag1 = (readyRx1|readyRx1b|tx1flag)?1:0;
	
	always @(posedge clk) begin
		//$display("[ARBITER] address: %h tx0busy: %b tx0enable: %b", address, busyTx0, tx0enable);
		case (stage)
			`STAGE_INTERFACE: begin
				//$display("interface rx");
				readyRx0b <= readyRx0;
				readyRx1b <= readyRx1;
				if (readyRx0 | readyRx1) begin//data
					if ((uart0toMem|uart1toMem) & !(tx0flag|tx1flag)) begin //rxdata, dando prioridade a ao txflag
						stage <= `STAGE_WORK;
					end else begin
						stage <= `STAGE_START;
					end
				end
			end
			`STAGE_START: begin //data
				//$display("start rx");
				if ((uart0toMem|uart1toMem) & !(tx0flag|tx1flag)) begin //rxdata, dando prioridade a ao txflag
					stage <= `STAGE_WORK;
				end
			end
			`STAGE_WORK: begin//flag
				//$display("work rx");
				if ((uart0toMem|uart1toMem) & !(tx0flag|tx1flag)) begin //rxdata sinalizador na memoria
					stage <= `STAGE_INTERFACE;
				end
			end
			default: stage <= `STAGE_INTERFACE;
		endcase
	end

	
	always @(posedge clk) begin
		case (stage0)
			`STAGE_INTERFACE: begin //os dois desocupados
				//$display("interface tx");
				busyTx0reg <= busyTx0;
				busyTx1reg <= busyTx1;
				if (busyTx0 & !busyTx1) begin //0 inicia a transmissão
					stage0 <= `STAGE_START;										
				end else if (busyTx1 & !busyTx0) begin //1 inicia a transmissão
					stage0 <= `STAGE_WORK;										
				end else if (busyTx1 & busyTx0) begin //1 inicia a transmissão
					stage0 <= `STAGE_STOP;										
				end
			end
			`STAGE_START: begin //1 desocupado e 0 querendo escrever 
				//$display("start tx");
				busyTx1reg <= busyTx1;
				if (!busyTx0) begin //terminou de transmitir o tx0Data e agora que escrever a flag na mem
					if (uart0toMem & !busyTx1) begin //escreveu 0, e 1 ta desocupado
						stage0 <= `STAGE_INTERFACE;										
					end	else if (uart0toMem & busyTx1) begin //escreveu 0, e 1 ta ocupado (caso raro)
						stage0 <= `STAGE_WORK;
					end	else if (!uart0toMem & busyTx1) begin //nao escreveu 0 ainda e aparece o 1 pra escrever tb
						stage0 <= `STAGE_STOP;
					end		
				end else begin
					if (busyTx1) begin
						stage0 <= `STAGE_STOP;
					end
				end
			end
			`STAGE_WORK: begin //0 desocupado e 1 querendo escrever 
				//$display("work tx");
				busyTx0reg <= busyTx0;
				if (!busyTx1) begin //terminou de transmitir o tx1Data e agora que escrever a flag na mem
					if (uart1toMem & !busyTx0) begin 
						stage0 <= `STAGE_INTERFACE;										
					end	else if (uart1toMem & busyTx0) begin
						stage0 <= `STAGE_START;
					end	else if (!uart1toMem & busyTx0) begin //nao escreveu 0 ainda e aparece o 1 pra escrever tb
						stage0 <= `STAGE_STOP;
					end		
				end else begin
					if (busyTx0) begin
						stage0 <= `STAGE_STOP;
					end
				end	
				
			end
			`STAGE_STOP: begin//dois querendo
				//$display("stop tx");
				if (!busyTx0) begin//terminou de transmitir tx0Data
					if (uart0toMem) begin //autorizou o 0
						stage0 <= `STAGE_WORK;
					end 
				end else begin
					if (!busyTx1) begin//terminou de transmitir tx1Data
						if (uart1toMem) begin //autorizou o 1
							stage0 <= `STAGE_START;
						end		
					end		
				end
			end
			default: stage0 <= `STAGE_INTERFACE;
		endcase
	end
endmodule