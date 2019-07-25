#Author: Zhiwen Luo
#Date: 01/27/2018
#CS465 Spring 2018

.data

hello_str:
	.asciiz "Hello World!\n Spring 2018 is going to be awesome!"

.text

main:

li $v0, 4
la $a0, hello_str
syscall

# To exit off main

li $v0, 10
syscall