//-----------------------------------------------------------------------------
// UEFS TEC 499
// Lab 1, 2016.1
//-----------------------------------------------------------------------------
module ml505top (
  input  [11:0]   KEY,
  input  clock_50MHz,   
  output [7:0] LEDM_R,
  output [4:0] LEDM_C,
  output LED_R,
  output LED_G
);

  parameter Width   = 8;
  localparam CWidth = Width*2;
  
  wire                Reset;
  reg [CWidth-1:0]    Count;

  wire [Width-1:0]    CUTResult;
  wire [Width-1:0]    ExpectedResult;
  wire                CUTCout;
  wire                ExpectedCout;

  /* Trick to deal with the LED matrix. In this example only the first row (0)
  *  is used by disabling rows 1 to 7. Considering that LEDM_C logic is
  *  inverted, we have created a internal signal to not interfeer the implementation */
  wire [7:0] Not_LEDM_R;

  assign LEDM_R = ~Not_LEDM_R; // invert LED output

  assign LEDM_C[0] = 1'b0; // enable row 0
  assign LEDM_C[4:1] = 4'b1111; // disable rows 1 to 7

  assign Reset = KEY[3] | KEY[2] | KEY[1] | KEY[0];
 
  // Circuit Under Test
  Adder #(.Width(Width)) CUT (
    .A(Count[CWidth-1:Width]),
    .B(Count[Width-1:0]),
    .Result(CUTResult),
    .Cout(CUTCout)
    );
  
  BehavioralAdder #(.Width(Width)) Solution (
    .A(Count[CWidth-1:Width]),
    .B(Count[Width-1:0]),
    .Result(ExpectedResult),
    .Cout(ExpectedCout)
    );

  always @(posedge clock_50MHz) begin
    if(Reset) Count <= {CWidth{1'b0}};
    else if ((Count != {CWidth{1'b1}}) && LED_G) Count <= Count + 1'b1;
  end

  assign LED_G = CUTResult == ExpectedResult && CUTCout == ExpectedCout;
  assign LED_R = ~LED_G;

  /* The unsed LEDs are simply left turned off. Feel free to implement your 
   * your own logic! */
  assign Not_LEDM_R[7:0] = 8'b000000000;

endmodule
