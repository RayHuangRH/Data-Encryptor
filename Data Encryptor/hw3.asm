# Raymond Huang
# rahhuang
# 111368192

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################

.text

# Part I
#t0 - t1
get_adfgvx_coords:
li $v0, -200
li $v1, -200
move $t0, $a0									#t0 = index1
move $t1, $a1									#t1 = index2
bgt $t0, 5, get_adfgvx_error
bltz $t0, get_adfgvx_error
bgt $t1, 5, get_adfgvx_error
bltz $t1, get_adfgvx_error
beq $t0, 0, one_zero
beq $t0, 1, one_one
beq $t0, 2, one_two
beq $t0, 3, one_three
beq $t0, 4, one_four
beq $t0, 5, one_five
one_zero:
	li $v0, 65
	j find_two
one_one:
	li $v0, 68
	j find_two
one_two:
	li $v0, 70
	j find_two
one_three:
	li $v0, 71
	j find_two
one_four:
	li $v0, 86
	j find_two
one_five:
	li $v0, 88
	j find_two
find_two:
	beq $t1, 0, two_zero
	beq $t1, 1, two_one
	beq $t1, 2, two_two
	beq $t1, 3, two_three
	beq $t1, 4, two_four
	beq $t1, 5, two_five
	two_zero:
		li $v1, 65
		j adfgvx_done
	two_one:
		li $v1, 68
		j adfgvx_done
	two_two:
		li $v1, 70
		j adfgvx_done
	two_three:
		li $v1, 71
		j adfgvx_done
	two_four:
		li $v1, 86
		j adfgvx_done
	two_five:
		li $v1, 88
		j adfgvx_done
adfgvx_done:
	jr $ra
get_adfgvx_error:
	li $v0, -1
	li $v1, -1
	jr $ra
	
# Part II
# t0 - t8
search_adfgvx_grid:
li $v0, -200
li $v1, -200
move $t0, $a0								#t0 = base of array
move $t1, $a1								#t1 = char
li $t2, 6									#t2 = num of rows/columns
li $t3, -1									#t3 = row
li $t4, -1									#t4 = column
adfgvx_row_loop:
	addi $t3, $t3, 1
	beq $t3, $t2, adfgvx_error
	adfgvx_column_loop:
		addi $t4, $t4, 1
		beq $t4, $t2, adfgvx_col_done
		mult $t2, $t3
		mflo $t5							#t5 = #cols*row
		add $t6, $t5, $t4					#t6 = (#cols*row+column)
		add $t7, $t6, $t0					#t7 = base of array + (#cols*row+column)
		lb	$t8, 0($t7)						#t8 = arr[i][j]
		beq $t8, $t1, adfgvx_found			#arr[i][j] == char
		bne $t4, $t2, adfgvx_column_loop	#t4!=t2
		adfgvx_col_done:
		li $t4, -1
		j adfgvx_row_loop
adfgvx_error:
	li $v0, -1
	li $v1, -1
	jr $ra
adfgvx_found:
	move $v0, $t3
	move $v1, $t4
	jr $ra
										
# Part III
map_plaintext:
#s0-s2
li $v0, -200
li $v1, -200
addi $sp, $sp, -16
sw $ra, 12($sp)
sw $s0, 8($sp)
sw $s1, 4($sp)
sw $s2, 0($sp)
move $s0, $a0								#s0 = adfgvx_grid
move $s1, $a1								#s1 = plaintext
move $s2, $a2								#s2 = middletext_buffer
map_loop:
lb $t0, 0($s1)								#t0 = plaintext_char
beq $t0, $zero, map_done			
move $a0, $s0	
move $a1, $t0
addi $s1, $s1, 1
jal search_adfgvx_grid						#get index of char in grid
move $a0, $v0								
move $a1, $v1								
jal get_adfgvx_coords						#get char at indexes
move $t1, $v0								#t1 = row char
move $t2, $v1								#t2 = col char
sb $t1, 0($s2)
sb $t2, 1($s2)
addi $s2, $s2, 2
j map_loop
map_done:
lw $ra, 12($sp)
lw $s0, 8($sp)
lw $s1, 4($sp)
lw $s2, 0($sp)
addi $sp, $sp, 16
jr $ra

# Part IV
swap_matrix_columns:
#t0 - t9
li $v0, -200
li $v1, -200
move $t0, $a0								#t0 = array
move $t1, $a1								#t1 = num_rows
move $t2, $a2								#t2 = num_col
move $t3, $a3								#t3 = col1
lw $t4, 0($sp)								#t4 = col2
blez $t1, swap_error
blez $t2, swap_error
bltz $t3, swap_error
bltz $t4, swap_error
bge $t3, $t2, swap_error
bge $t4, $t2, swap_error
li $t5, -1									#t5 = row index
swap_loop:
	addi $t5, $t5, 1 
	beq $t5, $t1, swap_done
	mult $t5, $t2							
	mflo $t7								#t7 = #cols*row							
	add $t6, $t7, $t3						#t6 = #cols*row+col1
	add $t6, $t6, $t0						#t6 = arr[row][col1]
	add $t7, $t7, $t4						#t7 = #cols*row+col2
	add $t7, $t7, $t0						#t7 = arr[row][col2]
	lbu $t8, 0($t6)							#t8 = t6
	lbu $t9, 0($t7)							#t9 = t7
	sb $t8, 0($t7)							#t7 = t6
	sb $t9, 0($t6)							#t6 = t7
	j swap_loop
swap_done:
	li $v0, 0
	jr $ra
swap_error:
li $v0, -1
jr $ra
											
# Part V
key_sort_matrix:
li $v0, -200
li $v1, -200
addi $sp, $sp, -36
sw $ra, 32($sp)
sw $s0, 28($sp)
sw $s1, 24($sp)
sw $s2, 20($sp)
sw $s3, 16($sp)
sw $s4, 12($sp)
sw $s5, 8($sp)
sw $s6, 4($sp)
sw $s7, 0($sp)
move $s0, $a0								#s0 = matrix
move $s1, $a1								#s1 = # rows
move $s2, $a2    							#s2 = # col
move $s3, $a3								#s3 = key arr
lw $s4, 36($sp) 							#s4 = elem size
addi $s5, $s2, -1							#s5 = n-1
beq $s4, 1, byte_done
beq $s4, 4, word_done
word_done:
	move $s3, $a3
	li $s6, -1								#s6 = i
	word_out_loop:
		addi $s6, $s6, 1
		li $s7, -1							#s7 = j
		beq $s6, $s5, key_done				#i == n-1
		word_in_loop:
			addi $s7, $s7, 1
			sub $t5, $s5, $s6				#t5 = n - i - 1 
			bne $s7, $t5, continue_word_sort
			j word_out_loop
			continue_word_sort:
			mult $s7, $s4
			mflo $t0						#t0 = offset
			add $t1, $s3, $t0				#t1 = arr[j] address
			lw $t6, 0($t1)					#t6 = arr[j]
			lw $t7, 4($t1)					#t7 = arr[j+1]
			ble $t6, $t7, skip_word_swap
			move $t8, $t6					#temp = arr[j]
			sw $t7, 0($t1)					#arr[j] = arr[j+1]
			sw $t8, 4($t1)					#arr[j+1] = temp
			addi $t2, $s7, 1				#t2 = j+1
			move $a3, $s7
			addi $sp, $sp, -4
			sw $t2, 0($sp)
			jal swap_matrix_columns
			addi $sp, $sp, 4
			skip_word_swap:
			j word_in_loop
byte_done:
	move $s3, $a3
	li $s6, -1								#s6 = i
	byte_out_loop:
		addi $s6, $s6, 1
		li $s7, -1							#s7 = j
		beq $s6, $s5, key_done				#i == n-1
		byte_in_loop:
			addi $s7, $s7, 1
			sub $t5, $s5, $s6				#t5 = n - i - 1 
			bne $s7, $t5, continue_byte_sort
			j byte_out_loop
			continue_byte_sort:
			mult $s7, $s4
			mflo $t0						#t0 = offset
			add $t1, $s3, $t0				#t1 = arr[j] address
			lbu $t6, 0($t1)					#t6 = arr[j]
			lbu $t7, 1($t1)					#t7 = arr[j+1]
			ble $t6, $t7, skip_byte_swap
			move $t8, $t6					#temp = arr[j]
			sb $t7, 0($t1)					#arr[j] = arr[j+1]
			sb $t8, 1($t1)					#arr[j+1] = temp
			addi $t2, $s7, 1				#t2 = j+1
			move $a3, $s7
			addi $sp, $sp, -4
			sw $t2, 0($sp)
			jal swap_matrix_columns
			addi $sp, $sp, 4
			skip_byte_swap:
		j byte_in_loop
key_done:
lw $ra, 32($sp)
lw $s0, 28($sp)
lw $s1, 24($sp)
lw $s2, 20($sp)
lw $s3, 16($sp)
lw $s4, 12($sp)
lw $s5, 8($sp)
lw $s6, 4($sp)
lw $s7, 0($sp)
addi $sp, $sp, 36
jr $ra

# Part IV
transpose:
li $v0, -200
li $v1, -200
move $t0, $a0							#t0 = src
move $t1, $a1							#t1 = dest
move $t2, $a2							#t2 = # rows
move $t3, $a3							#t3 = # cols
bltz $t2, trans_error
bltz $t3, trans_error	
	li $t4, -1							#t4 = row
trans_out_loop:
	addi $t4, $t4, 1
	beq $t4, $t2, trans_done
	li $t5, -1							#t5 = col
	trans_in_loop:
		addi $t5, $t5, 1
		bne $t5, $t3, continue_trans
		j trans_out_loop
		continue_trans:
		mult $t3, $t4
		mflo $t6
		add $t6, $t6, $t5
		add $t6, $t6, $t0				#t6 = base of src + (#cols*row+column)
		lbu $t7, 0($t6)					#t7 = src[row][col]
		mult $t2, $t5
		mflo $t6
		add $t6, $t6, $t4
		add $t6, $t6, $t1				#t6 = base of dest + (#rows*column+row)
		sb $t7, 0($t6)
		j trans_in_loop	
trans_done:
li $v0, 0
jr $ra
trans_error:
li $v0, -1
jr $ra

# Part VII
encrypt:
li $v0, -200
li $v1, -200
addi $sp, $sp, -32
sw $ra, 28($sp)
sw $s6, 24($sp)
sw $s5, 20($sp)
sw $s4, 16($sp)
sw $s3, 12($sp)
sw $s2, 8($sp)
sw $s1, 4($sp)
sw $s0, 0($sp)
move $s0, $a0									#s0 = grid
move $s1, $a1									#s1 = plaintext
move $s2, $a2									#s2 = keyword
move $s3, $a3									#s3 = cipher
li $t1, 0										#t1 = plaintext length
plain_length:
	lbu $t0, 0($s1)
	beq $t0, $zero, plain_done
	addi $s1, $s1, 1
	addi $t1, $t1, 1
	j plain_length
plain_done:
move $s1, $a1
li $t2, 2
mult $t1, $t2
mflo $t3										#t3 = plainlength * 2
li $s4, 0										#s4 = keyword length aka columns
keyword_length:
	lbu $t0, 0($s2)
	beq $t0, $zero, keyword_done
	addi $s2, $s2, 1
	addi $s4, $s4, 1
	j keyword_length
keyword_done:
move $s2, $a2
move $t2, $s4									#t2 = bytes to allocate
heap_size:
	bge $t2, $t3, heap_size_done
	add $t2, $t2, $s4
	j heap_size
heap_size_done:	
div $t2, $s4
mflo $s5										#s5 = rows
move $a0, $t2									#allocate bytes on heap for array
li $v0, 9
syscall
move $s6, $v0									#s6 = heap array
move $t1, $s6									#t1 = heap array
li $t4, '*'
li $t5, 0
asterisk_loop:
	bge $t5, $t2, asterisk_done
	sb $t4, 0($t1)
	addi $t1, $t1, 1
	addi $t5, $t5, 1
	j asterisk_loop
asterisk_done:
move $a0, $s0
move $a1, $s1
move $a2, $s6
jal map_plaintext
move $a0, $s6
move $a1, $s5
move $a2, $s4
move $a3, $s2
li $t5, 1
addi $sp, $sp, -4
sw $t5, 0($sp)
jal key_sort_matrix
addi $sp, $sp, 4
move $a0, $s6
move $a1, $s3
move $a2, $s5
move $a3, $s4
jal transpose
terminate_loop:
	lbu $t4, 0($s3)
	bne $t4, '?', skip_term
	sb $zero, 0($s3)
	j term_done
	skip_term:
	addi $s3, $s3, 1
	j terminate_loop
term_done:	
lw $ra, 28($sp)
lw $s6, 24($sp)
lw $s5, 20($sp)
lw $s4, 16($sp)
lw $s3, 12($sp)
lw $s2, 8($sp)
lw $s1, 4($sp)
lw $s0, 0($sp)
addi $sp, $sp, 32	
jr $ra

# Part VIII
lookup_char:
li $v0, -200
li $v1, -200
move $t0, $a0								#t0 = grid_ADFGVX
move $t1, $a1								#t1 = row char
move $t2, $a2								#t2 = col char
beq $t1, 'A', row_zero
beq $t1, 'D', row_one
beq $t1, 'F', row_two
beq $t1, 'G', row_three
beq $t1, 'V', row_four
beq $t1, 'X', row_five
j lookup_error
row_zero:
li $t3, 0
j get_col_num
row_one:
li $t3, 1
j get_col_num
row_two:
li $t3, 2
j get_col_num
row_three:
li $t3, 3
j get_col_num
row_four:
li $t3, 4
j get_col_num
row_five:
li $t3, 5
j get_col_num
get_col_num:
beq $t2, 65, col_zero
beq $t2, 68, col_one
beq $t2, 70, col_two
beq $t2, 71, col_three
beq $t2, 86, col_four
beq $t2, 88, col_five
j lookup_error
col_zero:
li $t4, 0
j get_char
col_one:
li $t4, 1
j get_char
col_two:
li $t4, 2
j get_char
col_three:
li $t4, 3
j get_char
col_four:
li $t4, 4
j get_char
col_five:
li $t4, 5
j get_char
get_char:
li $t5, 6
mult $t5, $t3
mflo $t6
add $t6, $t6, $t4
add $t6, $t6, $t0
lb $t7, 0($t6)
li $v0, 0
move $v1, $t7
jr $ra
lookup_error:
li $v0, -1
li $v1, -1
jr $ra

# Part IX
string_sort:
li $v0, -200
li $v1, -200
move $t0, $a0								#t0 = string
move $t1, $a0								#t1 = string
li $t2, -1									#t2 = n - 1
length_loop:
	lbu $t3, 0($t1)
	beq $t3, $zero, length_done
	addi $t1, $t1, 1
	addi $t2, $t2, 1
	j length_loop
length_done:
	li $t3, -1								#t3 = i
	string_out_loop:
		addi $t3, $t3, 1
		li $t4, -1							#t4 = j
		beq $t3, $t2, sort_done
		string_in_loop:
			addi $t4, $t4, 1
			sub $t5, $t2, $t3				#t5 = n - i - 1 
			bne $t4, $t5, continue_sort
			j string_out_loop
			continue_sort:
			add $t1, $t0, $t4				#t1 = arr[j] address
			lbu $t6, 0($t1)					#t6 = arr[j]
			lbu $t7, 1($t1)					#t7 = arr[j+1]
			ble $t6, $t7, skip_swap
			move $t8, $t6					#temp = arr[j]
			sb $t7, 0($t1)					#arr[j] = arr[j+1]
			sb $t8, 1($t1)					#arr[j+1] = temp
			skip_swap:
			j string_in_loop
sort_done:
jr $ra

# Part X
index_of:
li $v0, -200
li $v1, -200
move $t6, $a0						#t0 = string
move $t7, $a1						#t1 = char
li $t8, 0 							#t2 = index
index_loop:
	lbu $t9, 0($t6)
	beq $t9, $t7, index_done
	addi $t6, $t6, 1
	addi $t8, $t8, 1
	j index_loop
index_done:
move $v0, $t8
jr $ra

decrypt:
li $v0, -200
li $v1, -200
addi $sp, $sp, -36
sw $ra, 32($sp)
sw $s7, 28($sp)
sw $s6, 24($sp)
sw $s5, 20($sp)
sw $s4, 16($sp)
sw $s3, 12($sp)
sw $s2, 8($sp)
sw $s1, 4($sp)
sw $s0, 0($sp)
move $s0, $a0									#s0 = grid
move $s1, $a1									#s1 = cipher
move $s2, $a2									#s2 = keyword
move $s3, $a3									#s3 = plaintext
li $s4, 0										#s4 = keyword length aka rows
key_length:
	lbu $t0, 0($s2)
	beq $t0, $zero, key_length_done
	addi $s2, $s2, 1
	addi $s4, $s4, 1
	j key_length
key_length_done:
move $s2, $a2
move $a0, $s4
li $v0, 9
syscall
move $s5, $v0									#s5 = heap keyword
move $t1, $v0
copy_keyword:
	lbu $t0, 0($s2)
	sb $t0, 0($t1)
	beq $t0, $zero, copy_keyword_done
	addi $s2, $s2, 1
	addi $t1, $t1, 1
	j copy_keyword
copy_keyword_done:
move $s2, $a2
move $a0, $s5
jal string_sort
li $t5, 4
mult $s4, $t5
mflo $t6
move $a0, $t6
li $v0, 9
syscall
move $s6, $v0									#s6 = heap keyword index
li $t0, 0										
keyword_index_loop:
	beq $t0, $s4, keyword_index_done
	mult $t5, $t0
	mflo $t6
	add $t1, $s6, $t6							#t1 = heap index address
	add $t2, $s5, $t0							#t2 = heap keyword address
	lbu $t3, 0($t2)
	move $a0, $s2
	move $a1, $t3
	jal index_of
	move $t4, $v0
	sw $t4, 0($t1)
	addi $t0, $t0, 1
	j keyword_index_loop
keyword_index_done:
move $a1, $s1
li $t1, 0										#t1 = bytes
cipher_length:
	lbu $t0, 0($s1)
	beq $t0, $zero, cipher_done
	addi $t1, $t1, 1
	addi $s1, $s1, 1
	j cipher_length
cipher_done:
move $s1, $a1
div $t1, $s4
mflo $t9										#t9 = columns
move $a0, $t1
li $v0, 9
syscall
move $s7, $v0									#s7 = transpose array
move $a0, $s1
move $a1, $s7
move $a2, $s4
move $a3, $t9
jal transpose
move $a0, $s7
move $a1, $t9
move $a2, $s4									#t9 WILL BE OVERRIDDEN
move $a3, $s6
addi $sp, $sp, -4
li $t0, 4
sw $t0, 0($sp)
jal key_sort_matrix
addi $sp, $sp, 4
matrix_loop:
	lbu $t0, 0($s7)
	lbu $t1, 1($s7)
	beq $t0, '*', matrix_done
	beq $t1, '*', matrix_done
	move $a0, $s0
	move $a1, $t0
	move $a2, $t1
	jal lookup_char
	move $t0, $v1
	sb $t0, 0($s3)
	addi $s7, $s7, 2
	addi $s3, $s3, 1
	j matrix_loop
matrix_done:
sb $zero, 0($s3)
lw $ra, 32($sp)
lw $s7, 28($sp)
lw $s6, 24($sp)
lw $s5, 20($sp)
lw $s4, 16($sp)
lw $s3, 12($sp)
lw $s2, 8($sp)
lw $s1, 4($sp)
lw $s0, 0($sp)
addi $sp, $sp, 36
jr $ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
