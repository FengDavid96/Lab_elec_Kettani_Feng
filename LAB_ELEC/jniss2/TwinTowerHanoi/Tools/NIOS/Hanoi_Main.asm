#-----------------------------------------------------
# Projet :
# File   :
#
#-----------------------------------------------------

		.data
TopA:					# top of stack
		.skip	16*4	# manage memory for 16 value of 4 bytes (i.e. 16 Words)
StackA:					# bottom of stack

Counter: .skip	4		# some other data of program


# start of program is defined by the next directive 
		.text

Prog_Main:			# <label> of begin program
	movia	r8, StackA	# load address of symbol
	addi	r4, r0, 3
	call	Sub_Prog
	nop
	trap			# this instruction is the end of program


Sub_Prog:
	addi    r27, r27, -4	# manage space in the stack and ...
	stw     r31, 0(r27)	# save the RA (return address) register

	nop			# insert your code

     	ldw     r31, 0(r27)	# restaure the RA register
      	addi    r27, r27, 4
      	ret