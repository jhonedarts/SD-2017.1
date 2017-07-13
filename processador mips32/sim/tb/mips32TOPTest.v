`timescale 1ps / 1ps

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


    task printOutput;
        input [13:0] addr;
        input writeEn;
        input [31:0] dIn,dOut;
        begin
            $display ("Address: %d  Write: %d",addr,writeEn);
            $display("DataOut: %d  DataIn: %d\n",dOut,dIn);
        end
    endtask

    /*localparam wordsInFile = 8192;

    reg [31:0] fileContent [0:wordsInFile-1];
    integer i;*/

    initial begin
      /*Reset = 1;
      #(Cycle);
      Reset = 0;
     

        #(Halfcycle);
      
      while (address != 32'h400) begin
        #(Halfcycle);
      end
      

      $finish(); */
    Reset = 1;
    #(Cycle);
    Reset = 0;

      while (count_stop<=100) begin
        #(Cycle);
        count_stop = count_stop+1;
      end

		$finish();
        
	

    end
endmodule
