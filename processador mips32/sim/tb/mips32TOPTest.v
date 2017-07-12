`timescale 1ns / 1ps

module mips32TOPTest ();

    parameter Halfcycle = 5;

    localparam Cycle = 2*Halfcycle;

    reg Clock, Reset;

    initial Clock = 0;
    always #(Halfcycle) Clock = ~Clock;

    wire [31:0] address;
    wire writeMem, readMem;
    wire [31:0] writeDataMem;
    //wire brWrite, isBrnch, brDataIn, , brancSrc;
    //wire [4:0] brAddr;

    RAM ram (
        .Clock(Clock),
        .Address(address),
        .MemWrite(writeMem),
        .MemRead(readMem),
        .WriteData(writeDataMem)        
    );

    /*registerFile BR (
        .clk (Clock), 
		.rst (Reset), 
		.rs (), 
		.rt (),
		.rWriteValue (destRegValueWB), 
		.rWriteAddress (destRegWB), 
		.regWrite (controlWB[2]), 
		.rsData (), 
		.rtData ()
    );*/

    mips32TOP cpu (
        .clk(Clock),
        .rst(Reset),
        .memWr(writeMem),
        .memRd(readMem),
        .memAddr(address),
        .memDataIn(writeDataMem),
        .brDataIn(),
        .brAddr(),
        .brWrite(),
        .isBrnch(),
        .compCode(),
        .brancSrc()
    );   


    task printOutput;
        input [13:0] addr;
        input writeEn;
        input [31:0] dIn,dOut;
        begin
            $display ("Address: %d  Write: %d",addr,writeEn);
            $display("DataOut: %d  DataIn: %d\n",dOut,dIn);
        end
    endtask

    localparam wordsInFile = 8192;

    reg [31:0] fileContent [0:wordsInFile-1];
    integer i;

    initial begin
      Reset = 1;
      #(Cycle);
      Reset = 0;
      
      while (address != 32'h3ffc) begin
        #(Cycle);
      end
      

      $finish();
    end
endmodule
