.data
.equ UART0, 0x860
input1:	.asciz "Insira um numero: "
input2:	.asciz "resultados em hexadecimal:"
space:	.asciz " "
saida: #64 words
.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
swap: #64 words
.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

.text 
	.global main
	
main:
	movia r20, swap		#guarda o endereço da memoria para swap
	addi r20, r20, 256	#posiciona no final da swap
	movi r16,0
	movia r21, saida	#guarda o endereço das saidas em r21
	movi r16,0
	#movi r2,4
	#movia r4,msg
	#call printf
	#call scanf
	movi r17,1		#c=1
	movi r18,35		#valor de entrada
loop:	
	mov r4,r16		#mov i -> int i
	bgt r17,r18,end		#if c<=n
	call fib
	mov r4,r2		#mov return -> r4 to print
	movi r2,1	
	#call printf		#print number
	stw r4, 0(r21)
	addi r21,r21,4 
	#movia r4,msg2
	#movi r2,4
	#call printf		#print space
	addi r17,r17,1		#c=c+1
	addi r16,r16,1		#i=i+1
	br loop



##################################

 fib:
	addi r27, r27, -4
	addi r20, r20, -8
	stw r31, 0(r27)
	stw r16, 4(r20)
	addi r2, r0, 1
	beq r4, r0, fin2
	addi r8, r0, 1
	beq r4, r8, fin
	addi r4, r4, -1
	stw r4, 0(r20)
	call fib
	add r16, r2, r0
	ldw r4, 0(r20)
	addi r4, r4, -1
	call fib
	add r2, r2, r16
fin:
	ldw r16, 4(r20)
	ldw r31, 0(r27)
	addi r27, r27, 4
	addi r20, r20, 8
	jmp r31
	
fin2:				#necessário criar esta label para retornar 0
	movi r2,0		
	ldw r16, 4(r20)
	ldw r31, 0(r27)
	addi r27, r27, 4
	addi r20, r20, 8
	jmp r31
	
scanf:	mov r23, r31
sloop:	movia r4, UART0		
	call nr_uart_rxchar
	blt r2, r0, sloop
	mov r4, r2
	call nr_uart_txchar		
	bne r4, r19, cont	#apertou enter sai do scanf
	jmp r23
cont:	mul r22, r22, r19
	subi r2, r2, 0x30
	add r22, r22, r2
	br sloop
		
printf: mov r23, r31
	call nr_uart_txhex	##
	movi r4, 10
	call nr_uart_txchar
	jmp r23
end:
	

#reference
# https://www.fatalhalt.net/content/mips-assembly-recursive-fibonacci
