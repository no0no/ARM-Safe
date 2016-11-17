@ Project 3: Part-2.s
@ Group 4 (Gage Aschenbrenner, Ian B., Filiberto Reyes, Wei Zhao, Nathan Kandouw)
@ 11/16/16
@ Decrypts a message from an input file (output.txt), outputs
@ decryption to an output file

Main:
	bl	OpenInput
	bl	ReadInt
	bl	ReadString
	bl	Encrypt
	bl	OpenOutput
	bl	PrintPassword
	bl	OpenShift
	bl	PrintShift
	bl	CloseFiles

OpenInput:
	ldr	r0,=InFileName
	mov	r1,#0
	swi	SWI_Open
	bcs	NoInFileFound
	ldr	r2,=InFileHandle		@ Memory [r2] is for input file handle
	str	r0,[r2]

	bx	lr						@ Branches back to where it was called (i.e Main)

@ ==== Reads the first integer from the file, used as shift value ==== @	
ReadInt:
	ldr	r6,=LinkRegister		@ Storing the Link Register so when ZeroOrLess is called it
	str	lr,[r6]					@ branches back to main 

	ldr	r0,[r2]
	swi	SWI_RdInt
	bcs	ReadError
	ldr	r5,=InputNumber
	str	r0,[r5]
	ldr	r5,[r5]
	bl	ZeroOrLess				@ Checks if shift value is <= 0
@	mvn	r7,r5
@	add	r5,r7,#1
	mov	r7,#-1
	mul	r5,r7,r5
	ldr	lr,[r6]

	bx	lr
	
ReadString:
	ldr	r0,[r2]
	ldr	r1,=InputString
	mov	r2,#80
	swi	SWI_RdStr
	cmp	r0,#1					@ If readString loads <= 1 into r0 nothing was read from file
	ble	ReadStringError

	bx	lr
	
@ ==== Encrypts the byte with a shift value determined by user ==== @	
Encrypt:
	ldrb	r4,[r1], #1
	cmp	r4,#0					@ Compares to 0, because 0 is null in ASCII
	addne	r4,r4,r5
	strb	r4,[r1, #-1]
	bne	Encrypt

	bx	lr
	
OpenOutput:
	ldr	r0,=OutFileName
	mov	r1,#1
	swi	SWI_Open
	ldr	r1,=OutFileHandle
	str	r0,[r1]					@ Memory [r1] for output file handle
	
	bx	lr
	
PrintPassword:
	ldr	r0,[r1]
	ldr	r1,=InputString
	swi	SWI_PrStr

	bx	lr

OpenShift:
	ldr r0,=ShiftFileName
	mov	r1,#1
	swi	SWI_Open
	ldr	r3,=ShiftFileHandle
	str	r0,[r3]
	
	bx	lr

PrintShift:
	ldr	r0,[r3]
	mul r5,r7,r5
	mov	r1,r5
	swi	SWI_PrInt
	
	bx	lr
	
@ ==== Checks if the shift value is negative or zero ==== @
ZeroOrLess:
	cmp	r5,#0
	movle	r0,#StdOut
	ldrlt	r1,=NegativeInput			@ "[Encryption] Please input numbers greater than 0 for your shift value"
	ldreq	r1,=ZeroInput				@ "Fatal Error: 0 is not a sufficient shift value"
	swi	SWI_PrStr
	ble	CloseFiles

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

ReadStringError:
	mov	r0,#StdOut
	ldr	r1,=ReadStringErr
	swi	SWI_PrStr
	b	CloseFiles

@ ==== Closes input and output file ==== @
CloseFiles:
	ldr	r0,[r2]
	swi	SWI_Close
	ldr	r0,[r1]
	swi	SWI_Close
	ldr	r0,[r3]
	swi	SWI_Close
	b	Exit

Exit:
	SWI	SWI_Exit

@ ==== File Components ==== @
InFileName:	.asciz "decrypt-input.txt"
InFileHandle:	.word 0
OutFileName:	.asciz "decrypt-output.txt"
OutFileHandle:	.word 0
ShiftFileName:	.asciz "shift.txt"
ShiftFileHandle:	.word 0

@ ==== Strings ==== @
NoInFileErr:	.asciz "Fatal Error: Unable to find input.txt\r\n"
ReadErr:	.asciz "Fatal Error: Unable to read number from input.txt"
ReadStringErr:	.asciz "Fatal Error: Unable to read string from input.txt"
NegativeInput:	.asciz "[Decryption] Please input numbers greater than 0 for your shift value"
ZeroInput:	.asciz "Fatal Error: 0 is not a sufficient shift value"

@ ==== Memory Addresses ==== @
LinkRegister:	.word 0
InputString:	.skip 80
InputNumber:	.word 0

@ ==== SWI Statements ==== @
.equ	StdOut,		1
.equ	SWI_RdInt,	0x6c
.equ	SWI_PrInt,	0x6b
.equ	SWI_RdStr,	0x6a
.equ	SWI_PrStr,	0x69
.equ	SWI_Open,	0x66
.equ	SWI_Close,	0x68
.equ	SWI_Exit,	0x11
