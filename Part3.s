@==========================Project 3 Comp 122


@=======8 Segment Letters 
.equ SEG_A, 0x80 @ patterns for 8 segment display
.equ SEG_B, 0x40 @byte values for each segment
.equ SEG_C, 0x20 @of the 8 segment display
.equ SEG_D, 0x08
.equ SEG_E, 0x04
.equ SEG_F, 0x02
.equ SEG_G, 0x01
.equ SEG_P, 0x10
.equ LEFT_LED, 0x02 @bit patterns for LED lights
.equ RIGHT_LED, 0x01
@==========================SWI 
.equ Stdin, 0
.equ SWI_SETSEG8, 0x200 @display on 8 Segment
.equ SWI_SETLED, 0x201 @LEDs on/off
.equ SWI_CheckBlack, 0x202 @check Black button
.equ SWI_CheckBlue, 0x203 @check press Blue button
.equ SWI_EXIT, 0x11 @terminate program
@==========================Numbers 
.equ LEFT_BLACK_BUTTON,0x02 @bit patterns for black buttons
.equ RIGHT_BLACK_BUTTON,0x01 @and for blue buttons
.equ BLUE_KEY_00, 0x01 @button(0)
.equ BLUE_KEY_01, 0x02 @button(1)
.equ BLUE_KEY_02, 0x04 @button(2)
.equ BLUE_KEY_03, 0x08 @button(3)
.equ BLUE_KEY_04, 0x10 @button(4)
.equ BLUE_KEY_05, 0x20 @button(5)
.equ BLUE_KEY_06, 0x40 @button(6)
.equ BLUE_KEY_07, 0x80 @button(7)
.equ BLUE_KEY_08, 1<<8 @button(8) 
.equ BLUE_KEY_09, 1<<9 @button(9)
.equ BLUE_KEY_10, 1<<10 @button(10)
.equ BLUE_KEY_11, 1<<11 @button(11)
.equ BLUE_KEY_12, 1<<12 @button(12)
.equ BLUE_KEY_13, 1<<13 @button(13)
.equ BLUE_KEY_14, 1<<14 @button(14)
.equ BLUE_KEY_15, 1<<15 @button(15)


.equ SWI_GetTicks, 0x6d @get current time 
@=========================What each register does 
;r3 = Blue 
;r4 = Black Button 
;r5 = True/ False for PW check, used for storage too
;r6 = Some code sequence storage 
;r7 = Lock or Unlock 
;r8 = Used in array 
;r9 = Counter 
;r10 = Time 
@=========================Start
.global SafeMain
.global _start
.text
SafeMain:




	mov r7, #0			@ #0 for unlock state
	mov r0, #0			@ Reset to 0 
	mov r11, #10		@ Set r11 to 10 


Main:					@ Basically reset all registers 
	mov r8, #0			
	mov r3, #0			
	mov r5, #0			
	mov r4, #0			
	mov r6, #0			
	mov r10, #200		
	cmp r7, #0			@ if r7 = 0, then unlocked. if =1, then it's locked 
	beq Unlocked		@ if r7 = 0, unlocked, branch to unlocked 
	cmp r7, #1			@ if r7 = 1, locked, branch to locked 
	beq Locked
	
Unlocked:
	bl Display8Segment	@ Display U for unlock 
	swi SWI_CheckBlack	@ Check for Black 
	cmp r0, #RIGHT_BLACK_BUTTON		@ If right black button is 0 b to RightBlack 
	beq RightBlack
	cmp r0, #LEFT_BLACK_BUTTON		@ If left black button is 0 b to LeftBlack  
	beq LeftBlack
	b BlueKey						@ If none are pressed, branch and check BlueKeys now 


Locked:
	mov r0, #1			@ Locked = r1, #1 		
	bl Display8Segment
	swi SWI_CheckBlack
	cmp r0,#RIGHT_BLACK_BUTTON
	beq RightBlack
	cmp r0, #LEFT_BLACK_BUTTON
	beq LeftBlack
	b BlueKey


BlueKey:				@ Checks to see if any blue buttons are pressed 
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
	b Main	


ResetNumbers:				@ Resets counter 
	mov r8, #0
	mov r3, #0


PrevNumbers:				@ Allow first button pressed from Main to go through
	swi SWI_CheckBlue


Numbers:					@ Whichever # is pressed, branch to that number function 
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
	
	cmp r8, #8
	beq Main				@ Check to see if another # is pressed after
	swi SWI_CheckBlack		@ Is black pressed to stop pressing the code? 
	cmp r0, #LEFT_BLACK_BUTTON		
	beq LeftBlack
	cmp r0, #RIGHT_BLACK_BUTTON
	beq RightBlack
	b PrevNumbers
	
Zero:
	mov r0,#0x03	@ both LEDs on
	swi 0x201	 	
	bl Blink
	cmp r8, #0
	beq ZeroFirst
	mov r5, r3
	mul r3, r5, r11
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers
	
ZeroFirst:			
	mov r1, #0
	bleq ArrayLocation
	add r3, r3, #1000
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers
	
One:
	mov r0,#0x03	@ Both LEDs on
	swi 0x201	 
	bl Blink
	mov r1, #1		@ Preps Array Location
	cmp r8, #0		@ If first number of password, save to ArrayLocation
	bleq ArrayLocation
	add r3, r3, #1	@ Store password as single digit
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers
	
Two:
	mov r0,#0x03	
	swi 0x201	 
	bl Blink
	mov r1, #2	
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #2
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers
	
Three:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r1, #3	
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #3
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers
	
Four:
	mov r0,#0x03	
	swi 0x201	 
	bl Blink
	mov r1, #4	
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #4
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers
	
Five:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r1, #5	
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #5
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers
	
Six:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r1, #6	
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #6
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers
	
Seven:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r1, #7	
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #7
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers
	
Eight:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r1, #8	
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #8
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers
	
Nine:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r1, #9	
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #9
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers
	
Ten:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r1, #10	
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #10
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers	
	
Eleven:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r1, #11
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #11
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers	
	
Twelve:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r1, #12
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #12
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers	
	
Thirteen:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r1, #13
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #13
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers	
	
Fourteen:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r1, #14
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #14
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers	
	
Fifteen:
	mov r0,#0x03
	swi 0x201	
	bl Blink
	mov r1, #15
	cmp r8, #0	
	bleq ArrayLocation
	add r3, r3, #15
	mov r5, r3
	mul r3, r5, r11
	add r8, r8, #1
	bal Numbers		
@=================================================	
Display8Segment:
	stmfd sp!,{r0-r2,lr}	@ Stores the place you were
	ldr R2, =Letters		@ Loads the Letters array
	ldr r0,[r2,r0,lsl#2]	@ Depending on number in R0, takes letter from position in array
	swi SWI_SETSEG8			@ Display LED 
	ldmfd sp!,{r0-r2,pc}	@ Returns to stored location 


LeftBlack:
	

	mov r0,#0x02			@ Left LED on
	swi 0x201 				
	bl Blink
	cmp r7, #0
	beq LeftBlackLock 		@ if equal to 0, branch to LeftBlackLock
	cmp r8, #4				@ Checks to see if password is shorter than 4 digits
	blt Less4 				@ If true, branch to Less4 
	bl PWLoop		@ Checks if password is correct
	cmp R5, #1				@ Correct password = true 
	beq LeftBlackUnlock


Less4:
	mov r10, #800	
	mov r0, #6
	bl Display8Segment			 @ Display E for Error
	bl Blink
	bal Main 				@ False than 4, start again 
	
LeftBlackLock:				@ Lock the safe if everything is right 
	bl CheckPrevPW			@ Check to see if any passwords have been saved, if not, cannot lock safe
	cmp r5, #0
	beq Less4 				@ Digits less than 4, branch out


	mov r7, #1				@ Lock safe 
	bal Main				@ Branch to beginning
	
LeftBlackUnlock:
	mov r7, #0				@ Unlock Safe
	bal Main


RightBlack:
	mov r0,#0x01			@ Right LED on
	swi 0x201 				
	bl Blink
	cmp r7, #1
	beq Main
	cmp r4, #0				@ Checks the current stage, locked, unlocked, programn, etc
	bgt RightFirst					
	mov r0, #2
	bl Display8Segment		@ Displays P
	mov r0, #99				@ Reset r0 to non-blue key digit
	add r4, r4, #1			@ Add to Right counter
	bal ResetNumbers


RightFirst:					@ Right button first pressed 
	cmp r8, #4				@ Checks the current stage, locked, unlocked, programn, etc
	blt Less4 
	cmp r4, #2
	beq FinalPW
	cmp r4, #3
	beq FinalForget
	bl PWLoop
	cmp r5, #0
	beq NewPW
	cmp r5, #1
	beq ForgetPW
	
NewPW:
	bl HasPW				@ Checks to see if User has a password already 
	cmp r5, #1
	beq ContPW				@ Continue to create PW
	mov r10, #800			
	mov r0, #6
	bl Display8Segment		@ Displays Error Message
	bl Blink
	bal Main
	
ContPW:						@ Continue PW
	mov r0, #3
	bl Display8Segment		@ Displays C
	mov r0, #99
	mov r6, r3				@ save r3 to r6 
	add r4, r4, #1
	bal ResetNumbers
	
FinalPW:
	mov r10, #800				
	cmp r3, r6				@ Compares pw with pw 
	beq RightPW				
	mov r0, #6
	bl Display8Segment		@ Display Error Message 
	bl Blink
	bal Main


RightPW:
	mov r0, #5
	bl Display8Segment			 @ Displays A
	bl Blink
	ldr r1, =array		 		 @ Load the array address
    mov r2, r9, LSL #2      	 @ Multiply array index by 4 to get array offset
    add r2, r1, r2          	 @ Set r2 to element address pointer
    STR R3, [R2]            	 @ Store value in array[i]
	bal Main


ForgetPW:
	mov r0, #4
	bl Display8Segment			 @ Displays F
	mov r0, #99
	mov r6, r3				 	 @ Save r6 to r3 to compare 
	add r4, r4, #2
	bal ResetNumbers
	
FinalForget:
	mov r10, #800				 
	cmp r3, r6					 @ Compares pw with pw, if right or wrong 
	beq RightForget	
	mov r0, #6
	bl Display8Segment			 @ Display E for Error
	bl Blink
	bal Main


RightForget:
	mov r0, #5	
	bl Display8Segment			 @ Display A
	bl Blink
	mov r3, #0
	ldr r1, =array		 		 @ Load array address
    mov r2, r9, LSL #2       	 @ Multiply array index by 4 to get array offset
    add r2, r1, r2           	 @ Set r2 to element address pointer
    STR R3, [R2]             	 @ Store value in array[i]
	bal Main


ArrayLocation:
	stmfd sp!,{r0-r2,lr}		 @ Stores where you were
	mov r9, r1
	ldmfd sp!,{r0-r2,pc}		 @ Return to stored 


Blink:							 
	stmfd sp!,{r0-r2,lr}
	swi SWI_GetTicks
	mov r1, r0
	
WaitLoop:
	swi SWI_GetTicks
	subs r0, r0, r1
	cmp r0, r10
	blt WaitLoop
	mov r0, #0x00
	swi 0x201
	ldmfd sp!,{r0-r2,pc}
	
PWLoop:						@ Loop to check existing codes
	stmfd sp!,{r0-r2,lr}
	mov r5, #0
	
CLoop:
	cmp r5, #10                           @ check if end of array
	beq NotMatch                          @ exit loop if done
	ldr r1, =array                        @ Load array address
	mov r2, r5, LSL #2                    
	add r2, r1, r2                        @ Set R2 to element address
	ldr R1, [R2]                          
	cmp r3, R1
	beq IsMatch
	add r5, r5, #1                        @ Increment index
	b CLoop
	
NotMatch:	
	mov r5, #0								@ If no match, return 0 on r5
	ldmfd sp!,{r0-r2,pc}
	
IsMatch:
	mov r5, #1								@ If match, return 1 on r5
	ldmfd sp!,{r0-r2,pc}


HasPW:										@ Loop to see if slot for unique User has been filled already
	stmfd sp!,{r0-r2,lr}
	ldr R1, =array                         @ Load array address
	mov R2, R9, LSL #2                     
	add R2, R1, R2                         @ Set R2 to element address
	ldr R1, [R2]                           
	cmp R1, #0
	beq Empty
	
NotEmpty:	
	mov r5, #0								@ If no match, return 0 on r5
	ldmfd sp!,{r0-r2,pc}

Empty:
	mov r5, #1								@ If match, return 1 on r5
	ldmfd sp!,{r0-r2,pc}


CheckPrevPW:								@ Loop to check if any codes are saved, yes lock, no no lock
	stmfd sp!,{r0-r2,lr}
	mov r5, #0
	
CPPLoop:									@ Check Prev PW loop 
	cmp R5, #10                            @ check if end of array
	beq NotMatch                           @ exit loop if done
	ldr R1, =array                         @ Load array address
	mov R2, R5, LSL #2                     
	add R2, R1, R2                         @Set R2 to element address
	ldr R1, [R2]                           
	cmp r1, #0
	bne HavePW
	add R5, R5, #1                         ;increment index
	b CPPLoop
	
NoPW:	
	mov r5, #0			
	ldmfd sp!,{r0-r2,pc}
	
HavePW:
	mov r5, #1			
	ldmfd sp!,{r0-r2,pc}
	

.data
;.align 4
array: .skip 40


@========================================State Letters
Letters:
.word SEG_B|SEG_C|SEG_D|SEG_E|SEG_G|SEG_P		@0 = U
.word SEG_D|SEG_E|SEG_G|SEG_P 					@1 = L
.word SEG_A|SEG_B|SEG_E|SEG_F|SEG_G|SEG_P 		@2 = P
.word SEG_A|SEG_D|SEG_E|SEG_G|SEG_P	 			@3 = C
.word SEG_A|SEG_E|SEG_F|SEG_G|SEG_P	 			@4 = F
.word SEG_A|SEG_B|SEG_C|SEG_E|SEG_F|SEG_G|SEG_P	@5 = A
.word SEG_A|SEG_D|SEG_E|SEG_F|SEG_G|SEG_P 		@6 = E
.end
