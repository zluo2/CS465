# Hongyuan Liu
# ID: hliu22
# Zhiwen Luo
# ID: zluo2

# Algorithm of int get_num(char *str, int base)
# if base is 8, 10, or 16, compute the number in decimal
# else return -1
# get the length of the char array str 
# initialize int num to 0, and int power to 1
# starting from the last char to the first char of str
# Loop Step:
# check the char
# if the char lies in '0' to '9'
# subtract 48 from the char to get the correct digit
# else if the char lies in 'a' to 'f'
# subtract 87 from the char to get the correct digit
# then multiply the correct digit with power
# and add the result to num 
# raise power by multiplying power with base 
# get the char before this one, go to Loop step


.data
	str_input: .space 10
	prompt_num_of_values: .asciiz "How many values? "
	prompt_base: .asciiz "What is the base? "
	prompt_value: .asciiz "What is the value? "
	string_total: .asciiz "Total: "
.text

##########################################################################

# start of main

main:
	# print prompt_num_of_values to screen
	la $a0, prompt_num_of_values			
	li $v0, 4
	syscall 
	
	# read user input: int num_of_values
	# it gets stored at $v0
	li $v0, 5
	syscall
	# move int num_of_values to $s0
	add $s0, $v0, $zero
	# int sum = 0
	li $s1, 0
	# int i = 0
	li $s2, 0
	loop:
		# if i >= num_of_values, endloop
		bge $s2, $s0, endloop
		# print prompt_base to screen
		la $a0, prompt_base			
		li $v0, 4
		syscall
		# read user input: int base
		# it gets stored at $v0
		li $v0, 5
		syscall
		# move int base to $s3
		add $s3, $v0, $zero
		
		# print prompt_value to screen
		la $a0, prompt_value			
		li $v0, 4
		syscall
		# read user input string
		li $v0, 8
		la $a0, str_input
		li $a1, 10
		syscall
		
		# move int base to $a1 
		# as it will be the second argument 
		# passed to get_num
		add $a1, $s3, $zero
		# int num = get_num(str_input, base);
		# $s4 = $v0
		jal get_num
		add $s4, $v0, $zero
		# if(num == -1), ignore it
		beq $s4, -1, endif
		# else add num to sum
		add $s1, $s1, $s4 
		endif:
			# i++
			addi $s2, $s2, 1
			j loop
	endloop:
		# print string_total to screen
		la $a0, string_total			
		li $v0, 4
		syscall
		# move sum to $a0
		# print sum
		add $a0, $s1, $zero
		li $v0, 1
		syscall
		
		# system call for exit
		li $v0, 10
		syscall

# end of main

##########################################################################

# start of get_num

# int get_num(char *str, int base)
.globl get_num
get_num:
	# if(base == 10 || base == 16 || base == 8), compute_num
        # else return -1;
        beq $a1, 10, compute_num 
        beq $a1, 16, compute_num
        beq $a1, 8, compute_num
        li $v0, -1
        j get_num_done
        
        compute_num:
		# adjust stack for 5 items
		addi $sp, $sp, -20	
		# store return address on stack	
		sw $ra, ($sp)			
		# store previous s0 before this function call on stack
		sw $s0, 4($sp)
		# store previous s1 before this function call on stack
		sw $s1, 8($sp)
		# store previous s2 before this function call on stack
		sw $s2, 12($sp)
		# store previous s3 before this function call on stack
		sw $s3, 16($sp)
		
		# the input string always ends with a new line
		# because a new line is also a character
		# subtract 1 from length to exclude counting of new line char
		# int length = strlen(str) - 1
		jal strlen
		addi $s0, $v0, -1
		# int power = 1
		li $s1, 1
		# int num = 0
		li $s2, 0
		# int i = length - 1
		addi $s3, $s0, -1
		# move the string pointer to point at ith element
		add $a0, $a0, $s3
		for_loop:
			# if i < 0, branch to end_for_loop
			bltz $s3, end_for_loop
			# $t0 = str[i]
			lb $t0, 0($a0)
			# if (str[i] < 48 || str[i] > 57)
			# the char lies in 'a' to 'f'
			# branch to a_f
			blt $t0, 48, char_a_f
			bgt $t0, 57, char_a_f
			# else the char lies in '0' to '9'
			# $t1 = (str[i] - 48) * power
			addi $t0, $t0, -48
			mult $t0, $s1
			mflo $t1 
			# num += $t1;
			add $s2, $s2, $t1
			j end_if
			char_a_f:
			# the char lies in 'a' to 'f'
			# $t1 = (str[i] - 87) * power
			addi $t0, $t0, -87
			mult $t0, $s1 
			mflo $t1 
			# num += $t1;
			add $s2, $s2, $t1
			end_if:
				# power = power * base;
				mult $s1, $a1
				mflo $s1
				# i--
				addi $s3, $s3, -1
				# decrement the string pointer
				addi $a0, $a0, -1
				j for_loop
		end_for_loop:
			# store num to v0 as return value
			add $v0, $s2, $zero
			# restore return address
			lw $ra, ($sp)
			# restore the previous s0 before this function call
			lw $s0, 4($sp)
			# restore the previous s1 before this function call
			lw $s1, 8($sp)
			# restore the previous s2 before this function call
			lw $s2, 12($sp)
			# restore the previous s3 before this function call
			lw $s3, 16($sp)
			# pop 5 items from stack
			addi $sp, $sp, 20
		get_num_done:
			# return
			jr $ra

# end of get_num

##########################################################################

# start of strlen

# leaf procedure
# int strlen(char *str)
.globl strlen
strlen:
	# int length = 0
	li $t0, 0 
	# store start_addr of str to $t1 
	add $t1, $a0, $zero
	while_loop:
		# load one char in string
		lb $t2, 0($t1)
		# if the char is null character, end_loop
		beqz $t2, end_loop
		# else increment string pointer and length
		addi $t1, $t1, 1
		addi $t0, $t0, 1
		# continue loop
		j while_loop
	end_loop:
		# store length to v0 as return value
		add $v0, $t0, $zero
		# return
		jr $ra

# end of strlen
