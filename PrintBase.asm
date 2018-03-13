; Prints number in binary
; Expects:	number in r8
;			1-byte buffer called BUFF
;			1 in rax
;			1 in rdi
; Uses:		rcx, esi, r8, r9, r10
; Leaves:	...

printBin:
		mov rcx, 64d
		mov esi, BUFF + 63d
.next_digit:
		mov r10, r8
		and r10, 1b
		shr r8, 1d

		add r10, '0'					; Now in r11 '0' or '1'
		mov [esi], r10b					; Placing lowest byte to buff
		dec esi

		loop .next_digit

		mov rax, 1
		mov rdi, 1
		mov rdx, 64d
		mov rsi, BUFF	
		syscall

;		call flushBuff
		ret

; ======================================

; Prints number in octal
; Expects:	number in r8
;			64-byte buffer called BUFF
;			1 in rax
;			1 in rdx
;			1 in rdi
; Uses:		rcx, esi, r8, r9, r10
; Leaves:	...

printOct:
		mov rcx, 22d
		mov esi, BUFF + 63d
.next_digit:
		mov r10, r8
		and r10, 111b
		shr r8, 3d

		add r10, '0'					; Now in r11 '0'-'1'
		mov [esi], r10b					; Placing lowest byte to buff
		dec esi

		loop .next_digit

		mov rax, 1
		mov rdi, 1
		mov rdx, 64d
		mov rsi, BUFF	
		syscall

;		call flushBuff
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
		mov rcx, 16d
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

		loop .next_digit

		mov rax, 1
		mov rdi, 1
		mov rdx, 64d
		mov rsi, BUFF
		syscall

;		call flushBuff
		ret

; ======================================

; Prints number in decimal
; Expects:	number in r8
;			1 in rdi
;			1-byte buffer called BUFF
; Uses:		rcx, rdx, esi, r8, r9, r10
; Leaves:	...

printDec:
		mov rcx, 22d
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

		loop .next_digit
		
		mov rax, 1
		mov rdi, 1
		mov rdx, 64
		mov esi, BUFF
		syscall
		
;		call flushBuff
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

		mov byte [BUFF], '0'			; Restoring buffer

;		call flushBuff
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
;		call flushBuff
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
		mov byte [BUFF], r8b

.print:		
		syscall
		mov byte [BUFF], '0'

;		call flushBuff
		ret

; ======================================

; Expects:	nothing
; Uses:		al, rcx, edi
; Leaves:	...

flushBuff:
nop
nop
nop
		mov edi, BUFF
		mov al,  0
		mov rcx, 64
rep		stosb
		ret


