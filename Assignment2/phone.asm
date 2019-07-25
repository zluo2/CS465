# Hongyuan Liu
# ID: hliu22
# Zhiwen Luo
# ID: zluo2

# number of MIPS instructions run: 77257
# R-type: 22382
# I-type: 52818
# J-type: 2057

# Algorithm In Part 1 PDF

.data
	numRows:   .word 4
	numCols:   .word 3
.text

main:
	lw $t6, numRows
	lw $t7, numCols
	# t5 = numRows - 1
	addi $t5, $t6, -1
	
	# int total = 0
	li $s0, 0
	# int i = 0
	li $t4, 0
	forLoop:
		# if i == numRows - 1, branch to endLoop
		beq $t4, $t5, endLoop
		# int j = 0	
		li $t3, 0
		innerForLoop:
			# if j == numCols, branch to endInnerLoop
			beq $t3, $t7, endInnerLoop
			# if(i != 0 || j != 0), branch to callNumOfPNumbers 
			bnez   $t4, callNumOfPNumbers
			bnez   $t3, callNumOfPNumbers
			# else j++, then jump to innerForLoop
			addi $t3, $t3, 1 
			j innerForLoop
			callNumOfPNumbers:
				# total += numOfPNumbers(i, j, 1);
				add $a0, $t4, $zero
				add $a1, $t3, $zero
				addi $a2, $zero, 1
				jal numOfPNumbers
				add $s0, $s0, $v0
			# j++, then jump to innerForLoop
			addi $t3, $t3, 1 
			j innerForLoop
		endInnerLoop:
			# i++, then jump to forLoop
			addi $t4, $t4, 1
			j forLoop
	endLoop:
		# print total
		add $a0, $s0, $zero
		li $v0, 1
		syscall

exit:	
	li $v0, 10			# system call for exit
	syscall				# Exit!

# numOfPNumbers(int x, int y, int length)
numOfPNumbers:
	# adjust stack for 2 items
	addi $sp, $sp, -8	
	# store return address on stack	
	sw $ra, ($sp)			
	# store int total on stack
	sw $s0, 4($sp)
	# total = 0		
	li $s0, 0
	# if x == 3 && y != 1, return 0
	# because it is a symbol instead of a digit
	# else branch to findNextDigit
	bne $a0, 3, findNextDigit
	beq $a1, 1, findNextDigit
	li $v0, 0
	j numOfPNumbersDone
	
	findNextDigit:
		# if length == 7, return 1
		li $v0, 1
		beq $a2, 7, numOfPNumbersDone
	
		# x = x + 2
		# y = y + 1
		# length = length + 1
		addi $a0, $a0, 2
		addi $a1, $a1, 1
		addi $a2, $a2, 1
		# if x + 2 >= numRows || y + 1 >= numCol
		# || x + 2 < 0 || y + 1 < 0, branch to next if
		bge $a0, $t6, secondIf
		bge $a1, $t7, secondIf
		blt $a0, $zero, secondIf
		blt $a1, $zero, secondIf 
		# else, total += numOfPNumbers(x + 2, y + 1, length + 1);
		jal numOfPNumbers
		add $s0, $s0, $v0
	
	secondIf:
		# now x = x + 2, y = y + 1
		# want x = x + 2, y = y - 1
		# just add -2 to y to get y = y - 1
		addi $a1, $a1, -2
		# if x + 2 >= numRows || y - 1 >= numCol
		# || x + 2 < 0 || y - 1 < 0, branch to next if
		bge $a0, $t6, thirdIf
		bge $a1, $t7, thirdIf
		blt $a0, $zero, thirdIf
		blt $a1, $zero, thirdIf 
		# else, total += numOfPNumbers(x + 2, y - 1, length + 1);
		jal numOfPNumbers
		add $s0, $s0, $v0
		
	thirdIf:
		# now x = x + 2, y = y - 1
		# want x = x + 1, y = y - 2
		addi $a0, $a0, -1
		addi $a1, $a1, -1
		# if x + 1 >= numRows || y - 2 >= numCol
		# || x + 1 < 0 || y - 2 < 0, branch to next if
		bge $a0, $t6, fourthIf
		bge $a1, $t7, fourthIf
		blt $a0, $zero, fourthIf
		blt $a1, $zero, fourthIf 
		# else, total += numOfPNumbers(x + 1, y - 2, length + 1);
		jal numOfPNumbers
		add $s0, $s0, $v0
	
	fourthIf:
		# now x = x + 1, y = y - 2
		# want x = x - 1, y = y - 2
		addi $a0, $a0, -2
		# if x - 1 >= numRows || y - 2 >= numCol
		# || x - 1 < 0 || y - 2 < 0, branch to next if
		bge $a0, $t6, fifthIf
		bge $a1, $t7, fifthIf
		blt $a0, $zero, fifthIf
		blt $a1, $zero, fifthIf 
		# else, total += numOfPNumbers(x - 1, y - 2, length + 1);
		jal numOfPNumbers
		add $s0, $s0, $v0
	
	fifthIf:
		# now x = x - 1, y = y - 2
		# want x = x + 1, y = y + 2
		addi $a0, $a0, 2
		addi $a1, $a1, 4
		# if x + 1 >= numRows || y + 2 >= numCol
		# || x + 1 < 0 || y + 2 < 0, branch to next if
		bge $a0, $t6, sixthIf
		bge $a1, $t7, sixthIf
		blt $a0, $zero, sixthIf
		blt $a1, $zero, sixthIf 
		# else, total += numOfPNumbers(x + 1, y + 2, length + 1);
		jal numOfPNumbers
		add $s0, $s0, $v0
	
	sixthIf:
		# now x = x + 1, y = y + 2
		# want x = x - 1, y = y + 2
		addi $a0, $a0, -2
		# if x - 1 >= numRows || y + 2 >= numCol
		# || x - 1 < 0 || y + 2 < 0, branch to next if
		bge $a0, $t6, seventhIf
		bge $a1, $t7, seventhIf
		blt $a0, $zero, seventhIf
		blt $a1, $zero, seventhIf 
		# else, total += numOfPNumbers(x - 1, y + 2, length + 1);
		jal numOfPNumbers
		add $s0, $s0, $v0
	
	seventhIf:
		# now x = x - 1, y = y + 2
		# want x = x - 2, y = y - 1
		addi $a0, $a0, -1
		addi $a1, $a1, -3
		# if x - 2 >= numRows || y - 1 >= numCol
		# || x - 2 < 0 || y - 1 < 0, branch to next if
		bge $a0, $t6, eighthIf
		bge $a1, $t7, eighthIf
		blt $a0, $zero, eighthIf
		blt $a1, $zero, eighthIf 
		# else, total += numOfPNumbers(x - 2, y - 1, length + 1);
		jal numOfPNumbers
		add $s0, $s0, $v0
		
	eighthIf:
		# now x = x - 2, y = y - 1
		# want x = x - 2, y = y + 1
		addi $a1, $a1, 2
		# if x - 2 >= numRows || y + 1 >= numCol
		# || x - 2 < 0 || y + 1 < 0, branch to RestoreArgs
		bge $a0, $t6, RestoreArgs
		bge $a1, $t7, RestoreArgs
		blt $a0, $zero, RestoreArgs
		blt $a1, $zero, RestoreArgs
		# else, total += numOfPNumbers(x - 2, y + 1, length + 1);
		jal numOfPNumbers
		add $s0, $s0, $v0
	
	RestoreArgs:
		# now x = x - 2, y = y + 1
		# length = length + 1
		# want the original x, y, length before any recursion call on it
		addi $a0, $a0, 2
		addi $a1, $a1, -1
		addi $a2, $a2, -1
		# store total to v0 as return value
		add $v0, $s0, $zero
	
	numOfPNumbersDone:
		# restore return address
		lw $ra, ($sp)
		# restore the previous total before this function call
		lw $s0, 4($sp)
		# pop 2 items from stack
		addi $sp, $sp, 8
		# return 
		jr $ra
		