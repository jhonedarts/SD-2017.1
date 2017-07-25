.module calculo_raiz
	
	.text
	addi $s0, $zero, 25 #raiz
	addi $s1, $zero, 1 #so para comparacao

	
	Loop: slti $t1, $s0, 1 #verifica se o resultado parcial Ã© menor do que 1
	beq $t1, $s1, Endfor #caso seja menor do que 1 vai pro final do loop
	addi $s3, $zero, 2
	mul $t0, $s2, $s3 #indice * 2 + 1
	addi $t0, $t0, 1
	sub $s0, $s0, $t0 #raiz - indice
	addi $s2, $s2, 1 #adiciona 1 ao contador
	j Loop
	Endfor: sw $s2, 0($gp) #armazena o resultado final

.end