
main: 
	li $v0, 5
	syscall 		#input the number from the users
	add $t1, $v0, $zero
	
LOOP: 	slt $t2, $zero, $t1
	beq $t2, $zero, DONE
	subi $t1, $t1, 1
	addi $s2, $s2, 2
	j LOOP
DONE:

end: 
	li $v0, 10
	syscall