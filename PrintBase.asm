; Prints number in binary
; Expects:	number in r8
;			1-byte buffer called BUFF
;			1 in rax
;			1 in rdi
; Uses:		rcx, esi, r8, r9, r10
; Leaves:	...

printBin:
		xor rdx, rdx
		mov rsi, BUFF + 63d
.next_digit:
		mov r10, r8
		and r10, 1b
		shr r8, 1d

		add r10, '0'					; Now in r11 '0' or '1'
		mov [esi], r10b					; Placing lowest byte to buff
		dec rsi
		inc rdx

		cmp r8, 0
		jne .next_digit

		inc rsi
		mov rax, 1
		mov rdi, 1
		syscall

		ret

; ======================================

; Prints number in octal
; Expects:	number in r8
;			64-byte buffer called BUFF
;			1 in rax
;			1 in rdi
; Uses:		rcx, esi, r8, r9, r10
; Leaves:	...

printOct:
		xor rdx, rdx
		mov rsi, BUFF + 63d
.next_digit:
		mov r10, r8
		and r10, 111b
		shr r8, 3d

		add r10, '0'					; Now in r10 '0'-'7'
		mov [rsi], r10b					; Placing lowest byte to buff
		dec rsi
		inc rdx

		cmp r8, 0
		jne .next_digit

		inc rsi

		mov rax, 1
		mov rdi, 1
		syscall

		ret

; =======================================

; Prints number in hex
; Expects:	number in r8
;			1-byte buffer called BUFF
;			1 in rax
;			1 in rdx
;			1 in rdi
; Uses:		rcx, esi, r8, r9, r10
; Leaves:	...

printHex:
		xor rdx, rdx
		mov esi, BUFF + 63d
.next_digit:
		mov r10, r8
		and r10, 1111b
		shr r8,  4d

		cmp r10, 9d
		jbe .just_digit
		add r10, 7d
.just_digit:
		add r10, '0'

		mov [esi], r10b					; Placing lowest byte to buff
		dec esi
		inc rdx

		cmp r8, 0
		jne .next_digit

		inc rsi
		mov rax, 1
		mov rdi, 1
		syscall

		ret

; ======================================

; Prints number in decimal
; Expects:	number in r8
;			1 in rdi
;			1-byte buffer called BUFF
; Uses:		rcx, rdx, esi, r8, r9, r10
; Leaves:	...

printDec:
		xor r9, r9
		mov r10, 10d
		mov esi, BUFF + 63
.next_digit:
		mov rax, r8
		xor rdx, rdx
		div r10
		mov r8, rax

		add rdx, '0'					; Now in rdx '0' - '9'
		mov [rsi], dl					; Placing remainder to buff
		dec esi
		inc r9

		cmp r8, 0
		jne .next_digit
		
		inc rsi
		mov rdx, r9
		mov rax, 1d
		mov rdi, 1d
		syscall
		
		ret

; ======================================

; Prints char
; Expects:	char in r8
;			1 in rax
;			1 in rdx
;			1 in rdi
; Uses:		rcx, rsi, r8
; Leaves:	...

printChr:
		mov byte [BUFF], r8b			; Placing char to buffer
		
		mov rax, 1
		mov rdi, 1
		mov rsi, BUFF
		mov rdx, 1
		syscall

		ret

; ======================================

; Prints string
; Expects:	pointer to str in r8
;			1 in rax
;			1 in rdx
;			1 in rdi
; Uses:		rcx, rsi, r8
; Leaves:	...

printStr:
		mov rax, 1
		mov rdi, 1
		mov rsi, r8
		mov rdx, 1
.next:									; Kinda like infinite 'while'
		cmp byte [rsi], 0
		je .exit
		syscall
		inc rsi
		jmp .next

.exit:
		ret

; ======================================

; Prints special symbols
; Expects:	symbol to be printed in r8b
; Uses:		r8b, rsi, rcx, r11
; Leaves:	...

printSpec:
		mov rax, 1
		mov rdi, 1
		mov rdx, 1
		mov rsi, BUFF					; Setting syscall

		cmp r8b, 'n'
		je  .enter
		cmp r8b, 'm'
		je  .cat
		jmp .default

.enter:
		mov byte [rsi], 10
		jmp .print
.cat:
		mov byte [rsi],		'M'
		mov byte [rsi + 1], 'E'
		mov byte [rsi + 2], 'O'
		mov byte [rsi + 3], 'W'
		mov byte [rsi + 4], ':'
		mov byte [rsi + 5], '3'
		mov rdx, 6
		jmp .print
.default:
		mov byte [rsi], r8b

.print:		
		syscall
		ret

