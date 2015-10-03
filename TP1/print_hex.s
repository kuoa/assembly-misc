.data
	table: .asciiz "0123456789ABCDEF"
	string: .asciiz "0x--------"
	n: .word 0x5432ABCD
	
.text
.globl main
main:
	
	# initiating variables
	
	la $2, string	# @string[0]
	addiu $2, $2, 2	# ps -> @string[2]
	la $3, n	# @n
	lw $3, 0($3)	# value n
	ori $4, $0, 32	# i = 32
	la $10, table 	# @table[0]
	ori $14, $0, 4	# used in i = i - 4 (xspim doesn't accept subbiu for some reason)
	
	# start while loop
	
	loop:
	subu $4, $4, $14 	# i = i - 4
	srlv $5, $3, $4		# (n >> i)
	andi $5, $5, 0x0F 	# q -> new_n & 0x0F
	
	addu $6, $10, $5 	# @of char to read from table
	lb $7, 0($6) 		# read char from talbe
	sb $7, 0($2) 		# store char in string[$2]
	addiu $2, $2, 1 	# ps++ (next case in string[])
	
	bgtz $4, loop 		# while i > 0 goto loop
	
	# end while loop
	
	la $4, string 		# @string
	ori $2, $0, 4		# print_string code
	syscall
	
	ori $2, $0, 10 		# exit code
	syscall
	
	
	
	
	
	
	
	
	

	 
	
	
