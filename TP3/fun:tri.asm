	.data
tab:	.word 3, 33, 49, 4, 23, 12, 46, 21, 48, 2
retour:	.asciiz "\n"

	.text

main:
	# $31 + $16,$17 + taille + 2 params

	#prolog
	addiu $29, $29, -24
	sw $31, 20($29)
	sw $16, 16($29)
	sw $17, 12($29)
	ori $17, $0, 10		# taille = 10
	sw $16, 8($29)


	la $16, tab 		# @tab

	or $4, $0, $16		# savings params
	or $5, $0, $17
	#jal affiche

	or $4, $0, $16		# savings params
	or $5, $0, $17

	## test
	or $4, $0, $16
	ori $5, $0, 2
	ori $6, $0, 9
	jal echange
	
#	jal tri

	or $4, $0, $16		# savings params
	or $5, $0, $17
	jal affiche

	ori $2, $0, 10		# exit
	syscall

	jr $31

	lw $31, 20($29)
	lw $16, 16($29)
	lw $17, 12($29)	
	lw $16, 8($29)
	addiu $29, $29, -24


####################################################

affiche: ## WORKS!

	# 4 pers + $31 + 1 local

	# head
	addiu $29, $29, -24
	sw $31, 20($29)
	sw $16, 16($29)
	sw $17, 12($29)
	sw $18, 8($29)
	sw $19, 4($29)
	
	# body
	or $16, $4, $0 		# @tab
	or $17, $5, $0		# taile
	ori $18, $0, 0		# i
	la $19, retour		# "\n"

loop:	# no need to save on the stack, as discussed
	
	lw $4, 0($16)		#tab[i]
	ori $2, $0, 1
	syscall			#print %d

	or $4, $19, $0		#print \n
	ori $2, $0, 4
	syscall
		
	addiu $16, $16, 4	#(tab + 4)
	addiu $18, $18, 1
		
	bne $18, $17, loop	# while i < 10
	
	# tail
	lw $31, 20($29)
	lw $16, 16($29)
	lw $17, 12($29)
	lw $18, 8($29)
	lw $19, 4($29)
	addiu $29, $29, 24

	jr $31

#####################################################

echange:

	# head
	# 3 pers + 1 local + $31
	addiu $29, $29, -20
	sw $31, 16($29)
	sw $16, 12($29)
	sw $17, 8($29)
	sw $18, 4($29)

	# $4 tab, $5 i, $6 j

	or $16, $0, $4		# @tab
	or $17, $0, $5		# i
	or $18, $0, $6 	# j

	sll $17, $17, 4 	# i * 4
	addu $17, $17, $16	# @t[i]
	sll $18, $18, 4		# j * 4
	addu $18, $18, $16	# @t[j]

	lw $8, 0($17)		# temp = t[i]
	lw $9, 0($18)		# $9 = t[j]
	sw $9, 0($17)		# t[i] = t[j]
	sw $8, 0($18)		# t[j] = t[i]
	
	lw $31, 16($29)
	lw $16, 12($29)
	lw $17, 8($29)
	lw $18, 4($29)
	addiu $29, $29, 20

	jr $31
	
