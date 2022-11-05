.data
	op2: .asciiz "b4 sorting>\n"
	op3: .asciiz "after sorting>\n"
	op1: .asciiz "enter the number of elements n (must be greater than 1)> "
	elements: .asciiz "Enter values>\n"
	.align 2
	array:    .space 4
.text
main:
	jal read_array
	move $a0,$v0 #address
	move $a1,$v1 #size
	
	move $t9,$a1 #to be used later
	
	li $v0, 4
	la $a0, op2
	syscall
	
	move $a1,$t9
	la $a0, array
	
	jal print_array
	
	sub $a1,$a1,1
	move $s4,$a0
	li $a0,0
	subi $sp, $sp, 12
	sw $ra, 8($sp)
	sw $a0, 4($sp)
	sw $a1, 0($sp)
	jal quicksort
	lw $ra, 8($sp)
	lw $a0, 4($sp)
	lw $a1, 0($sp)
	addi $sp, $sp, 12
	
	li $v0,11
	li $a0, 10
	syscall
	
	li $v0, 4
	la $a0, op3
	syscall
	
	move $a1,$t9
	la $a0, array
	jal print_array
	
	li $v0,10
	syscall
	
read_array:
	addi $sp,$sp,-4
	sw $ra 0($sp)
	li $v0,4
	la $a0,op1
	syscall
	li $v0,5
	syscall
	move $v1,$v0 #N
	
	li $v0,4
	la $a0, elements
	syscall
	add $t4,$t4,$v1 #&N
	
	li $v0,9 #heap allocation
	li $t5,4
	mul $a0,$t5,$v1
	syscall
	
	la $s0, array
	move $t0,$s0 #adress here
	read_for_n:
		li $v0,5
		syscall
		sw $v0, 0($t0)
		
		addi $t4,$t4,-1
		addi $t0,$t0,4
		bgtz $t4, read_for_n
		
		move $v0,$s0 #address
		
		lw $ra, 0($sp)
		addi $sp,$sp,4
		
		jr $ra

print_array:
	addi $sp,$sp,-4
	sw $ra 0($sp)
	
	move $s0,$a0
	li $t0,0
	
	printit:
	lw $a0, 0($s0)
	li $v0,1
	syscall
	
	li $v0,11
	li $a0,','
	syscall
	
	addi $t0,$t0,1
	addi $s0,$s0,4
	blt $t0,$a1, printit
	
	lw $ra, 0($sp)
	addi $sp,$sp,4
	jr $ra
	
quicksort:
	#a0: left
	#a1: right
	#s0: i
	#s1: j
	#s2: tmp
	#s3: pivot
	#s4: array access
	
	move $s0, $a0 #i = left
	move $s1, $a1 #j = right
	add $t0, $a0, $a1 #left + right
	div $t0, $t0, 2 #(left + right) / 2
	mul $s4, $t0, 4 #array access 
	lw $s3, array($s4) #pivot = array[(left + right) / 2]
	
	while:
    bgt $s0, $s1, endWhile #if i > j skip while
    
    whileIPivot: #while (array[i] < pivot)
        mul $s4, $s0, 4
        lw $t0, array($s4) #array[i]           

        bge $t0, $s3, endWhileIPivot #skip inside if array[i] >= pivot     
        addi $s0, $s0, 1 #i++        
        j whileIPivot
        
    endWhileIPivot:
    whileJPivot: #while (array[j] > pivot)
        mul $s4, $s1, 4
        lw $t0, array($s4) #array[j]         

        ble $t0, $s3, endWhileJPivot #skip inside if array[i] >= pivot
        subi $s1, $s1, 1 #j--    
        j whileJPivot
        
    endWhileJPivot:
    bgt $s0, $s1, whileIfFalse #if (i <= j)
        mul $s4, $s0, 4
        lw $s2, array($s4) #tmp = array[i]            

        mul $s4, $s1, 4
        lw $t0, array($s4) #access array[j]           
           
        mul $s4, $s0, 4
        sw $t0, array($s4) #array[i] = array[j]            
           
        mul $s4, $s1, 4
        sw $s2, array($s4) #array[j] = tmp            
           
        addi $s0, $s0, 1 #i++           
        subi $s1, $s1, 1 #j--             
           
    whileIfFalse:
    j while
    
endWhile:
	bge $a0, $s1, rc2 #if left < j
    sub $sp, $sp, 12
    sw $ra, 8($sp)
    sw $a0, 4($sp)
    sw $a1, 0($sp)
    
    move $a0, $a0 #left = left
    move $a1, $s1 #right = j
    
    jal quicksort
    lw $ra, 8($sp)
    lw $a0, 4($sp)
    lw $a1, 0($sp)
    add $sp, $sp, 12
rc2:
	bge $s0, $a1, noOp
    sub $sp, $sp, 12
    sw $ra, 8($sp)
    sw $a0, 4($sp)
    sw $a1, 0($sp)
    move $a0, $s0 #left = i
    move $a1, $a1 #right = right
    
    jal quicksort
    
    lw $ra, 8($sp)
    lw $a0, 4($sp)
    lw $a1, 0($sp)
    add $sp, $sp, 12
noOp:
	jr $ra