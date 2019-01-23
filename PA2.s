#Johnny Li      CDA3101
#Project 2: Decimal to Binary
#1.Read an integer input
#2.Print the binary representation to the screen.
#Assumptions:
#1) The inputs will be unsigned.
#2) The inputs can be as large as (2^(32) - 1).

#Registers used:
#               x0   - system parameter and format type
#               x1   - system parameter and print value
#               x6   - system parameter and input storage
#               x8   - tells system what function to call
#               x9   - system parameter and temporary place
#               x10  - system parameter and temporary place
#               x19  - saved parameter and #2
#               x21  - saved parameter and permanent place
#               x22  - saved parameter and stack
#               x23  - system parameter and counter
#               x27  - system parameter and permanent place
#             x28/sp - stack pointer register
#               x30  - main method location

.section .text
.global main

main:

#-------------------------------------------
#Output introduction.
#Load welcome message.
#String format.
ldr x0, =readformat
ldr x1, =str1
#Print Message.
bl printf

#Load input message.
#String format.
ldr x0, =readformat
ldr x1, = str2
#Print Message.
bl printf

#Read the input.
#Integer format.
ldr x0, =numtype
#Integer limit.
ldr x1, =intbuffer
bl scanf
#-------------------------------------------
#Load input integer.
mov x21,x6
#Storage value of 2, will be used in divison.
mov x19, #2
#Clear counter, will be used to keep track of
#popping from stack.
mov x23, #0

#Check if null, if so go to done- print 0
cbz x21, zero

#Convert to Binary.
bl binary
#-------------------------------------------
#Load output message.
#String format.
ldr x0, =readformat
ldr x1, =str3
#Print Message.
bl printf

#Print from stack.
bl print
#-------------------------------------------

#Calculate Binary Value.
#Divide dividend by 2. Then multiple the quotient by 2.
#Subtract Oringnal and Product. Store result in stack.
#Ex: 10/2=5*2=10-10=0, 5/2=2*2=4-5=1, 2/2=1*2=2-2=0
#	1/2=0*2=0-1=1 
binary: 
	#Check if null, if so go to done- finished
	#with the algebra/loop
	cbz x21, done
	
	#Store original.
	mov x10, x21 
	#Step 1: Divide by 2.
	udiv x21, x21, x19
	#Step 2: Multiple quotient by 2.
	mul x27, x21, x19
	#Step 2: Multiple quotient by 2.
	sub x28, x10, x27
	
	#Step 4: Add to stack
	#Clear stack.
	sub sp, sp, #16
	#Store in stack 
	str x28,[sp,#0]

	#Increment counter by 1.
	add x23,x23,#1
	#Increment counter by 1.
	b binary

#Print from stack.
print:
	#Check if null, if so go to exit- finished
	#with the printing/loop.
	cbz x23, exit

	#Retrieve value from stack.
	#Load the stack.
	ldr x22, [sp,#0]
	#Pop from stack.
	add sp, sp,#16

	#Print the binary value.
	#Integer format.
	ldr x0, = numtype
	mov x1, x22
	bl printf
	#Decrement counter for stack.
	sub x23,x23,#1
	#Return back to print.
	b print

#Print zero.
zero:
	#Load zero message.
	#String format.
	ldr x0, =readformat
	ldr x1, =str4
	#Print Message.
	bl printf
	
	#Exit
	b exit

#Return to main.		
done:
	#Return to x30.
	br x30

#Use for debugging.
debug:
	br x30	

#Exit the program.
exit:
	#Recommended by TA
	#Flush
	ldr x0, = nl
	bl printf
	
	mov x8, #93
	mov x0, #42
	svc #0

.section .data
#Form new line.
nl: .asciz "\n"

#Format type decimal.
numtype: .asciz "%d"

#Format type sring.
readformat: .asciz "%s"

#Store integar.
intbuffer: .space 64

#Intro string.
str1: .asciz "Johnny Li -CDA3101 Fall 2018. \nProject 2: Decimal to Binary.\n"

#Input prompt.
str2: .asciz "Input a integer to convert to binary:\n"

#Output prompt.
str3: .asciz "The Binary value is:\n"
#Zero prompt.
str4: .asciz "The Binary value is:\n0"

