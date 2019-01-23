

.global _start
.section .text

_start:

/* syscall write(int fd, const void *buf, size_t count) */
/* the three arguments will be put in registers x0, x1, x2*/
/*syscall number is put in register x8.  It tells system what function to call*/



mov x0, #1
ldr x1, =string
mov x2, #12 
mov x8, #0x40 //hex 40 for write  (decimal 64)
svc #0 //do it!

//exit the program
mov x8, #93
mov x0, #42
svc #0

ret

.section .data

string:
	.asciz "Hello World\n"
