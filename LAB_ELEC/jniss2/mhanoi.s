# Magnetic Tower of Hanoi game
#
# assume that input n is in r4, src/dst/tmp in r5/r6/r7
# return the number of steps in r2
#
# Stacks A/B/C are located in memory locations [0: 63], [64: 127], and [128: 191]
# r8/r9/r10 are designated as stack points for A/B/C
# Initially, stack pointers for A/B/C point to memory locations 0, 64, and 128 (initial TOS)
# Stacks are assumed to grow upward

#============= Section : JNISS =================================
        xor     r2, r2, r2
        addi    r8, r0, 0           # r8  = 0x0000
        addi    r9, r0, 64          # r9  = 0x0040
        addi    r10, r0, 128        # r10 = 0x0080
#============= Section : JNISS =================================

#============= Section : SIMNIOS2 ==============================
#-- define towers (16 words) in data section
#			.data
#TowerA:		.skip	16*4				# use TowerA to dump stack in debug window
#TowerB:		.skip	16*4
#TowerC:		.skip	16*4

#		.extern		Graphic_MovePalet	# for Hardware test
#		.global		fill		# called by Hardware tester

#		.text
#			movia	r8,  TowerA			# Stack pointer of Tower A
#			movia	r9,  TowerB			# Stack pointer of Tower B
#			movia	r10, TowerC			# Stack pointer of Tower C
#============= Section : SIMNIOS2 ==============================

# byte 0: size of disk
# byte 1: color of disk
#   00 = R/B
#   ff = B/R
# place large disk at the bottom of each pile
#   pile A: R/B
#   pile B: B/R
#   pile C: B/R

START:  addi    r4, r0, 7           # n = 7

        xor     r2, r2, r2
        xor     r24,r24,r24
        xor     r25,r25,r25

        addi    r24, r0, 1          # set 1 -> r24
        addi    r25, r0, 2          # set 2 -> r25
        call    fill
        stop                        # replace by "Trap" for SIMNIOS2

# store a super large disk at the bottom of each pile
fill:   addi    r17, r0, 0x00ff     # R/B for src pile
        stw     r17, 0(r8)          # Store base color and the max size disk 0x00FF
        addi    r8, r8, 4           # beginning of the stack Tower A

        addi    r17, r0, 0xffff     # B/R for dst/tmp pile
        stw     r17, 0(r9)          # Store base color and the max size disk 0xFFFF
        addi    r9, r9, 4           # beginning of the stack Tower B

        stw     r17, 0(r10)         # Store base color and the max size disk 0xFFFF
        addi    r10, r10, 4         # beginning of the stack Tower C

        # store n disks on src pile in the decreasing size order
        add     r16, r0, r4

# fill the source stack of disks 
loop:   stw     r16, 0(r8)
        addi    r8, r8, 4
        addi    r16, r16, -1
        bne     r16, r0, loop       # stop when r16 == 0

        # mhanoi requires 4 inputs
        #   r4: n
        #   r5: src
        #   r6: dst
        #   r7: tmp

        # stack A = 0
        # stack B = 1
        # stack C = 2

main:   addi    r5, r0, 0           # src = A (R/B)
        addi    r6, r0, 1           # dst = B (B/R)
        addi    r7, r0, 2           # tmp = C (B/R)

        addi    r20, r20, 0xff00    # for changing disk color to 0xff by sub
        addi    r21, r21, 0x00ff    # for changing disk color to 0x00 by doing AND logic

        call    depart            # depart corresponds to the function main in c code
        stop                      # replace by "Trap" for SIMNIOS2

depart: addi    r27, r27, -20
        stw     r31, 0(r27)       # return address
        stw     r4, 4(r27)        # N
        stw     r5, 8(r27)        # src
        stw     r6, 12(r27)       # dst
        stw     r7, 16(r27)       # tmp

# mhanoi(N, src, dst, tmp)
        ldw     r4, 4(r27)
        ldw     r5, 8(r27)
        ldw     r6, 12(r27)
        ldw     r7, 16(r27)
        call    mhanoi

        br      fin

mhanoi: addi    r27, r27, -20
        stw     r31, 0(r27)       # return address
        stw     r4, 4(r27)        # N
        stw     r5, 8(r27)        # src
        stw     r6, 12(r27)       # dst
        stw     r7, 16(r27)       # tmp

        beq     r4, r24, Tmove    # move(1, src, dst) when n=1

# mhanoi(N-1, src, tmp,dst)
        addi    r4, r4, -1        # r4 = n-1
        ldw     r5, 8(r27)
        ldw     r6, 16(r27)
        ldw     r7, 12(r27)
        call    mhanoi

# move(1, src, dst)
        ldw     r5, 8(r27)
        ldw     r6, 12(r27)
        ldw     r7, 16(r27)
        call    move

# mhanoi(N-1, tmp, src, dst)
        ldw     r4, 4(r27)
        addi    r4, r4, -1        # r4 = n-1
        ldw     r5, 16(r27)
        ldw     r6, 8(r27)
        ldw     r7, 12(r27)
        call    mhanoi2

# mhanoi(N-1, src, dst, tmp)
        ldw     r4, 4(r27)
        addi    r4, r4, -1        # r4 = n-1
        ldw     r5, 8(r27)
        ldw     r6, 12(r27)
        ldw     r7, 16(r27)
        call    mhanoi

        br      fin

mhanoi2: addi    r27, r27, -20
        stw     r31, 0(r27)       # return address
        stw     r4, 4(r27)        # N
        stw     r5, 8(r27)        # src
        stw     r6, 12(r27)       # dst
        stw     r7, 16(r27)       # tmp

        beq     r4, r24, Tmove    # move(1, src, dst) when n=1

# mhanoi(N-1, src, dst, tmp)
        ldw     r4, 4(r27)
        addi    r4, r4, -1        # r4 = n-1
        ldw     r5, 8(r27)
        ldw     r6, 12(r27)
        ldw     r7, 16(r27)
        call    mhanoi2

# mhanoi(N-1, dst, tmp, src)
        ldw     r4, 4(r27)
        addi    r4, r4, -1        # r4 = n-1
        ldw     r5, 12(r27)
        ldw     r6, 16(r27)
        ldw     r7, 8(r27)
        call    mhanoi

# move(1, src, dst)
        ldw     r5, 8(r27)
        ldw     r6, 12(r27)
        ldw     r7, 16(r27)
        call    move

# mhanoi(N-1, tmp, dst, src)
        ldw     r4, 4(r27)
        addi    r4, r4, -1        # r4 = n-1
        ldw     r5, 16(r27)
        ldw     r6, 12(r27)
        ldw     r7, 8(r27)
        call    mhanoi2

        br      fin

Tmove:  ldw     r5, 8(r27)
        ldw     r6, 12(r27)
        ldw     r7, 16(r27)
        call    move

# fin
fin:    ldw     r31, 0(r27)       # return address
        ldw     r4, 4(r27)        # N
        ldw     r5, 8(r27)        # src
        ldw     r6, 12(r27)       # dst
        ldw     r7, 16(r27)       # tmp
        addi    r27, r27, 20      # back to position
        ret

# Define movement
move:   beq     r5, r24, srcB     # if r5=1, src = B
        beq     r5, r25, srcC     # if r5=2, src = C

# test if we have a color error or size error
srcA:   beq     r6, r24, sizAB    # if r5=0 && r6=1, AtoB
        beq     r6, r25, sizAC    # if r5=0 && r6=2, AtoC
        br      errorS

srcB:   beq     r6, r0, sizBA     # if r5=1 && r6=0, BtoA
        beq     r6, r25, errorC   # if r5=1 && r6=2, BtoC but error color
        br      errorS

srcC:   beq     r6, r0, sizCA     # if r5=2 && r6=0, CtoA
        beq     r6, r24, errorC   # if r5=2 && r6=1, CtoB but error color
        br      errorS

sizAB:  ldw     r23, -4(r8)
        ldw     r22, -4(r9)
        add     r23, r23, r20 # turn to 0xff before comparison
        blt     r23, r22, AtoB
        br      errorS

sizAC:  ldw     r23, -4(r8)
        ldw     r22, -4(r10)
        add     r23, r23, r20 # turn to 0xff before comparison
        blt     r23, r22, AtoC
        br      errorS

sizBA:  ldw     r23, -4(r9)
        ldw     r22, -4(r8)
        and     r23, r23, r21 # turn to 0x00 before comparison
        blt     r23, r22, BtoA
        br      errorS

sizCA:  ldw     r23, -4(r10)
        ldw     r22, -4(r8)
        and     r23, r23, r21 # turn to 0x00 before comparison
        blt     r23, r22, CtoA
        br      errorS

AtoB:   addi    r8, r8, -4
        ldw     r23, 0(r8)
        stw     r0, 0(r8)
        add     r23, r23, r20 # passage 0x00 to 0xff
        stw     r23, 0(r9)
        addi    r9, r9, 4
        br      done

AtoC:   addi    r8, r8, -4
        ldw     r23, 0(r8)
        stw     r0, 0(r8)
        add     r23, r23, r20 # passage 0x00 to 0xff
        stw     r23, 0(r10)
        addi    r10, r10, 4
        br      done

BtoA:   addi    r9, r9, -4
        ldw     r23, 0(r9)
        stw     r0, 0(r9)
        and     r23, r23, r21 # passage 0xff to 0x00
        stw     r23, 0(r8)
        addi    r8, r8, 4
        br      done

CtoA:   addi    r10, r10, -4
        ldw     r23, 0(r10)
        stw     r0, 0(r10)
        and     r23, r23, r21 # passage 0xff to 0x00
        stw     r23, 0(r8)
        addi    r8, r8, 4
        br      done

done:   addi    r3, r3, 1           # increment numerous step
        ret

# move error
errorC: addi    r2, r0, -1          # color error
        stop                        # replace by "Trap" for SIMNIOS2

errorS: addi    r2, r0, -2          # size error
        stop                        # replace by "Trap" for SIMNIOS2
