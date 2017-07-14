`timescale 1ns / 1ps

/*
    Memória RAM de 64KB.
    Endereço de 14 bits e saída de 32 bits
*/

module ROM #(parameter SIZE = 1024, FILE_IN = "memoryInit/instructions.input")(
    input Clock,
    input [9:0] Address,
    output [31:0] ReadData
    );

    // 2^14 registradores de 32 bits
    reg [31:0] memory [0:(SIZE-1)];

    reg [9:0] addr_reg = 0;

    integer i;
    initial begin                             
        $readmemb(FILE_IN, memory);
    end

    // Escrita sequencial na subida do clock
    always @(posedge Clock) begin
       
       addr_reg <= Address;
            
    end

    
    /*always @(negedge Clock) begin
        addr_reg <= Address;
    end*/
    
    assign ReadData = memory[addr_reg];

endmodule
