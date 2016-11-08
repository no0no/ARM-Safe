@ Project 3: Part-1.s
@ Group 4
@ 10/30/16
@ Encrypts a message from an input file, outputs
@ encryption to an output file

Main:
	BL	OpenInput
	BL	ReadString
	BL	PrintString
	BL	CloseFiles

OpenInput:
	ldr	r0,=InFileName
	mov	r1,#0
	swi	SWI_Open
	bcs	NoInFileFound
	ldr	r1,=InFileHandle			@ Memory [r1] is for input file handle
	str	r0,[r1]
	bx	lr					@ Branches back to where it was called (i.e Main)
	
ReadString:
	ldr	r0,[r1]
	mov	r2,#80
	ldr	r3,=InputString
	str	r1,[r3]
	swi	SWI_RdStr
	bcs	ReadError
	bx	lr
	
PrintString:
	mov	r0,#StdOut
	ldr	r1,[r3]
	swi	SWI_PrStr
	bx	lr

Encrypt:
	

@ ==== Input File Error ==== @	
NoInFileFound:
	mov	r0,#StdOut
	ldr	r1,=NoInFileErr
	swi	SWI_PrStr
	b	Exit
	
ReadError:
	mov	r0,#StdOut
	ldr	r1,=ReadErr
	swi	SWI_PrStr
	b	CloseFiles

@ ==== Closes input and output file ==== @
CloseFiles:
	ldr	r0,[r1]
	swi	SWI_Close
	b	Exit

Exit:
	SWI	SWI_Exit

@ ==== File Components ==== @
InFileName:	.asciz "input.txt"
InFileHandle:	.word 0

@ ==== Strings ==== @
NoInFileErr:	.asciz "Fatal Error: Unable to find input.txt\r\n"
ReadErr:	.asciz "Fatal Error: Unable to read number from input.txt"

@ ==== Memory Addresses ==== @
InputString:	.word 0

@ ==== SWI Statements ==== @
	.equ	StdOut,		1
	.equ	SWI_RdStr,	0x6a
	.equ	SWI_PrStr,	0x69
	.equ	SWI_Open,	0x66
	.equ	SWI_Close,	0x68
	.equ	SWI_Exit,	0x11
