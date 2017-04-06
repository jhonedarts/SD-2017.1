.module fibonacci
	.text
		li $s1, 15 					#QUANTIDADE DE NUMEROS NA SEQUENCIA DE FIB
		move $t2, $gp				#Endereco de armazenamento
		
		fib:
			subi $sp,$sp,12         # save registers on stack
	        sw $s1, 0($sp)          # save $s1 = n
	        sw $s0, 4($sp)          # save $s0
	        sw $ra, 8($sp)          # save return address $ra
	        bgt $s1,1, gen          # if n>1 then goto generic case
	        move $v0,$s1            # output = input if n=0 or n=1
	        j rreg                  # goto restore registers
		
		gen:
			subi $s1,$s1,1           # param = n-1
	        jal fib                 # compute fib(n-1)
	        move $s0,$v0            # save fib(n-1)
	        sub $s1,$s1,1           # set param to n-2
	        jal fib                 # and make recursive call
	        add $v0, $v0, $s0       # $v0 = fib(n-2)+fib(n-1)
		
		rreg:
			lw  $s1, 0($sp)         # restore registers from stack
	        lw  $s0, 4($sp)         #
	        lw  $ra, 8($sp)         #
	        addi $sp, $sp, 12       # decrease the stack size
	        jr $ra



			
.end