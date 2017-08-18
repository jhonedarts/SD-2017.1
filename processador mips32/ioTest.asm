.module calculo_potencia
	
	.text
		addi $s0, $zero, 51 
		addi $s2, $zero, 0x860		#UART 0
		sw $s0, 0($s2)
		superLoop:
		beq $s5, 51, end
		loop:
		beq $s1, 0x0c, rx
		lw $s1, 8($s2)
		j loop
		rx:
		lw $s4, 4($s2)
		sw $s4, 0($s2)
		j superLoop
		end:				
.end