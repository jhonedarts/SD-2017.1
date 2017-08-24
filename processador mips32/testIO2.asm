.module testIO
	
	.text	
		add $zero, $zero, $zero
		addi $s6, $zero, 51
		addi $s7, $zero, 0x860
		sw $s6, 0($s7)		
		addi $t6, $zero, 12
		norx:
			lw $t5, 4($s7)
			add $zero, $zero, $zero
			sw $t5, 0($s7)
			beq $t5, $t6, endnorx
			j norx
		endnorx:			
.end
