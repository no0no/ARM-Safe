@ Project 3 - Part 4: Menu 
@ Group 4: (Filberto Reyes, Gage Aschenbrenner, Ian B., Nathan Kandouw, Wei Zhao)
@ 10/20/16
@ Interfaces the 3 programs together through a menu

@ ====================== Initialization ====================== @
@ ==== The 8 Segment ==== @
.equ SEG_A, 						0x80
.equ SEG_B, 						0x40
.equ SEG_C, 						0x20
.equ SEG_D, 						0x08
.equ SEG_E, 						0x04
.equ SEG_F, 						0x02
.equ SEG_G, 						0x01
.equ SEG_P, 						0x10
.equ SWI_DRAW_STRING, 					0x204					@ display a string on LCD

@ ==== (2) Red LEDs ==== @
.equ LEFT_LED,						0x02 					@ Left red LED
.equ RIGHT_LED,						0x01					@ Right red LED

@ ==== SWI Stuff ==== @ 
.equ Stdin, 						0
.equ SWI_SETSEG8, 					0x200 					@ display on 8 Segment
.equ SWI_SETLED, 					0x201 					@ LEDs on/off
.equ SWI_CheckBlack, 					0x202 					@ check Black button
.equ SWI_CheckBlue, 					0x203 					@ check press Blue button
.equ SWI_EXIT, 						0x11 					@ terminates program
.equ SWI_LCD_SCREEN, 					0x204					@ display a string on LCD
.equ SWI_CLEAR_SCREEN, 					0x206					@ Clears the LCD screen
.equ SWI_Exit, 						0x11 					@ Local Constants
.equ SWI_PrintInt, 					0x6B
.equ SWI_PrintChar, 					0x0
.equ Stdout, 						1
LinkRegister:	.word 0

@ ==== (15) Blue Buttons ==== @
.equ BLUE_KEY_00, 					0x01 					@ Blue Button 0
.equ BLUE_KEY_01, 					0x02 					@ Blue Button 1
.equ BLUE_KEY_02, 					0x04 					@ Blue Button 2
.equ BLUE_KEY_03, 					0x08 					@ Blue Button 3
.equ BLUE_KEY_04, 					0x10 					@ Blue Button 4
.equ BLUE_KEY_05, 					0x20 					@ Blue Button 5
.equ BLUE_KEY_06, 					0x40 					@ Blue Button 6
.equ BLUE_KEY_07, 					0x80 					@ Blue Button 7
.equ BLUE_KEY_08, 					1<<8 					@ Blue Button 8
.equ BLUE_KEY_09,		 			1<<9 					@ Blue Button 9
.equ BLUE_KEY_10, 					1<<10 					@ Blue Button 10
.equ BLUE_KEY_11, 					1<<11 					@ Blue Button 11
.equ BLUE_KEY_12, 					1<<12 					@ Blue Button 12
.equ BLUE_KEY_13, 					1<<13 					@ Blue Button 13
.equ BLUE_KEY_14, 					1<<14 					@ Blue Button 14
.equ BLUE_KEY_15, 					1<<15 					@ Blue Button 15
.equ LEFT_BLACK_BUTTON,					0x02 					@ bit patterns for black buttons
.equ RIGHT_BLACK_BUTTON,				0x01 					@ and for blue buttons
.equ SWI_GetTicks, 0x6d @get current time 

@ === For Calling Functions of other files === @
.global _start												@ Declares the program will start in Part 4
.extern EncryptMain 
.extern DecryptMain
.extern SafeMain
.text

@ ====================== CONTROL MENU ====================== @
_start:														@ Forces the program to start in Part 4
	BL	Clear
	MOV 	R0, #6
	LDR 	R0, [R2, R0, LSL#2]
	swi 	0x204
	MOV 	R0, #1 												@ column number
	MOV 	R1, #1 												@ row number
	LDR 	R2, =MenuMessage1 									@ "Please select one of the"
	swi 	SWI_LCD_SCREEN
	MOV 	R0, #1
	MOV 	R1, #2
	LDR 	R2, =MenuMessage2									@ "following options:"
	swi 	SWI_LCD_SCREEN
	MOV 	R0, #1
	MOV 	R1, #4
	LDR 	R2, =MenuMessage3									@ "1.Encrypt"
	swi 	SWI_LCD_SCREEN
	MOV 	R0, #1
	MOV 	R1, #5
	LDR 	R2, =MenuMessage4									@ "2.Decrypt"
	swi 	SWI_LCD_SCREEN
	MOV 	R0, #1
	MOV 	R1, #6
	LDR 	R2, =MenuMessage5									@ "3.Safe Control"
	swi 	SWI_LCD_SCREEN
	MOV	R0, #1
	MOV	R1, #7
	LDR	R2, =MenuMessage6									@ "4.Exit"
	swi	SWI_LCD_SCREEN
	
	mov 	r0, #0 												@ Resets R0
	mov 	r1, #0
	mov 	r2, #0

MenuBlueKey:												@ Checks to see if any blue buttons are pressed
	swi 	SWI_CheckBlue
	cmp 	r0, #BLUE_KEY_01
	beq 	MenuNumbers
	cmp 	r0, #BLUE_KEY_02
	beq 	MenuNumbers
	cmp 	r0, #BLUE_KEY_03
	beq 	MenuNumbers
	cmp	r0, #BLUE_KEY_04
	beq	MenuNumbers
	b 	MenuBlueKey

MenuNumbers:												@ Whichever # is pressed, branch to that number function 
	cmp 	r0, #BLUE_KEY_01
	beq 	Encrypt 											@ Calls Part 1: Encrypt file
	cmp 	r0, #BLUE_KEY_02
	beq 	Decrypt												@ Calls Part 2: Decrypt file
	cmp 	r0, #BLUE_KEY_03
	beq 	SafeControl											@ Calls Part 3: Safe Control file
	cmp	r0, #BLUE_KEY_04
	beq	Exit

Encrypt:
	swi	SWI_CLEAR_SCREEN
	MOV	R0, #1
	MOV	R1, #1
	LDR	R2, =EncryptInProg
	swi	SWI_DRAW_STRING
	ldr	r6, =LinkRegister
	str	lr,[r6]
	b	BlueKey
	bl 	EncryptMain

Decrypt:
	swi	SWI_CLEAR_SCREEN
	MOV	R0, #1
	MOV	R1, #1
	LDR 	R2, =DecryptInProg
	swi	SWI_DRAW_STRING
	bl 	DecryptMain
	
BlueKey:													@ Checks to see if any blue buttons are pressed 
	swi SWI_CheckBlue
	cmp r0, #BLUE_KEY_00
	beq Numbers
	cmp r0, #BLUE_KEY_01
	beq Numbers
	cmp r0, #BLUE_KEY_02
	beq Numbers
	cmp r0, #BLUE_KEY_03
	beq Numbers
	cmp r0, #BLUE_KEY_04
	beq Numbers
	cmp r0, #BLUE_KEY_05
	beq Numbers
	cmp r0, #BLUE_KEY_06
	beq Numbers
	cmp r0, #BLUE_KEY_07
	beq Numbers
	cmp r0, #BLUE_KEY_08
	beq Numbers
	cmp r0, #BLUE_KEY_09
	beq Numbers
	cmp r0, #BLUE_KEY_10
	beq Numbers
	cmp r0, #BLUE_KEY_11
	beq Numbers
	cmp r0, #BLUE_KEY_12
	beq Numbers
	cmp r0, #BLUE_KEY_13
	beq Numbers
	cmp r0, #BLUE_KEY_14
	beq Numbers
	cmp r0, #BLUE_KEY_15
	beq Numbers	

Numbers:													@ Whichever # is pressed, branch to that number function 
	cmp r0, #BLUE_KEY_00	
	beq Zero
	cmp r0, #BLUE_KEY_01
	beq One
	cmp r0, #BLUE_KEY_02
	beq Two
	cmp r0, #BLUE_KEY_03
	beq Three
	cmp r0, #BLUE_KEY_04
	beq Four
	cmp r0, #BLUE_KEY_05
	beq Five
	cmp r0, #BLUE_KEY_06
	beq Six
	cmp r0, #BLUE_KEY_07
	beq Seven
	cmp r0, #BLUE_KEY_08
	beq Eight
	cmp r0, #BLUE_KEY_09
	beq Nine
	cmp r0, #BLUE_KEY_10
	beq Ten
	cmp r0, #BLUE_KEY_11
	beq Eleven
	cmp r0, #BLUE_KEY_12
	beq Twelve
	cmp r0, #BLUE_KEY_13
	beq Thirteen
	cmp r0, #BLUE_KEY_14
	beq Fourteen
	cmp r0, #BLUE_KEY_15
	beq Fifteen

Zero:
	mov r0,#0x03	@ both LEDs on
	swi 0x201	 	
	bl Blink
	mov r9,#0
	ldr lr,[r6]
	bx lr
	
One:
	mov r0,#0x03											@ Both LEDs on
	swi 0x201	 
	bl Blink
	mov r9, #1
	ldr lr,[r6]
	bx lr												
		
Two:
	mov r0,#0x03	
	swi 0x201	 
	bl Blink
	mov r9, #2
	ldr lr,[r6]
	bx lr
	
Three:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r9, #3
	ldr lr,[r6]
	bx lr

Four:
	mov r0,#0x03	
	swi 0x201	 
	bl Blink
	mov r9, #4
	ldr lr,[r6]
	bx lr

Five:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r9, #5
	ldr lr,[r6]
	bx lr

Six:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r9, #6
	ldr lr,[r6]
	bx lr

Seven:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r9, #7
	ldr lr,[r6]
	bx lr	
	
Eight:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r9, #8
	ldr lr,[r6]
	bx lr	
	
Nine:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r9, #9
	ldr lr,[r6]
	bx lr	

Ten:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r9, #10
	ldr lr,[r6]
	bx lr	

Eleven:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r9, #11
	ldr lr,[r6]
	bx lr

Twelve:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r9, #12
	ldr lr,[r6]
	bx lr
	
Thirteen:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r9, #13
	ldr lr,[r6]
	bx lr	

Fourteen:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r9, #14
	ldr lr,[r6]
	bx lr	

Fifteen:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r9, #15
	ldr lr,[r6]
	bx lr	

SafeControl:
	bl 	SafeMain

Clear:
	mov	r0,#0
	mov	r1,#0
	mov	r2,#0
	mov	r3,#0
	mov	r4,#0
	mov	r5,#0
	mov	r6,#0
	mov	r7,#0
	mov	r8,#0
	mov	r9,#0
	bx	lr

Blink:							 
	stmfd sp!,{r0-r2,lr}
	swi SWI_GetTicks
	mov r1, r0

Exit:
	swi	SWI_CLEAR_SCREEN
	MOV	R0, #1
	MOV	R1, #1
	LDR	R2, =ExitString
	swi	SWI_DRAW_STRING
	swi	SWI_EXIT

@ ==== State Letters ==== @
Letters:
	.word 		SEG_G|SEG_E|SEG_D|SEG_C|SEG_B				@ Displays "U" (0)
	.word 		SEG_G|SEG_E|SEG_D							@ Displays "L" (1)
	.word 		SEG_A|SEG_B|SEG_G|SEG_F|SEG_E				@ Displays "P" (2)
	.word 		SEG_A|SEG_G|SEG_E|SEG_D						@ Displays "C" (3)
	.word 		SEG_A|SEG_G|SEG_F|SEG_E						@ Displays "F" (4)
	.word 		SEG_A|SEG_G|SEG_E|SEG_B|SEG_C|SEG_F			@ Displays "A" (5)
	.word 		SEG_A|SEG_G|SEG_F|SEG_E|SEG_D				@ Displays "E" (6)
	.word 		SEG_P										@ Displays "." (7)

MenuMessage1:	.asciz "Please select one of the"
MenuMessage2:	.asciz "following options:"
MenuMessage3:	.asciz "1.Encrypt"
MenuMessage4:	.asciz "2.Decrypt"
MenuMessage5:	.asciz "3.Safe Control"
MenuMessage6:	.asciz "4.Exit"
EncryptInProg:	.asciz "Encrpyt: Please enter a shift value"
DecryptInProg:	.asciz "Decrypt: Please enter a shift value"
ExitString:	.asciz "Goodbye!"
.end
