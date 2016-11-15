@ Project 3: Part-1.s
@ Group 4
@ 10/30/16
@ Encrypts a message from an input file, outputs
@ encryption to an output file

Main:
	bl	OpenInput
	bl	ReadInt
	bl	ReadString
	bl	Encrypt
	bl	PrintString
	bl	CloseFiles

OpenInput:
	ldr	r0,=InFileName
	mov	r1,#0
	swi	SWI_Open
	bcs	NoInFileFound
	ldr	r2,=InFileHandle			@ Memory [r2] is for input file handle
	str	r0,[r2]

	bx	lr					@ Branches back to where it was called (i.e Main)
	
ReadInt:
	ldr	r0,[r2]
	swi	SWI_RdInt
	bcs	ReadError
	ldr	r5,=InputNumber
	str	r0,[r5]
	ldr	r5,[r5]

	bx	lr
	
ReadString:
	ldr	r0,[r2]
	ldr	r1,=InputString
	mov	r2,#80
	swi	SWI_RdStr
	bcs	ReadError

	bx	lr
	
@ ==== Encrypts the byte with a shift value determined by user ==== @	
Encrypt:
	ldrb	r4,[r1], #1
	cmp	r4,#0
	addne	r4,r4,r5
	strb	r4,[r1, #-1]
	bne	Encrypt

	bx	lr

PrintString:
	mov	r0,#StdOut
	ldr	r1,=InputString
	swi	SWI_PrStr

	bx	lr

OpenOutput:
	ldr	r0,=OutFileName
	mov	r1,#1
	swi	SWI_Open
	ldr	r1,=OutFileHandle
	str	r0,[r1]
	
	bx	lr

@ ==== Input File Error ==== @	
NoInFileFound:
	mov	r0,#StdOut
	ldr	r1,[r3]
	swi	SWI_PrStr
	b	Exit

ReadError:
	mov	r0,#StdOut
	ldr	r1,=ReadErr
	swi	SWI_PrStr
	b	CloseFiles

@ ==== Closes input and output file ==== @
CloseFiles:
	ldr	r0,[r2]
	swi	SWI_Close
	b	Exit

Exit:
	SWI	SWI_Exit

@ ==== File Components ==== @
InFileName:	.asciz "input.txt"
InFileHandle:	.word 0
OutFileName:	.asciz "output.txt"
OutFileHandle:	.word 0

@ ==== Strings ==== @
NoInFileErr:	.asciz "Fatal Error: Unable to find input.txt\r\n"
ReadErr:	.asciz "Fatal Error: Unable to read number from input.txt"

@ ==== Memory Addresses ==== @
InputString:	.skip 80
InputNumber:	.word 0

@ ==== SWI Statements ==== @
	.equ	StdOut,		1
	.equ	SWI_RdInt,	0x6c
	.equ	SWI_RdStr,	0x6a
	.equ	SWI_PrStr,	0x69
	.equ	SWI_Open,	0x66
	.equ	SWI_Close,	0x68
	.equ	SWI_Exit,	0x11
