.eqv N 10
.data
	arr: .float 0:N
.text
	main:
	jal rnd
	
	jal print
	
	la $a0,arr
	jal bbsort
	
	li $v0,11
	li $a0,10
	syscall
	
	jal print
	
	li $v0,10
	syscall

	###########################################
rnd:
	li $t0,0 #counter
	la $s0, arr #array
	la $t3,N #size of array
	
	#####
	#allocate stack
	######
	
	addi $sp, $sp,-4
	sw $ra 0($sp)
	#
	li $t1,2 
	la $t2,N 
	
	loop:
	la $a1, N  #Here you set $a1 to the max bound.
	add $a0, $a0, 0  #Here you add the lowest bound
    li $v0, 42  #generates the random number.
    syscall
    
    mtc1 $a0, $f10
    cvt.s.w $f10, $f10 #random here
    
    mtc1 $t3, $f4
    cvt.s.w $f4,$f4 # N =10
    
    div.s $f12,$f10,$f4
    
    mtc1 $t1,$f3
    cvt.s.w $f3,$f3 #2
    
    mtc1 $t2,$f5
    cvt.s.w $f5,$f5 #20
    
    mul.s $f12,$f10,$f3
    sub.s $f12,$f12,$f5
      
    s.s $f12, 0($s0)
    
    addi $s0,$s0,4
	addi $t0,$t0,1
	
	blt $t0,$t3,loop
	
	lw $ra, 0($sp)
	addi $sp,$sp,4
	jr $ra
	
print:
	addi $sp,$sp,-4
	sw $ra, 0($sp)
	
	li $t0,0 #array
	la $s0,arr
	la $s1,N
	
	for:
	l.s $f12,0($s0)
	li $v0,2
	syscall
	
	li $v0,11
	li $a0,'	'
	syscall
	
	addi $t0,$t0,1
	addi $s0,$s0,4
	ble $t0,$s1,for
	
	lw $ra,0($sp)
	addi $sp,$sp,4
	jr $ra
	
bbsort:
	sw $ra, 0($sp)
	
	la $s0, arr
	
	addi $t0,$s0,36 # &arr + 40
	li $t1,0 #counter
	li $t2,1 #flag
	
	while:
		bgt $s0,$t0,reset #branch if  reached to size of array
		l.s $f0, 0($s0) #a[i]
		l.s $f1, 4($s0) #a[i+1]
		
		c.lt.s  $f1, $f0    # $f1 < $f0?
		bc1t swap        # if true, branch to "swap"
		
		addi $s0,$s0,4
		ble $s0,$t0,while #branch if not reached to size of array
		beqz $t2,exit #exit if no change ouccor

		reset:
		li $t2,0
		la $s0, arr
		
		j while
		
		swap:
			s.s $f1, 0($s0)
			s.s $f0, 4($s0)

			addi $s0,$s0,4
			li $t2,1

			j while
		exit:
		lw $ra, 0($sp)
		jr $ra
