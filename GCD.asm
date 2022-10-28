.data
	st: .asciiz "Enter first number> "
	nd: .asciiz "Enter second number> "
.text
	li $v0,4
	la $a0,st
	syscall
	
	li $v0,5
	syscall
	move $t0,$v0
	
	li $v0,11
	li $a0,10
	syscall
	
	li $v0,4
	la $a0,nd
	syscall
	
	li $v0,5
	syscall
	
	move $a1,$v0
	move $a0,$t0
	
	
	jal gcd
	
	move $a0,$v0
	li $v0,1
	syscall
	
	
	li $v0,10
	syscall
	
	gcd:
		beq $a1,$0, return
		divu $a0,$a1
		move $a0,$a1
		mfhi $a1
		bnez $a1,gcd
		
	return:
		move $v0,$a0
		jr $ra
