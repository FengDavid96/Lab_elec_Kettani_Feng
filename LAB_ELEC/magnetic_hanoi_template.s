# Magnetic Tower of Hanoi game
#
# assume that input n is in r4, src/dst/tmp in r5/r6/r7
# return the number of steps in r2
#
# Stacks A/B/C are located in memory locations [0: 63], [64: 127], and [128: 191]
# r8/r9/r10 are designated as stack points for A/B/C
# Initially, stack pointers for A/B/C point to memory locations 0, 64, and 128 (initial TOS)
# Stacks are assumed to grow upward

        xor     r2, r2, r2
        addi    r8, r0, 0           # r8  = 0x0000
        addi    r9, r0, 64          # r9  = 0x0040
        addi    r10, r0, 128        # r10 = 0x0060

# byte 0: size of disk
# byte 1: color of disk
#   00 = R/B
#   ff = B/R
# place large disk at the bottom of each pile
#   pile A: R/B
#   pile B: B/R
#   pile C: B/R

        # store a super large disk at the bottom of each pile

        addi    r17, r0, 0x00ff     # R/B for src pile
        stw     r17, 0(r8)
        addi    r8, r8, 4
        addi    r17, r0, 0xffff     # B/R for dst/tmp pile
        stw     r17, 0(r9)
        addi    r9, r9, 4
        stw     r17, 0(r10)
        addi    r10, r10, 4

        # store n disks on src pile in the decreasing size order

        addi    r4, r0, 7           # n = 7
        add     r16, r0, r4
loop:   stw     r16, 0(r8)
        addi    r8, r8, 4
        addi    r16, r16, -1
        bne     r16, r0, loop

        # mhanoi requires 4 inputs
        #   r4: n
        #   r5: src
        #   r6: dst
        #   r7: tmp
        #
        # stack A = 0
        # stack B = 1
        # stack C = 2

        addi    r5, r0, 0           # src = A (R/B)
        addi    r6, r0, 1           # dst = B (B/R)
        addi    r7, r0, 2           # tmp = C (B/R)
        call    mhanoi
        stop

# move error

errorC: addi    r2, r0, -1          # color error
        stop

errorS: addi    r2, r0, -2          # size error
        stop
