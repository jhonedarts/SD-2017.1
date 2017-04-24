.data
.equ UART0, 0x860
A: #64 words
.skip 256 # declaracao array
size: .word 0
input1: .asciz "Digite os valores seguidos de [enter] ([space] para finalizar):"
input2: .asciz "Vetor ordenado (hexadecimal):"

.text
.global main
	main:
	movi r21,10 		#codigo ascii do enter
	movi r12, 32		#codigo ascii do space
	movi r19, 45		#codigo ascii do "-"
	movia r16, A
	mov r17, r16
	movia r5, UART0
	movia r4, input1
	call nr_uart_txstring
	movia r4, 10
	call nr_uart_txchar
inputloop: 
	call scanf
	bne r2, r12, inputcont	
	br inputend
	inputcont: addi r18, r18, 1	# parameter n
	stw r22, 0(r17)
	addi r17, r17, 4
	br inputloop
inputend:
	movia r17, size
	stw r18, 0(r17)
	movi r12, 2
	sll r18, r18, r12 	# number of bytes in array A
	outer:
	subi r8, r18, 8 		# r8: j-1
	movi r9, 0 		# no stwap yet
	inner:
	add r17, r16, r8
	ldw r10, 4(r17) 	# r10 <- A[j]
	ldw r11, 0(r17) 	# r11 <- A[j-1]
	bge r10, r11, no_stwap 	# A[j] <= A[j-1]?
	stw r10, 0(r17) 	# A[j-1] <- r10 \ move bubble
	stw r11, 4(r17) 	# A[j] <- r11 / r10 upwards
	movi r9, 1 		# stwap occurred
	no_stwap:
	subi r8, r8, 4 		# proximo elemento do array (next array element)
	bge r8, r0, inner 	# more?
	bne r9, r0, outer 	# did we stwap
	
	#apresentar vetor ordenado
	movia r17, size
	ldw r18, 0(r17)
	movi r17, 0
	movi r4, 10	
	call nr_uart_txchar	# quebra de linha
	movia r4, input2
	call nr_uart_txstring
	movia r4, 10
	call nr_uart_txchar	# quebra de linha
show:	beq r17, r18, exit	# while(r17 != r18)
	ldw r4, 0(r16)
	call printf		# printa o valor em r4
	addi r16, r16, 4	# aponta o proximo
	addi r17, r17, 1	# count++
	br show
	
scanf:	mov r23, r31
	movi r22, 0
	movi r20, 1
sloop:	movia r4, UART0		
	call nr_uart_rxchar
	blt r2, r0, sloop
	mov r4, r2
	call nr_uart_txchar	
	bne r4, r12, cont1	#apertou enter sai do scanf
	jmp r23
cont1:	bne r4, r21, cont	#apertou enter sai do scanf
	beq r20, r0, negativenumber
	jmp r23
cont:	bne r2, r19, cont2
	movi r20, 0
	br sloop
cont2:	mul r22, r22, r21
	subi r2, r2, 0x30
	add r22, r22, r2
	br sloop
negativenumber: 
	mov r20, r22
	add r22, r22, r20
	sub r22, r20, r22
	jmp r23
	
printf: mov r23, r31
	call nr_uart_txhex	##
	movi r4, 10
	call nr_uart_txchar
	jmp r23
	
exit:

#reference
# http://pcspim-mips.blogspot.com.br/2009/06/bubble-sort.html
