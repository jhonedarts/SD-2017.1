`timescale 1ns / 1ps

module ArbiterTb ();

    parameter Halfcycle = 5;

    localparam Cycle = 2*Halfcycle;

    reg Clock;


    


	reg[13:0] address;
	reg readyRx0, readyRx1, busyTx0, busyTx1;
	reg memReadCPU, memWriteCPU;
	wire [13:0] rx0address, rx1address;
	wire memWriteOut, rx0toMem, rx1toMem;
	wire enableTx0, enableTx1, rx0DataSel, rx1DataSel;
    
    //===== TESTES =======
    wire [4:0] hc1;
    //====

    assign hc1 = {enableTx0, enableTx1, rx0toMem, rx1toMem, memWriteOut};
    //integer count_stop = 0;    

    initial Clock = 1;
    always #(Halfcycle) Clock = ~Clock;

    
    

    arbiter AR (
    .clk(Clock), //input
	.address(address), //input
    .readyRx0(readyRx0), //input
    .readyRx1(readyRx1), //input
    .busyTx0(busyTx0), //input
    .busyTx1(busyTx1), //input
	.memReadCPU(memReadCPU), //input
    .memWriteCPU(memWriteCPU), //input
	.rx0address(rx0address), //output
    .rx1address(rx1address), //output
	.memWriteOut(memWriteOut), //output
    .rx0toMem(rx0toMem), //output
    .rx1toMem(rx1toMem), //output
	.enableTx0(enableTx0), //output
    .enableTx1(enableTx1), //output
    .rx0DataSel(rx0DataSel), //output
    .rx1DataSel(rx1DataSel) //output
    );  

    .clk(),    //input
    .address(),    //input
    .memReadCPU(), //input
    .memWriteCPU(),    //input
    .readyRx0(),   //input
    .readyRx1(),   //input
    .busyTx0(),    //input
    .busyTx1(), //input
    .memWriteOut(), //output
    .uart0toMem(), //output
    .uart1toMem(), //output
    .tx0enable(),  //output
    .tx1enable(),  //output
    .addressUart0(),   //output
    .addressUart1(),   //output
    .uart0DataSel(),   //output
    .uart1DataSel()  //output
    ); 


    task checkOutput;
        input readyRx1,readyRx0,memReadCPU, memWriteCPU, address;
        input  [4:0] hc;//outputs       
            if ( hc !== hc1 ) begin
            //$display("ALUop = %b", ALUop);
            $display("\n FAIL enableTx0-%b, enableTx1-%b, rx0toMem-%b, rx1toMem-%b, memWriteOut-%b", enableTx0, enableTx1, rx0toMem, rx1toMem, memWriteOut);            
            $display("Endereco de saida rx0: rx0address: %h", rx0address);
            $display("Endereco de saida rx1: rx1address: %h", rx1address);
            $finish();             
        end
        else begin
            $display("\nPASS: code: %b", hc1);
            $display("enableTx0-%b, enableTx1-%b, rx0toMem-%b, rx1toMem-%b, memWriteOut-%b", enableTx0, enableTx1, rx0toMem, rx1toMem, memWriteOut);
            $display("rx0DataSel: %h", rx0DataSel);
            $display("rx1DataSel: %h", rx1DataSel);
            $display("Endereco de saida rx0: rx0address: %h", rx0address);
            $display("Endereco de saida rx1: rx1address: %h", rx1address);
                             
        end                            
    endtask   

    initial begin

// =============HARDCODE TEST - BARRAMENTO USADO PELA CPU ================= 
// 
    address = 0;//qualquer
    readyRx1 = 1'b0;                        //UART_0 requisita o uso do barramento (quer escrever na memória)
    readyRx0 = 1'b1;
    memReadCPU = 1'b1;                      // A CPU está usando o barramento com operação de leitura
    memWriteCPU = 1'b0;    
        #(Cycle);
        checkOutput(/*inputs*/readyRx1,readyRx0,memReadCPU,memWriteCPU,address,5'b00000);
//  

// BARRAMENTO usado PELA CPU
    address = 0;//qualquer
    readyRx1 = 1'b1;                        //UART_1 requisita o uso do barramento (quer escrever na memória)
    readyRx0 = 1'b0;
    memReadCPU = 1'b1;                      // A CPU está usando o barramento com operação de leitura
    memWriteCPU = 1'b0;    
        #(Cycle);
        checkOutput(/*inputs*/readyRx1,readyRx0,memReadCPU,memWriteCPU,address,5'b00000);


// BARRAMENTO usado PELA CPU
    address = 0;//qualquer
    readyRx1 = 1'b1;                        //UART_1 requisita o uso do barramento (quer escrever na memória)
    readyRx0 = 1'b0;
    memReadCPU = 1'b0;                      // A CPU está usando o barramento com operação de escrita
    memWriteCPU = 1'b1;    
        #(Cycle);
        checkOutput(/*inputs*/readyRx1,readyRx0,memReadCPU,memWriteCPU,address,5'b00000);
//   

// BARRAMENTO usado PELA CPU
    address = 0;//qualquer
    readyRx1 = 1'b0;                        //UART_0 requisita o uso do barramento (quer escrever na memória)
    readyRx0 = 1'b1;
    memReadCPU = 1'b0;                      // A CPU está usando o barramento com operação de escrita
    memWriteCPU = 1'b1;    
        #(Cycle);
        checkOutput(/*inputs*/readyRx1,readyRx0,memReadCPU,memWriteCPU,address,5'b00000);
//


//============================== Barramento DESOCUPADO =======================
    address = 0;//qualquer
    readyRx1 = 1'b1;                        //UART_1 requisita o uso do barramento (quer escrever na memória)
    readyRx0 = 1'b0;
    memReadCPU = 1'b0;                      
    memWriteCPU = 1'b0;    
        #(Cycle);
        checkOutput(/*inputs*/readyRx1,readyRx0,memReadCPU,memWriteCPU,address,5'b00011);



    address = 0;//qualquer
    readyRx1 = 1'b0;                        //UART_0 requisita o uso do barramento (quer escrever na memória)
    readyRx0 = 1'b1;
    memReadCPU = 1'b0;                      
    memWriteCPU = 1'b0;    
        #(Cycle);
        checkOutput(/*inputs*/readyRx1,readyRx0,memReadCPU,memWriteCPU,address,5'b00101);


    address = 0;//qualquer
    readyRx1 = 1'b1;                        //UART_0 e UART_1 requisitam o uso do barramento (escrever na memória)
    readyRx0 = 1'b1;
    memReadCPU = 1'b0;                      //UART_0 tem prioridade
    memWriteCPU = 1'b0;    
        #(Cycle);
        checkOutput(/*inputs*/readyRx1,readyRx0,memReadCPU,memWriteCPU,address,5'b00101); 



    // HARD CODE TESTS =========== da memória para as uarts

    address = 32'h00000860;//uart_0
    readyRx1 = 1'b0;                        //UART_0 recebe dado da cpu
    readyRx0 = 1'b0;
    memReadCPU = 1'b0;                      
    memWriteCPU = 1'b1;    
        #(Cycle);
        checkOutput(/*inputs*/readyRx1,readyRx0,memReadCPU,memWriteCPU,address,5'b10000); 

    
    
    address = 32'h00000880;//uart_1
    readyRx1 = 1'b0;                        //UART_1 recebe dado da cpu
    readyRx0 = 1'b0;
    memReadCPU = 1'b0;                      
    memWriteCPU = 1'b1;    
        #(Cycle);
        checkOutput(/*inputs*/readyRx1,readyRx0,memReadCPU,memWriteCPU,address,5'b01000); 

    $finish();
        
	

    end
endmodule