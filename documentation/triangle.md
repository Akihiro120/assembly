### Triangle
>###### Project Start Date: 19/03/2024
>
>###### Project End Date: 20/03/2024 
#
#### Including Externals
``` Assembly
extern printf
extern scanf
extern fflush
```
We will utilise the __printf__, __scanf__, and __fflush__ functions from the C Standard Library

#
#### Data Initialization
> section .data
``` Assembly
; text and formats
scanf_int_format: db "%i", 0
rows_message: db "Enter the number of rows: ", 0

; characters
star_text: db "*", 0
empty_text: db " ", 0
new_line: db 10, 0

; loop index
row_loop_index: dd 0, 0
star_loop_index: dd 0, 0
space_loop_index: dd 0, 0
```

>section .bss
``` Assembly
; counters
num_rows: resd 16
counter: resd 16
star_counter: resd 16
```
We initialize the variables, and reserve some bytes specifically some doublewords (4 bytes) for the numbers to specify __integers__ (4 bytes).
>In order to define integers we need to define least 4 bytes, any less will lead to a segmentation fault or overflow.

The sentences are a string of bytes so we can leave them as __define bytes (db)__
The same applies to characters
#
#### Program

> main:
``` Assembly
; stack allocation
push rbp
mov rbp, rsp

; draw the triangle
call _getRows
call _rowsLoop

; deallocate the stack
mov rsp, rbp
pop rbp

; exit - system call
mov rax, 60
mov rdi, 0
syscall
```
We first define the stack frame for the main function, afterwards we call the functions for drawing the triangle, then call the system call for exiting the program.
>Ensure we allocate the stack frame, this will ensure we are allocating 16 bytes to suit the C function calling convention, otherwise this will lead to a segmentation fault.
#
#### Setting up the Variables
> _getRows:
``` Assembly
; allocate new stack frame
push rbp
mov rbp rsp

;print rows messagae
mov rdi, rows_message
mov rsi, 0
call printf 
xor rax, rax

; get input for rows
mov rdi, scan_int_format
mov rsi, num_rows
call sanf
xor rax, rax

; setup counter
mov rdi, [num_rows]
mov [counter], rdi

; deallocate stack frame
mov rsp, rbp
pop rbp
```
Before we can create the triangle, we have to retrieve the user input, and setup the initialized variables, using the input from the user we can initialize __num_rows__, using that variable we can also initialize __counter__, by moving the pointer to the value into the RDI register, we can move that into a pointer to the value of __counter__.

> Make sure a new stack frame is created here as, when calling subroutines we move the control flow to a different memory location.
This is different to the 'jump' instruction, as that is essentially the equivalent of an __inline__ function therefore the memory location never changes

#
#### Printing the Triangle
> _rowsLoop
``` Assembly
; allocate new stack frame
push rbp
mov rbp, rsp

; print spaces
mov rdi, 0
mov [space_loop_index], rdi
call _emptySpaceLoop

: print stars
mov rdi, 0
mov [star_loop_index], rdi
call _starLoop

; decrement counter variable
mov rdi, [counter]
dec rdi
mov [counter], rdi

; add a new line character
mov rdi, new_line
mov rsi, 0
call printf
mov rax, rax

; flush the output buffer
mov rdi, 0
call fflush

; deallocate the stack
mov rsp, rbp
pop rbp
```
> We have to clear the output buffer, due to the characters or text not having an end line character, if you dont call fflush and your print doesnt have a new line character, nothing will be displayed to the standard output.

To print this triangle we have to call the space, and star functions, these functions are essentially for loops nested inside this current one. We first clear the loop index for each function, then call it.
Afterwards we decrement the counter variable by one
and add a new line character when its done. We can then check and determine if the loop has finished, if not then we will decrement the index and jump back to the top.

>_emptySpaceLoop:
``` Assembly
; allocate stack frame
mov rbp
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
mov rdi, [counter]
cmp rdi, rsi
jl _emptySpaceLoop

ret
```
In this function we print out space characters equal to the value in 
[counter], we continue the loop via that amount.
and return to the original function once the loop has completed.

>_starLoop:
``` Assembly
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
```
In this function we check if the current index for this loop is an even number, we can accomplish this using the division instruction, which returns a remainder in the RDX register, either 0 or 1, and depending on that we print either a space, or a star.

> _printStar:
``` Assembly
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

jump _endif
```
> _printSpace:
``` Assembly
push rbp
mov rbp, rsp

; print empty
mov rdi , empty_text
mov rsi, 0
call printf
xor rax, rax

; flush
mov rdi, 0
call fflush

jump _endIf
```
These two functions are simply to print out either a star character or a space character, and jumping to the end of the if statement

> _endIf:
``` Assembly
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
```
This is technically the end of the _starLoop function but due to the calling conventions of assembly we must format it like this, we setup a new loop condition for the index, by making it the index of row loop times 2 plus 2,
afterwards we increment the star loop index, and determine of the loop has concluded and return to the main function.
