	.data
tab:	.word 3, 33, 49, 4, 23, 12, 46, 21, 48, 2
retour:	.asciiz "\n"

	.text

main: 	## WORKS
	# $31 + $16,$17 + taille + 2 params

	#prolog
	addiu $29, $29, -24
	sw $31, 20($29)
	sw $16, 16($29)
	sw $17, 12($29)
	ori $17, $0, 10		# taille = 10 !!! modify it, if the size of tab changes
	sw $16, 8($29)

	la $16, tab 		# @tab

#################################

	or $4, $0, $16		# savings params
	or $5, $0, $17
	jal affiche
	
#################################	
	
	or $4, $0, $16		# savings params
	or $5, $0, $17
	jal tri
	
################################

	or $4, $0, $16		# savings params
	or $5, $0, $17
	jal affiche

###############################

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

	# $4 = @tab | $5 = taille | $7 = i | $8, $9 misc

	# head
	addiu $29, $29, -8 	# 1local + $31 + 0 rPers
	sw $31, 4($29)

	or $7, $0, $0		# i = 0
	la $8, retour		# @\n
	or $9, $4, $0		# save &tab

loop:	# no need to save on the stack, as discussed
	
	lw $4, 0($9)		# tab[i]
	ori $2, $0, 1
	syscall			# print %d

	or $4, $8, $0		# print \n
	ori $2, $0, 4
	syscall
		
	addiu $9, $9, 4		# (tab + 4)
	addiu $7, $7, 1		# i++
		
	bne $7, $5, loop	# while i < 10

	# print 1 addition '\n' to delimit 2 consecutive calls of affiche

	or $4, $8, $0		# print \n
	ori $2, $0, 4
	syscall
	
	# tail
	lw $31, 4($29)
	addiu $29, $29, 8

	jr $31

#####################################################

echange: ## WORKS

	# head
	# $4 = @tab | $5 = i | $6 = j | $8 = tmp | $9, $10 misc
	#
	addiu $29, $29, -8	# $31 + 1local + 0 rPers
	sw $31, 4($29)
	
	
	
	sll $5, $5, 2	 	# i * 4
	addu $5, $5, $4		# @t[i]
	sll $6, $6, 2		# j * 4
	addu $6, $6, $4		# @t[j]

	lw $8, 0($5)		# temp = t[i]
	lw $9, 0($6)		# $9 = t[j]
	sw $9, 0($5)		# t[i] = t[j]
	sw $8, 0($6)		# t[j] = temp
	
	lw $31, 4($29)
	addiu $29, $29, 8

	jr $31

####################################################

tri: ## WORKS

	# head
	# $16 = @tab | $17 = taille | $18 = valmax | $19 = i
	# $20 = imax | $21, $22 = misc

	addiu $29, $29, -56	# 7rPers + 3local + 3 args + $31 = 14
	sw $31, 52($29)
	sw $16, 48($29)
	sw $17, 44($29)
	sw $18, 40($29)
	sw $19, 36($29)
	sw $20, 32($29)
	sw $21, 28($29)
	sw $22, 24($29)


	or $16, $0, $4		# @tab
	or $17, $0, $5		# taille

	sltiu $21, $17, 2	# if taile < 2 then $21 = 1
	blez $21, general	# if $21 = 0 jump general
	jr $31			# $21 = 1, return ;
	
general:

	or $18, $0, $0		# valmax = 0
	or $19, $0, $0		# i = 0

loop_s:
	sll $21, $19, 2		# i * 4
	addu $21, $21, $16	# @t[i]
	lw $21, 0($21)		# t[i]

	############### if ####################

	slt $22, $18, $21	# if valmx < t[i] then $22 = 1	
	blez $22, false		# $22 = 0 => false => jump false

	or $18, $21, $0		# valmax = t[i]
	or $20, $19, $0		# imax = i
	
	############## end if ################
false:	
	addiu $19, $19, 1	# i++		
	bne $17, $19, loop_s	# while i < taille


	or $4, $16, $0		# @tab
	or $5, $20, $0		# imax
	or $6, $17, $0		# taille
	addi $6, $6, -1		# taille --
	jal echange

	# tri
	or $4, $16, $0
	or $5, $17, $0
	addi $5, $5, -1		# taile --
	jal tri


	# tail	
	lw $31, 52($29)
	lw $16, 48($29)
	lw $17, 44($29)
	lw $18, 40($29)
	lw $19, 36($29)
	lw $20, 32($29)
	lw $21, 28($29)
	sw $22, 24($29)
	addiu $29, $29, 56
	
	jr $31		
