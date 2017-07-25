.module test_case

	.pseg
		addi $t0, $zero, 1 #i
    addi $t1, $zero, 10 #limite

    Loop: beq $t1, $t0, Endfor
    sw $t0, 0($s0);
    addi $t0, $t0, 1 #incrementa
    EndFor:
.end
