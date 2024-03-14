section .data
	;text db "Hello, World!"
	;text_len equ $ - text

section .bss
	text resb 100

section .text
	global _start

_start:
	mov byte [text], 0x0A
	mov rax, [text]
	shl rax, 8
	mov [text], rax

	mov byte [text], 55

	mov rax, 1
	mov rdi, 1
	mov rsi, text
	mov rdx, 32
	syscall

	mov rax, 60
	mov rdi, 0
	syscall
