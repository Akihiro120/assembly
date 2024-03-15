extern printf

global main
section .data
	printf_format: db '%x', 10, 0

section .text
main:
	mov rdi, printf_format
	mov rsi, 0x92837
	xor rax, rax
	call printf WRT ..plt

	mov rax, 60
	syscall
