TITLE Project 6     (Project6.asm)

; Author: Kyle Dixon
; Last Modified: 11/28/2018
; OSU email address: dixonky@oregonstate.edu
; Course number/section: CS 271 400
; Project Number: 06                Due Date: 12/02/2018
; Description:
;	

INCLUDE Irvine32.inc

numMax = 9
numMin = 3

showString MACRO displayInfo	; Macro for showing string on output screen
push	edx 
mov		edx, offset displayInfo 
call	writestring
pop		edx

ENDM

.data
;Program Statements:
projectName		BYTE		"Combinations Calculator",0	
programmerName		BYTE		"Programmed by Kyle Dixon",0
instruction1A		BYTE		"Ill give you a combinations problem. You enter your answer,",0
instruction1B		BYTE		"and Ill let you know if youre right.",0
instructionFail	BYTE		"Invalid Input",0
space			BYTE		"   ",0
period			BYTE		".",0
question1			BYTE		"Problem: ",0
question2			BYTE		"Number of elements in the set: ",0
question3			BYTE		"Number of elements to choose from the set: ",0
question4			BYTE		"How many ways can you choose?: ",0
answer1			BYTE		"There are ",0
answer2			BYTE		" combinations of ",0
answer3			BYTE		" items from a set of ",0
questionFail		BYTE		"You need more practice...",0
questionCorrect	BYTE		"Correct!",0
restart			BYTE		"Another problem? (y/n): ",0
programEnd		BYTE		"Results certified by Kyle Dixon. Goodbye.",0

;Program Variables:
eleSet			DWORD	?			;holder for element number in the set
eleCho			DWORD	?			;holder for element number to choose 
continueFlag		DWORD	?			;flag that checks to loop the program
answerUser		BYTE		10 DUP(?)		;holder for user answer
answerContinue		BYTE		10 DUP(?)		;holder for user answer
answerUserNum		DWORD	?
answerCorr		DWORD	?			;holder for correct answer

.code

MAIN		PROC						;Main procedure of program
call		INTRODUCTION				
call		RANDOMIZE					;seeds the generator
AGAIN:
push		offset eleCho				
push		offset eleSet
call		SHOWPROBLEM
push		offset answerUserNum
push		offset answerUser
call		GETDATA	
push		eleCho				
push		eleSet
push		offset answerCorr
call		COMBINATIONS
push		eleCho				
push		eleSet
push		answerCorr
push		answerUserNum
call		SHOWRESULTS
push		offset answerUserNum
push		offset continueFlag
call		CONTINUE
mov		eax, continueFlag
cmp		eax, 0
jne		AGAIN
call		FAREWELL					
exit

main	ENDP


;INTRODUCTION***********************************************************
;Description:	Displays the program and programmer name
;Receives: None
;Returns: None
;Preconditions: None
;RegistersChanged: None
;***********************************************************************

INTRODUCTION	PROC				
pushad

showString projectName									
call		crlf
showString programmerName
call		crlf
call		crlf
showString instruction1A
call		crlf
showString instruction1B	
call		crlf
call		crlf

popad
ret
INTRODUCTION	ENDP


;SHOWPROBLEM*******************************************************
;Description: Generates two random numbers and prints the numbers
;Receives: EleSet and EleNum integer holders
;Returns: EleSet and EleNum with random generated numbers
;Preconditions: EleSet and EleNum integer holders
;RegistersChanged: EAX, EBX, ECX
;********************************************************************

SHOWPROBLEM 	PROC	
push		ebp						;save previous base pointer
mov		ebp, esp					;set up pointer at top of stack
mov		ecx, [ebp + 12]			;move the location of eleCho into ecx
mov		ebx, [ebp + 8]				;move the location of eleSet into ebx
mov		eax, numMax				;set eax as the high number for the random number generator
call		RandomRange				;generate a random number 0-9 and save in eax
add		eax, numMin				;make the random number 3-12
mov		[ebx], eax				;save the value into eleSet
dec		eax						;decrease eax to make it one less than the total element number
call		RandomRange				;generate a random number from 0 to one less than the total element number
inc		eax						;increment the random number to make it range from 1 to the total element number
mov		[ecx], eax				;save the value into eleCho
showString question1				;Display question with corresponding values
call		crlf
showString question2
mov		eax, [ebx]
call		writedec
call		crlf
showString question3
mov		eax, [ecx]
call		writedec
call		crlf
pop		ebp						;return previous base pointer
ret		12
SHOWPROBLEM ENDP


;GETDATA*******************************************************
;Description:Gets the user number and performs input validation
;Receives: None
;Returns: NONE
;Preconditions: answerUser & answerUserNum must exist to hold integers
;RegistersChanged: EAX, EBX, ECX, EDX, ESI
;**************************************************************

GETDATA	PROC						;Get the user number
push		ebp						;save previous base pointer
mov		ebp, esp					;set up pointer at top of stack

GETINPUT:
showString question4
mov		edx, [ebp+8]				;set up holder for intial input
mov		ecx, 10					;set max number of input spaces
call		ReadString				;get the input as an array of characters (string)
jmp		Validate					

IntegerSizeFail:					
showString instructionFail	
call		crlf
jmp		GETINPUT

Validate:
mov		ecx, eax					;move the number of characters into ecx to serve as the loop counter
mov		esi, [ebp+8]				;set up the pointer to go through the input array
cld								;clear the direction flag
mov		edx, 0					;clear edx

CHECK:
lodsb							;load the character at esi into al
cmp		al, 57					;compare the character to 57 which is the max number corresponding to an integer character
ja		IntegerSizeFail
cmp		al, 48					;compare the character to 48 which is the min number corresponding to an integer character
jb		IntegerSizeFail
movzx	eax, al					;if al passes the checks than move it into eax with zeros extended
push		ecx						;put the loop counter in the stack
mov		ecx, eax					;set up eax as the position of the character in the array
mov		ebx, 10
mov		eax, edx
mul		ebx						;multiply to change the position in the character array to a factorial of 10 (i.e. position 3 = 10*10*10)
mov		edx, eax
sub		ecx, 48					;subtract the character by 48 to change the character into an integer
add		edx, ecx					;add the integer to the position (now a factor of 10) to remove the array memory
pop		ecx						;put the loop counter back into ecx
loop		CHECK					;loop through the character array, changing each character into an integer

mov		ebx, [ebp+12]				;save the location of answerUserNum in edx
mov		[ebx], edx				;save the integers as the answerUserNum

pop		ebp						;restore the previous base pointer
ret		8
GETDATA	ENDP


;COMBINATIONS*******************************************************
;Description:Calculates EleSet Choose EleNum and stores answer
;Receives: EleSet, EleNum, & AnswerCorr on the stack
;Returns: None
;Preconditions: EleSet & EleNum must contain integers & AnswerCorr must exist
;RegistersChanged: EAX, EBX, ECX, EDX
;********************************************************************

COMBINATIONS	PROC	
push		ebp						;save previous base pointer
mov		ebp, esp					;set up pointer at top of stack
mov		ebx, [ebp+16]				;move eleCho into ebx
mov		eax, [ebp+12]				;move eleSet into eax
cmp		eax, ebx
je		EQUAL

mov		ebx, [ebp+16]				;set up eleCho for factorial
push		ebx						;save copies of the ele values on the stack
push		eax
call		factorial					;r!
mov		ecx, ebx					;move the factorial of eleCho into ecx
pop		eax						;get the ele values back from the stack
pop		ebx
mov		eax, [ebp+12]				;set up to send eleSet - eleCho to factorial
push		eax
sub		eax, ebx					;eleSet - eleCho
mov		ebx, eax					;send eleSet - eleCho to factorial via ebx
call		factorial					;(n-r)!
mov		eax, ebx					;set up to multiply the two factorials together
mul		ecx						;(n-r)! * r!
mov		ecx, eax					;save the result in ecx to later use as divisor
pop		ebx						;Get eleSet off of the stack and send to factorial via ebx
call		factorial					;n!
mov		eax, edx					;set up to divide the factorial by ecx
mov		edx, 0					
mov		eax, ebx
div		ecx						;n! / (n-r)! * r!
mov		ebx, [ebp+8]				;save the location of answerCorr in edx
mov		[ebx], eax				;save the integers as the answerCorr

jmp		DONE

EQUAL:
mov		ecx, [ebp+8]				;if eleSet and eleCho are equal then there is only one answer
mov		ebx, 1
mov		[ecx], ebx
DONE:
pop		ebp
ret		12
COMBINATIONS ENDP


;FACTORIAL*******************************************************
;Description:Runs recursion to calculate the factorial of the value in EBX
;Receives: The initial value in EBX, EAX holds the current term
;Returns: The factorial in EBX
;Preconditions: EBX holds the initial value for factorial
;RegistersChanged: EAX, EBX, EDX
;********************************************************************

FACTORIAL	PROC	
mov		eax, ebx					;move the initial value into eax (ebx now serves as the running total)
FACTOR:
cmp		eax,1					;compare the current term to one to see if the factorial is over
jle		DONE
dec		eax						
push		eax						;save a copy of the now decreased new term
mul		ebx						;multiply the new term by the running total saved in ebx
mov		ebx, eax					;save the new running total in ebx
pop		eax						;get the new term off of the stack
call		FACTOR					;run recursion
DONE:
ret		
FACTORIAL ENDP


;SHOWRESULTS*******************************************************
;Description: Prints out the values with string labels, compares user and correct answers
;Receives: EleSet, EleNum, AnswerCorr, & AnswerUser on the stack
;Returns: None
;Preconditions: EleSet, EleNum, AnswerCorr, & AnswerUser on the stack
;RegistersChanged: None
;******************************************************************

SHOWRESULTS	PROC
push		ebp
mov		ebp, esp
mov		ebx, [ebp+20]				;save the eleCho in ecx
mov		ecx, [ebp+16]				;save the eleSet in ecx
mov		esi, [ebp+12]				;save the correct answer in esi
mov		edx, [ebp+8]				;save the user answer in edx
call		crlf

showString answer1
mov		eax, esi
call		writedec

showString answer2
mov		eax, ebx
call		writedec

showString answer3
mov		eax, ecx
call		writedec
call		crlf

cmp		esi, edx					;compare the correct answer and the user answer, jump to according response
jne		INCORRECT
jmp		CORRECT

CORRECT:
showString questionCorrect
jmp		DONE

INCORRECT:
showString questionFail
jmp		DONE

DONE:
pop		ebp
ret		24		
SHOWRESULTS ENDP


;CONTINUE***************************************************************
;Description: Asks user for char response, verifies response, sets continue flag
;Receives: continueFlag in the stack
;Returns: None
;Preconditions: continueFlag in the stack
;RegistersChanged: EAX, EBX, ECX, ESI
;***********************************************************************

CONTINUE	PROC						;Display closing messages of the program
push		ebp
mov		ebp, esp
call		crlf
call		crlf

GETINPUT2:
showString restart
mov		edx, [ebp+8]				;set up holder for intial input
mov		ecx, 10					;set max number of input spaces
call		ReadString				;get the input as an array of characters (string)
jmp		Validate2					

IntegerSizeFail2:					
showString instructionFail	
call		crlf
jmp		GETINPUT2

Validate2:
mov		esi, [ebp+8]				;set up the pointer to go through the input array
cld								;clear the direction flag
mov		edx, 0					;clear edx

lodsb							;load the character at esi into al
cmp		al, 78					;compare the character to 78 (N)
je		SETFLAG
cmp		al, 110					;compare the character to 110 (n)
je		SETFLAG
cmp		al, 89					;compare the character to 89 (Y)
je		SETFLAG1
cmp		al, 121					;compare the character to 121 (y)
je		SETFLAG1
jmp		IntegerSizeFail2

SETFLAG:							;sets continueFlag to 0 to represent the user wanting to quit the program
mov		ecx,[ebp+8]
mov		ebx, 0
mov		[ecx], ebx
jmp		DONE

SETFLAG1:							;sets the continueFlag to 1 which represents continuing the program
mov		ecx,[ebp+8]
mov		ebx, 1
mov		[ecx], ebx
jmp		DONE

DONE:
call		crlf
pop		ebp
ret		8	
CONTINUE	ENDP


;FAREWELL***************************************************************
;Description: Displays the closing message of the program
;Receives: None
;Returns: None
;Preconditions: None
;RegistersChanged: None
;***********************************************************************

FAREWELL	PROC						;Display closing messages of the program
pushad
call		crlf
mov 		edx, offset programEnd
call		writestring
call		crlf
call		crlf
popad
ret
FAREWELL	ENDP

END main
