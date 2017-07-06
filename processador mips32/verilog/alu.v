/*************************************************************
 * Module: ula
 * Project: mips32
 * Description: Só pra compilar o top
 ************************************************************/
 `include "parameters.v"
 
module alu(a,b, sel, result);

	input[31:0] a, b;
	input[3:0] sel;
	output[31:0] result;

wire signed [31:0] A_signed, B_signed;
	wire signed_comp;
	wire unsigned_comp;

  always@(*) begin 
  		

  		case(sel)

  			`ALU_ADDU: result = A + B;
			`ALU_SUBU: result = A - B;
			`ALU_SLT:  begin
							if(signed_comp == 1) result = 32'd1;
							else result = 32'd0;
				
						end
			`ALU_SLTU: begin
							if(unsigned_comp == 1) result = 32'd1;
							else result = 32'd0;
				
						end
			`ALU_AND: result = A & B;
			`ALU_OR: result = A | B;		
			`ALU_XOR: result = A ^ B;
			`ALU_LUI: result = B << 5'b10000;
			`ALU_SLLV: result = B << A[4:0];
			`ALU_SRLV: result = B >> A[4:0];
			`ALU_SRAV: result = B_signed >>> A[4:0];
			`ALU_NOR: result = (~A) & (~B);
			`ALU_XXX:  result = 32'd0;



  		default: result = 32'd0;

  		endcase
  end
  
  	
	assign signed_comp = ($signed(A) < $signed(B));
	assign unsigned_comp = A < B;
	assign B_signed = $signed(B);
  
endmodule