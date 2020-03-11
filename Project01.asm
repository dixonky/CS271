TITLE Project One    (Project01.asm)

; Author: Kyle Dixon
; Last Modified: 10/2/18
; OSU email address: dixonky@oregonstate.edu
; Course number/section: CS 271 400
; Project Number: 01              Due Date: 10/7/18
; Description: Write and test a MASM program to perform the following tasks:
;	1. Display your name and program title on the output screen.
;	2. Display instructions for the user.
;	3. Prompt the user to enter two numbers.
;	4. Calculate the sum, difference, product, (integer) quotient and remainder of the numbers.
;	5. Display a terminating message.

INCLUDE Irvine32.inc

; (insert constant definitions here)

.data
pName		BYTE		"Elementary Arithmetic          by Kyle Dixon",0				
instruc1		BYTE		"Enter 2 numbers, and I'll show you the sum, ",0
instruc2		BYTE		"difference, product, quotient, and remainder.",0			
fNum			BYTE		"First Number: ",0
sNum			BYTE		"Second Number: ",0
gbye			BYTE		"Impressed? BYE!",0

equalSign		BYTE		" = ",0
sumSign		BYTE		" + ",0
diffSign		BYTE		" - ",0
productSign	BYTE		" * ",0
quotientSign	BYTE		" / ",0
remainderSign	BYTE		" remainder ",0

val1			DWORD	?					;create a variable to hold the first user entry
val2			DWORD	?					;create a variable to hold the second user entry
sum			DWORD	?					;sum will hold the sum of val1 and val2
diff			DWORD	?					;diff will be the difference of val1 minus val2
product		DWORD	?					;product will be the product of val1 and val2
quotient		DWORD	?					;quotient will be the quotient of val1 divided by val2
remainder		DWORD	?					;remainder will be the remainder of the division of val1 by val2


.code
main PROC

;INTRODUCTION
;Display name and program title
mov 		edx, offset pName
call		writestring
call		crlf
call		crlf

;Display instructions
mov 		edx, offset instruc1
call		writestring	
call		crlf
mov 		edx, offset instruc2
call		writestring	
call		crlf

;GET DATA			
;Prompt for val1
mov 		edx, offset fNum
call		writestring	
call		ReadDec
mov		val1, eax
				
;Prompt for val2
mov 		edx, offset sNum
call		writestring
call		ReadDec
mov		val2, eax

;CALCULATE			
;calculate sum
mov		eax, val1
add		eax, val2
mov		sum, eax	
				
;calculate diff
mov		eax, val1
sub		eax, val2
mov		diff, eax
				
;calculate product				
mov		eax, val1
mov		ebx, val2
mul		ebx
mov		product, eax
				
;calculate quotient and remainder				
mov		edx, 0
mov		eax, val1
cdq
mov		ebx, val2
cdq
div		ebx
mov		quotient, eax
mov		remainder, edx				

;DISPLAY			
;Display the sum
mov		eax, val1
call		WriteDec
mov		edx, OFFSET sumSign
call		WriteString
mov		eax, val2
call		WriteDec
mov		edx, OFFSET equalSign
call		WriteString
mov		eax, sum
call		WriteDec
call		CrLf
				
;Display the difference
mov		eax, val1
call		WriteDec
mov		edx, OFFSET diffSign
call		WriteString
mov		eax, val2
call		WriteDec
mov		edx, OFFSET equalSign
call		WriteString
mov		eax, diff
call		WriteDec
call		CrLf
				
;Display the product
mov		eax, val1
call		WriteDec
mov		edx, OFFSET productSign
call		WriteString
mov		eax, val2
call		WriteDec
mov		edx, OFFSET equalSign
call		WriteString
mov		eax, product
call		WriteDec
call		CrLf
				
;Display the quotient
mov		eax, val1
call		WriteDec
mov		edx, OFFSET quotientSign
call		WriteString
mov		eax, val2
call		WriteDec
mov		edx, OFFSET equalSign
call		WriteString
mov		eax, quotient
call		WriteDec
mov		edx, OFFSET remainderSign
call		WriteString
mov		eax, remainder
call		WriteDec
call		CrLf

;GOODBYE				
;Display goodbye message
mov 		edx, offset gbye
call		writestring
call		crlf				
				

; (insert executable instructions here)

exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
