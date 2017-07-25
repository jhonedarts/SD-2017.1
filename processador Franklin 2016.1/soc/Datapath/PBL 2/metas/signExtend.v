module signExtend(X,Out);

input [15:0] X;
output [31:0] Out;
reg [31:0] Out;

always@(*)
	begin
		Out[31:0] <= { {16{X[7]}}, X};
	end
endmodule 