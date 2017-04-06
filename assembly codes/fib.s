.text
	.global main
	main:
		movi r17, 5 					#QUANTIDADE DE NUMEROS NA SEQUENCIA DE FIB
		#mov r10, $gp				#Endereco de armazenamento
		movi r18, 1
		
		fib:
		subi r27,r27,12         # save registers on stack
	        stw r17, 0(r27)          # save r17 = n
	        stw r16, 4(r27)          # save r16
	        stw r31, 8(r27)          # save return address r31
	        bgt r17,r18, gen          # if n>1 then goto generic case
	        mov r2,r17            # output = input if n=0 or n=1
	        br rreg                  # goto restore registers
		
		gen:
		subi r17,r17,1           # param = n-1
	        call fib                 # compute fib(n-1)
	        mov r16,r2            # save fib(n-1)
	        subi r17,r17,1           # set param to n-2
	        call fib                 # and make recursive call
	        add r2, r2, r16       # r2 = fib(n-2)+fib(n-1)
		
		rreg:
		ldw  r17, 0(r27)         # restore registers from stack
	        ldw  r16, 4(r27)         #
	        ldw  r31, 8(r27)         #
	        addi r27, r27, 12       # decrease the stack size
	        jmp r31
			
.data