.data
msg:	.asciiz "Insira um numero: "
msg2:	.asciiz " "
	
	.text 
	.globl main
	
main:
	li $s0,0
	li $v0,4
	la $a0,msg
	syscall
	li $v0,5
	syscall
	bge $v0,20,end		#if n<=20
	li $s1,1		#c=1
	move $s2,$v0		#n
loop:	
	move $a0,$s0		#move i -> int i
	bgt $s1,$s2,end		#if c<=n
	jal fib
	move $a0,$v0		#move return -> $a0 to print
	li $v0,1
	syscall
	la $a0,msg2
	li $v0,4
	syscall
	addi $s1,$s1,1		#c=c+1
	addi $s0,$s0,1		#i=i+1
	j loop

end:
	li $v0,10
	syscall

##################################

 fib:
	addi $sp, $sp, -12
	sw $ra, 8($sp)
	sw $s0, 4($sp)
	addi $v0, $zero, 1
	beq $a0, 0, fin2
	addi $t0, $zero, 1
	beq $a0, $t0, fin
	addi $a0, $a0, -1
	sw $a0, 0($sp)
	jal fib
	add $s0, $v0, $zero
	lw $a0, 0($sp)
	addi $a0, $a0, -1
	jal fib
	add $v0, $v0, $s0
fin:
	lw $s0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
fin2:				#necessário criar esta label para retornar 0
	li $v0,0		
	lw $s0, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra