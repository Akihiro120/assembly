extern printf
extern time
extern srand
extern rand
extern scanf

section .data
    scan_format: db "%i", 0
    print_format: db "%i", 10, 0

    ; message
    message_range: db "Enter a Range Limit: ", 0

section .bss
    seed: resd 1
    random_number: resd 1
    range: resb 8

section .text
    global main

main:
    ; stack alignment
    push rbp
    mov rbp, rsp

    ; time
    xor rdi, rdi
    call time
    add rax, rax
    mov [seed], rax

    ; srand
    mov rdi, [seed]
    call srand

    ; rand
    call rand
    mov [random_number], rax

    ; display range message
    mov rdi, message_range
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

    ; print 
    mov rdi, print_format
    mov rsi, [random_number]
    call printf
    xor rax, rax

    ; deallocate stack
    mov rsp, rbp
    pop rbp

    ; end
    mov rax, 60
    mov rdi, 0
    syscall
