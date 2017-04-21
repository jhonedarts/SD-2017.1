.data
.equ UART0, 0x860
resultado:
.word 0
msg:
.asciz "Digite um numero inteiro (Base): "
msg1:
.asciz "Digite um numero inteiro (Expoente): "
msg2:
.asciz "Resultado: "

.text	
	.global main
	main:
		movi r20, 10 		# 10 = codigo do enter
		
		movia r4, msg		##
		movia r5, UART0		# printf
		call nr_uart_txstring	##
		call scanf
		mov r16, r21
		
		movia r4, msg1		##
		movia r5, UART0		# printf
		call nr_uart_txstring	##			
		mov r21, r0
		call scanf		
		mov r17, r21
				
		#movi r16, 7 		   #DEFINE A BASE
		#movi r17, 3 		   #DEFINE A POTENCIA
		movi r18, 1 		   #CONTADOR DO LOOP
		mov r8, r16		   #atribui a primeira iteracao, colocando a base em r8
	
		Loop: 
		beq r18, r17, Endfor	   #verifica se o contador do loop e igual a potencia, ou seja, fim de calculo
		mul r8, r8, r16		   #multiplica a base por ela mesmo e armazena em r8
		addi r18, r18, 1	   #incrementa contador
		br Loop			   #volta para o loop, caso contador != potencia
		
		Endfor: 
		movia r9, resultado
		stw r8, 0(r9)		   #guarda o resultado na memoria
		movia r4, msg2		##
		movia r5, UART0		# printf
		call nr_uart_txstring	##
		mov r4, r8		##
		movia r5, UART0		# printf result
		call nr_uart_txhex	##
		br exit
		
		#ldw r10, 0(r9)
	scanf:	mov r22, r31
	sloop:	movia r4, UART0		
		call nr_uart_rxchar
		blt r2, r0, sloop
		mov r4, r2
		movia r5, UART0
		call nr_uart_txchar		
		bne r4, r20, cont	#apertou enter sai do scanf
		jmp r22
	cont:	mul r21, r21, r20
		subi r2, r2, 0x30
		add r21, r21, r2
		br sloop
	
	exit:
