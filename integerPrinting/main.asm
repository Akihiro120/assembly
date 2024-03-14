section .data

section .bss
	number resb 100
	number_pos resb 8

section .text
	global _start

_start:
	mov rax, 15456
	call _printInteger

	mov rax, 60
	mov rdi, 0
	syscall

_printInteger:
	mov byte [number], 0x0A

	call _printInteger

_printIntegerLoop:
	mov rdx, 0
	mov rdi, 10
	div rdi
	push rax

	mov rax, 1
	mov rdi, 1
	mov [rsi], dl
	mov rdx, 8

	pop rdi
	mov rsi, 0
	cmp rdi, rsi
	jnle _printIntegerLoop

	ret
