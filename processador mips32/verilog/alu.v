/*************************************************************
 * Module: ula
 * Project: mips32
 * Description: Só pra compilar o top
 ************************************************************/
 `include "parameters.v"
 
module alu(a,b, sel, result);

	input[31:0] a, b;
	input[3:0] sel;
	output [31:0] result;

	reg [31:0] resultReg;
	wire signed [31:0] b_signed; //nao há usos de a_signed, entao o exclui
	wire signed_comp;
	wire unsigned_comp;

  always@(*) begin 
  		
  		$display("--------------ULA--------------\n A: %d, B: %d, aluOp", a, b, sel);
  		case(sel)

  			`ALU_ADDU: resultReg = a + b;
			`ALU_SUBU: resultReg = a - b;
			`ALU_SLT:  begin
							if(signed_comp == 1) resultReg = 32'd1;
							else resultReg = 32'd0;
				
						end
			`ALU_SLTU: begin
							if(unsigned_comp == 1) resultReg = 32'd1;
							else resultReg = 32'd0;
				
						end
			`ALU_AND: resultReg = a & b;
			`ALU_OR: resultReg = a | b;		
			`ALU_XOR: resultReg = a ^ b;
			`ALU_LUI: resultReg = b << 5'b10000;
			`ALU_SLLV: resultReg = b << a[4:0];
			`ALU_SRLV: resultReg = b >> a[4:0];
			`ALU_SRAV: resultReg = b_signed >>> a[4:0];
			`ALU_NOR: resultReg = (~a) & (~b);
			`ALU_XXX:  resultReg = 32'd0;



  		default: resultReg = 32'd0;

  		endcase
  end
  
  	assign result = resultReg;
	assign signed_comp = ($signed(a) < $signed(b));
	assign unsigned_comp = a < b;
	assign b_signed = $signed(b);
  
endmodule