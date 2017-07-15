`timescale 1ns / 1ps

module mips32TOPTest2 ();

    parameter Halfcycle = 5;
    localparam Cycle = 2*Halfcycle;

    reg Clock, Reset;    
    wire [13:0] memAddr;
    wire [11:0] controlCode;
    wire [31:0] brData, memData;
    wire [4:0] brAddr;

    integer count_stop = 0;    

    initial Clock = 1;
    always #(Halfcycle) Clock = ~Clock;
    
    mips32TOP2 cpu (
        .clk(Clock),
        .rst(Reset),
        .controlCode(controlCode),
        .memAddr(memAddr),
        .memDataIn(memData),
        .brDataIn(brData),
        .brAddr(brAddr)   
    );   

    initial begin
        while(count_stop <=15) begin
            #(Cycle);
            count_stop = count_stop + 1;
            $display("controlCode ID: %b\nMemory Addr: %b, Data: %b\nDestReg: %b, Value: %b", 
                controlCode, memAddr, memData, brAddr, brData);
        end  
        $finish(); 
    end
endmodule
