#Author: Zhiwen Luo
#Date: 02/27/2018
#CS465 HW2 Part2

################################################################################

.data

list0: .word 4,6
list1: .word 6,8
list2: .word 7,9
list3: .word 4,8
list4: .word 0,3,9
list5: .word 
list6: .word 0,1,7
list7: .word 2,6
list8: .word 1,3
list9: .word 2,4

listLength: .word 2,2,2,2,3,0,3,2,2,2 # listLength

prompt:
	.asciiz "Total Phone Number is : "
.text

#########################################################################################

main:

	# allocate new spot for array in memory
	#syscall: sbrk
	addi $a0, $0, 40			# allocate n*4 = 40 bytes (n=10)  
	addi $v0, $0, 9
	syscall						# syscall to allocate
	addi $s0, $v0, 0			# $s0 = new empty memory

	# manually initialize dynamic array with each list first address {list0-list9}
	la $t0, list0
	sw $t0, 0($s0)
	la $t0, list1
	sw $t0, 4($s0)
	la $t0, list2
	sw $t0, 8($s0)
	la $t0, list3
	sw $t0, 12($s0)
	la $t0, list4
	sw $t0, 16($s0)
	la $t0, list5
	sw $t0, 20($s0)
	la $t0, list6
	sw $t0, 24($s0)
	la $t0, list7
	sw $t0, 28($s0)
	la $t0, list8
	sw $t0, 32($s0)
	la $t0, list9
	sw $t0, 36($s0)
							# s0 = array

	la $s1, listLength #$s1 - first address of length

							# s1 = length of each array 
	
	#j AllPhoneNumber

	#endAllPhoneNumber:

	#li $v0, 4
	#addi $a0, $s7, 0
	#syscall 

	# To exit off main
	end: 
		li $v0, 10
		syscall

##################################################################################################

# int AllPhoneNumber()
#{
#	int total = 0;
#	int PhoneNumberLength = 1;
#	for (int i = 2; i<10; i++)
#	{
#		//based on i to find all of the next number 
#		//such as: if i == 1, j should be 8 and 6. 
#		for (j = nextNumber)
#		{
#			total += generatePhoneNumber(j, PhoneNumberLength);
#		}	
#	}
#	return total;
#}

	AllPhoneNumber:
		li $s7, 0 		# init total
		addi $t0, $zero, 1 	#init phoneNumberLength 
		addi $t1, $zero, 2	#beginning first the phone number
		li $t7, 10
		outloop:
			slt $t2, $t1, $t7 # t2 == 1 if t1<t7
			beq $t2, $zero, endOutloop #if t2==0, meaning that t1>=t7(10)
			sll $t3, $t1, 2 #currentPhoneNumber * 4 
	    		add $t3, $t3, $s1 #get the address of length
	    		lw $s2, 0($t3) #s2 to store the length 
	    		sll $t4, $t1, 2 #currentPhoneNumber * 4
	    		add $t4, $t4, $s0 #get the address of array
	    		lw $s3, 0($t4) #s3 to store the array 
	    		li $t3, 0 #using t3 as index on the array 
	    	inloop:
	    		slt $t4, $t3, $s2 #t4==1 if t3<s2
	    		beq $t4, $zero endinloop #if t4==0 means that t3 >=s2
	    		sll $t5, $t3, 2 
	    		add $t5, $t5, $s3 #get the next number address 
	    		lw $s3, 0($t5) #get the next number
	    		add $a0, $s3, $zero
	    		add $a1, $t0, $zero
	    		jal generatePhoneNumber
	    		lw $a0, 0($sp)
	    		lw $a1, 4($sp)
	    		lw $ra, 4($sp)
	    		addi $sp, $sp, 12
	    		add $s7, $s7, $v0
	    		jr $ra
	    		addi $t3, $t3, 1
	    		j inloop
	    	endinloop:
	    		addi $t1, $t1, 1
	    		j outloop
		endOutloop:

	#j endAllPhoneNumber


####################################################################################################

# algorithm: According to the constrains, build the phone number tree.
# for each root(2-9), return the total number of leaf.  
# int generatePhoneNumber(int currentPhoneNumber, int phoneNumberLength)
#{
#	phoneNumberLength++;
#	if (phoneNumberLength == 7)
#		return 1;
#	else 
#	{
#		//based on the currentPhoneNumber, find the next number
#		int total = 0;
#		for (i = nextNumber)
#			total += generatePhoneNumber(nextNumber, phoneNumberLength)
#		return total;
#	}	
#}

	generatePhoneNumber:

		addi $sp, $sp, -12 #adjust stack for 3 items 
		sw $ra, 8($sp)     #save return address 
		sw $a1, 4($sp)	   #save argument1 - phoneNumberLength
		sw $a0, 0($sp)     #save argument0 - currentPhoneNumber
		addi $t0, $a1, 0   #put phoneNumberLength into $t0
	    	addi $t0, $t0, 1   #phoneNumberLength++;
	    	slti $t1, $t0, 7    #test length < 7
	    	bne $t1, $zero, else #if length < 7 then go to else
	    	addi $v0, $zero, 1	#if length==7 return is 1
	    	addi $sp, $sp, 12   #pop 3 items from stack 
	    	jr $ra 				#and return 

	    else:	

	    	addi $s6, $s6, 0 #init s6 as total 
	    	sll $t3, $a0, 2 #currentPhoneNumber * 4 
	    	add $t3, $t3, $s1 #get the address of length
	    	lw $s2, 0($t3) #s2 to store the length 
	    	sll $t4, $a0, 2 #currentPhoneNumber * 4
	    	add $t4, $t4, $s0 #get the address of array
	    	lw $s3, 0($t4)  #s3 store the array
	    	li $t7, 0
	    	
	    	loop:
	    		slt $t6, $t7, $s2 #if t6 ==1 then t7 < s2
	    		beq $t6, $zero endloop #if t6==0, then t7>=s2
	    		sll $t5, $t7, 2 
	    		add $t5, $t5, $s3 #get the next number address 
	    		lw $s4, 0($t5) #get the next number - s4
	    		addi $a0, $s4, 0
	    		addi $a1, $t0, 0
	    		jal generatePhoneNumber
	    		lw $a0, 0($sp)
	    		lw $a1, 4($sp)
	    		lw $ra, 4($sp)
	    		addi $sp, $sp, 12
	    		add $s6, $s6, $v0
	    		jr $ra
	    		addi $t7, $t7, 1
	    		j loop 
	    		
	    	endloop:


#######################################################################################################

