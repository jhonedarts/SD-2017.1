###############################################
# Example: io.s
# All inputed on UART0 is outputed on UART0
###############################################

		.data
		.equ UART0, 0x860
		 msg:
		 .asciz "Positive integer: "

		.global main
		.text
main:		movia r4, UART0
		call nr_uart_rxstring
		blt r2, r0, main

		mov r4, r2
		movia r5, UART0
		call nr_uart_txstring
		br main
