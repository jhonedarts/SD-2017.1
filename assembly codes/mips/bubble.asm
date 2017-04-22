#I/O console
.data
.equ UART0, 0x860
saida:
.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
#input_int: .asciz "The prime numbers between 1 and n are:\n"
#newline: .asciz "\n"
#space: .asciz " "


.text
.global main

main:
movia r20, saida
#movi r21, 0
#movia r4, input_int #print "The prime numbers between 1 and 1000 are:"
#movi r2,4
#syscall

movi r6,2 #the first prime is 2
movi r18,10 #Stop searching for primes after r18 value -------------------------------
#subi r18, r18, 1

movi r13,0 #zero initialized
movi r10,6 #initialized to 6

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
		mov r4, r6		##
		movia r5, UART0		# printf result
		call nr_uart_txhex	##
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

exit:

#reference
# http://icrontic.com/discussion/38236/prime-number-in-mips