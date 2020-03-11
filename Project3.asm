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
instruction2C		BYTE		"Enter Number: ",0
instruction2Fail	BYTE		"Not a valid number, please enter numbers in [-100, -1]",0

responseTotalNumA	BYTE		"You entered ",0
responseTotalNumB	BYTE		" valid numbers",0
responseSum		BYTE		"The sum of your valid numbers is ",0
responseAverage	BYTE		"The rounded average is ",0

programEnd		BYTE		"Thank you for playing Integer Accumulator! It's been a pleasure to meet you, ",0
period			BYTE		".",0

;Program Variables:
userName			BYTE		25 DUP(?)								;Variable to hold user's name, max of 24 characters (plus 0)
userNum			SDWORD	?									;Variable to hold the user's currently entered number
minNum			SDWORD	-101									;Min number for comparison
maxNum			SDWORD	0									;max number for comparison 
counter			SDWORD	0									;counter for total valid user numbers entered
sum				SDWORD	0									;Holder for sum 
average			SDWORD	0									;Holder for average


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

;Get the user number
getInt:
mov 		edx, offset instruction2C
call		writestring	
call		ReadInt
mov		userNum, eax											;store the entered value as the user number
jo		IntegerSizeFail										;check to make sure input is integer
cmp		eax, maxNum	
jge		DisplayResults											;check to make sure integer is less than the max number
cmp		eax, minNum
jle		IntegerSizeFail										;check to make sure integer is greater than the min number
jmp		Accumulator

IntegerSizeFail:												;If any checks fail, get the input again
mov 		edx, offset instruction2Fail
call		writestring	
call		crlf
jmp		getInt

Accumulator:
inc		counter												;increment counter to account for new valid user value

mov		eax, userNum											;get the user value
add		eax, sum												;add the sum to the user value
mov		sum, eax												;save the new sum

mov		eax, sum												;set up dividend
cdq															;extend eax into edx
mov		ebx, counter											;set up divisor
idiv		ebx													;divide the new sum by the counter to get the current average
mov		average, eax											;update the current average

jmp		getInt												;jump to get another user integer

DisplayResults:												;Display results if user enters a non-negative number
call		crlf
mov 		edx, offset responseTotalNumA								;display the counter as the total valid numbers
call		writestring
mov		eax, counter
call		writeint
mov 		edx, offset responseTotalNumB
call		writestring
call		crlf
mov 		edx, offset responseSum									;display the sum
call		writestring
mov		eax, sum
call		writeint
call		crlf
mov 		edx, offset responseAverage								;display the average
call		writestring
mov		eax, average
call		writeint

FAREWELL:
;Display closing messages of the program
call		crlf
mov 		edx, offset programEnd
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
