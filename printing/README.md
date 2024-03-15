### Printing in Asssembly using Printf

#### Steps for Complilation
__Linux/Unix__

``` Bash
nasm -f elf64 main.asm
gcc -o main main.o -lc
./main
```
