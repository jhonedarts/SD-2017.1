`timescale 1ns / 1ps

module mips32TOPTest2 ();

    parameter halfcycle = 5;
    localparam cycle = 2*halfcycle;    
    integer count_stop; 

    reg clock, reset;    
    wire [13:0] memAddr;
    wire [11:0] controlCode;
    wire [31:0] brData, memData, nextpcOut, instructionIFOut, instructionIDOut;
    wire [4:0] brAddr;

    always #(halfcycle) clock = ~clock; 

    mips32TOP2 cpu (
        .clk(clock),
        .rst(reset),
        .controlCode(controlCode),
        .memAddr(memAddr),
        .memDataIn(memData),
        .brDataIn(brData),
        .brAddr(brAddr),
        .nextpcOut (nextpcOut),
        .instructionIFOut (instructionIFOut),
        .instructionIDOut (instructionIDOut)
    );    
    
    initial begin 
        clock = 0;
        reset = 0;
        count_stop = 0;       
        while(count_stop <=15) begin
            #(cycle);
            count_stop = count_stop + 1;
            $display("\ncontrolCode ID: %b\nMemory Addr: %d, Data: %d\nDestRegWB: %d, Value: %d\nNextPc: %d, instructionIF: %h", 
                controlCode, memAddr, memData, brAddr, brData, nextpcOut, instructionIFOut);
            $display("instructionID: %h" , instructionIDOut);
        end  
        $finish();  
    end
endmodule
