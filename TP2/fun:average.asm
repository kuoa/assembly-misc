	.data
tab:	.word 10, 20, 10, 10, -1

	.text
main:	
	#prolog
	addiu $29, $29, -12
	sw $31, 8($29)

	#body
	la $4, tab	#&tab
	jal arimean
	
	or $4, $2, $0	#res 
	ori $2, $0, 1	
	syscall		#print rez

	ori $2, $0, 10
	syscall

	#epilog
	lw $31, 8($29)
	addiu $29, $29, 12

	jr $31


	################################################################
	

arimean:
	#WORKS!
	#epilog
	addiu $29, $29, -16
	sw $31, 12($29)
	sw $11, 8($29)
	sw $12, 4($29)


	#body
	#$4 contains &t

	jal sizetab
	or $11, $2, $0	#$11 <- sizetab($4)

	jal sumtab
	or $12, $2, $0	#12 <- sumtab($4)

	div $12, $11	
	mflo $2		#take quotient

	#prolog
	lw $31, 12($29)
	lw $11, 8($29)
	lw $12, 4($29)
	addiu $29, $29, 16

	jr $31

	################################################################
	
sizetab:
	#WORKS!
	#epilog
	addiu $29, $29, -16
	sw $31, 12($29)
	sw $10, 8($29)
	sw $11, 4($29)

	#body
	#$4 contains &tab

	or $10, $4, $0 	#&tab ++
	ori $2, $0, 0	#index

loop_stab:
	lw $11, 0($10)	
	bltz $11 end_loop_stab #if <0 end
	addiu $2, $2, 1
	addiu $10, $10, 4 # i++
	j loop_stab

end_loop_stab:

	#prolog
	lw $31, 12($29)
	lw $10, 8($29)
	lw $11, 4($29)
	addiu $29, $29, 16

	jr $31

	################################################################



	
sumtab:
	#WORKS!
	addiu $29, $29, -20
	sw $31, 16($29)
	sw $10, 12($29)
	sw $11, 8($29)
	
	#body
	#$4 contains &tab	

	or $10, $4, $0 	#&index
	ori $11, $0, 0	#t[index]
	ori $2, $0, 0

loop:	
	lw $11, 0($10)	
	bltz $11 end_loop #if <0 end
	addu $2, $2, $11
	addiu $10, $10, 4 # i++
	j loop


end_loop:

	lw $31, 16($29)
	lw $10, 12($29)
	lw $11, 8($29)
	addiu $29, $29, 20

	jr $31
