### Number Guessing Game
###### Project Start Date: 15/03/2024
###### Project End Date: 18/03/2024
#

#### Initializing Data
We require some data to be initialized at the beginning of the project

- Messages
- Formats
``` Assembly
section .data
    scan_format: db "%i", 0
    print_format: db "%i", 10, 0

    answer_message: db "Guess the number!!: ", 0
    lose_message: db "You got the number wrong!!! it was: %i", 10, 0
    win_message: db "You got the number right!!!", 10, 0
    range_message: db "Enter the Range Limit: ", 0
```
We initialized the data for the display messages, the range, and the formats for collecting and printing data using prinf and scanf.

#
#### Allocating Data
We have to allocate some data.
``` Assembly
section .bss
    seed: resq 1
    random_number: resq 1
    range: resq 1
    answer: resq 1
```
We define 4 quadwords (8 Bytes) (32 Bytes) total.

#
#### Required External Functions
We need to define some external functions from the standard C library.
``` Assembly
extern printf
extern scanf
extern time
extern rand
extern srand
```
#
#### Main Function
``` Assembly
main:
    ; allocate the stack
    push rbp
    mov rbp, rsp

    [..]

    ; deallocate the stack
    mov rsp, rbp
    pop rbp

    [..]
```
We first have to allocate some bytes for the stack, in order to abide by C function calling conventions, or else a __Segmentation Fault__ will be returned in runtime.

``` Assembly
; time
xor rdi, rdi
call time
mov rdx, 0
mov rsi, 736467
mul rsi
mov [seed], rax
```
In between the stack frame, we get the time by calling the time function, RDI is the first input for time which we set as __NULL__, and RAX is the output.
In order to further randomize the number we multiply the return value with an arbitrary number.
We then move the return value into the pointer of __seed__

``` Assembly
; srand
mov rdi, [seed]
call srand
```
To get a random number we have to supply a seed for the randomizer which is what srand is used for, RDI is the first input for the seed to set for the seed. There is no return value

``` Assembly
; rand
call rand
mov [random_number], rax
```
After supplying a random number we can call the rand function which returns a random signed integer in the RAX register, for which we move the value into the pointer for the random_number variable.

#
#### Getting the Range

``` Assembly
; display range message
mov rdi, range_message
mov rsi, 0
call printf
xor rax, rax
```
Getting the range of the random number generator is very simple, we first print the message for entering a number for the maximum value of the range.

``` Assembly
; get range from user input
mov rdi, scan_format
mov rsi, range
call scanf
xor rax, rax
```
After printing the message to the standard output we next have to get the result from the standard input, we will receive an integer for the range of the number.

``` Assembly
; limit the range to 0 - range
xor rdx, rdx
mov rax, [random_number]
mov rdi, [range]
div rdi
inc rdx
mov [random_number], rdx
```
To limit the range of the __random_number__ from 0 - __range__ we can use the division instruction, we have to zero out the RDX register this is the register where the remainder will be returned, RAX is the value that is getting divided, and the input for the division instruction will be the divisor.
We load the value of the random number into RAX, and the value of the range into RDI.
We afterwards increment to ensure a zero will not be returned, and move the value into the random_number variable.

#
#### Getting the Answer

``` Assembly
; print the message for the answer
mov rdi, answer_message
mov rsi, 0
call printf
xor rax, rax
```
We first prompt the user that they must enter their answer, we can use print

``` Assembly
; get the user input
mov rdi, scan_format
mov rsi, answer
call scanf
xor rax, rax
```
We next get the answer from the user and store the input into the answer variable

#
#### Win-Lose Conditions

``` Assembly
_win:
    ; allocate the stack
    push rbp
    mov rbp, rsp

    ; print the win message
    mov rsi, win_message
    mov rsi, 0
    call pritnf
    xor rax, rax

    ; reset the stack
    mov rsp, rbp
    pop rbp

    ret

_lose:
    ; allocate the stack
    push rbp
    mov rbp, rsp

    ; print the lose message
    mov rsi, lose_message
    mov rsi, [random_number]
    call printf
    xor rax, rax

    ; reset stack
    mov rsp, rbp
    pop rbp

    ret
```
For the win and lose conditions we first have to create some functions for the win and lose state, both are simply print functions with some formatting.

Back in the main function we now compare the random number to our answer, we do this after we deallocate the stack in the main function.
``` Assembly 
; compare answer
mov rdi, [random_number]
mov rsi, [answer]
cmp rdi, rsi
je _win
jne _lose
```
``` Assembly
; end program
mov rax, 60
mov rsi, 0
syscall
```
After we finish the program we can just call the system call for exiting the program, if we dont have thing at the end we will return a __Seg Fault__.
