# Full BCD stopwatch with HARDWARE DELAY (for real FPGA deployment)
# MM:SS:CC format with pause on SW[0]
# This version counts at 1 increment per second (human-visible speed)
# Assumes 10 MHz clock: delay = 10,000,000 cycles for 1 second

.text
.globl _start

_start:
    # Load I/O addresses
    lui s2, 0x10002          # HEX0-3
    lui s3, 0x10003          # HEX4-7
    lui s4, 0x10010          # SW
    
    # Initialize counter (6 BCD digits in t0-t5)
    li t0, 0                 # CC ones
    li t1, 0                 # CC tens  
    li t2, 0                 # SS ones
    li t3, 0                 # SS tens
    li t4, 0                 # MM ones
    li t5, 0                 # MM tens
    
main_loop:
    # Check pause
    lw a7, 0(s4)
    andi a7, a7, 1
    beqz a7, display_all
    
    # Hardware delay for 1 second at 10 MHz
    # Need 10,000,000 cycles for 1 second
    # Using nested loops: outer = 1000, inner = 10000
    li s6, 1000              # Outer loop counter
outer_delay:
    li a6, 10000             # Inner loop counter (10,000 iterations)
inner_delay:
    addi a6, a6, -1
    bnez a6, inner_delay
    addi s6, s6, -1
    bnez s6, outer_delay
    
    # Increment CC ones
    addi t0, t0, 1
    li a6, 10
    blt t0, a6, display_all
    li t0, 0
    
    # Increment CC tens
    addi t1, t1, 1
    blt t1, a6, display_all
    li t1, 0
    
    # Increment SS ones
    addi t2, t2, 1
    blt t2, a6, display_all
    li t2, 0
    
    # Increment SS tens (0-5)
    addi t3, t3, 1
    li a6, 6
    blt t3, a6, display_all
    li t3, 0
    
    # Increment MM ones
    addi t4, t4, 1
    li a6, 10
    blt t4, a6, display_all
    li t4, 0
    
    # Increment MM tens
    addi t5, t5, 1
    blt t5, a6, display_all
    li t5, 0

display_all:
    # Inline conversion macro for each digit
    # HEX0 = t0
    mv a0, t0
    beqz a0, hex0_0
    li a1, 1; beq a0, a1, hex0_1
    li a1, 2; beq a0, a1, hex0_2
    li a1, 3; beq a0, a1, hex0_3
    li a1, 4; beq a0, a1, hex0_4
    li a1, 5; beq a0, a1, hex0_5
    li a1, 6; beq a0, a1, hex0_6
    li a1, 7; beq a0, a1, hex0_7
    li a1, 8; beq a0, a1, hex0_8
    li a1, 9; beq a0, a1, hex0_9
    j hex0_w
hex0_0: li a0, 0x40; j hex0_w
hex0_1: li a0, 0x79; j hex0_w
hex0_2: li a0, 0x24; j hex0_w
hex0_3: li a0, 0x30; j hex0_w
hex0_4: li a0, 0x19; j hex0_w
hex0_5: li a0, 0x12; j hex0_w
hex0_6: li a0, 0x02; j hex0_w
hex0_7: li a0, 0x78; j hex0_w
hex0_8: li a0, 0x00; j hex0_w
hex0_9: li a0, 0x10
hex0_w: sb a0, 0(s2)
    
    # HEX1 = t1
    mv a0, t1
    beqz a0, hex1_0
    li a1, 1; beq a0, a1, hex1_1
    li a1, 2; beq a0, a1, hex1_2
    li a1, 3; beq a0, a1, hex1_3
    li a1, 4; beq a0, a1, hex1_4
    li a1, 5; beq a0, a1, hex1_5
    li a1, 6; beq a0, a1, hex1_6
    li a1, 7; beq a0, a1, hex1_7
    li a1, 8; beq a0, a1, hex1_8
    li a1, 9; beq a0, a1, hex1_9
    j hex1_w
hex1_0: li a0, 0x40; j hex1_w
hex1_1: li a0, 0x79; j hex1_w
hex1_2: li a0, 0x24; j hex1_w
hex1_3: li a0, 0x30; j hex1_w
hex1_4: li a0, 0x19; j hex1_w
hex1_5: li a0, 0x12; j hex1_w
hex1_6: li a0, 0x02; j hex1_w
hex1_7: li a0, 0x78; j hex1_w
hex1_8: li a0, 0x00; j hex1_w
hex1_9: li a0, 0x10
hex1_w: sb a0, 1(s2)
    
    # HEX2 = t2
    mv a0, t2
    beqz a0, hex2_0
    li a1, 1; beq a0, a1, hex2_1
    li a1, 2; beq a0, a1, hex2_2
    li a1, 3; beq a0, a1, hex2_3
    li a1, 4; beq a0, a1, hex2_4
    li a1, 5; beq a0, a1, hex2_5
    li a1, 6; beq a0, a1, hex2_6
    li a1, 7; beq a0, a1, hex2_7
    li a1, 8; beq a0, a1, hex2_8
    li a1, 9; beq a0, a1, hex2_9
    j hex2_w
hex2_0: li a0, 0x40; j hex2_w
hex2_1: li a0, 0x79; j hex2_w
hex2_2: li a0, 0x24; j hex2_w
hex2_3: li a0, 0x30; j hex2_w
hex2_4: li a0, 0x19; j hex2_w
hex2_5: li a0, 0x12; j hex2_w
hex2_6: li a0, 0x02; j hex2_w
hex2_7: li a0, 0x78; j hex2_w
hex2_8: li a0, 0x00; j hex2_w
hex2_9: li a0, 0x10
hex2_w: sb a0, 2(s2)
    
    # HEX3 = t3 (SS tens, 0-5 only)
    mv a0, t3
    beqz a0, hex3_0
    li a1, 1; beq a0, a1, hex3_1
    li a1, 2; beq a0, a1, hex3_2
    li a1, 3; beq a0, a1, hex3_3
    li a1, 4; beq a0, a1, hex3_4
    li a1, 5; beq a0, a1, hex3_5
    j hex3_w
hex3_0: li a0, 0x40; j hex3_w
hex3_1: li a0, 0x79; j hex3_w
hex3_2: li a0, 0x24; j hex3_w
hex3_3: li a0, 0x30; j hex3_w
hex3_4: li a0, 0x19; j hex3_w
hex3_5: li a0, 0x12
hex3_w: sb a0, 3(s2)
    
    # HEX4 = t4
    mv a0, t4
    beqz a0, hex4_0
    li a1, 1; beq a0, a1, hex4_1
    li a1, 2; beq a0, a1, hex4_2
    li a1, 3; beq a0, a1, hex4_3
    li a1, 4; beq a0, a1, hex4_4
    li a1, 5; beq a0, a1, hex4_5
    li a1, 6; beq a0, a1, hex4_6
    li a1, 7; beq a0, a1, hex4_7
    li a1, 8; beq a0, a1, hex4_8
    li a1, 9; beq a0, a1, hex4_9
    j hex4_w
hex4_0: li a0, 0x40; j hex4_w
hex4_1: li a0, 0x79; j hex4_w
hex4_2: li a0, 0x24; j hex4_w
hex4_3: li a0, 0x30; j hex4_w
hex4_4: li a0, 0x19; j hex4_w
hex4_5: li a0, 0x12; j hex4_w
hex4_6: li a0, 0x02; j hex4_w
hex4_7: li a0, 0x78; j hex4_w
hex4_8: li a0, 0x00; j hex4_w
hex4_9: li a0, 0x10
hex4_w: sb a0, 0(s3)
    
    # HEX5 = t5
    mv a0, t5
    beqz a0, hex5_0
    li a1, 1; beq a0, a1, hex5_1
    li a1, 2; beq a0, a1, hex5_2
    li a1, 3; beq a0, a1, hex5_3
    li a1, 4; beq a0, a1, hex5_4
    li a1, 5; beq a0, a1, hex5_5
    li a1, 6; beq a0, a1, hex5_6
    li a1, 7; beq a0, a1, hex5_7
    li a1, 8; beq a0, a1, hex5_8
    li a1, 9; beq a0, a1, hex5_9
    j hex5_w
hex5_0: li a0, 0x40; j hex5_w
hex5_1: li a0, 0x79; j hex5_w
hex5_2: li a0, 0x24; j hex5_w
hex5_3: li a0, 0x30; j hex5_w
hex5_4: li a0, 0x19; j hex5_w
hex5_5: li a0, 0x12; j hex5_w
hex5_6: li a0, 0x02; j hex5_w
hex5_7: li a0, 0x78; j hex5_w
hex5_8: li a0, 0x00; j hex5_w
hex5_9: li a0, 0x10
hex5_w: sb a0, 1(s3)
    
    # HEX6 and HEX7 = blank
    li a0, 0x7F
    sb a0, 2(s3)
    sb a0, 3(s3)
    
    j main_loop
