`timescale 1ns / 1ps

/*
    Memória RAM de 64KB.
    Endereço de 14 bits e saída de 32 bits
*/

module RAM #(parameter SIZE)(
    input Clock,
    input [13:0] Address,
    input MemWrite,
    input MemRead,
    input [31:0] WriteData,
    output [31:0] ReadData
    );

    // 2^14 registradores de 32 bits
    reg [31:0] memory [0:(SIZE-1)];

    reg [13:0] addr_reg = 0;


    // Escrita sequencial na subida do clock
    always @(posedge Clock) begin
        if (MemWrite) begin
            memory[Address] <= WriteData;
        end
        else begin
            if(MemRead) begin
                addr_reg <= Address;
            end
        end
    end

    
    /*always @(negedge Clock) begin
        addr_reg <= Address;
    end*/
    
    assign ReadData = MemWrite ? WriteData : memory[addr_reg];

endmodule
