	addi	r4, r0, -2
	addi	r5, r0, 3
	call	SHF
	trap

SHF:
	addi	r27, r27, -4
	stw	r31, 0(r27)

	sra		r2, r4, r5
	addi	r5, r5, -32
	addi	r5, r5, -1
	xori	r5, r5, 0xffffffff
	sll		r3, r4, r5

	ldw	r31, 0(r27)
	addi	r27, r27, 4
	ret