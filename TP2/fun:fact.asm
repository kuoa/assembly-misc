	.data
n:	.word	5
	.text

main:
	addiu $29, $29, -8	
	sw $31, 4($29)

	la $4, n	# @n	
	lw $4, 0($4)	# val n

	jal fact

	or $4, $2, $0	
	ori $2, $0, 1
	syscall		# print fact(n)

	ori $2, $0, 10
	syscall		# exit

	lw $31, 4($29)
	addiu $29, $29, 8
	jr $31

	##############################################

fact:
	addiu $29, $29, -12
	sw $31, 8($29)
	sw $10, 4($29)
	
	# $4 contains n
	
	bgtz $4, general	# n > 0 then jump
	ori $2, $0, 1		# n <= 0 then return 1
	jr $31

general:

	or $10, $4, $0		# save n value
	addi $4, $4, -1		# n = n -1
	jal fact		# fact(n-1)

	# $2 contains fact(n-1)

	mult $2, $10		# n * fact (n-1)
	mflo $2			# $2 = n * fact(n-1)

	lw $31, 8($29)
	lw $10, 4($29)
	addiu $29, $29, 12
	jr $31

	
	
	
	
