extern printf

section .data
	print_format: db "%i", 10, 0
	counter: dq 0, 0

section .bss

section .text
	global main

main:
	jmp _printStar

	mov rax, 60
	mov rdi, 0
	syscall

_printStar:
	push rbp
	mov rbp, rsp

	mov rdi, [counter]
	inc rdi,
	mov [counter], rdi

	mov rdi, print_format
	mov rsi, [counter]
	call printf
	xor rax, rax

	mov rsp, rbp
	pop rbp

	ret
