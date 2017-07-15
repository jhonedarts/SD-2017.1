`include "parameters.v"

module unitControlTest ();

reg[5:0] opcode[0:12], funct, op;
reg [12:0] result[0:12];
wire[1:0] branchSrc, compareCode;
wire[12:0] control;
wire[`CONTROL_SIZE-1:0] controlOut; 
integer i = 0;
localparam loops = 13;

unitControl controle(
	.opcode(op),
	.func(funct),
	.controlOut(controlOut), 
	.branchSrc(branchSrc),
	.compareCode(compareCode)
);

assign control = {controlOut, branchSrc, compareCode};

initial begin

	funct	  = `R_TYPE; //para outras instruçoes do tipo R_type
	opcode[0] = `R_TYPE; //R type 
	opcode[1] = `R_TYPE; //R type 1 - jr
	opcode[2] = `ADDI;	 //addi
	opcode[3] = `SLTI;	 //slti
	opcode[4] = `BEQ; 	 //beq
	opcode[5] = `BNE; 	 //bne
	opcode[6] = `LW; 	 //lw
	opcode[7] = `SW; 	 //sw
	opcode[8] = `J; 	 //j
	opcode[9] = `ANDI; 	 //andi
	opcode[10] =`ORI;  	 //ori
	opcode[11] = `JAL; 	 //jal
	opcode[12] = 6'b111110; //inventei

		//microcode
	result[0] = 12'b001000010000; //codigos esperados na saida da uc, por opcode
	result[1] = 12'b000000001011;
	result[2] = 12'b001000100000;
	result[3] = 12'b001000100000;
	result[4] = 12'b000000001001;
	result[5] =	12'b000000001010;
	result[6] = 12'b011010100000;
	result[7] = 12'b000100000000;
	result[8] = 12'b000000000011;
	result[9] = 12'b001000100000;
	result[10] = 12'b001000100000;
	result [11] = 12'b101001000011;
	result [12] = 12'b000000000000;

	for(i = 0; i < loops; i = i + 1) begin
		op = opcode[i];
		if(i == 1)	begin
			funct = `JR; //altera o function se for um JR
		end
		#1;
		if(control == result[i])  begin//compara os codigos; i-1 por que o i ja foi incrementado la em cima.
			$display("INTERAÇÃO %d PASSOU\n VALOR ESPERADO = %d, RESULTADO = %d", i, control, result[i]);
		end else begin
			$display("INTERAÇÃO %d NÃO PASSOU\n VALOR ESPERADO = %d, RESULTADO = %d", i, control, result[i]);
			$finish();
		end

	end
	#1;
	$display("ALL TESTS PASSED!");
	$finish();
end
    
endmodule