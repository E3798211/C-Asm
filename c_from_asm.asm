global main
extern printf

section .text

main:                                   ; This is called by C library's startup code
        mov     rdi, message          	; First integer (or pointer) parameter in %rdi
	xor rax, rax
        call    printf                    ; puts(message)
        ret                             ; Return to C library code

section .data

message:	db "Hola, mundo",10, 0        	; asciz puts a 0 byte at the end
