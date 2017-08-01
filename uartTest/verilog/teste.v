module teste(
    input clock_50MHz,
    input UART_Rx,
    output UART_Tx,
    output LED_R,
    output [7:0] LEDM_R,
    output [4:0] LEDM_C
);

wire Rx_data_ready, tx_busy, rdy;
wire [7:0] Rx_Data;

wire [7:0] LEDM_R_inv;

assign LEDM_R = ~LEDM_R_inv;

assign LEDM_C[0] = 1'b0; // enable col 0
assign LEDM_C[4:1] = 4'b1111; // disable cols 1~5

assign LEDM_R_inv = Rx_Data;

uart ut (
	.din(Rx_Data),
  	.enable(rdy),
	.clock_50MHZ(clock_50MHz),
	.tx(UART_Tx),
	.tx_busy(tx_busy),
	.rdy(rdy),
	.rx(UART_Rx),
	.rdy_clr(rdy),
	.dout(Rx_Data)
);

endmodule
