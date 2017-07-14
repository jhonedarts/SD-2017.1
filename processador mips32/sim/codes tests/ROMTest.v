`timescale 1ns / 1ps

module ROMTest ();

    parameter Halfcycle = 5;

    localparam Cycle = 2*Halfcycle;

    reg Clock, Reset;
    
    reg [9:0] address;
    wire [31:0] ReadData;
   
    

    integer count_stop = 0;    

    initial Clock = 1;
    always #(Halfcycle) Clock = ~Clock;

    
    

    ROM rom (
        .Clock(Clock),
        .Address(address),        
        .ReadData(ReadData)        
    );  


    task printOutput;
        input [9:0] addr;       
        input [31:0] ReadData;
        begin
            $display ("Address: %d",addr);
            $display("DataOut: %d \n",ReadData);
        end
    endtask

    /*localparam wordsInFile = 8192;

    reg [31:0] fileContent [0:wordsInFile-1];
    integer i;*/

    initial begin
     

      while (count_stop<=5) begin
        #(Cycle);
        printOutput(address,ReadData);
      end

		$finish();
        
	

    end
endmodule