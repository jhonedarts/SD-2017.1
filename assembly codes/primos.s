#I/O console
.data
.equ UART0, 0x860
swap:
.word 0
input_int: .asciz "Cálculo de numeros primos até a posição desejada " #Cálculo de numeros primos até a posição desejada
input_int2: .asciz "Digite um número inteiro positivo (enter para confimar):"
input_int3: .asciz "Resultados: (hexadecimal)"
space: .asciz " "


.text
.global main

main:
movi r19, 10
movia r5, UART0
movia r20, swap
#movi r21, 0


movia r4, input_int 		#print input1
call nr_uart_txstring
movi r4, 10
call nr_uart_txchar
movia r4, input_int2 		#print input2
call nr_uart_txstring
movi r4, 10
call nr_uart_txchar

call scanf 			#scanf

movia r4, input_int3 		#print input3
call nr_uart_txstring
movi r4, 10
call nr_uart_txchar


movi r6,2 			#the first prime is 2
mov r18,r22 			#Stop searching for primes after r18 value -------------------------------
#subi r18, r18, 1

movi r13,0 			#zero initialized
movi r10,6 			#initialized to 6

movi r16,1

call primeloop 		#jumps back
primeloop:

#Find primes
beq r18,r21,exit	#If it is to the value (r21), else (r0)
#subi r18,r18,1 	#Subtract to keep track as in counter, Enable if it is up to the value
#Set r9 to 2
movi r9,2

divide:

div r11,r6,r9 		#Divides by 2 to get next prime
cmplt r2,r11,r9 	#if quotient less than divisor stop
beq r2,r16,fdprime 	#determine if prime (r2=1), if prime prints
#If remainder is zero, it is a composite,not prime
mul r12, r11, r9
sub r12, r6, r12 	#If it is up to the value
beq r12,r0,nprime
#Try next divisor
addi r9,r9,1
br divide



fdprime:
movi r2,1
#mov r4,r6

#stw r4, 0(r20)		#Salva os primos na memória
#addi r20, r20, 2	#Parte comentada
stw r31, 0(r20)
call printf
ldw r31, 0(r20)

addi r21, r21, 1 # count ++


addi r13,r13,1
beq r13,r10,skip



nprime:
#Advances to the next number
addi r6,r6,1
jmp r31 #goes back to find the primes



skip:
#print break-line
#movi r2,4
#movia r4,newline
#syscall
movi r13,0
br nprime

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
	mov r4, r6		## printf result
	call nr_uart_txhex	##
	movi r4, 10
	call nr_uart_txchar
	jmp r23
	

exit:
subi r6, r6, 1

#reference
# http://icrontic.com/discussion/38236/prime-number-in-mips
