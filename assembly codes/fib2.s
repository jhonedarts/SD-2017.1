# recursive factorial function, utter silliness of course

print_int = 1
print_string = 4
read_int = 5

	.text
main:
	sub	$sp, 4
	sw	$ra, 0($sp)

	li	$v0, read_int
	syscall

	move	$a0, $v0
	jal	fibonacci

	move	$a0, $v0
	li	$v0, print_int
	syscall

	la	$a0, lf
	li	$v0, print_string
	syscall

	lw	$ra, 0($sp)
	add	$sp, 4

	jr	$ra

# fib(n):$v0 = fibonacci(n:$a0)
# note that we also return the
# (n-1)th fibonacci number in $v1
fibonacci:
	sub	$sp, 8
	sw	$ra, 0($sp)
	sw	$s0, 4($sp)
    
    move $s0, $a0

    # if input is 0 or 1, jump to
    # base case
    beq $s0, $zero, base_case
    li $t6, 1
    bne $s0, $t6, end_base
base_case:
    # for both base cases, F(0)=0
    # and F(1)=1, ie the nth fib number
    # is n itself, so just return $s0.
    move $v0, $s0

    # letting F(-1)=0, the (n-1)th fib
    # number is always 0 in the base case
    li $v1, 0

    j done
end_base:

    # otherwise,
    # F(n)=F(n-1)+F(n-2)
    sub $a0, $s0, 1
    jal fibonacci
    add $t0, $v0, $v1
    move $v1, $v0
    move $v0, $t0

done:
	lw	$s0, 4($sp)
	lw	$ra, 0($sp)
	add	$sp, 8

	jr	$ra


.data
lf:
	.asciiz	"\n"