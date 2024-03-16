extern printf
extern time
extern srand
extern rand

section .data
    print_format: db "%i", 10, 0
    range: dd 10

section .bss
    seed: resd 1
    random_number: resd 1

section .text
    global main

main:
    ; stack alignment
    push rbp
    mov rbp, rsp

    ; time
    xor rdi, rdi
    call time
    mov [seed], rax

    ; srand
    mov rdi, [seed]
    call srand

    ; rand
    call rand
    mov [random_number], rax

    ; limit the range to 0 - 1
    xor rdx, rdx
    mov rax, [random_number]
    mov rdi, [range]
    div rdi
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
