`include "parameters.v"
module rx(
	input wire rx,
	input wire clear,
	input wire clock50,
	input wire tick,
	output reg rdy,
	output reg [7:0] out_rx
);

	reg [1:0] estado = `ESTADO_START; //PRIMEIRO ESTADO 
	reg [3:0] amostra_dado = 0;
	reg [3:0] contador = 0;
	reg [7:0] data = 8'b0;

	always @ ( posedge clock50 ) begin

		if(clear) rdy <= 0;//REINICIA A MAQUINA

		if(tick) begin// INFORMAR SE O ESTADO ESTÁ ATIVO
			case (estado)
				`ESTADO_START: begin
					if(~rx || amostra_dado != 0) amostra_dado <= amostra_dado + 4'b1;
					if(amostra_dado == 15) begin
						estado <= `ESTADO_TRAB;
						contador <= 4'd0;
						amostra_dado <= 4'd0;
						data <= 8'd0;
					end
				end
				`ESTADO_TRAB: begin
					amostra_dado <= amostra_dado + 4'b1;
					if (amostra_dado == 4'd8) begin
						data[contador] <= rx;//contador para colocar o dado recebido no data ...
						contador <= contador + 4'b1;
					end
					if (contador == 8 && amostra_dado == 15) 
						estado <= `ESTADO_STOP; // quando a amostrar passar do contador 8 envia  e tb 15.. agora não entendi porque usaram 15 fiquei na duvida olhar na video aula de verilog
				end
				`ESTADO_STOP: begin
					if (amostra_dado == 15 || (amostra_dado >= 8 && ~rx)) begin
						estado <= `ESTADO_START;
						out_rx <= data;
						rdy <= 1'b1;
						amostra_dado <= 4'd0;
					end
					else begin
						amostra_dado <= amostra_dado + 4'b1;
					end
				end
				default: estado <= `ESTADO_START;
			endcase
		end
	end
endmodule
