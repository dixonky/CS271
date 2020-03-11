TITLE Project 3     (Project3.asm)

; Author: Kyle Dixon
; Last Modified: 10/22/2018
; OSU email address: dixonky@oregonstate.edu
; Course number/section: CS 271 400
; Project Number: 03                Due Date: 10/28/2018
; Description: 
	;1. Display the program title and programmer’s name.
	;2. Get the user’s name, and greet the user.
	;3. Display instructions for the user.
	;4. Repeatedly prompt the user to enter a number. Validate the user input to be in [-100, -1] (inclusive). Count and accumulate the valid user numbers until a non-negative number is entered. (The non-negative number is discarded.)
	;5. Calculate the (rounded integer) average of the negative numbers.
	;6. Display:
		;i. the number of negative numbers entered (Note: if no negative numbers were entered, display a special message and skip to iv.)
		;ii. the sum of negative numbers entered
		;iii. the average, rounded to the nearest integer (e.g. -20.5 rounds to -20)
		;iv. a parting message (with the user’s name)

INCLUDE Irvine32.inc

.data
;Program Statements:
projectName		BYTE		"Welcome to the Integer Accumulator",0	
programmerName		BYTE		"Programmed by Kyle Dixon",0
instruction1		BYTE		"What's your name?",0
userNameResponse	BYTE		"Hello, ",0
instruction2A		BYTE		"Please enter numbers in [-100, -1]",0
instruction2B		BYTE		"Enter a non-negative number when you are finished to see results.",0
instruction2c		BYTE		"Enter Number: ",0

responseTotalNumA	BYTE		"You entered ",0
responseTotalNumB	BYTE		" valid numbers",0
responseSum		BYTE		"The sum of your valid numbers is ",0
responseAverage	BYTE		"The rounded average is ",0

programEnd		BYTE		"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ",0
period			BYTE		".",0

;Program Variables:
userName			BYTE		25 DUP(?)								;Variable to hold user's name, max of 24 characters (plus 0)
userNum			DWORD	?									;Variable to hold the user's number of fib numbers
maxNum			DWORD	46									;Max number of fib numbers for comparison
minNum			DWORD	0									;Min number of fib numbers for comparison	
termOne			DWORD	1									;Holder for fib sequence
termTwo			DWORD	1									;Holder for fib sequence
sum				DWORD	?									;Holder for fib sequence
counter			DWORD	1									;counter for fifth printing sequence 

.code
main PROC

INTRODUCTION:
;Display project and programmer
mov 		edx, offset projectName
call		writestring
call		crlf
mov 		edx, offset programmerName
call		writestring
call		crlf
call		crlf

USERINSTRUCTIONS:
;Display instruction to get user name
mov 		edx, offset instruction1
call		writestring	
call		crlf

GETUSERDATA:
;Get the user name
mov		edx, offset userName
mov		ecx, 25
call		ReadString

;Address the user by their name
mov		edx, offset userNameResponse
call		writestring
mov		edx, offset userName
call		writestring
call		crlf

;Display instruction to get user number
mov 		edx, offset instruction2A
call		writestring	
call		crlf
mov 		edx, offset instruction2B
call		writestring	
call		crlf
call		crlf
mov 		edx, offset instruction2C
call		writestring	
call		crlf

;Get the user number
getInt:
call		ReadInt
jo		IntegerSizeFail										;check to make sure input is integer
cmp		eax, maxNum	
jg		IntegerSizeFail										;check to make sure integer is less than the max number
cmp		eax, minNum
jle		IntegerSizeFail										;check to make sure integer is greater than the min number
jmp		InputPass

IntegerSizeFail:												;If any checks fail, get the input again
mov 		edx, offset instruction2Fail
call		writestring	
call		crlf
jmp		getInt

InputPass:													;Continue if the checks pass

DISPLAYFIBS:
sub		eax, 1												;subtract one from the user number to account for first fib sequence not being part of the loop
mov		userNum, eax
mov		ecx, userNum											;move the new user number to the counter
mov		eax, termOne											;Display the first number of the sequence
call		writedec
mov 		edx, offset space
call		writestring

FibSequence:
mov		eax, termOne											;Display the current fib sequence term
call		writedec
mov 		edx, offset space										;Display a spacer (5 space characters)
call		writestring

mov		eax, termOne											
add		eax, termTwo											;Add the previous sequence term to the current term
mov		sum, eax												;save the sum
mov		eax, termOne
mov		termTwo, eax											;save the current term in the previous term space
mov		eax, sum	
mov		termOne, eax											;save the sum as the new current fib sequence term
inc		counter												;Add one to the counter
cmp		counter, 5
je		Equal												;When the counter is 5 jump to a special sequence

NotEqual:														;Do nothing (but loop) when counter is not five
loop FibSequence

Equal:														;when the counter is 5 add a new line to the output screen and reset the counter (and loop)
call		crlf
mov		counter, 0
loop FibSequence

FAREWELL:
;Display closing messages of the program
call		crlf
mov 		edx, offset programEnd
call		writestring
call		crlf
mov 		edx, offset goodbye
call		writestring
mov		edx, offset userName
call		writestring
mov		edx, offset period
call		writestring
call		crlf
call		crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
