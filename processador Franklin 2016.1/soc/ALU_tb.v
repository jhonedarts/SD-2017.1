//Fonte base: laboratório 03 desenvolvido pelos tutores

`include "Opcode.vh"

module ALU_tb;
	
	reg clkACC = 0;	
	reg[31:0] A, B;
	reg [5:0] funct, opcode;
	
	wire[3:0] ALUop;
	wire [31:0] ALUresult;
	reg [31:0] REFout;
	wire zero, overflow;
   	reg [30:0] rand_31;
   	reg [14:0] rand_15;
 	
	integer i = 0;
	
	 // Task for checking output 
    	task checkOutput;
       	 input [5:0] opcode, funct;	
        	if ( REFout !== ALUresult ) begin
        	    $display("FAIL: Incorrect result for opcode %b, funct: %b:", opcode, funct);
        	    $display("\tA: 0x%d, B: 0x%d, ALUresult: 0x%d, REFout: 0x%d", A, B, ALUresult, REFout);
        	    $finish();
       		 end
        	else begin
        	    $display("PASS: opcode %b, funct %b", opcode, funct);
        	    $display("\tA: 0x%d, B: 0x%d, ALUresult: 0x%d, REFout: 0x%d", A, B, ALUresult, REFout);
       	 	end
   	 endtask
	
	ALU alu(clkACC, A, B,ALUop,ALUresult, zero, overflow);
	ALUdec dec(funct, opcode, ALUop);

	localparam loops = 100;

	initial begin
		clkACC = !clkACC;
		for(i = 0; i < loops; i = i + 1)
        	begin
		
             		rand_31 = {$random} & 31'h7FFFFFFF;
             		rand_15 = {$random} & 15'h7FFF;
            		A = {1'b1, rand_31};
             		B = {16'hFFFF, 1'b1, rand_15};
			
			opcode = `RTYPE1;
			//ADD
              		REFout = A + B;
              		funct = `ADD;
              		#1; 	
              		checkOutput(opcode, funct);

			//SUB
              		REFout = $signed(A) - $signed(B);
              		funct = `SUB;
              		#1; 	
              		checkOutput(opcode, funct);
			

			//DIV
              		REFout = 32'bx;
              		funct = `DIV;
			#1;
              		checkOutput(opcode, funct);


			//MFHI
              		REFout = $signed($signed(A) % $signed(B));
              		funct = `MFHI;
              		#1;
              		checkOutput(opcode, funct);

			

			//MUL
              		REFout = $signed(A) * $signed(B);
              		funct = `MUL;
              		#1; 	
              		checkOutput(opcode, funct);

			//SLT
              		REFout = $signed(A) < $signed(B);
              		funct = `SLT;
              		#1; 	
              		checkOutput(opcode, funct);
		end
	$display("\n\nALL TESTS PASSED!");
        $finish();
	end
		
endmodule