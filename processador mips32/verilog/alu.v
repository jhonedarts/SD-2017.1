/*************************************************************
 * Module: ula
 * Project: mips32
 * Description: Só pra compilar o top
 ************************************************************/
 `include "parameters.v"
 
module alu(a,b, sel, result);

	input[31:0] a, b;
	input[3:0] sel;
	output reg[31:0] result;

wire signed [31:0] b_signed; //nao há usos de a_signed, entao o exclui
	wire signed_comp;
	wire unsigned_comp;

  always@(*) begin 
  		
  		$display("--------------ULA--------------\n A: %d, B: %d, aluOp", a, b, sel);
  		case(sel)

  			`ALU_ADDU: result = a + b;
			`ALU_SUBU: result = a - b;
			`ALU_SLT:  begin
							if(signed_comp == 1) result = 32'd1;
							else result = 32'd0;
				
						end
			`ALU_SLTU: begin
							if(unsigned_comp == 1) result = 32'd1;
							else result = 32'd0;
				
						end
			`ALU_AND: result = a & b;
			`ALU_OR: result = a | b;		
			`ALU_XOR: result = a ^ b;
			`ALU_LUI: result = b << 5'b10000;
			`ALU_SLLV: result = b << a[4:0];
			`ALU_SRLV: result = b >> a[4:0];
			`ALU_SRAV: result = b_signed >>> a[4:0];
			`ALU_NOR: result = (~a) & (~b);
			`ALU_XXX:  result = 32'd0;



  		default: result = 32'd0;

  		endcase
  end
  
  	
	assign signed_comp = ($signed(a) < $signed(b));
	assign unsigned_comp = a < b;
	assign b_signed = $signed(b);
  
endmodule