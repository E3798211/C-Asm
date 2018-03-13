global  myPrintf

section .text

; Here's extended printf() function from C std library. Much better of course.
; Actions sequence:
; 1. Taking string														[main()		]
; 2. Printing characters untill we see '%' 								[printLine()]
; 3. Checking next character for base									[checkBase()]
; 4. Printing one num from the stack in proper notation					[printBASE()]
; 5. Going on printing next char (returning to #2)						[printLine()]
; 6. Coming across '0' - finishing placing characters to std output		[printLine()]
; 7. Exit syscall														[main()		]

; ======================================

myPrintf:	
		push r9
		push r8
		push rcx
		push rdx
		push rsi
		push rdi
		call printLine
		pop rax
		pop rax
		pop rax
		pop rax
		pop rax
		pop rax

		mov rax, 0


; ====	Done. Quitting program. ====
		mov     eax, 60                 ; system call 60 is exit
        xor     rdi, rdi                ; exit code 0
        syscall                         ; invoke operating system to exit

; ======================================

%include "PrintLine.asm"

section .data

; Service
BUFF		times 64 db '0'
ERROR_BEG	db 10,27,"[31mSorry, '"
ERR_BEG_L	equ $-ERROR_BEG
ERROR_END	db "' doesn't supported.",27,"[0m", 10
ERR_END_L	equ $-ERROR_END

;			nasm -f elf64 printf.asm
;			ld printf.o -o printf
;
;
;

