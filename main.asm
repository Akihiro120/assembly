section .text
	text db "Hello world", 0x0A

section .data
	global _start

_start:
	rax, 1
	rdi, 1
	rsi, text
	rdx, 24
	syscall

	rax, 60
	rdi, 0
	syscall
