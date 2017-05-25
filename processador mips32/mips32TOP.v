/*************************************************************
 * Module: mips32TOP
 * Project: mips32
 * Description: Top Level do projeto, conecta todos o modulos
 ************************************************************/
module mips32TOP();

wire rst;
assign rst = 0//rst da placa;
//wires... wires everwhere
wire[`WORD_SIZE:0] nextpc, currentpc, instruction, pc4IF; 
wire pcwrite;

PC pc(
	.enable (pcwrite),
	.nextpc (nextpc),
	.out (currentpc)
);

instructionMem instructionMem(
	.rst (rst),
	.address (currentpc),
	.instruction (instruction)
);

adder adderIF (
	.a (currentpc),
	.b (32'd4),
	.out (pc4IF)
);

endmodule