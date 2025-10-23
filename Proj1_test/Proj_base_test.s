# RISC-V Assembly Test Suite - Tests all required instructions
# This program demonstrates each instruction with expected values in comments (in hex)

.data
test_array:     .word 0x12345678, 0xABCDEF00, 0x00FF00FF, 0xDEADBEEF
test_byte:      .byte 0x42
test_half:      .half 0x1234
msg:            .string "Test complete\n"

.text
.globl main

main:
    # ===== ARITHMETIC INSTRUCTIONS =====
    
    # ADD: t0 = t1 + t2 (expected: t0 = 0x0000000F)
    addi t1, zero, 10      # t1 = 0x0000000A
    addi t2, zero, 5       # t2 = 0x00000005
    add t0, t1, t2         # t0 = 0x0A + 0x05 = 0x0000000F
    
    # ADDI: t3 = t0 + 100 (expected: t3 = 0x00000073)
    addi t3, t0, 100       # t3 = 0x0F + 0x64 = 0x00000073
    
    # SUB: t4 = t3 - t1 (expected: t4 = 0x00000069)
    sub t4, t3, t1         # t4 = 0x73 - 0x0A = 0x00000069
    
    # ===== LOGICAL INSTRUCTIONS =====
    
    # LUI: Load upper immediate (expected: t5 = 0x12345000)
    lui t5, 0x12345        # t5 = 0x12345000
    
    # AUIPC: Add upper immediate to PC (expected: t6 = PC + 0x00001000)
    auipc t6, 0x1          # t6 = PC + 0x1000
    
    # AND: s0 = 0xFF & 0xF0 (expected: s0 = 0x000000F0)
    addi s0, zero, 0xFF
    addi s1, zero, 0xF0
    and s0, s0, s1         # s0 = 0xFF & 0xF0 = 0x000000F0
    
    # ANDI: s2 = 0xFF & 0x0F (expected: s2 = 0x0000000F)
    addi s2, zero, 0xFF
    andi s2, s2, 0x0F      # s2 = 0xFF & 0x0F = 0x0000000F
    
    # OR: s3 = 0xF0 | 0x0F (expected: s3 = 0x000000FF)
    addi s3, zero, 0xF0
    addi s4, zero, 0x0F
    or s3, s3, s4          # s3 = 0xF0 | 0x0F = 0x000000FF
    
    # ORI: s5 = 0xF0 | 0x0F (expected: s5 = 0x000000FF)
    addi s5, zero, 0xF0
    ori s5, s5, 0x0F       # s5 = 0xF0 | 0x0F = 0x000000FF
    
    # XOR: a0 = 0xFF ^ 0xAA (expected: a0 = 0x00000055)
    addi a0, zero, 0xFF
    addi a1, zero, 0xAA
    xor a0, a0, a1         # a0 = 0xFF ^ 0xAA = 0x00000055
    
    # XORI: a2 = 0xFF ^ 0xAA (expected: a2 = 0x00000055)
    addi a2, zero, 0xFF
    xori a2, a2, 0xAA      # a2 = 0xFF ^ 0xAA = 0x00000055
    
    # ===== SHIFT INSTRUCTIONS =====
    
    # SLL: Shift left logical (expected: a3 = 0x00000040)
    addi a3, zero, 0x10
    addi a4, zero, 2
    sll a3, a3, a4         # a3 = 0x10 << 2 = 0x00000040
    
    # SLLI: Shift left logical immediate (expected: a5 = 0x00000080)
    addi a5, zero, 0x10
    slli a5, a5, 3         # a5 = 0x10 << 3 = 0x00000080
    
    # SRL: Shift right logical (expected: a6 = 0x00000020)
    addi a6, zero, 0x80
    addi a7, zero, 2
    srl a6, a6, a7         # a6 = 0x80 >> 2 = 0x00000020
    
    # SRLI: Shift right logical immediate (expected: t0 = 0x00000010)
    addi t0, zero, 0x80
    srli t0, t0, 3         # t0 = 0x80 >> 3 = 0x00000010
    
    # SRA: Shift right arithmetic (expected: t1 = 0xFFFFFFFC)
    addi t1, zero, -8      # t1 = 0xFFFFFFF8
    addi t2, zero, 1
    sra t1, t1, t2         # t1 = 0xFFFFFFF8 >> 1 = 0xFFFFFFFC (sign extended)
    
    # SRAI: Shift right arithmetic immediate (expected: t3 = 0xFFFFFFFC)
    addi t3, zero, -16     # t3 = 0xFFFFFFF0
    srai t3, t3, 2         # t3 = 0xFFFFFFF0 >> 2 = 0xFFFFFFFC (sign extended)
    
    # ===== COMPARISON INSTRUCTIONS =====
    
    # SLT: Set less than (expected: t4 = 0x00000001)
    addi t4, zero, 5
    addi t5, zero, 10
    slt t4, t4, t5         # t4 = 0x00000001 (5 < 10)
    
    # SLTI: Set less than immediate (expected: t6 = 0x00000000)
    addi t6, zero, 10
    slti t6, t6, 5         # t6 = 0x00000000 (10 >= 5)
    
    # SLTIU: Set less than immediate unsigned (expected: s0 = 0x00000001)
    addi s0, zero, 5
    sltiu s0, s0, 10       # s0 = 0x00000001 (5 < 10 unsigned)
    
    # ===== LOAD/STORE INSTRUCTIONS =====
    
    # LW: Load word (expected: s1 = 0x12345678)
    la s2, test_array      # Load address of test_array
    lw s1, 0(s2)          # s1 = 0x12345678
    
    # SW: Store word (stores 0x00000099 to memory)
    addi s3, zero, 0x99
    sw s3, 8(s2)          # Store 0x00000099 to test_array[2]
    
    # LB: Load byte signed (expected: s4 = 0x00000042)
    la s5, test_byte
    lb s4, 0(s5)          # s4 = 0x00000042
    
    # LBU: Load byte unsigned (expected: s6 = 0x00000042)
    lbu s6, 0(s5)         # s6 = 0x00000042
    
    # LH: Load halfword signed (expected: s7 = 0x00001234)
    la s8, test_half
    lh s7, 0(s8)          # s7 = 0x00001234
    
    # LHU: Load halfword unsigned (expected: s9 = 0x00001234)
    lhu s9, 0(s8)         # s9 = 0x00001234