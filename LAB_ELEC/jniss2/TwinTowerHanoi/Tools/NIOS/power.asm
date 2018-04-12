	addi	r4, r0, 2	# set value 2 for a (base)
	addi	r5, r0, 4	# set value 4 for n (power)
	addi	r2, r0, 1	# initlialize r2 for restoring result
	
	call	power		# call procedure power
	stop

power:	beq	r5, r0, p1	# if n == 0, switch to branch p1
	br	p2		# else, switch to branch p2	

p1:	addi	r2, r0, 1
	addi	r27, r27, 4
	ldw	r31, 0(r27)
	ret

p2:	addi	r5, r5, -1
	stw	r31, 0(r27)
	addi	r27, r27, -4
	call	power
	mul	r2, r4, r2
	addi	r27, r27, 4
	ldw	r31, 0(r27)
	ret




