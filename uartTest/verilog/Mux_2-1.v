module mux2(
	input controle,
	input A,B,
	output  reg saida

);
	
	
	
always@(*)begin

	if(controle)
		saida = A;
    else 
		saida = B;

 end



endmodule
