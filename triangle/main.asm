extern printf
extern scanf
extern fflush

section .data
	scan_int_format: db "%i", 0
	rows_message: db "Enter the number of rows: ", 0

	star_text: db "*", 0
	empty_text: db " ", 0
	new_line: db 10, 0

	row_loop_index: dq 0, 0
	star_loop_index: dq 0, 0
	space_loop_index: dq 0, 0

section .bss
	num_rows: resq 16
	counter: resq 16
	star_counter: resq 16

section .text
	global main

main:	
	push rbp
	mov rbp, rsp

	; draw the triangle
	call _getRows
	call _rowsLoop

	mov rsp, rbp
	pop rbp

	mov rax, 60
	mov rdi, 0
	syscall

_getRows:
	push rbp
	mov rbp, rsp

	; print rows message
	mov rdi, rows_message
	mov rsi, 0
	call printf
	xor rax, rax

	; get input for rows
	mov rdi, scan_int_format
	mov rsi, num_rows
	call scanf 
	xor rax, rax

	; setup counter
	mov rdi, [num_rows]
	mov rsi, 0
	sub rdi, rsi
	mov [counter], rdi

	mov rsp, rbp
	pop rbp

	ret

_rowsLoop:
	; alstack
	push rbp
	mov rbp, rsp

	; space function
	mov rdi, 0
	mov [space_loop_index], rdi
	call _emptySpaceLoop

	; star function
	mov rdi, 0
	mov [star_loop_index], rdi
	call _starLoop

	; decrement counter
	mov rdi, [counter]
	dec rdi
	mov [counter], rdi

	; add new line
	mov rdi, new_line
	mov rsi, 0
	call printf
	mov rax, rax

	mov rdi, 0
	call fflush

	; destack
	mov rsp, rbp
	pop rbp

	; increment loop index
	mov rdi, [row_loop_index]
	inc rdi
	mov [row_loop_index], rdi

	; check if loop is fulfilled
	mov rdi, [row_loop_index]
	mov rsi, [num_rows]
	cmp rdi, rsi
	jl _rowsLoop

	ret

_emptySpaceLoop:
	push rbp
	mov rbp, rsp
	
	; print space
	mov rdi, empty_text
	mov rsi, 0
	call printf
	xor rax, rax

	; flush
	mov rdi, 0
	call fflush

	mov rsp, rbp
	pop rbp

	; increment loop index
	mov rdi, [space_loop_index]
	inc rdi
	mov [space_loop_index], rdi

	; check if loop is fulfilled
	mov rdi, [space_loop_index]
	mov rsi, [counter]
	cmp rdi, rsi
	jl _emptySpaceLoop
	
	ret

_starLoop:
	; modulo for even check
	xor rdx, rdx
	mov rax, [star_loop_index]
	mov rdi, 2
	div rdi
	
	; if even print star, if odd print space
	mov rdi, 1
	cmp rdx, rdi
	je _printStar
	jne _printSpace

_printStar:
	push rbp
	mov rbp, rsp
	
	; print star
	mov rdi, star_text
	mov rsi, 0
	call printf
	xor rax, rax

	; flush
	mov rdi, 0
	call fflush

	mov rsp, rbp
	pop rbp

	jmp _endIf

_printSpace:
	push rbp
	mov rbp, rsp

	; print empty
	mov rdi, empty_text
	mov rsi, 0
	call printf
	xor rax, rax

	; flush
	mov rdi, 0
	call fflush

	mov rsp, rbp
	pop rbp

	jmp _endIf

_endIf:
	; setup loop condition
	mov rdi, [row_loop_index]
	mov rsi, 2
	add rdi, rdi
	add rdi, rsi
	mov [star_counter], rdi

	; increment loop index
	mov rdi, [star_loop_index]
	inc rdi
	mov [star_loop_index], rdi
	
	; check if loop is fulfilled
	mov rdi, [star_loop_index]
	mov rsi, [star_counter]
	cmp rdi, rsi
	jl _starLoop
	
	ret
