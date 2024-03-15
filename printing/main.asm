extern printf

global main
section .data
	printf_format: db '%s', 10, 0
	text db "Hello World"

section .text
main:
	mov rdi, printf_format
	mov rsi, text
	xor rax, rax
	call printf WRT ..plt

	mov rax, 60
	syscall
