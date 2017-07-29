`timescale 1ns / 1ps

module mips32TOPTest2 ();

    real halfcycle = 5;
    localparam cycle = 10;    
    integer count_stop; 

    reg clock, clockMem, reset;    
    wire [13:0] memAddr;
    wire [11:0] controlCode;
    wire [31:0] brData, memData, nextpcOut, instructionIFOut, instructionIDOut;
    wire [4:0] brAddr;

    always begin 
        #(halfcycle/2) clock = !clock; clockMem = !clockMem;
        #(halfcycle/2) clockMem = !clockMem;
    end

    mips32TOP2 cpu (
        .clk(clock),
        .clkMem(clockMem),
        .rst(reset)
    );    
    
    initial begin 
        clock = 0;
        clockMem = 0;
        reset = 0;
        count_stop = 0;       
        while(count_stop <=15) begin
            #(cycle);
            count_stop = count_stop + 1;
            $display("clock: %d\n", count_stop);
        end  
        $finish();  
    end
endmodule
