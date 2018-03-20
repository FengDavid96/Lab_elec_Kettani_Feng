	addi	r4, r0, 10
	call	fact

	putint	r2
	stop

fact:	addi	r27, r27, -32	# allocate stack frame
	stw 	r31, 20(r27)
	stw	r28, 16(r27)
	addi	r28, r27, 32

	stw	r4, 0(r28)	# r4 <- n

	blt	r0, r4, L2	# if arg > 0, goto L2
	addi	r2, r0, 1	# fact(0) = 1
	jmpi	L1		# done

L2:	addi	r4, r4, -1	# n--
	call	fact		# fact(n-1)
	
	ldw	r3, 0(r28)	# r3 <- n
	mul	r2, r2, r3	# fact(n) = n * fact(n-1)

L1:	ldw	r31, 20(r27)	# restore return address
	ldw	r28, 16(r27)	# restore frame pointer
	addi	r27, r27, 32	# pop stack
	ret			# jmp ra

