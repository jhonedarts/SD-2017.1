//------------------------------------------------------------------------------
//	Module:	FPGA_TOP_MIV
//	Desc:	Top level interface from a Mercurio FPGA board
//------------------------------------------------------------------------------

module FPGA_TOP_MIV
	(
		////////////////////	Clock Input	 	////////////////////	 
		clock_50MHz,						//	50 MHz
		////////////////////	Push Button		////////////////////
		KEY,								//	Pushbutton[3:0]
		////////////////////	DPDT Switch		////////////////////
		Switch,								//	Toggle Switch[17:0]
		////////////////////	RGB LED		    ////////////////////
		LED_G,								//	RGB LED Green
		LED_R,								//	RGB LED Red
		LED_B,								//	RGB LED Blue
		////////////////////	LED Matrix		////////////////////
		LEDM_C,								//	LED Matrix column
		LEDM_R								//	LED Matrix row
	);

	////////////////////////	Clock Input	 	////////////////////////
	input			clock_50MHz;						//	50 MHz
	////////////////////////	Push Button		////////////////////////
	input	[11:0]	KEY;								//	Pushbutton[3:0]
	////////////////////////	DPDT Switch		////////////////////////
	input	[3:0]		Switch;							//	Toggle Switch[3:0]
	////////////////////////	RGB LED		   ////////////////////////
	output			LED_G;							//	RGB LED Green
	output			LED_R;							//	RGB LED Red
	output			LED_B;							//	RGB LED Red
	////////////////////////	LED Matrix		////////////////////////
	output	[3:0]	LEDM_C;							//	LED Matrix column
	output	[7:0]	LEDM_R;							//	LED Matrix row

	wire	[2:0]				State;
	wire	[2:0]				DebugState;
	
	wire						Enter;
	wire						Open;
	wire						Fail;
	wire	[3:0]				Digit;
	wire						LockReset;

	assign LockReset 	= KEY[0];
	assign Digit 	 	= Switch[3:0];

	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------
	parameter					ClockFreq =				50000000;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Parse input from buttons
	//--------------------------------------------------------------------------

	LevelToPulse	LockEnterPulse	(	
						.Clock(				clock_50MHz),
						.Reset(				LockReset),
						.Level(				KEY[11]),
						.Pulse(				Enter));		

	Lab2Lock		Lab2LockFSM (
						.Clock(				clock_50MHz),
						.Reset(				LockReset),
						.Enter(				Enter),
						.Digit(				Digit),
						.State(				State),
						.Open(				Open),
						.Fail(				Fail));
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Output Logic
	//--------------------------------------------------------------------------
	assign  LEDM_C[0] 	 = 1'b0; 			// Enable column 0 on LED matrix
	assign  LEDM_C[3:1]   = 3'b111; 			// Disable undriven columns

   assign  LEDM_R[7:3]   =  5'b11111;           // No undriven outputs can be used for debug
	assign  LEDM_R[2:0]	 =	~State;

	// The RGB LEDs light up green when the lock is open, and red when you fail to unlock.	
	assign  LED_R 		 =	Fail;
	assign  LED_G		 =	Open;
	assign  LED_B 		 = 1'b0;
	//--------------------------------------------------------------------------	

endmodule