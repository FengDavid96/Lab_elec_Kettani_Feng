# Twin Tower of Hanoi game
#
# assume that input n is in r4, src/dst/tmp in r5/r6/r7
# return the number of steps in r2 (When call procedure, count add one)

# Stacks A/B/C are located in memory locations [0: 63], [64: 127], and [128, 191]
# r8/r9/r10 are designated as stack points for A/B/C
# Initially, stack pointers for A/B/C point to memory locations 0, 64, and 128 (initial TOS)
# Stacks are assumed to grow upward

#============= Sec_1/A : JNISS =================================
            xor     r2, r2, r2
            addi    r8, r0, 0       # r8  = 0x0000
            addi    r9, r0, 64      # r9  = 0x0040
						addi    r10, r0, 128    # r10 = 0x0060
#============= Sec_1/A : JNISS =================================

#============= Sec_1/B : SIMNIOS2 ==============================
#-- define towers (16 words) in data section
#-- 			.data
#--TowerA:		.skip	16*4				# use TowerA to dump stack in debug window
#--TowerB:		.skip	16*4
#--TowerC:		.skip	16*4
#-- 
#-- 		.extern		Graphic_MovePalet	# for Hardware test
#-- 		.global		HanoiTwinTower		# called by Hardware tester
#-- 
#-- 		.text
#-- 		movia	r8,  TowerA			# Stack pointer of Tower A
#-- 		movia	r9,  TowerB			# Stack pointer of Tower B
#-- 		movia	r10, TowerC			# Stack pointer of Tower C
#============= Sec_1/B : SIMNIOS2 ==============================


#------------------
START:			xor     r2, r2, r2
						xor			r24,r24,r24
						xor			r25,r25,r25
						addi		r24, r0, 1			# set 1 -> r24
						addi		r25, r0, 2			# set 2 -> r25
						addi		r24,r0, 1
            addi    r4, r0, 7       # n = 7
						call		HanoiTwinTower
						stop										# replace by "Trap" for SIMNIOS2

#------------------Function called by Hardware tester
HanoiTwinTower:	addi    r17, r0, 0xffff

            stw     r17, 0(r8)
            addi    r8, r8, 4

# Place blue disks in pile A
#   Blue disks are FF00, FF01, FF02, etc. from the smallest to the largest

            add     r16, r0, r4
            ori     r17, r16, 0xff00
loopA:      stw     r17, 0(r8)
            addi    r8, r8, 4
            addi    r16, r16, -1
            ori     r17, r16, 0xff00
            bne     r16, r0, loopA

# Place a very large disk (which is not part of disks to move) at the bottom of the stack
# in order to make the size comparison easier when the pile becomes empty.

            addi    r17, r0, 0x00ff
            stw     r17, 0(r9)
            addi    r9, r9, 4

# Place white disks in pile B
#   White disks are 0000, 0001, 0002, etc. from the smallest to the largest

            add     r16, r0, r4
loopB:      stw     r16, 0(r9)
            addi    r9, r9, 4
            addi    r16, r16, -1
            bne     r16, r0, loopB

#===================================================================
#============== Program basicly start from here ====================
#===================================================================

main:       addi    r5, r0, 0       # src = A
            addi    r6, r0, 1       # dst = B
            addi    r7, r0, 2       # tmp = C
            call    swap						# Call swap(n, A, B)
						stop

#============= Swap prodruce Start =================================
# INPUT: 	src(r5), dst(r6), temp(r7)
# 
# OUTPUT: 	----
#===================================================================
# swap(A, B, C) 					//// N, A, B, C
swap:	addi	r27, 	r27, 	-20
			stw 	r31, 	0(r27)  		# return address
			stw 	r4, 	4(r27)  		# N
			stw 	r5, 	8(r27)  		# src
			stw 	r6,		12(r27)			# dst
			stw 	r7,		16(r27)			# tmp
			

# consolidate(N-1, B, A) 			////  N-1, B, A, C
			addi	r4, r4, -1		# n = n - 1
			ldw		r5, 12(r27) 	# acquire the new parameter order
			ldw 	r6, 8(r27)
			ldw 	r7, 16(r27)
			call 	cons

# move(B, C) 						////  --, B, C, A
			ldw 	r5, 12(r27)
			ldw 	r6, 16(r27)
			ldw 	r7, 8(r27)

			call 	move

# double_hanoi(N-1, A, C) 			//// N-1, A, C, B
			ldw 	r4, 4(r27)		# load n
			addi 	r4, r4, -1 		# n = n -1 
			ldw 	r5, 8(r27)
			ldw 	r6, 16(r27)
			ldw 	r7, 12(r27)

			call 	dhan

# move(A, B) 						//// --, A, B, C
			ldw 	r5, 8(r27)
			ldw 	r6, 12(r27)
			ldw 	r7, 16(r27)

			call 	move

# double_hanoi(N-1, C, B)			//// N-1, C, B, A
			ldw 	r4, 4(r27)		# load n
			addi 	r4, r4, -1 		# n = n -1 
			ldw		r5, 16(r27)
			ldw 	r6, 12(r27)
			ldw 	r7, 8(r27)

			call 	dhan	

# move(C,A)
			ldw		r5,	16(r27)
			ldw		r6,	8(r27)
			ldw 	r7,	12(r27)

			call 	move

# distribute(N-1, B, A)				//// N-1, B, A, C
			ldw 	r4, 4(r27)
			addi 	r4, r4, -1 		# n = n -1 
			ldw 	r5, 12(r27)
			ldw 	r6, 8(r27)
			ldw 	r7, 16(r27)

			call 	dsrb	

			br 		fin
#============= Consolidate prodruce Start ==========================
# INPUT: 	n(r4), src(r5), dst(r6), temp(r7)
# 
# OUTPUT: 	----
#===================================================================
cons:	addi	r27, 	r27, 	-20
			stw 	r31, 	0(r27)  		# return address
			stw 	r4, 	4(r27)  		# N
			stw 	r5, 	8(r27)  		# src
			stw 	r6,		12(r27)			# dst
			stw 	r7,		16(r27)			# tmp

			beq 	r4, r24, con1			# if n = 1

# consolidate(N-1, src, dst,temp)	//// N-1, src, dst, temp
			ldw 	r4, 4(r27)		# load n
			addi 	r4, r4, -1		# n = n-1
			ldw		r5, 8(r27)
			ldw 	r6, 12(r27)
			ldw		r7, 16(r27)

			call 	cons

# double_hanoi(N-1, dst, temp, src)	//// N-1, dst, temp, src
			ldw 	r4, 4(r27)		# load n
			addi 	r4, r4, -1		# n = n-1
			ldw 	r5, 12(r27)
			ldw 	r6, 16(r27)
			ldw 	r7, 8(r27)

			call 	dhan

# move(src, dst) 						//// --, A, B, C
			ldw 	r5, 8(r27)
			ldw 	r6, 12(r27)
			ldw 	r7, 16(r27)

			call 	move

# double_hanoi(N-1, temp, dst)			//// N-1, temp, dst, src
			ldw 	r4, 4(r27)
			addi 	r4, r4, -1
			ldw 	r5, 16(r27)
			ldw 	r6, 12(r27)
			ldw 	r7, 8(r27)

			call 	dhan

			br 		fin
#============= Double Hanoi prodruce Start =========================
# INPUT: 	n(r4), src(r5), dst(r6), temp(r7)
# 
# OUTPUT: 	----
#===================================================================
dhan:	addi	r27, 	r27, 	-20
			stw 	r31, 	0(r27)  		# return address
			stw 	r4, 	4(r27)  		# N
			stw 	r5, 	8(r27)  		# src
			stw 	r6,		12(r27)			# dst
			stw 	r7,		16(r27)			# tmp

			beq 	r4, r24, con2			# if n = 1, move 2 times

# double_hanoi(N-1, src, temp, dst)
			ldw 	r4, 4(r27)
			addi 	r4, r4, -1
			ldw 	r5, 8(r27)
			ldw 	r6, 16(r27)
			ldw 	r7, 12(r27)

			call 	dhan
# move(src, dst)
			ldw 	r5, 8(r27)
			ldw 	r6, 12(r27)
			ldw 	r7, 16(r27)

			call  	move
# move(src, dst)
			ldw 	r5, 8(r27)
			ldw 	r6, 12(r27)
			ldw 	r7, 16(r27)

			call  	move
# double_hanoi(N-1, temp, dst, src)
			ldw 	r4, 4(r27)
			addi 	r4, r4, -1
			ldw 	r5, 16(r27)
			ldw 	r6, 12(r27)
			ldw 	r7, 8(r27)

			call 	dhan

			br 		fin
#============= Distribute prodruce Start ===========================
# INPUT: 	n(r4), src(r5), dst(r6), temp(r7)
# 
# OUTPUT: 	----
#===================================================================
dsrb:	addi	r27, 	r27, 	-20
			stw 	r31, 	0(r27)  		# return address
			stw 	r4, 	4(r27)  		# N
			stw 	r5, 	8(r27)  		# src
			stw 	r6,		12(r27)			# dst
			stw 	r7,		16(r27)			# tmp

			beq 	r4, r24, con1			# if n = 1

# double_hanoi(N-1, src, temp, dst)
			ldw 	r4, 4(r27)
			addi 	r4, r4, -1
			ldw 	r5, 8(r27)
			ldw 	r6, 16(r27)
			ldw 	r7, 12(r27)

			call 	dhan

# move(src, dst)
			ldw 	r5, 8(r27)
			ldw 	r6, 12(r27)
			ldw 	r7, 16(r27)

			call  	move

# double_hanoi(N-1, temp, src, dst)
			ldw 	r4, 4(r27)
			addi 	r4, r4, -1
			ldw 	r5, 16(r27)
			ldw 	r6, 8(r27)
			ldw 	r7, 12(r27)

			call 	dhan

# distribute(N-1, src, dst)
			ldw 	r4, 4(r27)
			addi 	r4, r4, -1
			ldw 	r5, 8(r27)
			ldw 	r6, 12(r27)
			ldw 	r7, 16(r27)

			call  	dsrb

			br 		fin
#============= Condition section Start =============================
#	con2 -> double move
# 	con1 -> single mvoe
#===================================================================
con2: ldw 	r5, 8(r27)
			ldw 	r6, 12(r27)
			ldw 	r7, 16(r27)

			call  	move
# when n get 1
con1: ldw 	r5, 8(r27)
			ldw 	r6, 12(r27)
			ldw 	r7, 16(r27)

			call  	move 
# fin

fin:	ldw 	r31, 	0(r27)  		# return address
			ldw 	r4, 	4(r27)  		# N
			ldw 	r5, 	8(r27)  		# src
			ldw 	r6,		12(r27)			# dst
			ldw 	r7,		16(r27)			# tmp
			addi	r27, 	r27, 	20		#	back to position
			ret

#============= Move prodruce Start =================================
# INPUT: 	src(r5), dst(r6)
# 
# OUTPUT: 	step++(r2)
#===================================================================
move:	beq     r5, r24, srcB  	# if r5 = 1, src = B
      beq     r5, r25, srcC  	# if r5 = 2, src = C

srcA:	beq		r6, r24, ATB			# if r5 = 0 && r6 = 1, A -> B
			beq		r6, r25, ATC			# if r5 = 0 && r6 = 2, A -> C
			br		error							# else error

srcB:		beq		r6, r0, BTA			# if r5 = 1 && r6 = 0, B -> A
			beq		r6, r25, BTC			# if r5 = 1 && r6 = 2, B -> C
			br		error							# else error

srcC:		beq		r6, r0, CTA			# if r5 = 2 && r6 = 0, C -> A
			beq		r6, r24, CTB			# if r5 = 2 && r6 = 1, C -> B
			br		error							# else error

ATB:		addi    r8, r8, -4     	# A -> B
           	ldw     r23, 0(r8)
           	stw			r0,	 0(r8)
           	stw     r23, 0(r9)
           	addi    r9, r9, 4
           	br      done

ATC:		addi    r8, r8, -4     	# A -> C
           	ldw     r23, 0(r8)
           	stw			r0,	 0(r8)
           	stw     r23, 0(r10)
           	addi    r10, r10, 4
           	br      done

BTA:		addi    r9, r9, -4     	# B -> A
           	ldw     r23, 0(r9)
           	stw			r0,	 0(r9)
           	stw     r23, 0(r8)
           	addi    r8, r8, 4
           	br      done

BTC:		addi    r9, r9, -4     	# B -> C
           	ldw     r23, 0(r9)
           	stw			r0,	 0(r9)
           	stw     r23, 0(r10)
           	addi    r10, r10, 4
           	br      done

CTA:		addi    r10, r10, -4    # C -> A
           	ldw     r23, 0(r10)
           	stw			r0,	 0(r10)
           	stw     r23, 0(r8)
           	addi    r8, r8, 4
           	br      done

CTB:		addi    r10, r10, -4    # C -> B
           	ldw     r23, 0(r10)
           	stw			r0,	 0(r10)
           	stw     r23, 0(r9)
           	addi    r9, r9, 4
           	br      done

done:		addi    r3, r3, 1      	# increment no. of steps
           	ret

# move error

error:      addi    r2, r0, -1
			stop					# replace by "Trap" for SIMNIOS2
