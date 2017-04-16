.text 
	.global main
	
main:
	movi r20, 20		#r20 = limite da pilha, dá estouro de pilha no 13º
	movia r21, saida	#guarda o endereço das saidas em r21
	movi r16,0
	#movi r2,4
	#movia r4,msg
	#call printf
	movi r2,15		#valor de entrada
	#call scanf
	bge r2,r20,end		#if n<=20
	movi r17,1		#c=1
	mov r18,r2		#n
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
	addi r27, r27, -12
	stw r31, 8(r27)
	stw r16, 4(r27)
	addi r2, r0, 1
	beq r4, r0, fin2
	addi r8, r0, 1
	beq r4, r8, fin
	addi r4, r4, -1
	stw r4, 0(r27)
	call fib
	add r16, r2, r0
	ldw r4, 0(r27)
	addi r4, r4, -1
	call fib
	add r2, r2, r16
fin:
	ldw r16, 4(r27)
	ldw r31, 8(r27)
	addi r27, r27, 12
	jmp r31
	
fin2:				#necessário criar esta label para retornar 0
	movi r2,0		
	ldw r16, 4(r27)
	ldw r31, 8(r27)
	addi r27, r27, 12
	jmp r31
	
end:
	movi r2,10
	#call printf
.data
#msg:	.asciz "Insira um numero: "
#msg2:	.asciz " "
saida:
.word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0  		#15 words