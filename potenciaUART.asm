.module potenciaUART
	.data
		resultado:
		.word 0
		msg:
		.asciiz "Digite um numero inteiro positivo (Base): "
		msg1:
		.asciiz "Digite um numero inteiro positivo (Expoente): "
		msg2:
		.asciiz "Resultado (hexadecimal): "
	.text

		addi $s4, 10 				# 10 = codigo do enter
		addi 0x860, $zero, 0x860 		#UART0
		
		addi $a0, msg		
		addi $a1, $zero, 0x860	
		jal nr_uart_txstring
		jal scanf
		add $s0, $zer0, $s5
		
		la $a0, msg1		
		addi $a1, $zero, 0x860		# printf
		jal nr_uart_txstring			
		add $s5, $zero, $zero
		jal scanf		
		add $s1, $zero, $s5

		addi $s2, $zero, 1 		  	#CONTADOR DO LOOP
		add $t0, $zero, $s0		   	#atribui a primeira iteracao, colocando a base em $t0
		
		la $t1, resultado
		sw $s2, 0($t1)
		beq $s1, $zero, Endfor
		
		Loop: 
		beq $s2, $s1, Endfor	   	#verifica se o contador do loop e igual a potencia, ou seja, fim de calculo
		add $t2, $zero, $t0
		mul $t0, $t0, $s0		   	#multiplica a base por ela mesmo e armazena em $t0
		addi $s2, $s2, 1	   		#incrementa contador
		j Loop			   			#volta para o loop, caso contador != potencia
		
		Endfor: 
		bne $s1, $zero, contp
		addi $t0, $zero, 1
		addi $t2, $zero, 1
	contp:	
		la $t1, resultado
		sw $t0, 0($t1)		   		#guarda o resultado na memoria
		la $a0, msg2
		addi $a1, $zero, 0x860		# printf
		jal nr_uart_txstring	
		sw $t0, 0(0x860)
		notx:
			lw $t7, 12(0x860)
			addi $t8, $zero, 12
			bne $t7, $t8, notx
		j exit
		
	scanf:	add $s6, $zero, $ra
	sloop:	addi $a0, $zero, 0x860		
		jal nr_uart_rxchar
		blt $v0, $zero, sloop
		add $a0, $zero, $v0
		addi $a1, $zero, 0x860
		jal nr_uart_txchar		
		bne $a0, $s4, cont			#apertou enter sai do scanf
		jr $s6
	cont:	mul $s5, $s5, $s4
		subi $v0, $v0, 0x30
		add $s5, $s5, $v0
		j sloop

	nr_uart_txstring: 		
		lw $t5, 0($a0)
		addi $t6, $zero, 1
		printLoop:			
			lw $t7, $t6($a0)
			sw $t7, 0(0x860)
			notx:
				lw $t7, 12(0x860)
				addi $t8, $zero, 12
				bne $t7, $t8, notx
			beq $t6, $t5, endprintLoop
			addi $t6, $t6, 1
			j printLoop
		endprintLoop:
		jr $ra

		exit:
	
.end