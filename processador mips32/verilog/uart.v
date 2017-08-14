module uart(
	input wire [7:0] din,
	input wire clock_50MHZ,
	input wire enable,
	input wire rx,
	input wire rdy_clr,
	output wire tx,
	output wire tx_busy,	
	output wire rdy,
	output wire [7:0] dout
);

	wire rxclk_en, txclk_en;

	baudRate baudrate(
		.clk_50m(clock_50MHZ),
		.rxclk_en(rxclk_en),
		.txclk_en(txclk_en)
	);

	tx transmissao(				
		.dados_transmissao(din),
        .wr_en(enable),
        .clock_50(clock_50MHZ),
        .tick(txclk_en),
        .tx(tx),
        .tx_busy(tx_busy)
	);

	rx recebe(	  
		.rx(rx),
		.reinicia(rdy_clr),
		.clock(clock_50MHZ),
		.tick(rxclk_en),
		.rdy(rdy),
		.saida_rx(dout)		
	);
endmodule
