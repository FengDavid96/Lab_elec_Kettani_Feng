# Twin Tower of Hanoi game
#
# assume that input n is in r4, src/dst/tmp in r5/r6/r7
# return the number of steps in r2

# Stacks A/B/C are located in memory locations [0: 63], [64: 127], and [128, 191]
# r8/r9/r10 are designated as stack points for A/B/C
# Initially, stack pointers for A/B/C point to memory locations 0, 64, and 128 (initial TOS)
# Stacks are assumed to grow upward

            xor     r2, r2, r2
            addi    r8, r0, 0       # r8  = 0x0000
            addi    r9, r0, 64      # r9  = 0x0040
            addi    r10, r0, 128    # r10 = 0x0060

            addi    r4, r0, 7       # n = 7

# Place blue disks in pile A
#   Blue disks are FF00, FF01, FF02, etc. from the smallest to the largest

            add     r16, r0, r4
            ori     r17, r16, 0xff00
loopA:      stw     r17, 0(r8)
            addi    r8, r8, 4
            addi    r16, r16, -1
            ori     r17, r16, 0xff00
            bne     r16, r0, loopA

# Place white disks in pile B
#   White disks are 0000, 0001, 0002, etc. from the smallest to the largest

            add     r16, r0, r4
loopB:      stw     r16, 0(r9)
            addi    r9, r9, 4
            addi    r16, r16, -1
            bne     r16, r0, loopB

# Call swap(n, A, B)

            addi    r5, r0, 0       # src = A
            addi    r6, r0, 1       # dst = B
            addi    r7, r0, 2       # tmp = C
            call    swap
            stop

# move error

error:      addi    r2, r0, -1
            stop
