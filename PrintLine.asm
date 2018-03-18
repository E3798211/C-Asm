;.intel_syntax noprefix

;section .text

; Prints line with formatted inserts
;		%x	for		hexadecimal
;		%o	for		octal
;		%b	for		binary
;		%u	for		unsigned decimal
;		%c	for		character
;		%s	for		string
;
; Expects:	formatted line called MESSAGE with lengh MESG_LEN
;			arguments in stack in cdecl
; Uses:		rax, rbx, rcx, rdx, rsi, rdi, rbp, rsp
; Leaves:	rsi		amount of characters printed

printLine:
		push rbp
		mov  rbp, rsp					; [bp+16] - 1st argument. 24, 32, ...
		mov  rbx, 16					; Used for addressing. Next arg: bx+=8

		xor rsi, rsi
		mov rsi, qword [rbp + rbx]		; Loading string
		add rbx, 8
.load:	
		cmp byte [rsi], 0				; Terminator
		je  .exit
		cmp byte [rsi], '|'				; Screened symbol
		je  .special
		cmp byte [rsi], '%'
		jne .print						; Average - just print
		
		inc rsi							; Looking at the second character - must be base

		mov r8, qword [rbp + rbx]		; Loading parameter
		add rbx, 8

		cmp byte [rsi], 'x'
		je  .hex
		cmp byte [rsi], 'h'
		je  .hex
		cmp byte [rsi], 'o'
		je  .oct
		cmp byte [rsi], 'b'
		je  .bin
		cmp byte [rsi], 'u'
		je  .dec
		cmp byte [rsi], 'c'
		je  .chr
		cmp byte [rsi], 's'
		je  .str

;		Unexpected specificator
;		CRY LIKE A BITCH ABOUT THE FAULT
		
		mov  bl, byte [rsi]
		call error
		jmp .exit

; ======================================
;
; Processing is here
;

.hex:
		mov r14, rsi
		call printHex
		mov rsi, r14
		jmp .end_processing
.oct:
		mov r14, rsi
		call printOct
		mov rsi, r14
		jmp .end_processing
.bin:
		mov r14, rsi
		call printBin
		mov rsi, r14
		jmp .end_processing
.dec:
		mov r14, rsi
		call printDec
		mov rsi, r14
		jmp .end_processing
.chr:
		mov r14, rsi
		call printChr
		mov rsi, r14
		jmp .end_processing
.str:
		mov r14, rsi
		call printStr
		mov rsi, r14

.end_processing:
		inc rsi
		jmp .load

; ======================================
;
; Special symbols are printer here
;

.special:
		inc rsi
		mov r8b, byte [rsi]				; Placing element's specificator to r8b
		mov r15, rsi					; Saving current place in string
		call printSpec
		mov rsi, r15					; Restoring place in string
		inc rsi
		jmp .load

; ======================================


.print:	
		mov rax, 1
        mov rdi, 1
        mov rdx, 1						; Setting print
		syscall
		inc rsi

		jmp .load

; ======================================

.exit:
		pop rbp
		ret

; ======================================

; Prints error message about unexpected specificator
; Expects:	wrong specificator in bl
; Uses:		rax, rdx, rsi, rdi, BUFF, rcx, r11

error:	
		mov rax, 1
		mov rdi, 1
		mov rsi, ERROR_BEG
		mov rdx, ERR_BEG_L
		syscall

		mov rax, 1
		mov rdi, 1
		mov byte [BUFF], bl
		mov rsi,  BUFF
		mov rdx, 1
		syscall
		mov byte [BUFF], 0
		
		mov rax, 1
		mov rdi, 1
		mov rsi, ERROR_END
		mov rdx, ERR_END_L
		syscall
		
		ret

; ======================================

%include "PrintBase.asm"


;.att_syntax
