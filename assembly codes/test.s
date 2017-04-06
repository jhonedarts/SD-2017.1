.text
.global main
	main:
		movi r16, 15 				#QUANTIDADE DE NUMEROS NA SEQUENCIA DE FIB
		movia r10, foo				#Endereco de armazenamento			
		
		FIB:
			cmplti r8, r16, 2		#condicao base n < 2
			bne r8, zero, VERIFY		#caso seja a condicao base
			addi r8, r16, -1		#caso nao seja (n-1)
			addi r9, r16, -2		#(n-2)
			add r8, r8, r9		   	#(n-1) + (n-2)
						
		VERIFY:
			stw r8, 0(r10)			#coloca na memoria e continua o processo
			addi r10, r10, 1
			addi r16, r16, -1
			bne r16, zero, FIB
			
			ret
.data
foo: # a label, a name for this part of memory
.word 0 #this is a directive to initialize memory 
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
