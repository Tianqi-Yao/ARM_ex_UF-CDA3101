#Johnny Li      CDA3101
#Project 1: Palindrome String Checker
#1.x Prints "input a string".
#2.x Reads the input string.
#3.x Calculates the length of the string.
#4.x Outputs the string length to the console.
#5.x Recursively determines if the string is a palindrome.
#6.x Outputs whether the string is a palindrome.

#Registers used:
#               x0   - system parameter and format type
#               x1   - system parameter and print value
#               x2   - system parameter and index storage
#               x8   - tells system what function to call
#               x9   - system parameter and temporary place
#               x10  - system parameter and store string length
#               x12  - temporary parameter and string index 
#				storage
#               x13  - temporary parameter and string length
#               x14  - temporary parameter and original string
#               x21  - saved parameter and zero comparison
#               x29  - frame pointer register
#               x30  - main method location
#               w1   - reverse string vector
#               w11  - original string vector
#               w14  - original string vector

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

#Read the string.
#String format.
ldr x0, =readformat
#Character limit.
ldr x1, =strbuffer
bl scanf
#--------------------------------------------------
#Get length of string.
#Load string to x9.
ldr x9, =strbuffer
#Clear x10 by storing zero.
mov x10, #0

#Calculate string length.
bl Compute_Length

#Store length in x13.
mov x13, x10
		
#Length message.
#String format.
ldr x0, =readformat
ldr x1, = str3
#Print Message.
bl printf

#Print string length.
#Retrieve string from x13.
mov x1, x13
#Decimal format.
ldr x0, =numtype
#Print Message.
bl printf
#--------------------------------------------------
#Code edited from reverse_fa2018_complete.
#Move length to x0.
mov x0, x13
		
#Change length to length-1.
sub x0, x0, #1 
		
#Move string address to x1.
ldr x1, =strbuffer
		
#Starting index for reverse.
mov x2, #0
		
#Initial index is zero.
mov x12, #0
      
#Branch to reverse, setting return address.
bl reverse
		
#Branch to true output statement.
b true		
#--------------------------------------------------

#Calculate string length.
Compute_Length:
	#Load string.
	ldrb w11,[x10,x9]
	#Check if null, if so go to done.
	cbz w11, done
	#Increment by 1.
	add x10,x10,#1
	#Return back to compute length.
	b Compute_Length

#Store number.		
done:
	#Move x10 to x1.
	mov x1, x10
	#Return to x30.
	br x30

#Code edited from reverse_fa2018_complete.
reverse:    
	#In reverse we want to maintain.
	#x0 is length-1.
	#x1 is memory location where string is.
	#x2 is index.

     subs x3, x2, x0
	#If the last index haven't been reached, recurs. 
	b.lt recurse
	
base:       
	#Reached the end of the string.        
	#Keep x1 around because that's the string address.
	
	#Check Base output.
	#ldr x0, =outformat.

	#Also bl will overwrite return address, so store that too.
	stp x30, x1, [sp, #-16]!
	ldrb w1, [x1, x2]
		
	#bl printf
	
	#Compare strings and determine if they are a palindrome.
	#Load original string to x14.
	ldr x14, =strbuffer
	#Load vector string index.
	ldrb w14, [x14,x12]
	#Increment by 1.
	add x12,x12,#1
	#Compare by subtraction.
	sub x21,x14,x1
	#Check if the subtraction not result in zero, if so return 	#false.
	cbnz x21, false
			
	ldp x30, x1, [sp], #16
	
	#Go back and start executing at the return address.
	br x30
			
recurse:    
	#First we store the frame pointer(x29) and link	#register(x30).
	sub sp, sp, #16
	str x29, [sp, #0]
	str x30, [sp, #8]

	#Move our frame pointer.
	add x29, sp, #8

	#Make room for the index on the stack.
	sub sp, sp, #16

	#Store it with respect to the frame pointer.
	str x2, [x29, #-16]

	#Increment by 1.
	add x2, x2, #1 

	#Branch and link to original function. 
	bl reverse			

end_rec:    
	#Back from other recursion, so load in our index.
	ldr x2, [x29, #-16]

	#Find character.
	stp x30, x1, [sp, #-16]!

	#Check Base output.
	#ldr x0, =outformat

	ldrb w1, [x1, x2]
			
	#Compare strings and determine if they are a palindrome.
	#Load original string to x14.
	ldr x14, =strbuffer
	#Load vector string index.
	ldrb w14, [x14,x12]
	#Increment by 1.
	add x12,x12,#1
	#Compare by subtraction.
	sub x21,x14,x1
	#Check if the subtraction not result in zero, if so return	#false output statement.
	cbnz x21, false

	#bl printf

	ldp x30, x1, [sp], #16

	#Clear off stack space used to hold index.
	add sp, sp, #16

	#Load in fp and lr.
	ldr x29, [sp, #0]
	ldr x30, [sp, #8]
            
	#Clear off the stack space used to hold fp and lr.
	add sp, sp, #16

	#Return to correct location in execution.
	br x30
			
#Print that the string is a palindrome.
true:
	#String format.
	ldr x0, =readformat
	ldr x1, =str5
	bl printf

	#Exit the program.
	b exit
	
#Print that the string is not a palindrome.
false:
	#String format.
	ldr x0, =readformat
	ldr x1, =str4
	bl printf

	#Exit the program.
	b exit
	
#Exit the program.
exit:		
	mov x8, #93
	mov x0, #42
	svc #0

#Use for debugging.
debug:
	br x30

.section .data
#Format type sring
readformat: .asciz "%s"

#Format type decimal
numtype: .asciz "%d \n"

#Format type character
outformat:     .asciz "%c \n"

strbuffer: .space 256

str1: .asciz "Johnny Li -CDA3101 Fall 2018. \nProject 1: Palindrome String Checker.\n"

str2: .asciz "Input a string to check if it is a palindrome:\n"

str3: .asciz "Length of string is: "

str4: .asciz "FALSE: String is not a palindrome.\n"

str5: .asciz "TRUE: String is a palindrome.\n"
