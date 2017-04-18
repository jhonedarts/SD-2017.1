###############################################
# Example: io.s
# All inputed on UART0 is outputed on UART0
###############################################

.data
	.equ UART0, 0x860
	msg:
	.asciz "Positive integer: "
.text
	.global main
main:		
		movia r4, msg		##
		movia r5, UART0		# printf
		call nr_uart_txstring	##
		movi r20, 10 		# 10 = codigo do enter
scanf:		movia r4, UART0		
		call nr_uart_rxchar
		blt r2, r0, scanf

		mov r4, r2
		movia r5, UART0
		call nr_uart_txchar
		beq r4, r20, exit	#apertou enter sai do scanf
		mul r16, r16, r20
		subi r17, r2, 0x30
		add r16, r16, r17
		br scanf

exit:
