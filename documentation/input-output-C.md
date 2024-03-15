### Printing and User Input using C Library in Assembly
#
#### Printf
__Printf__ is a C function that allows you to print to the __Standard Output__ in a formatted form denoted by a __%__

Printf takes in **2 parameters** and **1 output**

| Parameter | Description |
| ----------| ----------- |
| text      | this is the input of the __printf__ function            |
| format ...| here we input all our variables based on the specifier used after the __%__           |
| output    | return the number of characters on success, otherwise -1 is returned             |

##### Example
``` C
const char* message = "Hello, World!";
printf("This is a string: %s", message);
```
``` 
This is a string: Hello, World!
```
There are many formatting parameters those include:

| Specifier | Description | Example | Output |
| --------- | ----------- | ------- | ------ |
| %c | Character | printf("ASCII of 'A' is: %c", 'A') | ASCII of 'A' is: 41
| %d, %i | Signed Decimal Integer | printf("Integer: %i", 1234) | Integer: 1234
| %f | Decimal Floating Point | printf("Float: %f", 1234.5) | Float: 1234.5
| %s | String of Characters | printf("String: %s", "Hello, World") | String: Hello, World

Based on the Input given in the __Format__ parameter the output in the console will match the __Specifier__ defined in the message, but sometimes the input wont be compatible with the given specifier and  a __Segmentation fault__ will be returned

So if you specify a __%c__, and input a 5, the output to the console will be __53__ which is the corresponding ASCII Character of the value 5

#
#### Scanf
__Scanf__ is a C Function that take in the __User Input__ from the __Standard Input__

Scanf takes in __2 parameters__, __1 output__

| Parameter | Description |
| --------- | ----------- |
| format | the specifier __%__ for how the input will be interpreted
| address | the memory address to the variable, that __scanf__ will use to store its value
| output | returns the number of number of items of the argument list, otherwise -1 is returned

##### Example
``` C
int number;
scanf("%i", number);
```
```
Input: 5
number: 5
```
Within the usage of __scanf__ the __specifiers__ used will be similar to __printf__ where based on the specifier the input will be intepreted in that format.

| Specifier | Description | Example | input | Value | 
| --------- | ----------- | ------- | ----- | ----- |
| %c | ASCII | scanf("%c", &input) | 5 | 53 | 
| %d, %i | Signed Integer Decimal | scanf("i", &input) | 3 | 3 |
| %f | Signed Float Decimal | scanf("%f", &input) | 5.0 | 5.0 |
| %s | String | scanf("%s", &input) | "Hello, World" | Hello, World
| %h | Hexadecimal | scanf(%h", &input) | 8 | 0x38

#
#### Using Printf and Scanf in Assembly

#### Linkage and Compilation
To call C Library Functions we need to __Include__ them as **External** functions

``` Assembly
extern printf
extern scanf
```
Despite the fact that we have defined our C functions as __External__ the linker and complier doesnt know what __printf__ and __scanf__ is, therefore a __linking error__ will be returned during compilation

So during compilation we can link __libc__, with 
``` Bash
gcc -o main main.o -lc
```
where __-lc__ is the __C library__

During compilation modern systems wiith GCC generates __Position Independent Executables__ (PIE). PIE executables have the benefit of being able to load at any address in memory, which improves security by making it difficult for attackers to exploit certain vulnerabilities (such as __Buffer Overflow__)

However, for certain programs, especialy those written in Assembly. using PIE may cause compatibility issues. Disabling PIE ensures that the resulting executable will be loaded at a __fixed address__ in memory, which can simplify certain types of programming and debugging.

We can disable PIE in linkage with
``` Bash
gcc -o main main.o -no-pie
```
This will allow us to generate an executable without PIE

#### Programming
To work with printf and scanf we need to first define the __format__ and the __specifier__ in the __.data section__
``` Assembly
section .data
	print_format: db "%i", 0x0A, 0
	scan_format: db "%i", 0
```
For the print_format we __define bytes__ (db) for which we use the __string__ specifier %s, the last to bytes are ASCII characters, 0x0A represents a new line, and 0 represents a NULL to define the end of the sequence

For the scan_format we define bytes for the formatting of the input for which we will use the __string__ specifier, and the end we define a __NULL TERMINATOR__

When working will __scanf__ in Assembly we first have to perform __Stack Alignment__ for 16 Bytes, For the reasons of that libraries like Libc for which printf and scanf come from rely on proper stack alignment. Failing to align the stack will cause undefined behaviour, crahes and incorrect results when calling the functions.

We can align the stack by calling
``` Assembly
main:
	push rbp
	mov rbp, rsp
```
| Instruction | Description |
| ----------- | ----------- |
| push rbp | we save the current value of the base pointer resgister (RBP) onto the stack. 
| mov rbp, rsp | moves the value of the stack pointer register (RSP) into the base pointer register (RBP)

##### Stack Alignment
The base pointer (RBP) is typically used as a reference point for accessing parameters and local variables within a function. By pushing its current value we preserve its value for later use. This is important because the function we're entering might modify the base pointer, and we need to restore its original value when we exit the function

This is useful for calling and create local variables, as the RBP is the base pointer, or the current location in memory, by offsetting the RBP by the current location of the stack pointer (RSP) this effectively creates a new base pointer for the current function, we can easily access local variables stored on the stack and parameters for function can be called.

This new stack frame includes space for local variables, function parameters and bookkeeping information. By saving the old base pointer and establishing a new one, these instructions allow the function to access it parameters and local variables using a fixed reference point relative to the beginning of the stack frame
. This simplifies the process of accessing variables and parameters stored on the stack, this is a requirement for calling c functions that rely on the 16 byte stack alignment

Scanf and Printf relies on the RSP being adjusted by 16 bytes, as ensure that any local variables or parameters used or created during the execution of the functions we move the RBP to the location of the RSP to reserve and allocate 16 Bytes where any variables made will not interfere will the main memory locations in order not to misalign any memory. After the function ends we can de allocate by moving the current stack pointer to the base pointer which stores the location of the stack at the start of the scope "shrinking the stack" resetting the stack pointer to the start of the stack frame making the stored value of the base pointer the upmost value on the stack, and allowing us to pop the value off the stack back into the base pointer to move it back to its original location.
This is very similar to when local variables made are stored on the stack are deallocated when the scope ends, this is essentially the same thing.
#
After we allocate 16 bytes on the stack and move the base pointer to the boundaries of the 16 byte allocated, we can call the __printf__ function:

``` Assembly
mov rdi, print_format
mov rsi, [number]
xor rax, rax
call printf
```

To call printf we have to fill out its parameters, RDI, RSI, and RAX are the equivalent of the 2 inputs and 1 output

| Instruction | Description |
| ----------- | ----------- |
| mov rdi, print_format | we move the address of the print_format variable into the first paramter of the printf function
| mov rdi, [number] | we move the value to print based on the specifier, which is a pointer to the value stored in the number variable
| xor rax, rax | we use the xor instruction to ensure we get 0 outputs as we do not need them, we can also use: mov rax, 0, but in this case if rax returns either 1, or 0, a 0 will be output into the rax register due to the XOR operation
| call printf 

#
To call the scanf function we can use the same calling convention

``` Assembly
mov rdi, scan_format
mov rsi, number
xor rax, rax
call scanf
```
To call scanf we have to fill out its parameters, RDI, RSI, and RAX are equivalent to the 2 inputs and 1 output
| Instruction | Description |
| ----------- | ----------- |
| mov rdi, scan_format | we move the adress of the scan_format variable into the first paramter of the scanf function
| mov rsi, number | like the  C variant of the scanf function we also pass in the memory address of the variable we are going to store our input to
| xor rax, rax | we use this to ensure the return value is 0
| call scanf

#
#### Deallocating the Stack and Returning Base Pointer

After we finish our operations in our function the scope has ended and we need to deallocate the local variables on the stack and return the base pointer to the original position. We can do this by
``` Assembly
mov rsp, rbp
pop rbp
```
| Instruction | Description |
| ----------- | ----------- |
| mov rsp, rbp | we move the base pointer into the stack pointer, which base pointer contains the location of the stack pointer at the start of our function, and moving it essentially resets the stack to that location, this makes the stored location of the base pointer to upmost value on the stack
| pop rbp | we can now pop the value of the base pointer before the calling our function this ensures that the memory beforehand does not get misaligned as the base pointer was moved to its original location after all local variables were deallocated

We call this at the end of our function

This works because when we push the value of our base pointer into the stack we store that location before the creation of our scope variables, and moving the stack pointer into the base pointer moves the base pointer up to a new location allowing us to create new variables without misaligning and messing with memory outside that function. At deallocation we move the value of the base pointer back int our stack pointer as the base pointer holds the value of the stack pointer at the start of the stack frame, we "shrink" the stack frame causing it to reset to its original location deallocating all memory from the start of the that stack frame, this makes the the value of the base pointer we push into the stack to be at the top again, allowing us to pop the value back into the base pointer and moving it back to its original location before alignment and the call of the function
