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
	mov rcx, number
	mov rbx, 10
	mov [rcx], rbx
	inc rcx
	mov[number_pos], rcx

	call _printIntegerLoop

	ret

_printIntegerLoop:
	mov rdx, 0
	mov rbx, 10
	div rbx
	push rax
	add rdx, 48

	mov rcx, [number_pos]
	mov [rcx], dl
	inc rcx
	mov [number_pos], rcx

	pop rax
	cmp rax, 0
	jne _printIntegerLoop

	call _printIntegerLoop2

	ret
	
_printIntegerLoop2:
	mov rcx, [number_pos]

	mov rax, 1
	mov rdi, 1
	mov rsi, rcx
	mov rdx, 1
	syscall

	mov rcx, [number_pos]
	dec rcx
	mov [number_pos], rcx

	cmp rcx, number
	jge _printIntegerLoop2

	ret
