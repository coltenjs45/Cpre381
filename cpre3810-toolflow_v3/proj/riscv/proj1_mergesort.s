.data
array:      .word 64, 34, 25, 12, 22, 11, 90, 88, 45, 50, 23, 36, 18, 77, 30, 40
array_size: .word 16
temp:       .space 64          # Temporary array for merging (16 * 4 bytes)

.text
.globl main

main:
    li sp, 0x7FFFFFFC       # Initialize stack pointer
    la a0, array            # Load address of array
    lw a1, array_size       # Load array size
    li a2, 0                # Left index = 0
    addi a3, a1, -1         # Right index = size - 1
    
    jal mergesort           # Call mergesort
    
    # Exit program
    li a7, 10
    ecall

# mergesort(array, size, left, right)
# a0 = array address
# a1 = array size (for temp array reference)
# a2 = left index
# a3 = right index
mergesort:
    addi sp, sp, -20
    sw ra, 16(sp)
    sw s0, 12(sp)           # Save left
    sw s1, 8(sp)            # Save right
    sw s2, 4(sp)            # Save mid
    sw s3, 0(sp)            # Save array addr
    
    bge a2, a3, mergesort_end  # if left >= right, return
    
    mv s0, a2               # s0 = left
    mv s1, a3               # s1 = right
    mv s3, a0               # s3 = array address
    
    # Calculate mid = left + (right - left) / 2
    sub t0, s1, s0          # t0 = right - left
    srli t0, t0, 1          # t0 = (right - left) / 2
    add s2, s0, t0          # s2 = mid
    
    # Sort left half: mergesort(array, size, left, mid)
    mv a0, s3
    mv a2, s0
    mv a3, s2
    jal mergesort
    
    # Sort right half: mergesort(array, size, mid+1, right)
    mv a0, s3
    mv a2, s2
    addi a2, a2, 1          # left = mid + 1
    mv a3, s1
    jal mergesort
    
    # Merge the two halves
    mv a0, s3
    mv a2, s0               # left
    mv a3, s2               # mid
    mv a4, s1               # right
    jal merge

mergesort_end:
    lw ra, 16(sp)
    lw s0, 12(sp)
    lw s1, 8(sp)
    lw s2, 4(sp)
    lw s3, 0(sp)
    addi sp, sp, 20
    ret

# merge(array, left, mid, right)
# a0 = array address
# a1 = array size
# a2 = left
# a3 = mid
# a4 = right
merge:
    addi sp, sp, -32
    sw ra, 28(sp)
    sw s0, 24(sp)           # i (left pointer)
    sw s1, 20(sp)           # j (right pointer)
    sw s2, 16(sp)           # k (temp array index)
    sw s3, 12(sp)           # array address
    sw s4, 8(sp)            # left
    sw s5, 4(sp)            # mid
    sw s6, 0(sp)            # right
    
    mv s3, a0               # Save array address
    mv s4, a2               # Save left
    mv s5, a3               # Save mid
    mv s6, a4               # Save right
    
    mv s0, a2               # i = left
    addi s1, a3, 1          # j = mid + 1
    mv s2, a2               # k = left
    
    la t6, temp             # Load temp array address

merge_loop:
    bgt s0, s5, copy_right  # if i > mid, copy remaining right
    bgt s1, s6, copy_left   # if j > right, copy remaining left
    
    # Load array[i] and array[j]
    slli t0, s0, 2          # t0 = i * 4
    add t0, s3, t0          # t0 = &array[i]
    lw t1, 0(t0)            # t1 = array[i]
    
    slli t0, s1, 2          # t0 = j * 4
    add t0, s3, t0          # t0 = &array[j]
    lw t2, 0(t0)            # t2 = array[j]
    
    # Compare and store smaller element
    blt t1, t2, store_left
    
store_right_elem:
    slli t0, s2, 2
    add t0, t6, t0
    sw t2, 0(t0)            # temp[k] = array[j]
    addi s1, s1, 1          # j++
    addi s2, s2, 1          # k++
    j merge_loop

store_left:
    slli t0, s2, 2
    add t0, t6, t0
    sw t1, 0(t0)            # temp[k] = array[i]
    addi s0, s0, 1          # i++
    addi s2, s2, 1          # k++
    j merge_loop

copy_left:
    bgt s0, s5, copy_back   # if i > mid, done copying
    slli t0, s0, 2
    add t0, s3, t0
    lw t1, 0(t0)            # t1 = array[i]
    
    slli t0, s2, 2
    add t0, t6, t0
    sw t1, 0(t0)            # temp[k] = array[i]
    
    addi s0, s0, 1          # i++
    addi s2, s2, 1          # k++
    j copy_left

copy_right:
    bgt s1, s6, copy_back   # if j > right, done copying
    slli t0, s1, 2
    add t0, s3, t0
    lw t1, 0(t0)            # t1 = array[j]
    
    slli t0, s2, 2
    add t0, t6, t0
    sw t1, 0(t0)            # temp[k] = array[j]
    
    addi s1, s1, 1          # j++
    addi s2, s2, 1          # k++
    j copy_right

copy_back:
    # Copy temp array back to original array
    mv t0, s4               # t0 = left
copy_back_loop:
    bgt t0, s6, merge_end   # if index > right, done
    
    slli t1, t0, 2
    add t2, t6, t1          # t2 = &temp[index]
    lw t3, 0(t2)            # t3 = temp[index]
    
    add t2, s3, t1          # t2 = &array[index]
    sw t3, 0(t2)            # array[index] = temp[index]
    
    addi t0, t0, 1
    j copy_back_loop

merge_end:
    lw ra, 28(sp)
    lw s0, 24(sp)
    lw s1, 20(sp)
    lw s2, 16(sp)
    lw s3, 12(sp)
    lw s4, 8(sp)
    lw s5, 4(sp)
    lw s6, 0(sp)
    addi sp, sp, 32
    ret
