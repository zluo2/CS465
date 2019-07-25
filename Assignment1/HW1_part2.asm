#Author: Zhiwen Luo
#Date: 02/12/2018
#CS465 HW2 Part2

#using loop to get the input from the users
#output the list and length
#sort the list and find the median 
#sort algorithm : bubble sort alogrithm 

#entry 3 1 5 2 10 11 0 
#the number of MIPS instructions: 475 

.data

list1: .word  # list

prompt:
	.asciiz "Please enter input postive numbers: "
prompt1:
	.asciiz "Please enter input postive numbers: "
nextLine: 
	.asciiz "\n"
space:
	.asciiz " "
elements:
	.asciiz "User input: "
size:
	.asciiz "List Size: "
result:	
	.asciiz "Median: "

.text

main:	
	li $t0, 0 		#$t0 is the counter 
	la $s1, list1		#load address of list1 into s1
	
	li $v0, 4
	la $a0, prompt
	syscall			#ouput the first promot 
	
	read:	
		li $v0, 5
		syscall 		#input the number from the users
		
		beq $v0, $zero, print1
		sll $t1, $t0, 2
		add $t1, $t1, $s1
		sw $v0, 0($t1)  	#store the input 
		addi $t0, $t0, 1 #increase counter 
		
		li $v0, 4
		la $a0, prompt1 
		syscall			#output rhe promot from each loop 
		
		j read
		
	print1:	
		li $t2, 0		#init the new int for the output loop
	
		li $v0, 4		#output the list promot 
		la $a0, elements
		syscall

	print2:
		beq $t0, $t2, print3
	
		sll $t3, $t2, 2
		add $t3, $t3, $s1
		lw $t4, 0($t3)
		addi $t2, $t2, 1 	#get the int from the list 
		
		li $v0, 1
		add $a0, $t4, $zero
		syscall 		#output the int from list 
		
		li $v0, 4
		la $a0, space		#ouput the space between the int 
		syscall 
		
		j print2
		
	print3: 
		li $v0, 4
		la $a0, nextLine	#change to the next line 
		syscall  
		
		li $v0, 4
		la $a0, size		
		syscall 
		
		li $v0, 1
		add $a0, $t0, $zero
		syscall 		#output the list size 
		
	# Bubble Sort  
	li $t1, 0                         # Resets $t1 to 0 (i)
	
	# Outer loop
    	outLoop:
        	beq $t1, $t0, endSort             # Branches to the end of list  
        	j InLoop1                           # Jumps back to bSort
        	outLoop2:	addi $t1, $t1, 1                  # Adds 1 to $t1  
        			j outLoop
         
    	InLoop1:
    		li $t2, 0
    		addi $t2, $t1, 0 		#$t2 (j) 
    		InLoop2:
       			beq $t2, $t0, outLoop2     # Branches to outLoop if j > len
        		sll $t3, $t1, 2                  
        		add $t3, $t3, $s1	#get the i 
        		sll $t4, $t2, 2
        		add $t4, $t4, $s1	#get the j
        		lw $t5, 0($t3)            # get the array[i]
        		lw $t6, 0($t4)            # get the array[j]
        		bge $t6, $t5, skip         # Branches to skipTheSwap if they are in the correct order
        		sw $t6, 0($t3)            # Swaps the two indexes 
        		sw $t5, 0($t4)            # ^
        	skip:	addi $t2, $t2, 1                  # Adds 4 to get the next index
        		j InLoop2

 	endSort: 
 	
	li $v0, 4
	la $a0, nextLine
	syscall 
	
	srl $t2, $t0, 1
	sll $t3, $t2, 2
	add $t3, $t3, $s1
	lw $t4, 0($t3)	#get the int from the list 
	
	li $v0, 4
	la $a0, result
	syscall 
		
	li $v0, 1
	add $a0, $t4, $zero
	syscall 
	
	# To exit off main
end: 
	li $v0, 10
	syscall

