extern printf
extern scanf

section .data
	print_format: db "%i", 0x0A, 0
	scan_format: db "%i", 0

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
	; rax, output
	mov rdi, scan_format	
	mov rsi, number
	xor rax, rax
	call scanf

	; printf
	; rdi, format parameter
	; rsi, value to be printed
	; rax, output / additional parameters
	mov rdi, print_format
	mov rsi, [number]
	xor rax, rax
	call printf

	; deallocate stack and return base pointer
	mov rsp, rbp
	pop rbp
	
	mov rax, 60
	mov rdi, 0
	syscall
