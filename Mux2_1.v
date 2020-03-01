//-----------------------------------------------------------------------------

// UEFS TEC 499

// Lab 0, 2016.1

// Module: Mux2_1.v

// Desc: OUT = A*(~SEL) + B*(SEL)

//-----------------------------------------------------------------------------

 module Mux2_1(
    input A,
    input B,
    input SEL,
    output OUT
);
// You may only use structural verilog! (i.e. wires and gates only)
 
 /********YOUR CODE HERE********/

	wire a_and_Sel1, b_and_Sel0;
	and (a_and_Sel1, A, ~SEL);
	and (b_and_Sel0, B, SEL);
	or ( OUT, a_and_Sel1, b_and_Sel0);



/********END CODE********/
  
// assign OUT = 1'b0; //delete this line once you finish writing your logic
   

endmodule
