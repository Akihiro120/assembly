extern printf
extern time
extern srand
extern rand
extern scanf

section .data
    scan_format: db "%i", 0
    print_format: db "%i", 10, 0

	answer_message: db "Guess the number!!: ", 0
	lose_message: db "You got the number wrong!!! it was: %i", 10, 0
	win_message: db "You got the number right!!!", 10, 0

    ; message
    range_message: db "Enter a Range Limit: ", 0

section .bss
    seed: resq 1
    random_number: resq 1
    range: resq 1
	answer: resq 1

section .text
    global main

main:
    ; stack alignment
    push rbp
    mov rbp, rsp

    ; time
    xor rdi, rdi
    call time
	mov rdx, 0
	mov rsi, 736467
    mul rsi
    mov [seed], rax

    ; srand
    mov rdi, [seed]
    call srand

    ; rand
    call rand
    mov [random_number], rax

    ; display range message
    mov rdi, range_message
    mov rsi, 0
    call printf
    xor rax, rax

    ; get range from user input
    mov rdi, scan_format
    mov rsi, range
    call scanf
    xor rax, rax

    ; limit the range to 0 - Range
    xor rdx, rdx
    mov rax, [random_number]
    mov rdi, [range]
    div rdi
    inc rdx
    mov [random_number], rdx

	; get the users answer
	; print
	mov rdi, answer_message
	mov rsi, 0
	call printf
	xor rax, rax

	; scan
	mov rdi, scan_format
	mov rsi, answer
	call scanf
	xor rax, rax

    ; deallocate stack
    mov rsp, rbp
    pop rbp

	; compare answer
	mov rdi, [random_number]
	mov rsi, [answer]
	cmp rdi, rsi
	je _win
	jne _lose

    ; end
    mov rax, 60
    mov rdi, 0
    syscall

_win:
	; configure the stack
	push rbp
	mov rbp, rsp

	; print the win message
	mov rdi, win_message
	mov rsi, 0
	call printf
	xor rax, rax ; clear the output

	; reset the stack
	mov rsp, rbp
	pop rbp

	ret

_lose:
	; configure the stack
	push rbp
	mov rbp, rsp

	; print the lose mesage
	mov rdi, lose_message
	mov rsi, [random_number]
	call printf
	xor rax, rax

	; reset stack
	mov rsp, rbp
	pop rbp

	ret
