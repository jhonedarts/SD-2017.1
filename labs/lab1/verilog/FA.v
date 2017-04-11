//-----------------------------------------------------------------------------
// UEFS TEC 499
// Lab 0, 2016.1
// Module: FA.v
// Desc: 1-bit Full Adder
//       You may only use structural verilog in this module.       
//-----------------------------------------------------------------------------
module FA(
    input A, B, Cin,
    output Sum, Cout
);
  // Structural verilog only!
   
/********YOUR CODE HERE********/
   
wire a_xor_b, a_and_b, axorb_and_Cin;
	xor (a_xor_b, A, B);
	xor (Sum, a_xor_b, Cin);
	and (a_and_b, A, B);
	and (axorb_and_Cin, a_xor_b, Cin);
	or (Cout, a_and_b, axorb_and_Cin);
/********END CODE********/

endmodule

