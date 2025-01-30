	.macro printArray(%arr, %size)

		print_array:
		    move $t0, %size                   # Load size of the array into $t0 (counter)
		    move $t1, %arr                   # Load base address of the array into $t1

		print_loop:
		    beqz $t0, print_exit            # Exit loop if counter is 0
		    lw $t2, 0($t1)                  # Load the current element into $t2
		    li $v0, 1                       # System call for print integer
		    move $a0, $t2                   # Move the value to be printed into $a0
		    syscall                         # Print integer

		    li $v0, 4                       # System call for print string
		    la $a0, space                   # Print space between numbers
		    syscall

		    addi $t1, $t1, 4                # Move to the next element in the array
		    addi $t0, $t0, -1               # Decrement the counter
		    j print_loop                    # Repeat loop
    
		print_exit:

	.end_macro

.data 
eightEvenArray: .word 16, 14, 12, 6, 10, 4, 2, 8  	#My array which contains 8 even integer
size:		.word		8 
space:		.asciiz 	" "

.text 
.globl main 						#global main so I can acess it from other files.

main:
la $t0, eightEvenArray 				#Moves the address of array into register $t0.
addi $a0, $t0, 0					#Set argument 1 to the array.
addi $a1, $zero, 0 					#Low index of the array which is 0
addi $a2, $zero, 7 					#High index of the array which is 7
jal quicksort 						#Call my quick sort fucntion

la	$a0, eightEvenArray                   # Load address of array into $a0
lw 	$a1, size                    # Load size of the array into $a1
    
printArray $a0 $a1

li $v0, 10 						#Execute the program
syscall

#swap method 
#Smaler than pivot to the left and bigger than pivot to the right
swap:										

	addi $sp, $sp, -12				#Make stack room for three variable (low, pivot, high)

	sw $a0, 0($sp)					#Store a0 in $sp address
	sw $a1, 4($sp)					#Store a1 in $sp address
	sw $a2, 8($sp)					#Store a2 in $sp address

	sll $t1, $a1, 2 				#t1 = 4a (4bit)
	add $t1, $a0, $t1				#t1 = eightEvenArray + 4a
	lw $s3, 0($t1)					#s3  -> t =  eightEvenArray[a]

	sll $t2, $a2, 2					#t2 = 4b (4bit)
	add $t2, $a0, $t2				#t2 = eightEvenArray + 4b
	lw $s4, 0($t2)					#s4 = eightEvenArray[b]

	sw $s4, 0($t1)					#eightEvenArray[a] = eightEvenArray[b]
	sw $s3, 0($t2)					#eightEvenArray[b] = t 


	addi $sp, $sp, 12				
	jr $ra						
	
#partition method	
#find the low and high element based on the pivot
partition: 						

	addi $sp, $sp, -16				#Make room for 5 variable

	sw $a0, 0($sp)					#store a0 in $sp address
	sw $a1, 4($sp)					#store a1 in $sp address
	sw $a2, 8($sp)					#store a2 in $sp address
	sw $ra, 12($sp)					#store return address
	
	move $s1, $a1					#s1 = low
	move $s2, $a2					#s2 = high

	sll $t1, $s2, 2					#t1 = 4*high (4 bit)
	add $t1, $a0, $t1				#t1 = eightEvenArray + 4*high
	lw $t2, 0($t1)					#t2 = eightEvenArray[high] 
							#which is the pivot

	addi $t3, $s1, -1 				#t3 -> i = low -1
	move $t4, $s1					#t4 -> j = low
	addi $t5, $s2, -1				#t5 = high - 1

	forloop: 
		slt $t6, $t5, $t4			#t6 = 1 if j > high - 1
							#t7 = 0 if j <= high - 1
							
		bne $t6, $zero, endfor			#if t6 = 1 then branch to endfor

		sll $t1, $t4, 2				#t1 = j*4 (4bit)
		add $t1, $t1, $a0			#t1 = eightEvenArray  + 4j
		lw $t7, 0($t1)				#t7 = eightEvenArray [j]

		slt $t8, $t2, $t7			#t8 = 1 if pivot < eightEvenArray[j]
							#0 if eightEvenArray[j] <= pivot
		bne $t8, $zero, endfif			#if t8 = 1 then branch to endfif
		addi $t3, $t3, 1			#increment i ->  i+1

		move $a1, $t3				#a1 = i
		move $a2, $t4				#a2 = j
		jal swap				#swap(eightEvenArray, i, j)
		
		addi $t4, $t4, 1			#j++
		j forloop

	    endfif:
		addi $t4, $t4, 1			#j++
		j forloop				#junp back to forloop

	endfor:
		addi $a1, $t3, 1			#a1 = i+1
		move $a2, $s2				#a2 = high
		add $v0, $zero, $a1			#v0 = i+1 return (i + 1);
		jal swap				#swap(eightEvenArray, i + 1, high);

		lw $ra, 12($sp)				#return address
		addi $sp, $sp, 16			#restore the stack
		jr $ra					

#quicksort method
quicksort:						

	addi $sp, $sp, -16				# Make room for 4 variable

	sw $a0, 0($sp)					
	sw $a1, 4($sp)					#Low
	sw $a2, 8($sp)					#High
	sw $ra, 12($sp)					#Return address

	move $t0, $a2					#High store in t0

	slt $t1, $a1, $t0				#t1=1 if low < high, else 0
	beq $t1, $zero, endif				#if low >= high, endif

	jal partition					#Call partition 
	move $s0, $v0					#Pivot, s0 = v0
	
	lw $a1, 4($sp)					#a1 = low
	addi $a2, $s0, -1				#a2 = pi -1
	jal quicksort					#call quicksort
	
	addi $a1, $s0, 1				#a1 = pi + 1
	lw $a2, 8($sp)					#a2 = high
	jal quicksort					#call quicksort

 endif:

 	lw $a0, 0($sp)					#restore a0
 	lw $a1, 4($sp)					#restore a1
 	lw $a2, 8($sp)					#restore a2
 	lw $ra, 12($sp)					#restore return address
 	addi $sp, $sp, 16				#restore the stack
 	jr $ra						#return to caller