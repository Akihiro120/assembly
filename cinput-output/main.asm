extern printf
extern scanf

section .data
	print_format: db "%d", 10, 0
	format: db "%c", 0

section .bss
	number: resb 8

section .text
	global main

main:
	; 16 byte stack alignment
	push rbp
	mov rbp, rsp

	; scanf
	; rdi, format parameter
	; rsi, address to the value
	; rax, additional parameters
	mov rdi, format	
	mov rsi, number
	mov rax, 0
	call scanf

	; printf
	; rdi, format parameter
	; rsi, value to be printed
	; rax, output / additional parameters
	mov rdi, print_format
	mov rsi, [number]
	xor rax, rax
	call printf

	leave
	mov rax, 60
	mov rdi, 0
	syscall
