//  Module: ALUTestbench
//  Desc:   32-bit ALU testbench for the MIPS150 Processor
//  Feel free to edit this testbench to add additional functionality
//  
//  Note that this testbench only tests correct operation of the ALU,
//  it doesn't check that you're mux-ing the correct values into the inputs
//  of the ALU. 

// If #1 is in the initial block of your testbench, time advances by
// 1ns rather than 1ps
`timescale 1ns / 1ps

`include "parameters.v"

module ulaTest();

    parameter Halfcycle = 5; //half period is 5ns
    
    localparam Cycle = 2*Halfcycle;
    
    reg Clock;
    
    // Clock Signal generation:
    initial Clock = 0; 
    always #(Halfcycle) Clock = ~Clock;
    
    // Register and wires to test the ALU
    reg [5:0] funct;
    reg [5:0] opcode;
    reg [31:0] A, B;
    wire [31:0] DUTout;
    reg [31:0] REFout; 
    wire [3:0] ALUop;

    reg [30:0] rand_31;
    reg [14:0] rand_15;

    // Signed operations; these are useful
    // for signed operations
    wire signed [31:0] B_signed;
    assign B_signed = $signed(B);

    wire signed_comp;
    assign signed_comp = ($signed(A) < $signed(B));
    

    // Task for checking output
    task checkOutput;
        input [5:0] opcode, funct;
        if ( REFout !== DUTout ) begin
            $display("ALUop = %b", ALUop);
            $display("FAIL: Incorrect result for opcode %b, funct: %b:", opcode, funct);
            $display("\tA: 0x%h, B: 0x%h, DUTout: 0x%h, REFout: 0x%h", A, B, DUTout, REFout);
            $finish();
        end
        else begin
            $display("PASS: opcode %b, funct %b", opcode, funct);
            $display("\tA: 0x%h, B: 0x%h, DUTout: 0x%h, REFout: 0x%h", A, B, DUTout, REFout);
        end
    endtask

    //This is where the modules being tested are instantiated. 
    aluControl DUT1(
        .funct(funct),
        .opcode(opcode),
        .aluOp(ALUop));

    alu DUT2( 
        .a(A),
        .b(B),
        .sel(ALUop),
        .result(DUTout));

    integer i;
    localparam loops = 500; // number of times to run the tests for

    // Testing logic:
    initial begin
    $display("\n\n ALL INSTRUCTIONS TESTS RANDOM");
        for(i = 0; i < loops; i = i + 1)
        begin
            /////////////////////////////////////////////
            // Put your random tests inside of this loop
            // and hard-coded tests outside of the loop
            // (see comment below)
            // //////////////////////////////////////////
            #1;
            // Make both A and B negative to check signed operations
            rand_31 = {$random} & 31'h7FFFFFFF;
            rand_15 = {$random} & 15'h7FFF;
            A = {1'b1, rand_31};
            // Hard-wire 16 1's in front of B for sign extension
            B = {16'hFFFF, 1'b1, rand_15};
            // Set funct random to test that it doesn't affect non-R-type insts
            opcode = {$random} % 6'b111111;
            funct = {$random} % 6'b111111;

            opcode = `R_TYPE;
            case(funct)
                    `SLL,`SLLV: REFout = B << A[4:0]; 
                    `SRL,`SRLV: REFout = B >> A[4:0];    
                    `SRA,`SRAV: REFout = $signed(B) >>> A[4:0];     
                    `ADDU:      REFout = A + B;  
                    `SUBU:      REFout = A - B; 
                    `AND:       REFout = A & B;   
                    `OR:        REFout = A | B;   
                    `XOR:       REFout = A ^ B;   
                    `NOR:       REFout = (~A) & (~B);
                    `SLT:       begin
                            if(signed_comp == 1'b1) REFout = 32'd1;
                            else REFout = 32'd0;
                
                        end
                    `SLTU: begin
                            if(A < B) REFout = 32'd1;
                            else REFout = 32'd0;
                
                        end

                    default: begin 
                    $display("O function abaixo nao existe na ula");
                    REFout = 0;      
                    end
            endcase
            #1
            checkOutput(opcode, funct); 

            opcode = `LUI;
            rand_15 = {$random} & 16'h7FFF;
            B = {rand_15,16'h0000};//Extensão de 0 pela esquerda                
            REFout = B << 5'b10000;
            #1
            checkOutput(opcode, funct); 
            
        end

          $display("\n\n LOAD AND STORES TESTS RANDOM");
        // Test load and store instructions (should add operands)
        for(i = 0; i < 20; i = i + 1)begin

            #1
        // Make both A and B negative to check signed operations
            rand_31 = {$random} & 31'h7FFFFFFF;
            rand_15 = {$random} & 15'h7FFF;
            A = {1'b1, rand_31};
            // Hard-wire 16 1's in front of B for sign extension
            B = {16'hFFFF, 1'b1, rand_15};
            // Set funct random to test that it doesn't affect non-R-type insts
            funct = 6'b000000;

            
            opcode = `LB;
            REFout = A + B; 
            #1;
            checkOutput(opcode, funct);

            opcode = `LH;
            REFout = A + B;
            #1;
            checkOutput(opcode, funct);

            opcode = `LW;
            REFout = A + B;
            #1;
            checkOutput(opcode, funct);

            opcode = `LBU;
            REFout = A + B;
            #1;
            checkOutput(opcode, funct);

            opcode = `LHU;
            REFout = A + B;
            #1;
            checkOutput(opcode, funct);
           
            opcode = `SB;
             REFout = A + B;
            #1;
            checkOutput(opcode, funct);

            opcode = `SH;
            REFout = A + B;
            #1;
            checkOutput(opcode, funct);

            opcode = `SW;
             REFout = A + B;
            #1;
            checkOutput(opcode, funct);

            end

        ///////////////////////////////
        // Hard coded tests go here

        $display("\n\nBEGIN HARD-CODED TESTS");

        opcode = `R_TYPE; 
        funct = `ADDU; 
        A = 32'b10111000000000001011100101111011; // problematic input for A 
        B = 32'b00100000000000001010111011001010; // problematic input for B 
        REFout = A + B; // expected result 
        #1; 
        checkOutput(opcode, funct);

        opcode = `R_TYPE; 
        funct = `SLT; 
        A = 32'b00000000000000000000000000000111; // 7
        B = 32'b11111111111111111111111111111010; // -6
        REFout = 32'd0; // expected result 
        #1; 
        checkOutput(opcode, funct);

        opcode = `R_TYPE; 
        funct = `SLTU; 
        A = 32'b00000000000000000000000000000111; // 7
        B = 32'b11111111111111111111111111111010; // 4294967290
        REFout = 32'd1; // expected result 
        #1; 
        checkOutput(opcode, funct);

        opcode = `R_TYPE; 
        funct = `SRL; 
        A = 32'b00000000000000000000000000000011; // 3
        B = 32'b00010000000000000000000000000111; // 268435463
        REFout = 32'b00000010000000000000000000000000; // expected result 
        #1; 
        checkOutput(opcode, funct);

        opcode = `R_TYPE; 
        funct = `SRA; 
        A = 32'b00000000000000000000000000000010; // 2
        B = 32'b11111111111111111111111111111010; // -6
        REFout = 32'b11111111111111111111111111111110; // expected result 
        #1; 
        checkOutput(opcode, funct);


        $display("\n\n SUBTRAÇÂO HARD-CODED TESTS");
      
        funct = `SUBU; // SUBTRAÇÂO HARD-CODED TESTS
        opcode = `R_TYPE;
        A = -3; 
        B = -2;
        REFout = A - B;
        #1; 
        checkOutput(opcode, funct);


        A = -6; 
        B = -1;
        REFout = A - B;
        #1; 
        checkOutput(opcode, funct);

        A = 2;
        B = -1;
        REFout = A - B;
        #1; 
        checkOutput(opcode, funct);

        A = -2;
        B = 1;
        REFout = A - B;
        #1; 
        checkOutput(opcode, funct);
	
	A = 4;
	B = 2;
	REFout = A - B;
	#1;
	checkOutput(opcode, funct);
	
	// FIM SUBTRAÇÂO HARD-CODED TESTS
	
             

        $display("\n\n SLT HARD-CODED TESTS");

        funct = `SLT; // SLT HARD-CODED TESTS
        opcode = `R_TYPE;
        A = -10; 
        B = -5;
        REFout = 1;
        #1; 
        checkOutput(opcode, funct);

        A = -2;
        B = -3;
        REFout = 0;
        #1; 
        checkOutput(opcode, funct);

        A = 2;
        B = -3;
        REFout = 0;
        #1; 
        checkOutput(opcode, funct);

        A = -3;
        B = 2;
        REFout = 1;
        #1; 
        checkOutput(opcode, funct);

        A = 4;
        B = 2;
        REFout = 0;
        #1; 
        checkOutput(opcode, funct);

        A = 5;
        B = 10;
        REFout = 1;
        #1; 
        checkOutput(opcode, funct);       

        $display("\n\n SLTU HARD-CODED TESTS");

        funct = `SLTU; // SLTU HARD-CODED TESTS
        opcode = `R_TYPE;   
        A = 10; 
        B = 5;
        REFout = 0;
        #1; 
        checkOutput(opcode, funct);

        A = 5; 
        B = 10;
        REFout = 1;
        #1; 
        checkOutput(opcode, funct);

        A = 3; 
        B = 5;
        REFout = 1;
        #1; 
        checkOutput(opcode, funct);

        A = 0; 
        B = 1;
        REFout = 1;
        #1; 
        checkOutput(opcode, funct);

        A = 2; 
        B = 2;
        REFout = 0;
        #1; 
        checkOutput(opcode, funct);

        A = 6; 
        B = 5;
        REFout = 0;
        #1; 
        checkOutput(opcode, funct);

        ///////////////////////////////

        //$display("\n\nADD YOUR ADDITIONAL TEST CASES HERE\n"); //delete this once you've written your test cases
       
        $display("\n\nALL TESTS PASSED!");
        $finish();
    end

  endmodule
