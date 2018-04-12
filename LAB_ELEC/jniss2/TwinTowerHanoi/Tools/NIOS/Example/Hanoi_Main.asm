

Prog_Main:					# <label> of begin program
	addi	r4, r0, 2
	addi	r5, r0, 4
	call	power
	nop
	trap					# this instruction is the end of program


power:
	addi    r27, r27, -4	# manage space in the stack and ...
	stw     r31, 0(r27)		# save the RA (return address) register

	beq		r5, r0, P1		# insert your code
	br		P2	

    ldw     r31, 0(r27)		# restaure the RA register
    addi    r27, r27, 4
    ret

P1:
	addi	r2, r0, 1
	ldw     r31, 0(r27)		
    addi    r27, r27, 4
	ret

P2:
	addi	r5, r5, -1
	call	power
	mul		r2,	r2,	r4
	ldw     r31, 0(r27)		
    addi    r27, r27, 4
	ret
	
	