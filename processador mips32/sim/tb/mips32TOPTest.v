`timescale 1ns / 1ps

module mips32TOPTest ();

    parameter Halfcycle = 5;

    localparam Cycle = 2*Halfcycle;

    reg Clock, Reset;

    initial Clock = 0;
    always #(Halfcycle) Clock = ~Clock;

    wire [31:0] address;
    wire writeEnable;
    wire [31:0] writeData, dataToMem;
    wire [31:0] readData;

    RAM ram (
        .Clock(Clock),
        .Address(address),
        .MemWrite(writeEnable),
        .WriteData(writeData),
        .ReadData(readData)
    );

    mips32TOP cpu (
        .Clock(Clock),
        .Reset(Reset),
        .Mem_DataIn(readData),
        .Mem_Address(address),
        .Mem_WriteEnable(writeEnable),
        .Mem_DataOut(writeData)
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
