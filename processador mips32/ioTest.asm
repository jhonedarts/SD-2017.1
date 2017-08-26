.module testUartLoopBack
	
	.text	
		add $zero, $zero, $zero
		addi $s7, $zero, 0x860		
		addi $s6, $zero, 12
			norx:
				lw $t5, 8($s7)
				add $zero, $zero, $zero
				add $zero, $zero, $zero
				beq $t5, $s6, endnorx
				j norx
			endnorx:
			sw $zero, 8($s7)
			lw $s0, 4($s7)
			addi $t5, $zero, 0
			sw $s0, 0($s7)
			notx:
				lw $t5, 12($s7)
				add $zero, $zero, $zero
				add $zero, $zero, $zero
				beq $t5, $s6, endnotx
				j notx
			endnotx:
			addi $t5, $zero, 0
			sw $zero, 12($s7)
		j norx
			
.end
