TITLE Project 5     (Project5.asm)

; Author: Kyle Dixon
; Last Modified: 11/11/2018
; OSU email address: dixonky@oregonstate.edu
; Course number/section: CS 271 400
; Project Number: 05                Due Date: 11/18/2018
; Description:
;	1.Introduce the program.
;	2.Get a user request in the range [min = 10 .. max = 200].
;	3.Generate request random integers in the range [lo = 100 .. hi = 999], storing them in consecutive elementsof an array.
;	4.Display the list of integers before sorting, 10 numbers per line.
;	5.Sort the list in descending order (i.e., largest first).
;	6.Calculate and display the median value, rounded to the nearest integer.
;	7.Display the sorted list, 10 numbers per line.

INCLUDE Irvine32.inc

.data
;Program Statements:
projectName		BYTE		"Sorting Random Integers",0	
programmerName		BYTE		"Programmed by Kyle Dixon",0
instruction1A		BYTE		"This program generates random numbers in the range [100 .. 999],",0
instruction1B		BYTE		"displays the original list, sorts the list, and calculates the",0
instruction1C		BYTE		"median value. Finally, it displays the list sorted in descending order.",0
instruction2		BYTE		"How many numbers should be generated? [10 .. 200]: ",0
instruction2Fail	BYTE		"Invalid Input",0
space			BYTE		"   ",0
title1			BYTE		"The unsorted random numbers: ",0
label1			BYTE		"The median is ",0
title2			BYTE		"The sorted list: ",0

programEnd		BYTE		"Results certified by Kyle Dixon. Goodbye.",0

;Program Variables:
min				equ		10			;Min number for comparison
max				equ		200			;max number for comparison 
lo				equ		100			;min number for random num generation
hi				equ		900			;max number for random num generation
list				DWORD	max DUP(?)	;empty array of integers with space for 200 elements

.code
;INTRODUCTION***********************************************************
;Description:	Displays the program and programmer name
;Receives: None
;Returns: None
;Preconditions: None
;RegistersChanged: None
;***********************************************************************

INTRODUCTION	PROC					;Display project and programmer
pushad
mov 		edx, offset projectName									
call		writestring
call		crlf
mov 		edx, offset programmerName
call		writestring
call		crlf
call		crlf

mov 		edx, offset instruction1A	;Display instruction to get user number
call		writestring	
call		crlf
mov 		edx, offset instruction1B
call		writestring	
call		crlf
mov 		edx, offset instruction1C
call		writestring	
call		crlf
call		crlf
popad
ret
INTRODUCTION	ENDP

;GETDATA*******************************************************
;Description:Gets the user number and performs input validation
;Receives: None
;Returns: Array element number (request) on stack
;Preconditions: None
;RegistersChanged: None
;**************************************************************

GETDATA	PROC						;Get the user number
pop		ebx						;save the return address from the stack into ebx
mov		eax, 0
mov 		edx, offset instruction2
call		writestring	
call		ReadDec
jmp		Validate					;jump to validate the user number

IntegerSizeFail:					;If any checks fail, get the input again
mov 		edx, offset instruction2Fail
call		writestring	
call		crlf
jmp		GETDATA

Validate:
jo		IntegerSizeFail			;check to make sure input is integer
cmp		eax, max	
jg		IntegerSizeFail			;check to make sure integer is less than the max number
cmp		eax, min
jl		IntegerSizeFail			;check to make sure integer is greater than the min number
push		eax						;save the array element number on the stack
push		ebx						;place return address back on stack
ret		
GETDATA	ENDP

;FILLARRAY*******************************************************
;Description:Creates an array filled with random numbers
;Receives: Request, Array
;Returns: Request, Array
;Preconditions: Stack with array address and array element number
;RegistersChanged: None
;****************************************************************

FILLARRAY	PROC
pop		ebx						;take return address out of stack and save in ebx
pop		esi						;take array address out of stack and save in esi
mov		ecx, 0					;clear ecx to serve as a counter

LOOP2:	
mov		eax, hi					;set eax as the high number for the random number generator
call		RandomRange				;generate a random number 0-899 and save in eax
add		eax, lo					;make the random number 100-999
mov		[esi+4*ecx], eax			;save the value in the array element according to the counter in ecx
inc		ecx						;increment the counter
pop		eax						;get the array element number from the stack and save in eax
cmp		ecx, eax					;compare the counter to the number of array elements
push		eax						;save the array element number back on the stack
jl		Loop2					;do the loop again if they are not equal
push		esi						;save the array address back on the stack
push		ebx						;save the return address back on the stack
ret
FILLARRAY ENDP

;SORTLIST*******************************************************
;Description:sorts the values in the array by descending order
;Receives: Request, Array
;Returns: Request, Array
;Preconditions: Stack with array address and array element number
;RegistersChanged: None
;***************************************************************

SORTLIST	PROC	
pop		ebx						;take the return address off of the stack and save in ebx
pop		esi						;take the array address off of the stack and save in esi
pop		ecx						;take the array element number off of the stack and save in ecx
mov		eax,4					;set up eax for multiplication to change element number into byte number
mul		ecx						;get byte number in eax
push		ecx						;put the total element number back on the stack
sub		esi, eax					;subtract the byte number from the array address to point it back at the first element in the array
mov		ecx, 0					;clear registers
mov		edx, 0
pop		eax						;take the total element number from the stack
push		ebx						;put the return address on the stack

OuterLoop:
mov		edx, ecx					;set up edx to be the inner loop counter

InnerLoop:
cmp		edx, eax					;compare the loop counter to the total element number
jge		Exchange					;exchange the elements after each inner loop cycle
inc		edx						
mov		ebx, [esi+4*ecx]			;move the value at the array address corresponding to ecx into ebx
cmp		[esi+4*edx], ebx			;compare the value in ebx (old array value) to the new array value via the address at edx
jle		InnerLoop					;if ebx is greater or even than get the next array value
mov		ebx, [esi+4*edx]			;if ebx is less, exchange the values in the pointers
xchg		[esi+4*ecx], ebx
mov		[esi+4*edx], ebx
jmp		InnerLoop

Exchange:		
xchg		[esi+4*ecx], ebx			;saves the largest found value into the array element in question
xchg		[esi+4*edx], ebx
inc		ecx						;increase outer loop counter
cmp		ecx, eax					;compare the outer loop counter to the total element number
je		EndofList
jmp		OuterLoop					;continue after swapping the values

EndOfList:
pop		ebx
push		eax						;put the total element number back on the stack
push		esi						;put the array address back on the stack
push		ebx						;put the return address back on the stack
ret
SORTLIST ENDP

;DISPLAYMEDIAN*******************************************************
;Description:displays the median value in the array
;Receives: Request, Array
;Returns: Request, Array
;Preconditions: Stack with array address and array element number
;RegistersChanged: None
;********************************************************************

DISPLAYMEDIAN	PROC	
pop		ecx						;get the return address from the stack
pop		esi						;get the array address from the stack
pop		ebx						;get the total element number from the stack
test		ebx, 1					;see if the total element number is even or odd
JZ		EvenNum


OddNum:
push		ecx						;save the return address on the stack
push		ebx						;save the total element number on the stack
mov		eax, ebx					;set up to divide the element number in half
mov		ebx, 2					
mov		edx, 0
div		ebx						;divide total element number in half
mov		edx, eax					;convert half the total element number to bytes to find the address location of the median value
mov		eax, 4
mul		edx
mov		eax, [esi+eax]				;save the value at the halfway element
jmp		Print 

EvenNum:
push		ecx						;save the return address on the stack
mov		eax, 2					;set up to get the address of the first middle element value
mul		ebx						
push		ebx						;save the total element number back on the stack
mov		ebx, [esi+eax]				;save the value at the first middle element
sub		eax, 4					;subtract 4 to get the previous element from the halfway element (as the array is even they are both halfway)
mov		eax, [esi+eax]				;save the second value in eax			
add		eax, ebx					;add the two terms together and save in eax
mov		ebx, 2					;set up division
mov		edx, 0
div		ebx						;divide ebx by 2 to get the value in between the two halfway elements
jmp		Print

Print:
call		crlf	
call		crlf	
mov		edx, offset label1			;print the median label followed by the calculated median
call		writestring
call		writedec
pop		ebx						;get the total element number off of the stack
pop		ecx						;get the return address off of the stack
call		crlf
push		ebx						;put the total element number on the stack
push		esi						;put the the array address on the stack
push		ecx						;put the return address on the stack
ret
DISPLAYMEDIAN ENDP


;DISPLAYLIST*******************************************************
;Description:displays the values in the array
;Receives: Request, Array, Title
;Returns: Request, Array
;Preconditions: Stack with array address, array element number, and title
;RegistersChanged: None
;******************************************************************

DISPLAYLIST	PROC
pop		ebx						;save return address from stack
pop		edx						;save title from stack
pop		esi						;save array pointer from stack
mov		ecx,0					;reset the register which will be used as a counter
call		crlf
call		writestring
call		crlf
push		ebx						;put the return address back on the stack
mov		edx, 0					;set the new line counter to zero
push		edx						;save the new line counter on the stack

PrintLoop:
mov		eax, [esi]				;move the value of the array element at element number ecx into eax
call		writedec
add		esi,4					;move the pointer to the next element
mov		edx, offset space			;add a spacer
call		writestring
pop		edx						;get the new line counter off of the stack
mov		ebx, edx
inc		ebx						;increment the new line counter
mov		edx, ebx
cmp		ebx,10					;compare the counter to 10 to see if there needs to be a new printed line
jge		newline
jmp		noAction

newline:
call		crlf						;if the values are even then print out a new line and reset the printing line counter
mov		edx,0
inc		ecx
jmp		loopend

noAction:
inc		ecx						;increment the counter register
jmp		loopend

loopend:
pop		ebx						;get the return address from the stack
pop		eax						;get the total element number from the stack
cmp		ecx, eax					;compare the counter with the array element number
push		eax						;put the array element number back on the stack
push		ebx						;put the return address back on the stack
push		edx						;put the new line counter on the stack
jl		PrintLoop					;if the counter is less than get the next element's value
pop		edx						;get the new line counter off of the stack
pop		ebx						;get the return address off of the stack
push		esi						;put the array address back on the stack
push		ebx						;put the return address back on the stack

ret				
DISPLAYLIST ENDP

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
call		crlf
mov 		edx, offset programEnd
call		writestring
call		crlf
call		crlf
popad
ret
FAREWELL	ENDP

;***********************************************************************
;Description: Main program of the composite number project

MAIN		PROC						;Main procedure of program
call		INTRODUCTION				
call		RANDOMIZE					;seeds the generator
call		GETDATA					;get the number of random integers wanted
push		offset list				;save the array address on the stack
call		FILLARRAY					;fill the array with random numbers according to user specifications
mov		edx, offset title1
push		edx
call		DISPLAYLIST				;display the unsorted list
call		SORTLIST
call		DISPLAYMEDIAN
mov		edx, offset title2
push		edx
call		DISPLAYLIST				;display the sorted list
call		FAREWELL					
exit

main	ENDP
END main

