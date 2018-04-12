MAIN:	addi 	r4, r0, 50
	addi 	r5, r0, 10
	call 	GCD
	trap

GCD:	addi	r27, r27, -4
	stw	r31, 0(r27)
	add	r2, r4, r0
	beq	r5, r0, FIN
	div	r2, r4, r5
	mul	r2, r2, r5
	sub	r2, r4, r2
	add	r4, r5, r0
	add	r5, r2, r0
	call	GCD 

FIN:	ldw	r31, 0(r27)
	addi	r27, r27, 4
	ret