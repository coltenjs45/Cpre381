# ===== BRANCH INSTRUCTIONS =====
    # BEQ: Branch if equal
    addi t0, zero, 10
    addi t1, zero, 10
    beq t0, t1, beq_target # Should branch (10 == 10)
    addi t2, zero, 99      # This should be skipped
beq_target:
    addi t2, zero, 1       # t2 = 1 (expected)
    
    # BNE: Branch if not equal
    addi t3, zero, 5
    addi t4, zero, 10
    bne t3, t4, bne_target # Should branch (5 != 10)
    addi t5, zero, 99      # This should be skipped
bne_target:
    addi t5, zero, 2       # t5 = 2 (expected)
    
    # BLT: Branch if less than
    addi t6, zero, 5
    addi s0, zero, 10
    blt t6, s0, blt_target # Should branch (5 < 10)
    addi s1, zero, 99      # This should be skipped
blt_target:
    addi s1, zero, 3       # s1 = 3 (expected)
    
    # BGE: Branch if greater or equal
    addi s2, zero, 10
    addi s3, zero, 5
    bge s2, s3, bge_target # Should branch (10 >= 5)
    addi s4, zero, 99      # This should be skipped
bge_target:
    addi s4, zero, 4       # s4 = 4 (expected)
    
    # BLTU: Branch if less than unsigned
    addi s5, zero, 5
    addi s6, zero, 10
    bltu s5, s6, bltu_target # Should branch (5 < 10)
    addi s7, zero, 99      # This should be skipped
bltu_target:
    addi s7, zero, 5       # s7 = 5 (expected)
    
    # BGEU: Branch if greater or equal unsigned
    addi s8, zero, 10
    addi s9, zero, 5
    bgeu s8, s9, bgeu_target # Should branch (10 >= 5)
    addi a0, zero, 99      # This should be skipped
bgeu_target:
    addi a0, zero, 6       # a0 = 6 (expected)
    
    # ===== JUMP INSTRUCTIONS =====
    
    # JAL: Jump and link
    jal ra, jal_target     # Jump to jal_target, ra = return address
    addi a1, zero, 99      # This should be skipped
jal_target:
    addi a1, zero, 7       # a1 = 7 (expected)
    
    # JALR: Jump and link register
    la a2, jalr_target     # Load address of jalr_target
    jalr ra, a2, 0         # Jump to address in a2
    addi a3, zero, 99      # This should be skipped
jalr_target:
    addi a3, zero, 8       # a3 = 8 (expected)
    
    # ===== SPECIAL INSTRUCTIONS =====
    wfi #halt and end sequece