#############################################################################
#  Row-major order traversal of 8 x 8 array of words.
#  Pete Sanderson
#  31 March 2007
#  Edited by Yutao Zhong, April 2017
#
#  To easily observe the row-oriented order, run the Memory Reference
#  Visualization tool with its default settings over this program.
#  You may, at the same time or separately, run the Data Cache Simulator 
#  over this program to observe caching performance.  Compare the results
#  with those of the column-major order traversal algorithm.
#
#  The C/C++/Java-like equivalent of this MIPS program is:
#     int size = 8;
#     int[size][size] data;
#     int value = 0;
#     for (int i=0; i<2; i++){
#     	 for (int row = 0; row < size; row=row+2) {
#            for (int col = 0; col < size; col++) }
#           	data[row][col] = value;
#           	value++;
#            }
#     	 }
#     }
#
#
         .data
data:    .word     0 : 64       # storage for 8x8 matrix of words
         .text
         li       $t0, 8        # $t0 = number of rows
         li       $t1, 8        # $t1 = number of columns
	 li	  $t3, 2
	 move	  $t4, $zero
outer:   move     $s0, $zero     # $s0 = row counter
         move     $s1, $zero     # $s1 = column counter
         move     $t2, $zero     # $t2 = the value to be stored
#  Each loop iteration will store incremented $t1 value into next element of matrix.
#  Offset is calculated at each iteration. offset = 4 * (row*#cols+col)
#  Note: no attempt is made to optimize runtime performance!
loop:    mult     $s0, $t1       # $s2 = row * #cols  (two-instruction sequence)
         mflo     $s2            # move multiply result from lo register to $s2
         add      $s2, $s2, $s1  # $s2 += column counter
         sll      $s2, $s2, 2    # $s2 *= 4 (shift left 2 bits) for byte offset
         sw       $t2, data($s2) # store the value in matrix element
         addi     $t2, $t2, 1    # increment value to be stored
#  Loop control: If we increment past last column, reset column counter and increment row counter
#                If we increment past last row, we're finished.
         addi     $s1, $s1, 1    # increment column counter
         bne      $s1, $t1, loop # not at end of row so loop back
         move     $s1, $zero     # reset column counter
         addi     $s0, $s0, 2    # increment row counter
         bne      $s0, $t0, loop # not at end of matrix so loop back
         addi	  $t4, $t4, 1
         bne 	  $t4, $t3, outer#repeat twice
#  We're finished traversing the matrix.
         li       $v0, 10        # system service 10 is exit
         syscall                 # we are outta here.
         
         
         
         
