module muxTwo(A,X0,X1,Out);

input [1:0] A;
input [31:0] X1,X0;
output [31:0] Out;
reg [31:0] Out;

always@(A, X1,X0)
	begin
	 case(A)
	 1'b0:
	 Out <= X0;
	 1'b1:
	 Out <= X1;
	 endcase
	end
endmodule 