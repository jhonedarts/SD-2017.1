.module calculo_potencia
	
	.text	
		addi $s7, $zero, 0x860
		addi $t6, $zero, 12
		loop:
		norx:
			lw $t5, 8($s7)
			beq $t5, $t6, endnorx
			j norx
		endnorx:
		sw $zero, 8($s7)
		lw $s0, 4($s7)
		sw $s0, 0($s7)
		notx:
			lw $t5, 12($s7)
			beq $t5, $t6, endnotx
			j notx
		endnotx:
		j loop
			
.end
