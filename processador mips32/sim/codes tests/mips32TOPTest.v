`timescale 1ns / 1ps

module mips32TOPTest ();

    parameter Halfcycle = 5;

    localparam Cycle = 2*Halfcycle;

    reg Clock, Reset;
    
    wire [13:0] address;
    wire writeMem, readMem;
    wire [31:0] writeDataMem;
    wire [31:0] ReadData,rsData, rtData;
    wire brWrite;
    wire [31:0] brDataIn;
    wire [4:0] brAddr;
    reg [4:0] rs, rt;
    reg [31:0] result;

    integer count_stop = 0;    

    initial Clock = 1;
    always #(Halfcycle) Clock = ~Clock;

    
    

    RAM ram (
        .Clock(Clock),
        .Address(address),
        .MemWrite(writeMem),
        .MemRead(readMem),
        .WriteData(writeDataMem),
        .ReadData(ReadData)        
    );

    registerFile BR (
        .clk (Clock), 
		.rst (Reset), 
		.rs (rs), 
		.rt (rt),
		.rWriteValue (brDataIn), 
		.rWriteAddress (brAddr), 
		.regWrite (brWrite), 
		.rsData (rsData), 
		.rtData (rtData)
    );

    mips32TOP cpu (
        .clk(Clock),
        .rst(Reset),
        .memWr(writeMem),
        .memRd(readMem),
        .memAddr(address),
        .memDataIn(writeDataMem),
        .brDataIn(brDataIn),
        .brAddr(brAddr),
        .brWrite(brWrite)       
    );   


    task printOutputBankRegister;
        input [4:0] addr1;                
        input [31:0] r1Data;
        input [31:0] result;
        if ( r1Data !== result ) begin           
            $display("TEST FAIL: Incorrect result for register : %b \n Resultado encontrado: %d, Resultado esperado: %d", addr1, r1Data, result);            
            $finish();
        end

        else begin
            $display ("TEST PASSED - Address: %d  DataOut: %d", addr1, r1Data);           
        end
    endtask

    

    /*localparam wordsInFile = 8192;

    reg [31:0] fileContent [0:wordsInFile-1];
    integer i;*/

    initial begin
     
     //correr ciclos para executar as instruções

    /*
        Tempo suficiente para rodar o programa carregado.
    */
    while(count_stop <=15) begin
        #(Cycle);
        count_stop = count_stop + 1;
    end  
    

    /*======================================================

        VERIFiCAÇÃO PARA O SEGUINTE PROGRAMA :     
        addi $t0,$zero, 2
        addi $t1, $zero, 3
        add $t2, $t0, $t1

        001000 00000 01000 0000000000000010
        001000 00000 01001 0000000000000011
        000000 01000 01001 010100 0000100000
    ======================================================*/

        rs = 5'b01000; //$t0
        result = 2;
       
        #(Cycle);
        printOutputBankRegister(rs,rsData, result);

        rs = 5'b01001; //$t1
        result = 3;    
        #(Cycle);
        printOutputBankRegister(rs,rsData, result);

        rs = 5'b01010; //$t2
        result = 5;        
        #(Cycle);
        printOutputBankRegister(rs,rsData,result);
    

		$finish();
        
	

    end
endmodule
