TITLE Project 4     (Project4.asm)

; Author: Kyle Dixon
; Last Modified: 10/25/2018
; OSU email address: dixonky@oregonstate.edu
; Course number/section: CS 271 400
; Project Number: 04                Due Date: 11/04/2018
; Description: 
	;a program to calculate composite numbers. 
	;First, the user is instructed to enter the number of composites to be displayed, and is prompted to enter an integer in the range [1 .. 400]. 
	;The user enters a number, n, and the program verifies that 0 < n < 401. 
	;If n is out of range, the user is re-prompted until they enters a value in the specified range. 
	;The program then calculates and displays all of the composite numbers up to and including the nth composite. 
	;The results should be displayed 10 composites per line with at least 3 spaces between the numbers.

INCLUDE Irvine32.inc

.data
;Program Statements:
projectName		BYTE		"Composite Numbers",0	
programmerName		BYTE		"Programmed by Kyle Dixon",0
instruction2A		BYTE		"Enter the number of composite numbers you would like to see.",0
instruction2B		BYTE		"I will accept orders for up to 400 composites.",0
instruction2C		BYTE		"Enter the number of composites to display [1 .. 400]: ",0
instruction2Fail	BYTE		"Out of range. Try again.",0
space			BYTE		"   ",0
tester			BYTE		"test",0

programEnd		BYTE		"Results certified by Kyle Dixon. Goodbye.",0

;Program Variables:
userNum			DWORD	?									;Variable to hold the user's currently entered number
minNum			DWORD	0									;Min number for comparison
maxNum			DWORD	401									;max number for comparison 
term				DWORD	2									;Holder
counter			DWORD	0									;counter for 10th printing sequence 
divisorValue		DWORD	?
max				DWORD	?

.code

MAIN		PROC						;Main procedure of program
   push 4
   push 7
   call rcrsn
   exit
main ENDP

rcrsn PROC
   push ebp
   mov ebp,esp
   mov eax,[ebp + 12]
   mov ebx,[ebp + 8]
   cmp eax,ebx
   jl recurse
   jmp quit
recurse:
   inc eax
   push eax
   push ebx
   call rcrsn
   mov eax,[ebp + 12]
   call WriteDec
quit:
   pop ebp
   ret 8
rcrsn ENDP

END main
