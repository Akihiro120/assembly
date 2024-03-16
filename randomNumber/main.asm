extern printf
extern scanf
extern rand
extern time
extern srand

section .data
    print_format: db "%d", 10, 0

section .bss
    random_number: resb 16
    seed: resb 64

section .text
    global main

main:
    ; stack alignment
    push rbp
    mov rbp, rsp

    ; get the time
    mov rdi, 0
    call time 
    mov [seed], rax

    ; set the seed for the number generator
    mov rdi, [seed]
    call srand

    ; get a random number
    call rand
    mov [random_number], rax

    ; print the random number
    mov rdi, print_format
    mov rsi, [random_number]
    xor rax, rax
    call printf

    ; revert the stack
    mov rsp, rbp
    pop rbp

    mov rax, 60
    mov rdi, 0
    syscall
